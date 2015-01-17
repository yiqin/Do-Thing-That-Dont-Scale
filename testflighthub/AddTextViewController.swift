//
//  AddTextViewController.swift
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

class AddTextViewController: UIViewController {

    @IBOutlet var appName: UITextField!
    
    @IBOutlet var appURL: UITextField!
    
    @IBOutlet var letWeEnterURL: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)

        // Do any additional setup after loading the view.
        
        appName.becomeFirstResponder()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func tapCancelButton(sender: UIButton) {
        
        appName.resignFirstResponder()
        appURL.resignFirstResponder()
        
        dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    @IBAction func tapSaveNameButton(sender: UIButton) {
        
        appName.resignFirstResponder()
        appURL.resignFirstResponder()
        
        CreatingNewProductDataManager.sharedInstance.finishName(appName.text, appURL: appURL.text)
        
        dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
