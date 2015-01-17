//
//  app.swift
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

/// App - from itune ios store
class App: NSObject {
    
    var appDescription : NSString
    
    var artistName : NSString
    var artworkUrl100 : NSString
    var artwork100 : UIImage
    var isLoadingArtwork100 : Bool
    
    var trackName : NSString
    var trackId : NSNumber
    var trackViewUrl : NSString
    
    var sellerName : NSString
    
    var screenshotUrls : NSMutableArray
    
    init(json:NSDictionary){
        
        println(json)
        
        appDescription = json.objectForKey("description") as NSString
        // appDescription = appDescription.stringByReplacingOccurrencesOfString("\n", withString: " ")
        
        artistName = json.objectForKey("artistName") as NSString
        artworkUrl100 = json.objectForKey("artworkUrl100") as NSString
        artwork100 = UIImage()
        isLoadingArtwork100 = true
        
        trackName = json.objectForKey("trackName") as NSString
        trackId = json.objectForKey("trackId") as NSNumber
        trackViewUrl = json.objectForKey("trackViewUrl") as NSString
        
        sellerName = json.objectForKey("sellerName") as NSString
        
        screenshotUrls = NSMutableArray(array: json.objectForKey("screenshotUrls") as NSArray)
        
        super.init()
        
        let artworkURLRequest = NSURLRequest(URL: NSURL(string: artworkUrl100)!)
        var requestOperation = AFHTTPRequestOperation(request: artworkURLRequest)
        requestOperation.responseSerializer = AFImageResponseSerializer()
        requestOperation.setCompletionBlockWithSuccess({ (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
            self.artwork100 = responseObject as UIImage
            self.isLoadingArtwork100 = false
            
            }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
            
        })
        requestOperation.start()
        
    }
    
    override init() {
        
        appDescription = ""
        
        artistName = ""
        artworkUrl100 = ""
        artwork100 = UIImage()
        isLoadingArtwork100 = true
        
        trackName = ""
        trackId = NSNumber()
        trackViewUrl = ""
        
        sellerName = ""
        
        screenshotUrls = []
        
        super.init()
    }
    
}
