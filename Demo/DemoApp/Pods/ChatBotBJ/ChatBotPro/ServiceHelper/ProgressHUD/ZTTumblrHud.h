//
//  Created by Ankita Dhaka on 1/6/15.
//  Copyright (c) 2015 Mobiloitte. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Header.h"

@interface ZTTumblrHud : UIView

@property (nonatomic, strong) UIColor *hudColor;

-(void)showAnimated:(BOOL)animated;
-(void)hide;

-(void)hideHUD;

@end