//
//  AttachmentCell.m
//  ChatBot
//
//  Created by PULP on 26/07/18.
//  Copyright © 2018 Ashish Kr Singh. All rights reserved.
//

#import "AttachmentCell.h"

@implementation AttachmentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imageview.layer.cornerRadius = 18;
    self.imageview.clipsToBounds = true;
    self.imageview.layer.borderWidth = 1.0;
    self.imageview.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.containerView.layer.cornerRadius = 8;
    self.containerView.layer.borderWidth = 1;
    self.containerView.layer.borderColor = [UIColor colorWithRed:(228.0/255.0) green:(228/255.0) blue:(228/255.0) alpha:1.0].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
