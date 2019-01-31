//
//  ImageReceiverTableViewCell.m
//  ChatBot
//
//  Created by Ashish Kr Singh on 14/07/18.
//  Copyright © 2018 Ashish Kr Singh. All rights reserved.
//

#import "ImageReceiverTableViewCell.h"

@implementation ImageReceiverTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imageview.layer.cornerRadius = 18;
    self.imageview.clipsToBounds = true;
    self.imageview.layer.borderWidth = 1.0;
    self.imageview.layer.borderColor = [UIColor colorWithRed:22/255.0 green:188/255.0 blue:206/255.0 alpha:1].CGColor;
    
    self.messageImageView.layer.cornerRadius = 6;
    self.messageImageView.clipsToBounds = true;
    self.containerView.layer.cornerRadius = 8;
    self.containerView.layer.masksToBounds = false;
    self.containerView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.containerView.layer.shadowOffset = CGSizeMake(0, 1);
    self.containerView.layer.shadowOpacity = 1;
    self.containerView.layer.shadowRadius = 1.0;
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
