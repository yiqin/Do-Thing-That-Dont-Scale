//
//  ProductDescriptionTableViewCell.swift
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

protocol ProductDescriptionTableViewCellDelegate {
    func updateDescriptionTableCell()
}

class ProductDescriptionTableViewCell: UITableViewCell {
    
    var nameLabel = YQLabel()
    var taglineLable = YQLabel() // We still use tagline in Description cell.
    
    var underline = UIView()
    
    var moreButton = UIButton()
    
    var isMore = false
    
    var delegate:ProductDescriptionTableViewCellDelegate?
    
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
        
        moreButton.setTitle("more...", forState: UIControlState.Normal)
        moreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        moreButton.titleLabel?.font = UIFont(name:"Lato-Regular", size: 15)
        moreButton.setTitleColor(UIColor.infoBlueColor(), forState: UIControlState.Normal)
        moreButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        
        moreButton.addTarget(self, action: "loadMoreDescription", forControlEvents: UIControlEvents.TouchUpInside)
        addSubview(moreButton)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.frame = CGRectMake(xPadding, yPadding, screenWidth-2*xPadding, 30)
        underline.frame = CGRectMake(xPadding, CGRectGetMaxY(nameLabel.frame)-2, kUnderlineWidth, kUnderlineHeight)
        taglineLable.setFrame(CGRectMake(xPadding, 50.0, screenWidth-2*xPadding, CGRectGetHeight(frame)), font: self.taglineLable.font, text: taglineLable.text)
        
        if(!isMore) {
            moreButton.frame = CGRectMake(xPadding, CGRectGetMaxY(taglineLable.frame), 50, 25)
        }
    }
    
    
    func setContentValue(product:Product, isDescriptionMoreMode:Bool){
        
        if(!isDescriptionMoreMode){
            taglineLable.yqNumberOfLine = 6
        }
        isMore = isDescriptionMoreMode
        
        nameLabel.text = "Description".uppercaseString
        taglineLable.text = product.appDescription
    }
    
    func loadMoreDescription(){
        delegate?.updateDescriptionTableCell()
    }
    
    class func cellHeight(product:Product, isDescriptionMoreMode:Bool)->CGFloat{
        
        let tempLabel = YQLabel()
        if(!isDescriptionMoreMode){
            tempLabel.yqNumberOfLine = 6
        }
        
        tempLabel.setFrame(CGRectMake(xPadding, 0, screenWidth-2*xPadding, screenWidth), font: UIFont(name:"Lato-Regular", size: 15), text: product.appDescription)        
        
        return CGRectGetHeight(tempLabel.frame)+40+2*yPadding+yPadding+10
    }

}
