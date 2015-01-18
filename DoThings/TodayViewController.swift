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
        
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var tagline: UILabel!
        
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        println("hello")
        loadDataFromParse()
    }
    
    func loadDataFromParse(){
        Parse.setApplicationId("E7StxK5eRXAok9R4Ohen8TjNxspF7N97ogokzsSa", clientKey: "yFGfgZcREb2bFc03jkOCpgDEof5WDCeLI4stOMM3")
        
        let query = PFQuery(className: "TodayProduct")
        /*
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects:[AnyObject]!, error:NSError!) -> Void in
            
            println("when you see this .... it means you have data from Parse.com. ")
            
            
        }
        */
        
        query.getFirstObjectInBackgroundWithBlock { (object:PFObject!, error:NSError!) -> Void in
            if ((error) != nil){
                
            }
            else {
                println("when you see this .... it means you have data from Parse.com. ")
                
                if let tempName = object["name"] as? String {
                    self.name.text = tempName
                }
                
                if let tempTagline = object["tagline"] as? String {
                    self.tagline.text = tempTagline
                }
                
                let tempImageFile = object["iconImage"] as PFFile
                tempImageFile.getDataInBackgroundWithBlock {
                    (imageData: NSData!, error: NSError!) -> Void in
                    if error == nil {
                        self.iconImageView.contentMode = UIViewContentMode.ScaleAspectFit
                        self.iconImageView.image = UIImage(data:imageData)
                    }
                }
                
            }
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
