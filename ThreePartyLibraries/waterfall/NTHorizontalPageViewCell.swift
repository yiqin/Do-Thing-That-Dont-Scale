//
//  NTHorizontalPageViewCell.swift
//  testflighthub
//
//  Created by Yi Qin on 12/17/14.
//  Copyright (c) 2014 Yi Qin. All rights reserved.
//

import Foundation
import UIKit

let cellIdentify = "cellIdentify"

/// in Page.....
class NTTableViewCell : UITableViewCell{
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.textLabel?.font = UIFont.systemFontOfSize(13)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageView :UIImageView = self.imageView!;
        imageView.frame = CGRectZero
        if (imageView.image != nil) {
            let imageHeight = imageView.image!.size.height*screenWidth/imageView.image!.size.width
            imageView.frame = CGRectMake(0, 0, screenWidth, imageHeight)
        }
    }
}

class NTHorizontalPageViewCell : UICollectionViewCell, UITableViewDelegate, UITableViewDataSource{
    
    var imageName : String?
    var pullAction : ((offset : CGPoint) -> Void)?
    var tappedAction : (() -> Void)?
    let tableView = UITableView(frame: screenBounds, style: UITableViewStyle.Plain)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.lightGrayColor()
        
        // [UIColor colorWithRed:41.0/255.0 green:45.0/255.0 blue:53.0/255.0 alpha:0.8]
        tableView.backgroundColor = UIColor(red: 41.0/255.0, green: 45.0/255.0, blue: 53.0/255.0, alpha: 0.8)
        
        contentView.addSubview(tableView)
        tableView.registerClass(NTTableViewCell.self, forCellReuseIdentifier: cellIdentify)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentify) as NTTableViewCell!
        cell.imageView?.image = nil
        cell.textLabel?.text = nil
        
        // Set the image size automatically.
        if indexPath.row == 0 {
            let image = UIImage(named: imageName!)
            cell.imageView?.image = image
        }else{
            cell.textLabel?.text = "try pull to pop view controller 😃"
        }
        cell.setNeedsLayout()
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var cellHeight : CGFloat = navigationHeight
        if indexPath.row == 0 {
            let image:UIImage! = UIImage(named: imageName!)
            let imageHeight = image.size.height*screenWidth/image.size.width
            cellHeight = imageHeight
        }
        
        return cellHeight
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tappedAction?()
    }
    
    func scrollViewWillBeginDecelerating(scrollView : UIScrollView) {
        if scrollView.contentOffset.y < navigationHeight{
            pullAction?(offset: scrollView.contentOffset)
        }
    }
}