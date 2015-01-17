//
//  UpvoteProfileImage.swift
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

class UpvoteProfileImage: NSObject {
    
    var image : UIImage
    var isLoading : Bool
    var file : PFFile
    
    init(pffile : PFFile) {
        image = UIImage()
        isLoading = true
        file = pffile
        
        super.init()
        
        let tempImagePFImageView = PFImageView()
        tempImagePFImageView.file = pffile
        tempImagePFImageView.loadInBackground { (image:UIImage!, error:NSError!) -> Void in
            self.image = image
            self.isLoading = false
            println("upvote profile image")
        }
        
    }
   
}
