//
//  ViewController.swift
//  instagram-swift
//
//  Created by Dimas Gabriel on 10/21/14.
//  Copyright (c) 2014 Swift Libs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  let engine = SLInstagramEngine.sharedEngine
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    engine.loginFromViewController(self, completionClosure: { (success, error) -> () in
      
    })
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func getFeedAction(sender: UIBarButtonItem) {
    engine.selfFeedWithSuccessClosure({ (objects, pagination) -> () in
      
    }, error: { (error) -> () in
      
    })
  }
  
}

