//
//  CreateNewViewController.swift
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

/// Redundant layout........ What I need is another table view.......
class CreateNewViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, QBImagePickerControllerDelegate, AppSearchResultsDelegate, UITextFieldDelegate, AddTextPopoverDelegate {
    
    
    var typeCollectionView = UICollectionView(frame: CGRectMake(0, 0, 100, 100), collectionViewLayout:UICollectionViewFlowLayout())     // this is a hard problem.....
    let typeNames = ["Name", "Tagline", "Screenshots"]
    let typeIcons = []
    
    var bottomView = UIView()
    var middleView = UIView()
    var upView = UIView()
    
    
    var leftButton = UIButton()
    var rightButton = UIButton()
    
    
    let tempX : CGFloat = 82.0
    var tempYTagline : CGFloat = 0
    var tempWidthTagline : CGFloat = 0
    
    // Dyanmic view
    var beginningLabel = UILabel()
    var addTextView = UIView()
    
    var inputTextField = UITextField()
    
    var taglineTextView = UITextView()
    var taglineSaveButton = UIButton()
    
    var appSearchResults = AppSearchResultsView(frame: CGRectMake(0, 44, 100, 200))     // wtf
    
    var addTextPopoverView = AddTextPopoverView()
    
    
    
    // After creating some information of the product
    var iconImageView = UIImageView()
    var appNameLabel = UILabel()
    var authorLabel = UILabel()
    var appDescriptionLabel = YQLabel()
    
    
    
    
    override init() {
        super.init()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        view.backgroundColor = UIColor.whiteColor()
        let xPadding = CGFloat(16.0)
        let yPadding = CGFloat(10.0)
        
        
        
        let tempHeight = screenWidth*(216/320)-38.5 // This should be the keyboard size.
        bottomView.frame = CGRectMake(0, CGRectGetHeight(view.frame)-tempHeight, CGRectGetWidth(view.frame), tempHeight)
        bottomView.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleWidth
        // bottomView.backgroundColor = UIColor.waveColor()
        
        view.addSubview(bottomView)
        
        
        /*
        let addTextButton = YQButtonWithImageAndTitle(frame: CGRectMake(0, 0, 100, 100), normalImage: UIImage(named: "Trending_v1.png"), highlightedImage: UIImage(named: "notification_v1.png"))
        bottomView.addSubview(addTextButton)
        */
        
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        // two variables
        // https://developer.apple.com/library/ios/documentation/WindowsViews/Conceptual/CollectionViewPGforIOS/UsingtheFlowLayout/UsingtheFlowLayout.html
        
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        let tempWidth = (UIScreen.mainScreen().bounds.size.width-2*10-2*flowLayout.minimumLineSpacing)/3;
        flowLayout.itemSize = CGSizeMake(tempWidth, tempHeight-30);
        
        typeCollectionView = UICollectionView(frame: CGRectMake(0, 0, screenWidth, tempHeight), collectionViewLayout: flowLayout)
        
        typeCollectionView.backgroundColor = UIColor.whiteColor()
        typeCollectionView.delegate = self
        typeCollectionView.dataSource = self
        typeCollectionView.scrollEnabled = false
        
        let nib = UINib(nibName: "CreateNewCollectionViewCell", bundle: nil)
        typeCollectionView.registerNib(nib, forCellWithReuseIdentifier: "CreateNewCollectionCell")
        
        bottomView.addSubview(typeCollectionView)
        
        
        
        let middleViewHeight = CGFloat (44.0)
        middleView.frame = CGRectMake(0, CGRectGetHeight(view.frame)-tempHeight-middleViewHeight, CGRectGetWidth(view.frame), middleViewHeight)
        middleView.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleWidth
        // middleView.backgroundColor = UIColor.grassColor()
        
        view.addSubview(middleView)
        
        let tempLine1 = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(view.frame), 0.5))
        tempLine1.backgroundColor = UIColor.lightGrayColor()
        tempLine1.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleWidth
        middleView.addSubview(tempLine1)
        
        let tempLine2 = UIView(frame: CGRectMake(0, CGRectGetHeight(middleView.frame)-1, CGRectGetWidth(view.frame), 0.5))
        tempLine2.backgroundColor = UIColor.lightGrayColor()
        tempLine2.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleWidth
        middleView.addSubview(tempLine2)
        
        
        
        leftButton.frame = CGRectMake(10, 0, 80, CGRectGetHeight(middleView.frame))
        leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        leftButton.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleTopMargin
        leftButton.setTitle("BACK", forState: UIControlState.Normal)
        
        leftButton.setTitleColor(UIColor.infoBlueColor(), forState: UIControlState.Normal)
        leftButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        // rightButton.backgroundColor = UIColor.grassColor()
        leftButton.titleLabel!.font =  UIFont(name: "Lato-Regular", size: 15)
        
        leftButton.addTarget(self, action: "clickCancelButton:", forControlEvents: UIControlEvents.TouchUpInside)
        middleView.addSubview(leftButton)
        
        
        
        rightButton.frame = CGRectMake(CGRectGetWidth(middleView.frame)-90, 0, 80, CGRectGetHeight(middleView.frame))
        rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        rightButton.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleTopMargin
        rightButton.setTitle("DISCARD", forState: UIControlState.Normal)
        
        rightButton.setTitleColor(UIColor.dangerColor(), forState: UIControlState.Normal)
        rightButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        // rightButton.backgroundColor = UIColor.grassColor()
        rightButton.titleLabel!.font =  UIFont(name: "Lato-Bold", size: 15)
        
        rightButton.addTarget(self, action: "clickPostButton:", forControlEvents: UIControlEvents.TouchUpInside)
        middleView.addSubview(rightButton)
        
        
        
        
        upView.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetMinY(middleView.frame))
        upView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        // upView.backgroundColor = UIColor(fromHexString: "D6D6CC")
        upView.backgroundColor = UIColor(fromHexString: "D9D9D9")
        view.addSubview(upView)
        
        // your beta testing app
        beginningLabel.text = "—  POST  YOUR  BETA  TESTING  APP  —"
        beginningLabel.textAlignment = NSTextAlignment.Center
        upView.addSubview(beginningLabel)
        
        
        
        inputTextField.placeholder = "Enter App Name..."
        // inputTextField.textAlignment = NSTextAlignment.Center
        // inputTextField.font = UIFont(name: "Lato-Regular", size: 15)
        inputTextField.font = UIFont.systemFontOfSize(14)
        inputTextField.borderStyle = UITextBorderStyle.RoundedRect
        inputTextField.tag = 0
        inputTextField.delegate = self
        inputTextField.returnKeyType = UIReturnKeyType.Next
        
        // inputTextField.addTarget(self, action: "myTextFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        
        taglineTextView.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        taglineTextView.layer.borderWidth = 1.0
        taglineTextView.layer.cornerRadius = 5.0
        taglineTextView.clipsToBounds = true
        
        
        
        appSearchResults.delegate = self
        
        
        CreatingNewProductDataManager.sharedInstance
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        println("init.......")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        // view.backgroundColor = UIColor(red: 41.0/255.0, green: 45.0/255.0, blue: 53.0/255.0, alpha: 0.8)
        
        var swipeDown = UISwipeGestureRecognizer(target: self, action: "swipeDown:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipeDown)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "dismissView", name:"finishedPostingNewAppToParse", object: nil)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        beginningLabel.frame = CGRectMake(0, CGRectGetHeight(upView.frame)*0.5-20, CGRectGetWidth(view.frame), 40)
        
        // iPhone 6
        if (self.view.frame.size.width >= 375) {
            beginningLabel.font = UIFont(name: "Lato-Bold", size: 18)
        }
        // iPhone 5
        else {
            beginningLabel.font = UIFont(name: "Lato-Bold", size: 16)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if(CreatingNewProductDataManager.sharedInstance.isFirstStepFinished){
            updateViewAfterFinishName()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func tapCancelButton(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
        NSNotificationCenter.defaultCenter().postNotificationName("popFromCreateNewViewController", object: nil)
    }
    
    /// Back button
    func clickCancelButton(sender:UIButton!)
    {
        println("Button tapped")
        TestMixpanel.pressCreateBack(CreatingNewProductDataManager.sharedInstance.isFirstStepFinished, secondStep:CreatingNewProductDataManager.sharedInstance.isSecondStepFinished, thirdStep:CreatingNewProductDataManager.sharedInstance.isThirdStepFinished)
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    func clickPostButton(sender:UIButton!)
    {
        println("Button tapped")
        
        if(CreatingNewProductDataManager.sharedInstance.onlyCheckAllValue() && !UserManager.sharedInstance.hasLoginWithTwitter){
            TestMixpanel.pressCreatePost()
            
            let alertController = UIAlertController(title: "Post a New Beta App", message: "You need to login with Twitter to finish.", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                // ...
            }
            alertController.addAction(cancelAction)
            
            let loginAction = UIAlertAction(title: "Login with Twitter", style: .Default) { (action) in
                TestMixpanel.pressCreatePostAndLogin()
                
                PFTwitterUtils.logInWithBlock {
                    (user: PFUser!, error: NSError!) -> Void in
                    if user == nil {
                        NSLog("Uh oh. The user cancelled the Twitter login.")
                    } else if user.isNew {
                        NSLog("User signed up and logged in with Twitter!")
                        TestMixpanel.loginSuccessFromCreateView()
                        TestMixpanel.pressCreatePostWithoutAnonymous()
                        
                        NSUserDefaults.standardUserDefaults().setObject(true, forKey: "login")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        UserManager.sharedInstance.updateUserInfoFromTwitterUsername()
                        
                        SVProgressHUD.show()
                        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "saveAndDismiss", userInfo: nil, repeats: false)
                        
                        // More work is needed here....
                        // Refresh data......
                        
                    } else {
                        NSLog("User logged in with Twitter!")
                        TestMixpanel.loginSuccessFromCreateView()
                        TestMixpanel.pressCreatePostWithoutAnonymous()
                        
                        NSUserDefaults.standardUserDefaults().setObject(true, forKey: "login")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        UserManager.sharedInstance.updateUserInfoFromTwitterUsername()
                        
                        SVProgressHUD.show()
                        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "saveAndDismiss", userInfo: nil, repeats: false)
                    }
                }
            }
            alertController.addAction(loginAction)
            
            let anonymousAction = UIAlertAction(title: "Continue as Anonymous User", style: .Default) { (action) in
                TestMixpanel.pressCreatePostAsAnonymous()
                SVProgressHUD.show()
                self.saveAndDismiss()
            }
            // alertController.addAction(anonymousAction)
            
            self.presentViewController(alertController, animated: true) {
                
            }
        }
        else if(!CreatingNewProductDataManager.sharedInstance.onlyCheckAllValue()){
            dismissView()
            CreatingNewProductDataManager.sharedInstance.checkAllValue()
        }
        else {
            TestMixpanel.pressCreatePost()
            TestMixpanel.pressCreatePostWithoutAnonymous()
            
            SVProgressHUD.show()
            saveAndDismiss()
        }
    }
    
    func saveAndDismiss(){
        CreatingNewProductDataManager.sharedInstance.checkAllValue()
    }
    
    func dismissView(){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CreateNewCollectionCell", forIndexPath: indexPath) as CreateNewCollectionViewCell
        cell.backgroundColor = UIColor(fromHexString: "#F5F5F5")
        
        cell.typeLabel.text = typeNames[indexPath.row]
        
        var tempIsFinished = false
        if (indexPath.row == 0){
            tempIsFinished = CreatingNewProductDataManager.sharedInstance.isFirstStepFinished
        }
        else if (indexPath.row == 1){
            tempIsFinished = CreatingNewProductDataManager.sharedInstance.isSecondStepFinished
        }
        else if (indexPath.row == 2){
            tempIsFinished = CreatingNewProductDataManager.sharedInstance.isThirdStepFinished
        }
        
        cell.isFinished = tempIsFinished
        println(tempIsFinished)
        
        if (tempIsFinished){
            cell.addFinishIndicator()
        }
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)

        if(indexPath.row == 0){
            // Old version
            // addTextAboutProduct()
            addText()
            TestMixpanel.pressCreateName()
        }
        else if(indexPath.row == 1) {
            // Old version
            // addTaglineAboutProduct()
            addHashtags()
            TestMixpanel.pressCreateHashtag()
        }
        else {
            addScreenshotsAboutProduct()
            // addReview()
            TestMixpanel.pressCreateReview()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        
        cell?.backgroundColor = UIColor(fromHexString: "#D9D9D9")   // D9D9D9
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.backgroundColor = UIColor(fromHexString: "#F5F5F5")
    }
    
    func swipeDown(recognizer:UISwipeGestureRecognizer){
        println("Swipe down.")
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    // No available now.
    func addTextAboutProduct(){
        let temp = AddTextViewController(nibName: "AddTextViewController", bundle: nil)
        temp.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        presentViewController(temp, animated: true) { () -> Void in
            
        }
        
        /*
        var txtView: UITextView = UITextView(frame: CGRect(x: 0, y: 100, width: CGRectGetWidth(self.upView.frame), height: 200.00));
        self.upView.addSubview(txtView)
        // txtView.borderStyle = UITextBorderStyle.Line
        txtView.font = UIFont(name: "Lato-Bold", size: 15)
        txtView.text = ""
        // txtView.backgroundColor = UIColor.redColor()
        */
    }
    
    // No available now.
    func addTaglineAboutProduct(){
        let temp = AddTaglineViewController(nibName: "AddTaglineViewController", bundle: nil)
        temp.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        presentViewController(temp, animated: true) { () -> Void in
            
        }
    }
    
    func addScreenshotsAboutProduct(){
        
        addScreenshotsAboutProductFromUser();
        
        /*
        var alertView: UIAlertView = UIAlertView()
        
        alertView.delegate = self
        
        alertView.title = "Screenshot Types"
        alertView.message = "You can choose to upload screenshots from your photos, or the app can load them directly from app store."
        alertView.addButtonWithTitle("From Photos")
        alertView.addButtonWithTitle("From App Store")
        alertView.addButtonWithTitle("Cancel")
        
        alertView.show()
        */
    }
    
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        
        switch buttonIndex{
        case 0:
            addScreenshotsAboutProductFromUser();
            break;
        case 1:
            addScreenshotsAboutProductFromAppStore();
            break;
        default:
            NSLog("Default");
            break;
        }
    }
    
    func addScreenshotsAboutProductFromAppStore(){
        CreatingNewProductDataManager.sharedInstance.loadScreenshotsFromAppStore()
        
        // No selected third step now.
        // CreatingNewProductDataManager.sharedInstance.isThirdStepFinished = true
        checkWhetherPostIsFinished()
    }
    
    func addScreenshotsAboutProductFromUser(){
        var imagePickerController = QBImagePickerController()
        imagePickerController.delegate = self;
        imagePickerController.allowsMultipleSelection = true
        let imagePickerNavigationController = UINavigationController(rootViewController: imagePickerController)
        imagePickerNavigationController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        presentViewController(imagePickerNavigationController, animated: true) { () -> Void in
            
        }
    }
    
    // imagePickerController
    func dismissImagePickerController(){
        dismissViewControllerAnimated(true, completion: { () -> Void in
            self.checkWhetherPostIsFinished()
        })
    }
    
    func qb_imagePickerController(imagePickerController: QBImagePickerController!, didSelectAsset asset: ALAsset!) {
        dismissImagePickerController()
    }
    
    func qb_imagePickerController(imagePickerController: QBImagePickerController!, didSelectAssets assets: [AnyObject]!) {
        
        // assets
        CreatingNewProductDataManager.sharedInstance.finishScreenshots(assets)
        dismissImagePickerController()
    }
    
    func qb_imagePickerControllerDidCancel(imagePickerController: QBImagePickerController!) {
        dismissImagePickerController()
    }
    
    //*********************
    // add text
    //*********************
    func addText(){
        addTextView.frame = CGRectMake(0, 0, CGRectGetWidth(upView.frame), 44)
        addTextView.backgroundColor = UIColor(red: 41.0/255.0, green: 45.0/255.0, blue: 53.0/255.0, alpha: 0.8)
        upView.addSubview(addTextView)
        
        let tempBackButton = UIButton(frame: CGRectMake(CGRectGetWidth(middleView.frame)-60, 0, 60, 44))
        
        tempBackButton.setTitle("Cancel", forState: UIControlState.Normal)
        tempBackButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        tempBackButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        // tempBackButton.titleLabel!.font =  UIFont(name: "Lato-Bold", size: 15)
        tempBackButton.titleLabel!.font = UIFont.systemFontOfSize(14)
        
        tempBackButton.addTarget(self, action: "clickAppSearchCancelButton:", forControlEvents: UIControlEvents.TouchUpInside)
        
        addTextView.addSubview(tempBackButton)
        
        
        inputTextField.frame = CGRectMake(xPadding, CGRectGetHeight(addTextView.frame)*0.5-28*0.5, CGRectGetMinX(tempBackButton.frame)-xPadding, 28)
        inputTextField.backgroundColor = UIColor.whiteColor()
        addTextView.addSubview(inputTextField)
        
        inputTextField.becomeFirstResponder()
        
        
        self.appSearchResults = AppSearchResultsView(frame: CGRectMake(0, 44, CGRectGetWidth(upView.frame), 0))
        self.appSearchResults.delegate = self
        view.addSubview(appSearchResults)
    }
    
    func changeSearchResultsViewSizeWithNewHeight(newHeight: CGFloat) {
        println(newHeight)
        let oldFrame = self.appSearchResults.frame
        self.appSearchResults.frame = CGRectMake(CGRectGetMinX(oldFrame), CGRectGetMinY(oldFrame), CGRectGetWidth(oldFrame), newHeight)
        self.appSearchResults.setNeedsDisplay()
    }
    
    func hideKeyboard(){
        inputTextField.resignFirstResponder()
    }
    
    func clickAppSearchCancelButton(sender:UIButton!) {
        addTextView.removeFromSuperview()
        appSearchResults.removeFromSuperview()
    }
    
    func clickSearchButton(sender:UIButton!) {
        self.appSearchResults.updateEnteredAppName(inputTextField.text)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField.tag == 0){
            // self.appSearchResults.updateEnteredAppName(inputTextField.text)
            CreatingNewProductDataManager.sharedInstance.finishName(inputTextField.text, appURL: "yiqin.info")
            updateViewAfterFinishName()
            inputTextField.resignFirstResponder()
        }
        return true
    }
    
    func selectedAppFromSearch(app:App) {
        CreatingNewProductDataManager.sharedInstance.finishApp(app)
        
        updateViewAfterFinishName()
        addTextView.removeFromSuperview()
        appSearchResults.removeFromSuperview()
    }
    
    func updateViewAfterFinishName(){
        beginningLabel.hidden = true
        
        iconImageView.removeFromSuperview()
        appNameLabel.removeFromSuperview()
        authorLabel.removeFromSuperview()
        appDescriptionLabel.removeFromSuperview()
        
        
        // Copy from TableViewCell......
        // I hate this method.
        let app = CreatingNewProductDataManager.sharedInstance.selectedApp
        iconImageView = UIImageView(frame: CGRectMake(16, 44+10, 50, 50))
        iconImageView.image = app.artwork100
        view.addSubview(iconImageView)
        
        
        appNameLabel = UILabel(frame: CGRectMake(tempX, 44+4, CGRectGetWidth(self.view.frame)-tempX-10, 28))
        appNameLabel.text = app.trackName
        view.addSubview(appNameLabel)
        
        authorLabel = UILabel(frame: CGRectMake(tempX, CGRectGetMaxY(appNameLabel.frame)-5, CGRectGetWidth(self.view.frame)-tempX-10, 22))
        authorLabel.text = "Created by \(app.artistName)"
        authorLabel.font = UIFont.systemFontOfSize(13)
        authorLabel.textColor = UIColor.grayColor()
        view.addSubview(authorLabel)
        
        appDescriptionLabel = YQLabel()
        appDescriptionLabel.yqNumberOfLine = 3
        appDescriptionLabel.font = UIFont.systemFontOfSize(13)
        appDescriptionLabel.setFrame(CGRectMake(tempX, 60.0+44.0, CGRectGetWidth(self.view.frame)-tempX-2, 50), font: appDescriptionLabel.font, text: app.appDescription)
        view.addSubview(appDescriptionLabel)
        
        
        tempYTagline = CGRectGetMaxY(appDescriptionLabel.frame)+15
        tempWidthTagline = CGRectGetWidth(appDescriptionLabel.frame)-20
        
        typeCollectionView.reloadData()
    }
    
    //*********************
    // add tagline
    //*********************
    func addHashtags(){
        addTextPopoverView = AddTextPopoverView(frame: CGRectMake(1.5*xPadding, 44, CGRectGetWidth(view.frame)-3*xPadding, 250), title: "Add Tagline", placeholder:"Very short description of the product (make it catchy!)")
        addTextPopoverView.tag = 0
        addTextPopoverView.delegate = self
        view.addSubview(addTextPopoverView)
    }
    
    //*********************
    // add review
    //*********************
    func addReview(){
        addTextPopoverView = AddTextPopoverView(frame: CGRectMake(1.5*xPadding, 44, CGRectGetWidth(view.frame)-3*xPadding, 250), title: "Add Review", placeholder:"Enter what do you think about it...")
        addTextPopoverView.tag = 1
        addTextPopoverView.delegate = self
        view.addSubview(addTextPopoverView)
    }
    
    func checkWhetherPostIsFinished(){
        typeCollectionView.reloadData()
        if(CreatingNewProductDataManager.sharedInstance.onlyCheckAllValue()) {
            rightButton.setTitle("POST", forState: UIControlState.Normal)
            rightButton.setTitleColor(UIColor.infoBlueColor(), forState: UIControlState.Normal)
        }
    }
    
    // MARK: AddTextPopoverView Delegate
    func cancelTextInput(){
        
    }
    
    func finishTextInput(text:String){
        println("finish text input.")
        if (addTextPopoverView.tag == 0){
            CreatingNewProductDataManager.sharedInstance.finishHashtags(text)
        }
        else {
            CreatingNewProductDataManager.sharedInstance.finishReview(text)
        }
        checkWhetherPostIsFinished()
    }

}
