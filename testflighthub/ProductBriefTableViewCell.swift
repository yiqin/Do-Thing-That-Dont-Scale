//
//  ProductBriefTableViewCell.swift
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit


class ProductBriefTableViewCell: UITableViewCell {
    
    let profileImageSize :CGFloat = 40.0
    
    var nameLabel = YQLabel()
    var taglineLable = YQLabel()
    var underline = UIView()
    
    var recommendLabel = UILabel()
    var userLabel = UILabel()
    var userProfileImage = PFImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = UITableViewCellSelectionStyle.None;
        // backgroundColor = UIColor.redColor()
        
        nameLabel.font = kNamelabelFont
        nameLabel.textColor = kNamelabelColor
        addSubview(nameLabel)
        
        underline.backgroundColor = kUnderlineColor
        addSubview(underline)
        
        taglineLable.font = UIFont(name:"Lato-Regular", size: 15)
        // taglineLable.textColor = mainColor
        addSubview(taglineLable)
        
        recommendLabel.font  = UIFont(name: "Lato-Regular", size: 9)
        recommendLabel.textColor = UIColor.grayColor()
        recommendLabel.text = "recommended by".uppercaseString
        addSubview(recommendLabel)
        
        userLabel.font = UIFont(name: "Lato-Regular", size: 15)
        addSubview(userLabel)
        
        userProfileImage.layer.masksToBounds = true
        userProfileImage.layer.cornerRadius = 40*0.5;
        addSubview(userProfileImage)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.frame = CGRectMake(xPadding, yPadding, screenWidth-2*xPadding, 30)
        underline.frame = CGRectMake(xPadding, CGRectGetMaxY(nameLabel.frame)-2, kUnderlineWidth, kUnderlineHeight)
        taglineLable.setFrame(CGRectMake(xPadding, 50.0, screenWidth-2*xPadding, CGRectGetHeight(frame)), font: self.taglineLable.font, text: taglineLable.text)
        
        userProfileImage.frame = CGRectMake(xPadding, CGRectGetMaxY(taglineLable.frame)+xPadding, profileImageSize, profileImageSize)
        recommendLabel.frame = CGRectMake(xPadding+CGRectGetMaxX(userProfileImage.frame), CGRectGetMaxY(taglineLable.frame)+xPadding+1, 200, 16)
        userLabel.frame = CGRectMake(xPadding+CGRectGetMaxX(userProfileImage.frame), CGRectGetMaxY(taglineLable.frame)+xPadding+16, 200, 20)
    }
    
    
    func setContentValue(product:Product){
        nameLabel.text = "Tagline".uppercaseString
        taglineLable.text = product.tagline
        userLabel.text = product.postedByUsername
        
        if (product.isLoadingPostedByProfileImage){
            if let tempPFFile = product.parseObject["iconImage"] as? PFFile {
                userProfileImage.file = tempPFFile
                userProfileImage.loadInBackground({ (image : UIImage!, error : NSError!) -> Void in
                    self.userProfileImage.image = image
                })
            }
        }
        else {
            userProfileImage.image = product.postedByProfileImage
        }
    }
    
    
    class func cellHeight(product:Product)->CGFloat{
        
        let tempLabel = YQLabel()
        tempLabel.setFrame(CGRectMake(xPadding, 0, screenWidth-2*xPadding, screenWidth), font: UIFont(name:"Lato-Regular", size: 15), text: product.tagline)
        
        return CGRectGetHeight(tempLabel.frame)+40+2*yPadding+yPadding+40+yPadding-5;
    }
    

}
