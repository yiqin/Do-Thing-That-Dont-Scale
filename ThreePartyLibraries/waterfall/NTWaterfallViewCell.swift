//
//  NTWaterfallViewCell.swift
//  testflighthub
//
//  Created by Yi Qin on 12/17/14.
//  Copyright (c) 2014 Yi Qin. All rights reserved.
//

import UIKit

class NTWaterfallViewCell :UICollectionViewCell, NTTansitionWaterfallGridViewProtocol{
    
    var imageName : String?
    var imageViewContent : UIImageView = UIImageView()
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        contentView.addSubview(imageViewContent)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        /**********************/
        /*     When the size is different, it looks bad....               */
        /**********************/
        
        // This is better (not the best) for iphone 6....... (only for iphone 6.......)
        imageViewContent.frame = CGRectMake(0.5, 0, frame.size.width+0.25, frame.size.height)       // iPhone 6 is 1 pixel off........
        
        // This is the best for iphone 5......
        imageViewContent.frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
        imageViewContent.image = UIImage(named: imageName!)
    }
    
    func snapShotForTransition() -> UIView! {
        let snapShotView = UIImageView(image: self.imageViewContent.image)
        snapShotView.frame = imageViewContent.frame
        return snapShotView
    }
}