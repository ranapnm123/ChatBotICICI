//
//  CollectionViewTableViewCell.m
//  ChatBot
//
//  Created by Ashish Kr Singh on 15/07/18.
//  Copyright © 2018 Ashish Kr Singh. All rights reserved.
//

#import "CollectionViewTableViewCell.h"
#import "CarausalCollectionViewCell.h"

@implementation CollectionViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCollectionData:(NSArray *)collectionData {
    _dataArray = [[NSMutableArray alloc] initWithArray:collectionData];
}

#pragma mark - UICollectionViewDelegate & DataSource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(220, 150);
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CarausalCollectionViewCell *cell = (CarausalCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"CarausalCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *dataDict = [_dataArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = [dataDict objectForKey:@"title"];
    cell.descriptionLabel.text = [dataDict objectForKey:@"text"];
    NSArray *buttnArray = [dataDict objectForKey:@"buttons"];
    cell.readMoreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    cell.readMoreBtn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    cell.readMoreBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    cell.readMoreBtn2.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    if (buttnArray.count == 2) {
        cell.readMoreBtn2.hidden = NO;
    }
    else{
        cell.readMoreBtn2.hidden = YES;
    }
    for(NSDictionary *dict in buttnArray){
        [cell.readMoreBtn setTitle:[dict objectForKey:@"text"] forState:UIControlStateNormal];
        [[cell.readMoreBtn layer] setValue:dict forKey:@"data"];
    }
    [cell.readMoreBtn addTarget:self action:@selector(readMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
     [cell.readMoreBtn2 addTarget:self action:@selector(readMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
    //cell.contentView.layer.cornerRadius = 6;
    cell.contentView.layer.borderWidth = 1;
    cell.contentView.layer.borderColor = [UIColor colorWithRed:(228.0/255.0) green:(228/255.0) blue:(228/255.0) alpha:1.0].CGColor;
    return cell;
}

-(void)readMoreBtn:(UIButton *)btn{
//    btn.backgroundColor = UIColor.blueColor;
//    NSLog(@"buttontext %@",btn.titleLabel.text);
    NSDictionary  *yourObj = [[btn layer] valueForKey:@"data"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"collectionCellButtonActionNotification" object:yourObj];
}
@end
