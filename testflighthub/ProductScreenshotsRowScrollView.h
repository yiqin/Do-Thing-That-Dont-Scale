//
//  ProductScreenshotsRowScrollView.h
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Product;

@interface ProductScreenshotsRowScrollView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

- (instancetype) initWithFrame:(CGRect)frame product:(Product *)selectedProduct;
@property (nonatomic, strong) Product *product;
@property (nonatomic, strong) NSMutableArray *imagesCollectionData;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *imagesArray;

@end
