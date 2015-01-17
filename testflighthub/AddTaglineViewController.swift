//
//  AddTaglineViewController.swift
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

class AddTaglineViewController: UIViewController {
    
    @IBOutlet var taglineTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        taglineTextView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    

    @IBAction func tapCancelButton(sender: UIButton) {
        taglineTextView.resignFirstResponder()
        
        dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })

    }
    
    @IBAction func tapSaveTaglineButton(sender: UIButton) {
        
        taglineTextView.resignFirstResponder()
        
        // CreatingNewProductDataManager.sharedInstance.finishTagline(taglineTextView.text)
        
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
