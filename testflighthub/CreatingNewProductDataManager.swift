//
//  CreatingNewProductDataManager.swift
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

class CreatingNewProductDataManager: NSObject {
    
    var appName = ""
    var appURL = ""
    var hashtags = ""
    var review = ""
    
    var selectedApp = App()
    
    var screenshots : NSMutableArray = []
    
    var isFirstStepFinished = false
    var isSecondStepFinished = false
    var isThirdStepFinished = false
    
    class var sharedInstance : CreatingNewProductDataManager {
        struct Static {
            static let instance = CreatingNewProductDataManager()
        }
        return Static.instance
    }
    
    // previous version
    func finishName(appName:NSString, appURL:NSString){
        self.appName = appName
        self.appURL = appURL
        
        isFirstStepFinished = true
    }
    
    // latest version
    func finishApp(app:App){
        self.selectedApp = app
        CreatingNewProductDataManager.sharedInstance.loadScreenshotsFromAppStore()
        isFirstStepFinished = true
        TestMixpanel.createNameSuccessfully()
    }
    
    func finishHashtags(hashtags:NSString){
        self.hashtags = hashtags
        
        isSecondStepFinished = true
        TestMixpanel.createHashtagSuccessfully()
    }
    
    func finishReview(review:String){
        self.review = review
        
        isThirdStepFinished = true
        TestMixpanel.createReviewSuccessfully()
    }
    
    
    // From Photos
    func finishScreenshots(assets:NSArray){
        
        screenshots.removeAllObjects()  // we need to remove this......
        for asset in assets {
            
            let rep = asset.defaultRepresentation()
            let iref = rep.fullResolutionImage()
            let image = UIImage(CGImage: iref.takeUnretainedValue())
            
            println(image?.size.width)
            println(image?.size.height)
            screenshots.addObject(image!)
        }
    }
    
    func onlyCheckAllValue()->Bool {
        return (isFirstStepFinished && isSecondStepFinished && isThirdStepFinished)
    }
    
    func checkAllValue(){
        println("Creating New Product Data Manager.......")
        println(appName)
        println(appURL)
        println(hashtags)
        
        if(isFirstStepFinished && isSecondStepFinished && isThirdStepFinished){
            saveProductToParse()
        }
        else {
            clearAll()
        }
    }
    
    func clearAll(){
        TestMixpanel.pressCreateDiscard(isFirstStepFinished, secondStep:isSecondStepFinished, thirdStep:isThirdStepFinished)
        
        appName = ""
        appURL = ""
        hashtags = ""
        
        selectedApp = App()
        
        screenshots.removeAllObjects()
        
        isFirstStepFinished = false
        isSecondStepFinished = false
        isThirdStepFinished = false
    }
    
    
    func loadScreenshotsFromAppStore(){
        
        screenshots.removeAllObjects()
        
        for screenshotUrl in selectedApp.screenshotUrls {
            println(screenshotUrl)
            
            // This part is really confusing.
            let tempString : String = screenshotUrl as String
            let url:NSURL = NSURL(string: tempString)!
            let urlRequest = NSURLRequest(URL: url)
            
            var requestOperation = AFHTTPRequestOperation(request: urlRequest)
            println(1)
            
            requestOperation.responseSerializer = AFImageResponseSerializer()
            
            requestOperation.setCompletionBlockWithSuccess({ (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
                
                let tempImage = responseObject as UIImage
                self.screenshots.addObject(tempImage)
                println("From APpStore ")
                
                }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                    
            })
            requestOperation.start()
        }
    }
    
    
    func saveProductToParse(){
        
        var product = PFObject(className:"Product")
        product["appID"] = selectedApp.trackId
        product["name"] = selectedApp.trackName
        product["website"] = selectedApp.trackViewUrl
        product["hashtags"] = hashtags
        product["review"] = review
        product["appDescription"] = selectedApp.appDescription
        
        product["tagline"] = ""
        
        let tempCoverImage = screenshots.firstObject as UIImage
        let tempCoverImageData = UIImagePNGRepresentation(tempCoverImage)
        product["coverImage"] = PFFile(name: "coverImage.png", data: tempCoverImageData)
        
        let tempIconImage = selectedApp.artwork100
        let tempIconImageData = UIImagePNGRepresentation(tempIconImage)
        product["iconImage"] = PFFile(name: "iconImage.png", data: tempIconImageData)
        
        product["upvoteCount"] = 0
        product["upvoteToday"] = 0
        product["scorePrevious"] = ConfigDataManager.sharedInstance.scoreAtPrevious
        
        product["postedBy"] = PFUser.currentUser()
        product["postedByUsername"] = UserManager.sharedInstance.name
        product["postedByProfileImage"] = UserManager.sharedInstance.getDataFromProfileImage()
        
        // Score
        product["favourites_count"] = UserManager.sharedInstance.favourites_count
        product["followers_count"] = UserManager.sharedInstance.followers_count
        product["friends_count"] = UserManager.sharedInstance.friends_count
        
        // Check In Review, opposite to isUserAuthorized.
        // More work is needed here.
        product["isInReview"] = (!PostAuthorizeManager.getAuthorize() || !UserManager.sharedInstance.checkUserLoginWithTwitter())
        println(PostAuthorizeManager.getAuthorize())
        
        
        product.saveInBackgroundWithBlock { (succeeded:Bool!, error:NSError!) -> Void in
            if (succeeded != nil) {
                println("save product successfully")
                YO.sendYOToIndividualUser("Leaftagger")
                YO.sendYOToIndividualUser("Cocoalite")
                
                SVProgressHUD.dismiss()
                NSNotificationCenter.defaultCenter().postNotificationName("finishedPostingNewAppToParse", object: nil)
                NSNotificationCenter.defaultCenter().postNotificationName("afterCreateAppAndReloadTable", object: nil)
                
                self.isFirstStepFinished = false
                self.isSecondStepFinished = false
                self.isThirdStepFinished = false
                self.saveScreenshotsToParse(product)
            }
        }
    }
    
    func saveScreenshotsToParse(savedProduct:PFObject){
        var i = 0
        // This method doesn't work very well.
        for image in screenshots {
            var screenshot = PFObject(className: "Screenshot")
            screenshot["belongTo"] = savedProduct
            screenshot["ordered"] = i
            let imageData = UIImagePNGRepresentation(image as UIImage)
            let imageName = "\(i).png"
            screenshot["image"] = PFFile(name: imageName, data: imageData)
            i++
            screenshot.saveInBackgroundWithBlock({ (succeeded:Bool!, error:NSError!) -> Void in
                
            })
        }
    }
    
}
