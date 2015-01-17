//
//  ProductDetailTableViewController.swift
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

class ProductDetailTableViewController: UITableViewController, AddTextPopoverDelegate, ProductDescriptionTableViewCellDelegate {
    
    var product : Product
    var comments : NSMutableArray = []
    var upvoteProfileImages : NSMutableArray = []
    
    var addTextPopoverView = AddTextPopoverView()
    
    var isDescriptionMoreMode = false
    
    var inputText = ""
    
    convenience init(product:Product){
        self.init(nibName: nil, bundle: nil)
        self.product = product
        title = self.product.name
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        product = Product(parseClassName: "WeDontKnow")
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        // self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
        
        super.viewDidLoad()
        
        
        NSNotificationCenter.defaultCenter().postNotificationName("hideTabBarUIView", object: nil)
        startToLoadFromParse()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().postNotificationName("showTabBarUIView", object: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func startToLoadFromParse() {
        var query = PFQuery(className: "Comment")
        
        query.whereKey("belongTo", equalTo: product.parseObject)
        query.orderByAscending("createdAt")     // Timelist....
        
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error:NSError!) -> Void in
            if(error == nil){
                println("successfully load comments")
                self.comments.removeAllObjects()
                self.comments.addObjectsFromArray(objects as NSArray)
                self.tableView.reloadData()
            }
            else {
                println(error)
            }
        }
        
        
        var query2 = PFQuery(className: "Like")
        query2.whereKey("product", equalTo: product.parseObject)
        query2.orderByAscending("createdAt")     // Timelist....
        
        query2.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error:NSError!) -> Void in
            if(error == nil){
                println("successfully load Likes")
                
                NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "reloadUpvoteProfileImages", userInfo: nil, repeats: false)
                
                for object in objects {
                    let user = object.objectForKey("user") as PFUser
                    user.fetchIfNeededInBackgroundWithBlock({ (object : PFObject!, error : NSError!) -> Void in
                        println("Get user...........")

                        if let name = user.objectForKey("name") as? String {
                            println(user.objectForKey("name"))
                            let profileImagePFImageView = PFImageView()
                            profileImagePFImageView.file = user.objectForKey("profileImage") as PFFile
                            
                            let tempFile = user.objectForKey("profileImage") as PFFile
                            /*
                            let temp = profileImagePFImageView.file.url
                            println(temp)
                            profileImagePFImageView.loadInBackground { (image:UIImage!, error:NSError!) -> Void in
                            
                            println("Get profile image...........")
                            }
                            */
                            let upvoteProfileImage = UpvoteProfileImage(pffile: tempFile)
                            self.upvoteProfileImages.addObject(upvoteProfileImage)
                        }
                        
                    })
                }
            }
            else {
                println(error)
            }
        }
        
    }
    
    func reloadUpvoteProfileImages() {
        let indexPath = NSIndexPath(forRow: 2, inSection: 0)
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(section == 0){
            return 4
        }
        else {
            return comments.count
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section == 0){
            if (indexPath.row == 0) {
                return ProductScreenshotsTableViewCell.cellHeight()
            }
            else if (indexPath.row == 1) {
                return ProductBriefTableViewCell.cellHeight(product)
            }
            else if (indexPath.row == 2) {
                return ProductUpvoteTableViewCell.cellHeight(product)
            }
            else {
                return ProductDescriptionTableViewCell.cellHeight(product, isDescriptionMoreMode: isDescriptionMoreMode)
            }
        }
        else if(indexPath.section == 1) {
            let object = comments[indexPath.row] as PFObject
            let content = object["content"] as NSString
            return ProductCommentTableViewCell.cellHeight(content)
        }
        else {
            return 100
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 0.0
        }
        else {
            // for offset
            if (comments.count == 0){
                return 100.0
            }
            else {
                return 55.0
            }
        }
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tempFrame = tableView.frame
        let headerView = UIView(frame: CGRectMake(0, 0, tempFrame.size.width, tempFrame.size.height))
        
        let commentLabel = UILabel(frame: CGRectMake(xPadding, yPadding, screenWidth, 30))
        commentLabel.text = "Comments".uppercaseString
        commentLabel.font = kNamelabelFont
        commentLabel.textColor = kNamelabelColor
        headerView.addSubview(commentLabel)
        
        headerView.backgroundColor = UIColor.whiteColor()
        
        let underline = UIView(frame: CGRectMake(xPadding, CGRectGetMaxY(commentLabel.frame), kUnderlineWidth, kUnderlineHeight))
        underline.backgroundColor = kUnderlineColor
        headerView.addSubview(underline)
        
        // Update add button.....
        var addCommentButton = UIButton.buttonWithType(UIButtonType.ContactAdd) as UIButton
        addCommentButton.frame = CGRectMake(screenWidth-70, yPadding-15, 70, 70)
        
        headerView.addSubview(addCommentButton)
        
        // addCommentButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: 15)
        // addCommentButton.backgroundColor = UIColor.blueColor()
        
        addCommentButton.addTarget(self, action: "addComment:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return headerView
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0){
            if (indexPath.row == 0) {
                let cellIdentifier = "ProductScreenshotsCell"
                var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? ProductScreenshotsTableViewCell
                
                if cell != nil {
                    // println("Cell exist")
                    
                }
                else {
                    cell = ProductScreenshotsTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier, product:self.product)
                }
                
                return cell!
            }
            else if (indexPath.row == 1) {
                let cellIdentifier = "ProductBriefCell"
                var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? ProductBriefTableViewCell
                
                if cell != nil {
                    // println("Cell exist")
                    
                }
                else {
                    cell = ProductBriefTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
                }
                
                cell?.setContentValue(product)
                
                return cell!
            }
            else if (indexPath.row == 2) {
                let cellIdentifier = "ProductUpvoteCell"
                var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? ProductUpvoteTableViewCell
                
                if cell != nil {
                    // println("Cell exist")
                    
                }
                else {
                    cell = ProductUpvoteTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier, product:self.product, profileImages:self.upvoteProfileImages)
                }
                
                cell?.setContentValue(product)
                
                return cell!
            }
            else {
                let cellIdentifier = "ProductDescriptionCell"
                var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? ProductDescriptionTableViewCell
                
                if cell != nil {
                    // println("Cell exist")
                    
                }
                else {
                    cell = ProductDescriptionTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
                }
                
                cell?.setContentValue(product, isDescriptionMoreMode:isDescriptionMoreMode)
                cell?.delegate = self
                return cell!
            }
        }
        else if (indexPath.section == 1) {
            let cellIdentifier = "ProductCommentCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? ProductCommentTableViewCell
            
            if cell != nil {
                // println("Cell exist")
                
            }
            else {
                cell = ProductCommentTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
            }
            
            let object = comments[indexPath.row] as PFObject
            cell?.setContentValue(object)
            
            return cell!
        }
        else {
            return UITableViewCell()
        }
    }
    
    func addComment(sender:UIButton!) {
        println("Add Comment")
        
        addTextPopoverView = AddTextPopoverView(frame: CGRectMake(1.5*xPadding, tableView.contentOffset.y+10, CGRectGetWidth(view.frame)-3*xPadding, 200), title: "Add Comment", placeholder: "Enter here... (If you don't enter anything, press Post button won't create a new comment.)")
        addTextPopoverView.rightButtonTitle = "Post"
        addTextPopoverView.delegate = self
        view.addSubview(addTextPopoverView)
        
    }
    
    func saveCommentToParse(comment:NSString){
        
        SVProgressHUD.show()
        
        var commentParseObject = PFObject(className: "Comment")
        commentParseObject["content"] = inputText
        commentParseObject["belongTo"] = product.parseObject
        commentParseObject["writtenBy"] = PFUser.currentUser()
        commentParseObject["name"] = UserManager.sharedInstance.name
        commentParseObject["profileImage"] = UserManager.sharedInstance.getDataFromProfileImage()
        
        commentParseObject.saveInBackgroundWithBlock { (succeeded:Bool!, error:NSError!) -> Void in
            if((succeeded) != nil){
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    // Add a new cell at the end........
                    // self.queryForTable()
                    
                    println("update ...... the table.")
                    SVProgressHUD.dismiss()
                    self.startToLoadFromParse()
                    
                })
            }
        }
    }
    
    // Mark : AddTextPopoverView Delegate
    func cancelTextInput(){
        // addTextPopoverView.removeFromSuperview()
    }
    
    func finishTextInput(text:String){
        TestMixpanel.pressAddComment()
        inputText = text
        if(!UserManager.sharedInstance.checkUserLoginWithTwitter()){
            
            let alertController = UIAlertController(title: "Add Your Comment", message: "You need to login with Twitter to finish.", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                // ...
                TestMixpanel.cancelCommentWhenNeedLogin()
            }
            alertController.addAction(cancelAction)
            
            let loginAction = UIAlertAction(title:  "Login", style: .Default, handler: { (action) -> Void in
                PFTwitterUtils.logInWithBlock {
                    (user: PFUser!, error: NSError!) -> Void in
                    if user == nil {
                        NSLog("Uh oh. The user cancelled the Twitter login.")
                    } else if user.isNew {
                        NSLog("User signed up and logged in with Twitter!")
                        TestMixpanel.loginSuccessFromComment()
                        
                        NSUserDefaults.standardUserDefaults().setObject(true, forKey: "login")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        
                        UserManager.sharedInstance.updateUserInfoFromTwitterUsername()
                        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "saveCommentToParse:", userInfo: nil, repeats: false)
                        // self.saveCommentToParse(text)
                        // self.addTextPopoverView.removeFromSuperview()
                    } else {
                        NSLog("User logged in with Twitter!")
                        TestMixpanel.loginSuccessFromComment()
                        
                        NSUserDefaults.standardUserDefaults().setObject(true, forKey: "login")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        
                        UserManager.sharedInstance.updateUserInfoFromTwitterUsername()
                        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "saveCommentToParse:", userInfo: nil, repeats: false)
                        // self.saveCommentToParse(text)
                        // self.addTextPopoverView.removeFromSuperview()
                    }
                }
            })
            alertController.addAction(loginAction)
            
            self.presentViewController(alertController, animated: true) {
                
            }
        }
        else {
            saveCommentToParse(text)
            // addTextPopoverView.removeFromSuperview()
        }
        
    }
    
    func updateDescriptionTableCell(){
        println("update description table cell.........")
        // isDescriptionMoreMode = true
        
        // let indexPath = NSIndexPath(forRow: 3, inSection: 0)
        // tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        
        /*
        ProductWebsiteViewController *webViewController = [[ProductWebsiteViewController alloc] initWithURL:url];
        
        self.navigationController.delegate = nil;
        [self.navigationController pushViewController:webViewController animated:YES];
        */
        
        
        
        
    }
}
