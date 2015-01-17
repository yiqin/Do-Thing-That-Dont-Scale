//
//  NTHorizontalPageViewController.swift
//  testflighthub
//
//  Created by Yi Qin on 12/17/14.
//  Copyright (c) 2014 Yi Qin. All rights reserved.
//

import Foundation
import UIKit

let horizontalPageViewCellIdentify = "horizontalPageViewCellIdentify"

class NTHorizontalPageViewController : UICollectionViewController, NTTransitionProtocol ,NTHorizontalPageViewControllerProtocol{
    
    var imageNameList : Array <NSString> = []
    var pullOffset = CGPointZero
    
    init(collectionViewLayout layout: UICollectionViewLayout!, currentIndexPath indexPath: NSIndexPath){
        super.init(collectionViewLayout:layout)
        let collectionView :UICollectionView = self.collectionView!;
        collectionView.pagingEnabled = true
        collectionView.registerClass(NTHorizontalPageViewCell.self, forCellWithReuseIdentifier: horizontalPageViewCellIdentify)
        collectionView.setToIndexPath(indexPath)
        collectionView.performBatchUpdates({collectionView.reloadData()}, completion: { finished in
            if finished {
                collectionView.scrollToItemAtIndexPath(indexPath,atScrollPosition:.CenteredHorizontally, animated: false)
            }});
        
        // This is a wrong value......
        // view.backgroundColor = UIColor(red: 41.0/255.0, green: 45.0/255.0, blue: 53.0/255.0, alpha: 0.8)
        view.backgroundColor = UIColor.clearColor()
        // view.backgroundColor = UIColor.whiteColor()
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().postNotificationName("hideTabBarUIView", object: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        var collectionCell: NTHorizontalPageViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(horizontalPageViewCellIdentify, forIndexPath: indexPath) as NTHorizontalPageViewCell
        collectionCell.imageName = self.imageNameList[indexPath.row]
        
        self.title = collectionCell.imageName
        
        collectionCell.tappedAction = {}
        collectionCell.pullAction = { offset in
            self.pullOffset = offset
            
            //viewWillAppearWithPageIndex
            let childrenCount = self.navigationController!.viewControllers.count
            let toViewController = self.navigationController!.viewControllers[childrenCount-2] as NTWaterFallViewControllerProtocol
            let toView = toViewController.transitionCollectionView()
            let popedViewController = self.navigationController!.viewControllers[childrenCount-1] as UICollectionViewController
            
            let popView  = popedViewController.collectionView!;
            let indexPath = popView.fromPageIndexPath()
            toViewController.viewWillAppearWithPageIndex(indexPath.row)
            toView.setToIndexPath(indexPath)
            
            self.navigationController!.popViewControllerAnimated(true)
            
            // show tabbar....
            NSNotificationCenter.defaultCenter().postNotificationName("showTabBarUIView", object: nil)
        }
        collectionCell.setNeedsLayout()
        return collectionCell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return imageNameList.count;
    }
    
    func transitionCollectionView() -> UICollectionView!{
        return collectionView
    }
    
    func pageViewCellScrollViewContentOffset() -> CGPoint{
        return self.pullOffset
    }
}