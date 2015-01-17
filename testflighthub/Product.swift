//
//  Product.swift
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

class Product: NSTestObject {
    
    var name: String
    /// A concise name, not saved in Parse
    var shortName : String
    var tagline: String
    var appDescription : String
    var review : String
    /// Hashtags of the app, but never used to display now
    var hashtags : String
    
    var website: NSURL
    var isOnAppStore : Bool
    
    var upvoteCount : Int
    
    var coverImage : UIImage
    var isLoadingCoverImage : Bool
    
    var iconImage : UIImage
    var isLoadingIconImage : Bool
    
    var alreadyLike : Bool
    var isLoadingAlreadyLike : Bool
    
    // posted by the user
    var postedByUsername : String
    var postedByProfileImage : UIImage
    var isLoadingPostedByProfileImage : Bool
    
    override init(parseObject:PFObject) {
        name = parseObject["name"] as String
        
        let tempCharacter = " - "
        if name.rangeOfString(tempCharacter) != nil {
            let tempNameArray = name.componentsSeparatedByString(tempCharacter)
            if (tempNameArray.count > 0){
                shortName = tempNameArray[0]
            }
            else {
                shortName = name
            }
        }
        else {
            shortName = name
        }
        
        tagline = ""
        // tagline = parseObject["tagline"] as String
        
        hashtags = parseObject["hashtags"] as String
        appDescription = parseObject["appDescription"] as String
        review = parseObject["review"] as String
        
        let rawWebsiteString = parseObject["website"] as String
        let websiteString = rawWebsiteString.stringByReplacingOccurrencesOfString(" ", withString: "")
                
        let ituneAddress = "itunes.apple.com"
        if websiteString.lowercaseString.rangeOfString(ituneAddress) != nil {
            isOnAppStore = true
        }
        else {
            isOnAppStore = false
        }
        
        website = NSURL(string: websiteString)!
        
        let tempNumber = parseObject["upvoteCount"] as NSNumber
        upvoteCount = tempNumber.integerValue
        
        coverImage = UIImage()
        isLoadingCoverImage = true
        
        iconImage = UIImage()
        isLoadingIconImage = true
        
        alreadyLike = false
        isLoadingAlreadyLike = true
        
        postedByUsername = parseObject["postedByUsername"] as String
        postedByProfileImage = UIImage()
        isLoadingPostedByProfileImage = true
        
        super.init(parseObject:parseObject)
        
        let coverImagePFImageView = PFImageView()
        if let tempCoverImagePFFile = parseObject["coverImage"] as? PFFile {
            coverImagePFImageView.file = tempCoverImagePFFile
            coverImagePFImageView.loadInBackground { (image:UIImage!, error:NSError!) -> Void in
                self.coverImage = image
                self.isLoadingCoverImage = false
            }
        }
        
        let iconImagePFImageView = PFImageView()
        if let tempIconImagePFFile = parseObject["iconImage"] as? PFFile {
            iconImagePFImageView.file = tempIconImagePFFile
                iconImagePFImageView.loadInBackground { (image:UIImage!, error:NSError!) -> Void in
                    self.iconImage = image
                    self.isLoadingIconImage = false
            }
        }
        
        let postedByProfileImagePFImageView = PFImageView()
        if let tempPostedByProfileImagePFFile = parseObject["postedByProfileImage"] as? PFFile {
            postedByProfileImagePFImageView.file = tempPostedByProfileImagePFFile
                postedByProfileImagePFImageView.loadInBackground { (image:UIImage!, error:NSError!) -> Void in
                    self.postedByProfileImage = image
                    self.isLoadingPostedByProfileImage = false
            }
        }
        
        println(UserManager.sharedInstance.checkUserIsAvailable())
        
        // If we have the user information in the device, we go to fetch what products they like. If not, no likes.
        if UserManager.sharedInstance.checkUserIsAvailable() {
            
            var query = PFQuery(className: "Like")
            query.whereKey("user", equalTo: PFUser.currentUser())
            query.whereKey("product", equalTo: parseObject)
            query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error:NSError!) -> Void in
                if((error) == nil){
                    self.isLoadingAlreadyLike = false
                    if(objects.count > 0){
                        self.alreadyLike = true
                    }
                    else {
                        self.alreadyLike = false
                    }
                }
                else {
                    
                }
            }
        } else {
            self.isLoadingAlreadyLike = false
            self.alreadyLike = false
        }
    }
    
    override init(parseClassName:String){
        name = ""
        shortName = ""
        tagline = ""
        appDescription = ""
        review = ""
        hashtags = ""
        
        website = NSURL()
        isOnAppStore = false
        upvoteCount = 0
        
        coverImage = UIImage()
        isLoadingCoverImage = true
        
        iconImage = UIImage()
        isLoadingIconImage = true
        
        alreadyLike = false
        isLoadingAlreadyLike = true
        
        postedByUsername = ""
        postedByProfileImage = UIImage()
        isLoadingPostedByProfileImage = true
        
        super.init(parseClassName:parseClassName)
    }
    
}
