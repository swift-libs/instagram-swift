//
//  SLInstagramEngine.swift
//  instagram-swift
//
//  Created by Dimas Gabriel on 10/21/14.
//  Copyright (c) 2014 Swift Libs. All rights reserved.
//

import Foundation
import UIKit

let kSLInstagramEngineErrorDomain = "kSLInstagramEngineErrorDomain"
let kSLInstagramEngineErrorCodeAccessNotGranted = -1

private let kInstagramAuthURL : String = "https://instagram.com/oauth/authorize/"
private let kInstagramBaseAPIURL : String = "https://api.instagram.com/v1/"

typealias SLInstagramArrayClosure = (objects : [AnyObject], pagination : [String : String]) -> ()
typealias SLInstagramErrorClosure = (error: NSError) -> ()

class SLInstagramEngine : SLLoginViewControllerDelegate {
  
  private var clientId : String?
  private var accessToken: String?
  private var redirectURI : String?
  private var httpManager : AFHTTPSessionManager
  
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
    
    httpManager = AFHTTPSessionManager(baseURL: NSURL(string: kInstagramBaseAPIURL))
    httpManager.responseSerializer = AFJSONResponseSerializer() as AFJSONResponseSerializer
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
    self.getPath("users/self/feed", parameters:nil , responseModel: SLInstagramEngine.self, authNeeded: true, succes: { (objects, pagination) -> () in
      
    }) { (error) -> () in
      
    }
  }
  
  // MARK: - HTTP Calls
  
  private func getPath(path: String, parameters: [String :  String]?, responseModel : AnyClass,
      authNeeded: Bool, succes: SLInstagramArrayClosure, error: SLInstagramErrorClosure) {
    
    assert(authNeeded == true && accessToken != nil, "SLInstagram Error: You need an Instagram access token to access the '\(path)' path")
        
        var params = [String : String]()
        
        if parameters != nil {
          params = parameters!
        }
        
        if authNeeded == true {
          params["access_token"] = accessToken
        }
        
        httpManager.GET(path, parameters: params, success: { (dataTask: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
          println("Response: \(responseObject)")
        }) { (dataTask: NSURLSessionDataTask!, err: NSError!) -> Void in
          let data = err.userInfo!["com.alamofire.serialization.response.error.data"] as NSData
          let string = NSString(data: data, encoding: NSUTF8StringEncoding)
          println("Err: \(string)")
          error(error: err)
        }
  }
  
}
