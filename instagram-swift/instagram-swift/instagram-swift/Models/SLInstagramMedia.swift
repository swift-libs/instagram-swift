//
//  SLInstagramMedia.swift
//  instagram-swift
//
//  Created by Dimas Gabriel on 11/4/14.
//  Copyright (c) 2014 Swift Libs. All rights reserved.
//

import Foundation
import SwiftyJSON

public enum InstagramMediaType {
  case Video
  case Photo
}

class SLInstagramMedia : SLInstagramBaseModel {
  var user : SLInstagramUser?
  var type : InstagramMediaType
  
  override init(json: JSON) {
    user = SLInstagramUser(json: json["user"])
    
    let t = json["type"].string
    if t == "image"{
      type = .Photo
    }else {
      type = .Video
    }
    
    super.init(json: json)
  }
}