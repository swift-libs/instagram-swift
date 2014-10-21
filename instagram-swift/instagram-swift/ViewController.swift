//
//  ViewController.swift
//  instagram-swift
//
//  Created by Dimas Gabriel on 10/21/14.
//  Copyright (c) 2014 Swift Libs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let engine = SLInstagramEngine.sharedEngine
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


}

