//
//  SLInstagramUser.swift
//  instagram-swift
//
//  Created by Dimas Gabriel on 10/22/14.
//  Copyright (c) 2014 Swift Libs. All rights reserved.
//

import Foundation
import SwiftyJSON

class SLInstagramUser : SLInstagramBaseModel {
  var username : String?
  var fullName : String?
  var profilePictureURL : String?
  var website : String?
  var bio : String?
  
  override init(json: JSON) {
    username = json["username"].string
    fullName = json["fullname"].string
    profilePictureURL = json["profile_picture"].string
    website = json["website"].string
    bio = json["bio"].string
    
    super.init(json: json)
  }
  
}