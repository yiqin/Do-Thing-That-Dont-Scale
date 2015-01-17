//
//  CloudCodeManager.swift
//  testflighthub
//
//  Created by Yi Qin on 12/19/14.
//  Copyright (c) 2014 Yi Qin. All rights reserved.
//

import UIKit

/**
  Cloud Code Function Manager
*/
class CloudCodeManager: NSObject {
    
    /// Test cloud code.
    class func sendTestHello() {
        let parameters = [:]
        PFCloud.callFunctionInBackground("hello", withParameters: parameters) { (result:AnyObject!, error:NSError!) -> Void in
            if (error == nil) {
                println("Hello world!")
            }
        }
    }
    
}
