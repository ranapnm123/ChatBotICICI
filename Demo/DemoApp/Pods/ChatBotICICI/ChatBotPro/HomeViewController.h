//
//  HomeViewController.h
//  ChatBot
//
//  Created by PULP on 24/07/18.
//  Copyright © 2018 Ashish Kr Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController
-(IBAction)crossBtnAction:(id)sender;
-(IBAction)startBotAction:(id)sender;
@property(nonatomic, strong) UIView *containerView;
@property(nonatomic, strong) UITextView *textView;
@property(nonatomic, strong) UIButton *startBotBtn;
@property(nonatomic, strong) UIButton *crossBtn;
@end

NS_ASSUME_NONNULL_END
