//
//  TodayViewController.swift
//  DoThings
//
//  Created by Yi Qin on 1/18/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit
import NotificationCenter
import Parse

class TodayViewController: UIViewController, NCWidgetProviding {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        println("hello")
        loadDataFromParse()
    }
    
    func loadDataFromParse(){
        Parse.setApplicationId("2D6T3tgwBIPoE8HkuninwT3gsUkrHouCfzg0MzDL", clientKey: "cmvDVWTEIrZO4phyuddppS96diUqckCKazxBEwxH")
        
        let query = PFQuery(className: "TodayProduct")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects:[AnyObject]!, error:NSError!) -> Void in
            
            println("when you see this .... it means you have data from Parse.com. ")
            
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
}
