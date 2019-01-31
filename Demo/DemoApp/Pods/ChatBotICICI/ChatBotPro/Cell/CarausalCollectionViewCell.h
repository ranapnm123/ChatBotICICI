//
//  CarausalCollectionViewCell.h
//  ChatBot
//
//  Created by Ashish Kr Singh on 15/07/18.
//  Copyright © 2018 Ashish Kr Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarausalCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *readMoreBtn;
@property (weak, nonatomic) IBOutlet UIButton *readMoreBtn2;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
