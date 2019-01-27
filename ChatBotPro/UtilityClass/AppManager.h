//
//  AppManager.h
//  TestWithOutXib
//
//  Created by Chirag Bhutani on 09/12/14.
//  Copyright (c) 2014 PulpStrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "Rechability.h"


@interface AppManager : NSObject <UIAlertViewDelegate>{
}
@property (nonatomic, strong) NSMutableDictionary *mDictImageForURL;
+ (id)sharedManager;
-(void)checkReachability;
@property (nonatomic, assign) BOOL                       isReachable;

@end
