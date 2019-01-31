//
//  CollectionViewTableViewCell.h
//  ChatBot
//
//  Created by Ashish Kr Singh on 15/07/18.
//  Copyright © 2018 Ashish Kr Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
- (void)setCollectionData:(NSArray *)collectionData;
 @property (strong, nonatomic)  NSMutableArray *dataArray;

@end
