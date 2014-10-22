//
//  SLInstagramBaseModel.swift
//  instagram-swift
//
//  Created by Dimas Gabriel on 10/21/14.
//  Copyright (c) 2014 Swift Libs. All rights reserved.
//

import Foundation

class SLInstagramBaseModel {
  var Id : String
  
  init(dic: [String : AnyObject]) {
    Id = dic["id"] as String
  }
  
}