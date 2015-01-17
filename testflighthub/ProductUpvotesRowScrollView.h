//
//  ProductUpvotesRowScrollView.h
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Product;

@interface ProductUpvotesRowScrollView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

- (instancetype) initWithFrame:(CGRect)frame product:(Product *)selectedProduct profileImages:(NSArray *)upvoteProfileImages;
@property (nonatomic, strong) Product *product;
@property (nonatomic, strong) NSMutableArray *imagesCollectionData;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *upvoteProfileImages;

@end
