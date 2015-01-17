//
//  ProductScreenshotsTableViewCell.swift
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

class ProductScreenshotsTableViewCell: UITableViewCell {
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, product: Product) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = UITableViewCellSelectionStyle.None;
        
        backgroundColor = UIColor.whiteColor()
        
        let temp = ProductScreenshotsRowScrollView(frame: CGRectMake(0, 0, screenWidth, screenHeight*0.6+20), product: product)
        
        addSubview(temp)

    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        println(screenWidth)
      
    }
    
    class func cellHeight()->CGFloat{
        return screenHeight*0.6+20;
    }

}
