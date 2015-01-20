//
//  TextMixpanel.swift
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

class TestMixpanel: NSObject {
    
    class func start() {
        /*
        let deviceName = UIDevice.currentDevice().name
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.people.set("DeviceName", to: deviceName)
        mixpanel.registerSuperProperties(["DeviceName":deviceName])
        */
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Enter App.")
    }
    
    class func setName() {
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.people.set("Name", to: PFUser.currentUser().username)
        mixpanel.registerSuperProperties(["Name":PFUser.currentUser().username])
    }
    
    // General view
    class func enteredTrending(){
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Trending View")
    }
    
    class func enteredRecent() {
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Recent View")
    }
    
    class func enteredProductDetailView() {
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Product Detail View")
    }
    
    class func enteredNotification() {
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Notification View")
    }
    
    class func enteredProfile() {
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Profile View")
    }
    
    class func enteredYourLikesView() {
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("My Likes View")
    }
    
    class func enteredYourRecommendationsView() {
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("My Recommendations View")
    }
    
    class func enteredCreateView(fromView : String) {
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Create View", properties: ["From View":fromView])
    }
    
    // Creating
    class func pressCreateName() {
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("About to Enter App Name")
    }
    
    class func createNameSuccessfully() {
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Enter App Name Successfully")
    }
    
    class func pressCreateHashtag() {
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("About to Enter Hashtag")
    }
    
    class func createHashtagSuccessfully() {
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Enter Hashtag Successfully")
    }
    
    class func pressCreateReview() {
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("About to Enter Review")
    }
    
    class func createReviewSuccessfully() {
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Enter Review Successfully")
    }
    
    //  Search Apps Results
    class func getSearchResult(count : Int){
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Search App Results", properties: ["count":count])
    }
    
    // Creating back
    class func pressCreateBack(firstStep:Bool, secondStep:Bool, thirdStep:Bool) {
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Creating Back", properties: ["Name":firstStep, "Hashtag":secondStep, "Review":thirdStep])
    }
    
    class func pressCreateDiscard(firstStep:Bool, secondStep:Bool, thirdStep:Bool) {
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Creating Discard", properties: ["Name":firstStep, "Hashtag":secondStep, "Review":thirdStep])
    }
    
    // About to Post
    class func pressCreatePost() {
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("About to Post")
    }
    
    class func pressCreatePostAndLogin(){
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Login", properties: ["From Where":"Create View"])
    }
    
    class func pressCreatePostAsAnonymous(){
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Post", properties: ["Anonymous":"Yes"])
    }
    
    class func pressCreatePostWithoutAnonymous(){
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Post", properties: ["Anonymous":"No"])
    }
    
    // Login and Logout
    class func login(){
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Login", properties: ["From Where":"Profile View"])
    }
    
    class func logout() {
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Logout")
    }
    
    class func logoutAndClear(){
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Logout and Clear")
    }
    
    class func loginSuccessFromProfileView() {
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Login Success", properties: ["From Where":"Profile View"])
        TestMixpanel.setName()
    }
    
    class func loginSuccessFromCreateView() {
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Login Success", properties: ["From Where":"Create View"])
        TestMixpanel.setName()
    }
    
    class func loginSuccessFromComment() {
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Login Success", properties: ["From Where":"Comment"])
        TestMixpanel.setName()
    }
    
    // Comment Action
    class func pressAddComment() {
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Press Comment")
    }
    
    class func addCommentToLogin() {
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Login", properties: ["From Where":"Comment"])
    }
    
    // No use.....
    class func cancelCommentInRegular() {
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Cancel Comment", properties: ["From Where":"Regular"])
    }
    
    class func cancelCommentWhenNeedLogin() {
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Cancel Comment", properties: ["From Where":"Need Login"])
    }
    
    // Get App
    class func getAppFromTrending() {
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Get App", properties: ["From Where":"Trending View"])
    }
    
    class func getAppFromRecent() {
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Get App", properties: ["From Where":"Recent View"])
    }
    
    class func getAppFromProductDetailView() {
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Get App", properties: ["From Where":"Product Detail View"])
    }
    
    // No use........
    class func getLikeFromTrending() {
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Get Like", properties: ["From Where":"Trending View"])
    }
    
    class func getLikeFromRecent() {
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Get Like", properties: ["From Where":"Recent View"])
    }
    
    // Others
    class func loadMoreProducts() {
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Load More Products")
    }
    
    // No use
    class func refresh() {
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Refresh to Load Product")
    }
    
    class func copyAppURL(){
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Copy App URL")
    }
    
    class func pressSettingButton(){
        var mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Press Setting Button")
    }
}
