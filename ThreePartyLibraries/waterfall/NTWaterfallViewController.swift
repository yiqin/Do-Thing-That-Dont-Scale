//
//  ViewController.swift
//  testflighthub
//
//  Created by Yi Qin on 12/17/14.
//  Copyright (c) 2014 Yi Qin. All rights reserved.
//

import UIKit

let waterfallViewCellIdentify = "waterfallViewCellIdentify"

// This delegate conflicts to the Cicle one.........
class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate{
    
    func navigationController(navigationController: UINavigationController!, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController!, toViewController toVC: UIViewController!) -> UIViewControllerAnimatedTransitioning!{
        
        let transition = NTTransition()
        transition.presenting = operation == .Pop
        
        
        return  transition
    }
    
}

class NTWaterfallViewController:UICollectionViewController,CHTCollectionViewDelegateWaterfallLayout, NTTransitionProtocol, NTWaterFallViewControllerProtocol{
    
    // class var sharedInstance: NSInteger = 0 Are u kidding me?
    var imageNameList : Array <NSString> = []
    let delegateHolder1 = NavigationControllerDelegate()
    let delegateHolder2 = CircleNavigationControllerDelegate()
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showCreateNew", name: "showCreateNewFromRecents", object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.setNavigationBarHidden(true, animated: true)
        // println(navigationController!.navigationBarHidden)
        
        
        self.navigationController!.delegate = delegateHolder1
        self.view.backgroundColor = UIColor.yellowColor()
        
        var index = 0
        while(index<5){
            let imageName = NSString(format: "%d.png", index)
            imageNameList.append(imageName)
            index++
        }
        
        let collection :UICollectionView = collectionView!;
        collection.frame = screenBounds
        collection.setCollectionViewLayout(CHTCollectionViewWaterfallLayout(), animated: false)
        collection.backgroundColor = UIColor.whiteColor()
        collection.registerClass(NTWaterfallViewCell.self, forCellWithReuseIdentifier: waterfallViewCellIdentify)
        collection.reloadData()
        
        
        // navigationController?.setNavigationBarHidden(false, animated: true)
        
        // tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        hidesBottomBarWhenPushed = true;
        tabBarController?.tabBar.hidden = true
        
        self.navigationController!.delegate = delegateHolder1
        
    }
    
    func showCreateNew() {
        self.navigationController!.delegate = delegateHolder2
        
        performSegueWithIdentifier("PushSegure1", sender: self)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        let image:UIImage! = UIImage(named: self.imageNameList[indexPath.row] as NSString)
        let imageHeight = image.size.height*gridWidth/image.size.width
        return CGSizeMake(gridWidth, imageHeight)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        var collectionCell: NTWaterfallViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(waterfallViewCellIdentify, forIndexPath: indexPath) as NTWaterfallViewCell
        collectionCell.imageName = self.imageNameList[indexPath.row]
        collectionCell.setNeedsLayout()
        return collectionCell;
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return imageNameList.count;
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        
        let pageViewController =
        NTHorizontalPageViewController(collectionViewLayout: pageViewControllerLayout(), currentIndexPath:indexPath)
        
        pageViewController.imageNameList = imageNameList
        collectionView.setToIndexPath(indexPath)
        
        // How to control bottomBar
        // http://stackoverflow.com/questions/6117717/when-using-hidesbottombarwhenpushed-i-want-the-tab-bar-to-reappear-when-i-push
        
        // Hide bar first
        navigationController?.setNavigationBarHidden(true, animated: true)
        hidesBottomBarWhenPushed = true;
        navigationController!.pushViewController(pageViewController, animated: true)
        // hidesBottomBarWhenPushed = false;   // Comment this if we use a customized tab bar.
    }
    
    func pageViewControllerLayout () -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        
        let itemSize  = CGSizeMake(screenWidth, screenHeight)
        
        flowLayout.itemSize = itemSize
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .Horizontal
        return flowLayout
    }
    
    func viewWillAppearWithPageIndex(pageIndex : NSInteger) {
        var position : UICollectionViewScrollPosition =
        .CenteredHorizontally & .CenteredVertically
        let image:UIImage! = UIImage(named: self.imageNameList[pageIndex] as NSString)
        let imageHeight = image.size.height*gridWidth/image.size.width
        if imageHeight > 400 {//whatever you like, it's the max value for height of image
           position = .Top
        }
        let currentIndexPath = NSIndexPath(forRow: pageIndex, inSection: 0)
        let collectionView = self.collectionView!;
        collectionView.setToIndexPath(currentIndexPath)
        if pageIndex<2{
            collectionView.setContentOffset(CGPointZero, animated: false)
        }else{
            collectionView.scrollToItemAtIndexPath(currentIndexPath, atScrollPosition: position, animated: false)
        }
    }
    
    func transitionCollectionView() -> UICollectionView!{
        return collectionView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

