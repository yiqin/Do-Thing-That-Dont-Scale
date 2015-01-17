//
//  ConfigDataManager.swift
//  testflighthub
//
//  Created by Yi Qin on 12/19/14.
//  Copyright (c) 2014 Yi Qin. All rights reserved.
//

import UIKit

/**
 Configuration data from Parse.com
*/
class ConfigDataManager: NSObject {
    
    var scoreAtPrevious : NSNumber = 0
    
    class var sharedInstance : ConfigDataManager {
        struct Static {
            static let instance = ConfigDataManager()
        }
        return Static.instance
    }
    
    class func startToRetrieveConfig() {
        NSLog("Getting the latest config...");
        PFConfig.getConfigInBackgroundWithBlock { (var config: PFConfig!, error: NSError!) -> Void in
            if ((error) != nil) {
                println(error)
                
            } else {
                
                ConfigDataManager.sharedInstance.scoreAtPrevious = config["scoreAtPrevious"] as NSNumber
                
            }
        }
    }
}
