//
//  SLLoginViewController.swift
//  instagram-swift
//
//  Created by Dimas Gabriel on 10/21/14.
//  Copyright (c) 2014 Swift Libs. All rights reserved.
//

import UIKit

protocol SLLoginViewControllerDelegate {
    func loginViewControllerDidCancel(vc: SLLoginViewController)
    func loginViewControllerDidLogin(accesToken: String)
    func loginViewControllerDidError(error : NSError)
}

class SLLoginViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var mainWebView: UIWebView!
    var delegate: SLLoginViewControllerDelegate?
    var redirectURI : String?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: "SLLoginViewController", bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainWebView.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonTap(sender: UIBarButtonItem) {
        self.delegate?.loginViewControllerDidCancel(self)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func webView(webView: UIWebView!, shouldStartLoadWithRequest request: NSURLRequest!, navigationType: UIWebViewNavigationType) -> Bool {
        
        if (self.redirectURI != nil){
            var urlStr = request.URL.absoluteString
            if (urlStr?.hasPrefix(self.redirectURI!) == true) {
                urlStr = urlStr!.stringByReplacingOccurrencesOfString("?", withString: "", options:nil, range:nil)
                urlStr = urlStr!.stringByReplacingOccurrencesOfString("#", withString: "", options:nil, range:nil)
                
                let urlResources = urlStr!.componentsSeparatedByString("/")
                let urlParameters = urlResources.last
                let parameters = urlParameters?.componentsSeparatedByString("&")
                
                if parameters?.count == 1 {
                    let keyValue = parameters![0]
                    let keyValueArray = keyValue.componentsSeparatedByString("=")
                    
                    let key = keyValueArray[0]
                    if key == "access_token" {
                        self.delegate?.loginViewControllerDidLogin(keyValueArray[1])
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    
                }else {
                    // We have an error
                    
                    let errorString = "Authorization not granted"
                    let error = NSError(domain: kSLInstagramEngineErrorDomain,
                                          code: kSLInstagramEngineErrorCodeAccessNotGranted,
                                      userInfo: [NSLocalizedDescriptionKey : errorString])
                    
                    self.delegate?.loginViewControllerDidError(error)
                }
                
                return false
            }
        }
        
        return true
    }

}
