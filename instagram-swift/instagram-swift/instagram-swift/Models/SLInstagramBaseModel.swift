//
//  SLInstagramBaseModel.swift
//  instagram-swift
//
//  Created by Dimas Gabriel on 10/21/14.
//  Copyright (c) 2014 Swift Libs. All rights reserved.
//

import Foundation
import SwiftyJSON

class SLInstagramBaseModel {
  var ID : String?
  
  init(json: JSON) {
    ID = json["id"].string
  }
  
}