//
//  TestImage.swift
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

/// General image class in testflighthub. It has isLoading, image and file three properties.
class TestImage: NSObject {
    
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
            println("test image")
        }
        
    }
    
}
