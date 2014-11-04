//
//  SLInstagramEngine.swift
//  instagram-swift
//
//  Created by Dimas Gabriel on 10/21/14.
//  Copyright (c) 2014 Swift Libs. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

let kSLInstagramEngineErrorDomain = "kSLInstagramEngineErrorDomain"
let kSLInstagramEngineErrorCodeAccessNotGranted = -1

private let kInstagramAuthURL : String = "https://instagram.com/oauth/authorize/"
private let kInstagramBaseAPIURL : String = "https://api.instagram.com/v1/"

typealias SLInstagramArrayClosure = (objects : [AnyObject], pagination : [String : JSON]) -> ()
typealias SLInstagramErrorClosure = (error: NSError) -> ()

class SLInstagramEngine : SLLoginViewControllerDelegate {
  
  private var clientId : String?
  private var accessToken: String?
  private var redirectURI : String?
  private var httpManager : Alamofire.Manager
  
  class var sharedEngine : SLInstagramEngine {
    struct Static {
      static var onceToken : dispatch_once_t = 0
      static var instance : SLInstagramEngine? = nil
    }
    
    dispatch_once(&Static.onceToken, {
      Static.instance = SLInstagramEngine()
    })
    
    return Static.instance!;
  }
  
  // Default init method
  init () {
    if let confPlistPath = NSBundle.mainBundle().pathForResource("SLInstagramConf", ofType: "plist") {
      let confDic = NSDictionary(contentsOfFile: confPlistPath)
      
      clientId = (confDic?.objectForKey("InstagramClientId") as String)
      redirectURI = (confDic?.objectForKey("InstagramRedirectURL") as String)
    }
    
    httpManager = Alamofire.Manager.sharedInstance
  }
  
  // MARK: - Login
  
  func loginFromViewController(viewController: UIViewController, completionClosure: (success : Bool, error : NSError?) -> ()){
    let urlString = "\(kInstagramAuthURL)?client_id=\(clientId!)&redirect_uri=\(redirectURI!)&response_type=token"
    if let url = NSURL(string: urlString) {
      
      let loginVC = SLLoginViewController(nibName: nil, bundle: nil)
      loginVC.delegate = self
      viewController.presentViewController(loginVC, animated: true, completion: nil)
      
      loginVC.redirectURI = redirectURI!
      loginVC.mainWebView.loadRequest(NSURLRequest(URL: url))
    }
  }
  
  // MARK: - SLLoginViewController Delegate Methods
  func loginViewControllerDidCancel(vc: SLLoginViewController) {
  }
  
  func loginViewControllerDidError(error: NSError) {
  }
  
  func loginViewControllerDidLogin(accesToken: String) {
    self.accessToken = accesToken;
  }
  
  // MARK: - Self Logged User Methods
  
  func selfFeedWithSuccessClosure(success: SLInstagramArrayClosure, error: SLInstagramErrorClosure) {
    self.getPath("users/self/feed", parameters:nil , responseModel: SLInstagramEngine.self, authNeeded: true, success: { (objects, pagination) -> () in

      var medias : [SLInstagramMedia] = []
      
      for (index: String, mediaJSON : JSON) in objects {
        medias.append(SLInstagramMedia(json: mediaJSON))
      }
      
      success(objects: medias, pagination: pagination)
      
    }) { (err) -> () in
      error(error: err)
    }
  }
  
  // MARK: - HTTP Calls
  
  private func getPath(path: String, parameters: [String :  String]?, responseModel : AnyClass,
    authNeeded: Bool, success: (objects : JSON, pagination : [String : JSON]) -> (), error: SLInstagramErrorClosure) {
    
    assert(authNeeded == true && accessToken != nil, "SLInstagram Error: You need an Instagram access token to access the '\(path)' path")
        
        var params = [String : String]()
        
        if parameters != nil {
          params = parameters!
        }
        
        if authNeeded == true {
          params["access_token"] = accessToken
        }
        
        httpManager.request(.GET, self.fullURLForPath(path), parameters: params).responseSwiftyJSON { (request, response, json, err) -> Void in
            if err != nil {
                error(error: err!);
            }else{
                let feed = json["data"]
                let pagination = json["pagination"].dictionary!
                success(objects: feed, pagination: pagination)
            }
        }
  }
    
    private func fullURLForPath(path: String) -> String {
        return "\(kInstagramBaseAPIURL)\(path)"
    }
  
}
