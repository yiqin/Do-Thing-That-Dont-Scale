//
//  ProductUpvotesRowScrollView.m
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import "ProductUpvotesRowScrollView.h"
#import "ProductUpvoteCollectionViewCell.h"
#import <Parse/Parse.h>
#import <testflighthub-Swift.h>
#import <Colours.h>

@implementation ProductUpvotesRowScrollView

- (instancetype) initWithFrame:(CGRect)frame product:(Product *)selectedProduct profileImages:(NSArray *)upvoteProfileImages
{
    self = [self initWithFrame:frame];
    if (self) {
        
        self.product = selectedProduct;
        self.upvoteProfileImages = upvoteProfileImages;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        flowLayout.itemSize = CGSizeMake(40, 40);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
        
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40) collectionViewLayout:flowLayout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
        self.collectionView.showsHorizontalScrollIndicator = NO;
        // self.collectionView.backgroundColor = [UIColor colorFromHexString:@"F5F5F5"];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        
        // self.imagesCollectionData = @[[UIImage imageNamed:@"1.png"], [UIImage imageNamed:@"1.png"], [UIImage imageNamed:@"1.png"]];
        self.imagesCollectionData = [[NSMutableArray alloc] init];
        
        UINib *nib = [UINib nibWithNibName:@"ProductUpvoteCollectionViewCell" bundle:nil];
        
        
        
        [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"ProfileImageCell"];
        
        
        [self addSubview:self.collectionView];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.upvoteProfileImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ImageCellIdentifier = @"ProfileImageCell";
    
    ProductUpvoteCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageCellIdentifier forIndexPath:indexPath];
    
    UpvoteProfileImage *upvoteProfileImage = [self.upvoteProfileImages objectAtIndex:indexPath.row];
    if (upvoteProfileImage.isLoading) {
        cell.profileImageView.file = upvoteProfileImage.file;
        [cell.profileImageView loadInBackground:^(UIImage *image, NSError *error) {
            NSLog(@"successfully loading");
            
        }];
    }
    else {
        cell.profileImageView.image = upvoteProfileImage.image;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
