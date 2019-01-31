//
//  ReciverTableViewCell.h
//  ChatBot
//
//  Created by Ashish Kr Singh on 14/07/18.
//  Copyright © 2018 Ashish Kr Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@interface ReciverTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *messageTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
