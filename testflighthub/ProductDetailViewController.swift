//
//  ProductDetailViewController.swift
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    var productDetailTVC : ProductDetailTableViewController
    var product : Product
    
    var getAppButton = UIButton(frame: CGRectMake(screenWidth-150, screenHeight-100, 50, 30))
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, product selectedProduct: Product? ) {
        
        productDetailTVC = ProductDetailTableViewController(product: selectedProduct!)
        product = selectedProduct!
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        view.addSubview(productDetailTVC.view)
        view.backgroundColor = UIColor.whiteColor()
        
        // No getAppButton now.
        getAppButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: 15)
        getAppButton.setTitle("GET", forState: UIControlState.Normal)
        getAppButton.setTitleColor(mainColor, forState: UIControlState.Normal)
        getAppButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Highlighted)
        
        getAppButton.backgroundColor = UIColor.blueColor()
        
        
        getAppButton.layer.masksToBounds = true;
        getAppButton.layer.cornerRadius = 30*0.5;
        
        // view.addSubview(getAppButton)
        
        title = selectedProduct?.shortName
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "swipeRight:")
        self.view.addGestureRecognizer(swipeRight)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "moveToWebsite", name: "ProductMoveToWebsite", object: nil)
    }

    func moveToWebsite() {
        
        var webViewController = ProductWebsiteViewController(URL: product.website)
        
        
        
        navigationController?.pushViewController(webViewController, animated: true)
        NSNotificationCenter.defaultCenter().postNotificationName("hideTabBarUIViewTwo", object: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        // self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
        
        super.viewDidLoad()
        TestMixpanel.enteredProductDetailView()
        
        let settingButton = UIBarButtonItem(image: UIImage(named: "setting_selected"), style: UIBarButtonItemStyle.Plain, target: self, action: "clickSettingButton:")
        navigationItem.rightBarButtonItem = settingButton
        
        
        NSNotificationCenter.defaultCenter().postNotificationName("hideTabBarUIViewTwo", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().postNotificationName("hideTabBarUIViewTwo", object: nil)
    }
    
    // ##############################
    // This is the problem........
    // ##############################
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // NSNotificationCenter.defaultCenter().postNotificationName("showTabBarUIViewTwo", object: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        productDetailTVC.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) //Why 64 here If setTranslucent
    }
    
    func swipeRight(recognizer:UISwipeGestureRecognizer){
        println("Swipe right.")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func clickSettingButton(sender:UIBarButtonItem!){
        println("Click setting button")
        TestMixpanel.pressSettingButton();
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "Report Abuse", style: .Destructive) { (action) in
            var abuse = PFObject(className:"Abuse")
            abuse["name"] = self.product.name
            abuse["product"] = self.product.parseObject
            abuse.saveInBackgroundWithBlock { (succeeded:Bool!, error:NSError!) -> Void in
                if (succeeded != nil) {
                    
                }
            }
        }
        alertController.addAction(destroyAction)
        
        let OKAction = UIAlertAction(title: "Get Beta App", style: .Default) { (action) in
            /*
            let url = self.product.website
            UIApplication.sharedApplication().openURL(url)
            TestMixpanel.getAppFromProductDetailView()
            */
            /*
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Get the Beta Testing App" message:@"You are going to share your email to the creator of the beta testing app. It's under the policy of Test Flight Program From Apple." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Share", nil];
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField *textField = [alertView textFieldAtIndex:0];
            textField.placeholder = @"Enter your email here...";
            
            [alertView show];
            */
            
            /*
            let alertControllerGET = UIAlertController(title: "Get the Beta Testing App", message: "You are going to share your email to the creator of the beta testing app. It's under the policy of Test Flight Program From Apple.", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
            let loginAction = UIAlertAction(title: "Share", style: .Default) { (_) in
                let loginTextField = alertController.textFields![0] as UITextField
                
            }
            loginAction.enabled = false
            
            alertControllerGET.addTextFieldWithConfigurationHandler { (textField) in
                textField.placeholder = "Email"
                
                NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                    loginAction.enabled = textField.text != ""
                }
            }
            
            alertControllerGET.addAction(cancelAction)
            alertControllerGET.addAction(loginAction)
            
            self.presentViewController(alertControllerGET, animated: true) {
                // ...
            }
            */
            
        }
        // alertController.addAction(OKAction)
        
        let CopyUrlAction = UIAlertAction(title: "Copy URL", style: .Default) { (action) in
            UIPasteboard.generalPasteboard().string = self.product.website.absoluteString
            TestMixpanel.copyAppURL()
        }
        // alertController.addAction(CopyUrlAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
        
    }
}
