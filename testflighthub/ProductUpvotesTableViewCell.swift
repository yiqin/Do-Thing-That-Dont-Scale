//
//  ProductAboutTableViewCell.swift
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

class ProductUpvoteTableViewCell: UITableViewCell {
    
    let profileImageSize :CGFloat = 40.0
    
    var nameLabel = YQLabel()
    var underline = UIView()
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, product: Product, profileImages: NSArray) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = UITableViewCellSelectionStyle.None;
        // backgroundColor = UIColor.redColor()
        
        nameLabel.font = kNamelabelFont
        nameLabel.textColor = kNamelabelColor
        addSubview(nameLabel)
        
        underline.backgroundColor = kUnderlineColor
        addSubview(underline)
        
        
        nameLabel.frame = CGRectMake(xPadding, yPadding, screenWidth-2*xPadding, 30)
        underline.frame = CGRectMake(xPadding, CGRectGetMaxY(nameLabel.frame)-2, kUnderlineWidth, kUnderlineHeight)
        
        let temp = ProductUpvotesRowScrollView(frame: CGRectMake(0, CGRectGetMaxY(underline.frame)+yPadding, screenWidth, 40), product: product, profileImages: profileImages)
        addSubview(temp)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setContentValue(product:Product){
        nameLabel.text = "likes".uppercaseString
    }
    
    
    class func cellHeight(product:Product)->CGFloat{
        
        return 111+5;
    }
    

}
