//
//  ProgressCell.m
//  ChatBot
//
//  Created by PULP on 23/07/18.
//  Copyright © 2018 Ashish Kr Singh. All rights reserved.
//

#import "ProgressCell.h"
#import "MBProgressHUD.h"

@implementation ProgressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imageview.layer.cornerRadius = 18;
    self.imageview.clipsToBounds = true;
    self.imageview.layer.borderWidth = 1.0;
    self.imageview.layer.borderColor = [UIColor colorWithRed:22/255.0 green:188/255.0 blue:206/255.0 alpha:1].CGColor;
    
    [self showProgress];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)showProgress{
    [MBProgressHUD showHUDAddedTo:self animated:YES];
}

@end
