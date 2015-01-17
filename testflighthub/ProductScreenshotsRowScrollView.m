//
//  ProductScreenshotsRowScrollView.m
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import "ProductScreenshotsRowScrollView.h"
#import "ProductScreenshotCollectionViewCell.h"
#import <Parse/Parse.h>
#import <testflighthub-Swift.h>
#import <Colours.h>

@interface ProductScreenshotsRowScrollView()
@property(nonatomic) CGFloat screenshotWidth;

// @property(nonatomic) CGFloat previoursContentOffX;

@end


@implementation ProductScreenshotsRowScrollView

- (instancetype) initWithFrame:(CGRect)frame product:(Product *)selectedProduct
{
    self = [self initWithFrame:frame];
    if (self) {
        
        self.product = selectedProduct;
        [self ScreenshotsWillLoad];
        
        self.imagesCollectionData = [[NSMutableArray alloc] init];
        // self.previoursContentOffX = 0;
        
        CGFloat tempWidth = [UIScreen mainScreen].bounds.size.width*0.6;
        CGFloat tempHeight = [UIScreen mainScreen].bounds.size.height*0.6;
        
        // iPhone 4 doesn't work with this dimension......
        // This is the fatest way to do it, but not the best.
        if (tempHeight/tempWidth <= 960.0/640.0) {
            tempWidth = (640.0/1136.0)*tempHeight;
        }
        self.screenshotWidth = tempWidth;
        
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(tempWidth, tempHeight);
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 16, 10, 10);
        
        // flowLayout.minimumLineSpacing = 0;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, tempHeight+20) collectionViewLayout:flowLayout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
        self.collectionView.showsHorizontalScrollIndicator = NO;
        // self.collectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
        self.collectionView.backgroundColor = [UIColor colorFromHexString:@"F5F5F5"];
        
        UINib *nib = [UINib nibWithNibName:@"ProductScreenshotCollectionViewCell" bundle:nil];
        [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"ScreenshotCell"];
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)ScreenshotsWillLoad
{
    PFQuery *query  = [PFQuery queryWithClassName:@"Screenshot"];
    
    self.imagesArray = [[NSMutableArray alloc] init];
    [query whereKey:@"belongTo" equalTo: self.product.parseObject];
    [query orderByAscending:@"ordered"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        for (PFObject *object in objects) {
            TestImage *testImage = [[TestImage alloc] initWithPffile:[object objectForKey:@"image"]];
            [self.imagesArray addObject:testImage];
        }
        
        self.imagesCollectionData = [NSMutableArray arrayWithArray:objects];;
        [self.collectionView reloadData];
    }];
}

#pragma mark - UICollectionViewDataSource methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.imagesCollectionData count];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // NSLog(@"%f", self.collectionView.contentOffset.x);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    /*
    NSLog(@"it stop drag..... %f", self.collectionView.contentOffset.x);
    
    float contentOffsetX = scrollView.contentOffset.x;
    // float width ＝ float (screenshotWidth);
    
    
    int i = 0;
    if ((contentOffsetX-self.previoursContentOffX)>50) {
        while(contentOffsetX > i*(self.screenshotWidth+10)){
            i++;
            NSLog(@"%d", i);
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        }
    }
    else if((contentOffsetX-self.previoursContentOffX)<-50){
        
    }
    
    self.previoursContentOffX = contentOffsetX;
    */
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ImageCellIdentifier = @"ScreenshotCell";
    ProductScreenshotCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageCellIdentifier forIndexPath:indexPath];
    
    TestImage *testImage = [self.imagesArray objectAtIndex:indexPath.row];
    
    if (testImage.isLoading) {
        PFObject *object = [self.imagesCollectionData objectAtIndex:indexPath.row];
        cell.screenshotImageView.file = [object objectForKey:@"image"];
        [cell.screenshotImageView loadInBackground:^(UIImage *image, NSError *error) {
            NSLog(@"successfully loading here..........");
            
        }];
    }
    else {
        cell.screenshotImageView.image = testImage.image;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
