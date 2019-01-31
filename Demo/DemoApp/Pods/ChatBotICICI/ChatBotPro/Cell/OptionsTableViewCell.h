//
//  OptionsTableViewCell.h
//  ChatBot
//
//  Created by PULP on 23/07/18.
//  Copyright © 2018 Ashish Kr Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OptionsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *containerView;
-(void)setData:(NSArray *)dataArray;

@end

NS_ASSUME_NONNULL_END
