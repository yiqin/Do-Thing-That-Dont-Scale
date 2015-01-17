//
//  UserManager.swift
//  Voice
//
//  Created by Yi Qin on 12/23/14.
//  Copyright (c) 2014 Yi Qin. All rights reserved.
//

import Foundation

/**
 Manages all user information. It includes
*/
class UserManager: NSObject {
    
    var isWorking = false
    
    var isUserAvailable = false
    
    var hasLoginWithTwitter = false
    
    var isLoading = false
    
    var screenName = "unknown"
    var name = "unknown"
    var profileImage = UIImage(named: "profile")
    
    var favourites_count = 0
    var followers_count = 0
    var friends_count = 0
    
    class var sharedInstance : UserManager {
        struct Static {
            static let instance = UserManager()
        }
        return Static.instance
    }
    
    func setUserAvailable() {
        isUserAvailable = true
    }
    
    func checkUserIsAvailable()->Bool{
        return isUserAvailable
    }
    
    func checkUserLoginWithTwitter()->Bool{
        return hasLoginWithTwitter
    }
    
    func getDataFromProfileImage()->PFFile{
        let tempData = UIImagePNGRepresentation(profileImage)
        return PFFile(name: "profile.png", data: tempData)
    }
    
    func updateUserInfoFromTwitterUsername(){
        /*
        PF_Twitter *twitterObject = [PFTwitterUtils twitter];
        if (twitterObject.screenName != nil) {
            
            NSURL *verify = [NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json?screen_name=yiqin1"];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:verify];
            [[PFTwitterUtils twitter] signRequest:request];
            NSURLResponse *response = nil;
            NSError *error = nil;
            NSData *data = [NSURLConnection sendSynchronousRequest:request
            returningResponse:&response
            error:&error];
            NSDictionary *json=[NSJSONSerialization
            JSONObjectWithData:data
            options:NSJSONReadingMutableLeaves
            error:nil];
            NSLog(@"jsonObject is %@",json);
            
            
            
            [[UserManager sharedInstance] updateUserFromTwitterUsername:twitterObject userJSON:json];
        }
        */
        
        var returnValue: Bool? = NSUserDefaults.standardUserDefaults().objectForKey("login") as? Bool
        if returnValue == nil //Check for first run of app
        {
            returnValue = false //Default value
        }
        if(returnValue == true){
            let twitterObject = PFTwitterUtils.twitter()
            if (twitterObject.screenName != nil){
                
                hasLoginWithTwitter = true
                
                let urlString = "https://api.twitter.com/1.1/users/show.json?screen_name=\(twitterObject.screenName)"
                let url = NSURL(string: urlString)
                let request = NSMutableURLRequest(URL: url!)
                PFTwitterUtils.twitter().signRequest(request)
                let response = NSURLResponse()
                let error = NSError()
                let queue = NSOperationQueue()
                NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: { (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
                    if (error == nil){
                        let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves, error: nil) as NSDictionary
                        // println(json)
                        self.parseUserRawData(twitterObject, userJSON: json)
                    }
                })
            }
        }

    }
    
    
    func parseUserRawData(twitterObject: PF_Twitter, userJSON: NSDictionary){
        
        screenName = twitterObject.screenName
        name = userJSON.objectForKey("name") as NSString
        
        favourites_count = userJSON.objectForKey("friends_count") as Int
        followers_count = userJSON.objectForKey("followers_count") as Int
        friends_count = userJSON.objectForKey("friends_count") as Int
        
        let rawProfileImageUrl = userJSON.objectForKey("profile_image_url") as NSString
        let profileImageUrl = rawProfileImageUrl.stringByReplacingOccurrencesOfString("_normal", withString: "")
        
        let request = NSURLRequest(URL: NSURL(string: profileImageUrl)!)
        let requestOperation = AFHTTPRequestOperation(request: request)
        requestOperation.responseSerializer = AFImageResponseSerializer()
        requestOperation.setCompletionBlockWithSuccess({ (operation : AFHTTPRequestOperation!, responseObject : AnyObject!) -> Void in
            
            println("success")
            self.profileImage = responseObject as? UIImage
            self.saveUserInfoToParse()
            
            
            }, failure: { (operation : AFHTTPRequestOperation!, error:NSError!) -> Void in
            println("image loading failue.................")
                
        })
        
        requestOperation.start()
    }
    
    // update later
    // It seems we don't need this method now. No need to post the image every time.
    func saveUserInfoToParse(){
        
        PFUser.currentUser()["name"] = name
        PFUser.currentUser()["screenName"] = screenName
        
        let tempData = UIImagePNGRepresentation(profileImage)
        PFUser.currentUser()["profileImage"] = PFFile(name: "profile.png", data: tempData)
        
        PFUser.currentUser().saveInBackgroundWithBlock { (succeeded:Bool!, error:NSError!) -> Void in
            if((succeeded) != nil){
                println("update pfuser successfully.")
            }
        }
    }
    
}
