//
//  AttachmentCell.h
//  ChatBot
//
//  Created by PULP on 26/07/18.
//  Copyright © 2018 Ashish Kr Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AttachmentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *messageTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@end

NS_ASSUME_NONNULL_END
