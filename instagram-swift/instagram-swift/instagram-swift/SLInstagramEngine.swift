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

class SLInstagramEngine : SLLoginViewControllerDelegate {
    
    private var clientId : String?
    private var redirectURI : String?
    
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
            
            self.clientId = (confDic?.objectForKey("InstagramClientId") as String)
            self.redirectURI = (confDic?.objectForKey("InstagramRedirectURL") as String)
        }
    }
    
// MARK: - Login
    
    func loginFromViewController(viewController: UIViewController, completionClosure: (success : Bool, error : NSError?) -> ()){
        let urlString = "\(kInstagramAuthURL)?client_id=\(self.clientId!)&redirect_uri=\(self.redirectURI!)&response_type=token"
        if let url = NSURL(string: urlString) {
            
            let loginVC = SLLoginViewController(nibName: nil, bundle: nil)
            loginVC.delegate = self
            viewController.presentViewController(loginVC, animated: true, completion: nil)
            
            loginVC.redirectURI = self.redirectURI!
            loginVC.mainWebView.loadRequest(NSURLRequest(URL: url))
        }
    }
    
// MARK: - SLLoginViewController Delegate Methods
    func loginViewControllerDidCancel(vc: SLLoginViewController) {
    }
    
    func loginViewControllerDidError(error: NSError) {
        
    }
    
    func loginViewControllerDidLogin(accesToken: String) {
        println("Login: \(accesToken)")
    }
}
