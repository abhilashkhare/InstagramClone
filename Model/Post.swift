//
//  Post.swift
//  InstagramClone
//
//  Created by Abhilash Khare on 7/15/18.
//  Copyright © 2018 Abhilash Khare. All rights reserved.
//

import Foundation

class Post{
    
    var caption : String
    var photoURL : String
    
    init(captionText : String , photoUrlString : String) {
        caption = captionText
        photoURL = photoUrlString
    }
    
}
