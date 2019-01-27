//
//  AppManager.m
//  TestWithOutXib
//
//  Created by Chirag Bhutani on 09/12/14.
//  Copyright (c) 2014 PulpStrategy. All rights reserved.
//

#import "AppManager.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


@implementation AppManager

@synthesize  mDictImageForURL;



#pragma mark Singleton Methods



+ (id)sharedManager {
    static AppManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        mDictImageForURL = [[NSMutableDictionary alloc] init];
        
    }
    
    return self;
}

-(void)checkReachability{
    
    Rechability * reach = [Rechability reachabilityForInternetConnection];
    self.isReachable = [reach isReachable];
    
    
    
    reach.reachableBlock = ^(Rechability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isReachable = YES;
            
        });
    };
    
    reach.unreachableBlock = ^(Rechability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isReachable = NO;
        });
    };
    
    [reach startNotifier];
}

@end

