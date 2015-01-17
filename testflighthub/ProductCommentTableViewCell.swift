//
//  ProductCommentTableViewCell.swift
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

class ProductCommentTableViewCell: UITableViewCell {
    
    let profileImageSize :CGFloat = 40.0
    
    var nameLabel = UILabel()
    var contentLabel = YQLabel()
    var timeLabel = UILabel()
    
    var profileImageView = PFImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = UITableViewCellSelectionStyle.None;
        
        
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = profileImageSize*0.5;
        addSubview(profileImageView)
        
        nameLabel.font = UIFont(name:"Lato-Bold", size: 15)
        addSubview(nameLabel)
        
        timeLabel.font = UIFont(name:"Lato-Regular", size: 11)
        timeLabel.textColor = UIColor.grayColor()
        timeLabel.textAlignment = NSTextAlignment.Right
        addSubview(timeLabel)
        
        contentLabel.font = UIFont(name:"Lato-Regular", size: 15)
        addSubview(contentLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.frame = CGRectMake(xPadding, xPadding, profileImageSize, profileImageSize)
        
        nameLabel.frame = CGRectMake(xPadding+CGRectGetMaxX(profileImageView.frame), xPadding, 200, 20)
        timeLabel.frame = CGRectMake(CGRectGetWidth(self.frame)-xPadding-200, CGRectGetMinY(nameLabel.frame), 200, 20)
        
        let contentLabelXPosition = xPadding+CGRectGetMaxX(profileImageView.frame)
        
        contentLabel.setFrame(CGRectMake(contentLabelXPosition, xPadding+25-2, CGRectGetWidth(frame)-xPadding-contentLabelXPosition, CGRectGetHeight(frame)), font: self.contentLabel.font, text: contentLabel.text)
        
    }
    
    func setContentValue(object:PFObject){
        
        contentLabel.text = object["content"] as NSString
        
        nameLabel.text = object["name"] as NSString
        
        profileImageView.file = object["profileImage"] as PFFile
        profileImageView.loadInBackground { (profileImage:UIImage!, error:NSError!) -> Void in
            
        }
        
        let dateFromParse = object.createdAt
        timeLabel.text = dateFromParse.timeAgoSinceNow()
    }
    
    class func cellHeight(content:NSString)->CGFloat{
        
        let profileImageSize :CGFloat = 40.0
        
        let tempLabel = YQLabel()
        tempLabel.setFrame(CGRectMake(xPadding+profileImageSize, 0, screenWidth-2*xPadding-profileImageSize, screenWidth), font: UIFont(name:"Lato-Regular", size: 15), text: content)
        
        // 60 is the profile image size....
        return CGRectGetHeight(tempLabel.frame)+xPadding+xPadding+25+10;
    }
    
}
