//
//  MessageInfo.h
//  ChatBot
//
//  Created by Ashish Kr Singh on 14/07/18.
//  Copyright © 2018 Ashish Kr Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MessageInfo : NSObject
@property( nonatomic) int messageId;
@property(strong, nonatomic) NSString *message;
@property(strong, nonatomic) NSString *descriptionStr;
@property(strong, nonatomic) NSString *fileNameStr;
@property(strong, nonatomic) UIImage *imageName;
@property(strong, nonatomic) NSURL *thumbnailImage;
@property(strong, nonatomic) NSURL *videoURL;
@property(strong, nonatomic) NSString *gifImage;
@property(strong, nonatomic) NSArray *carausalArray;
@property(strong, nonatomic) NSArray *optionsArray;
@property(strong, nonatomic) NSData *data;
@property(assign) BOOL isSender;
@property(assign) BOOL isCarausal;
@property(assign) BOOL isOption;
@property(assign) BOOL isProgress;
@property(assign) BOOL isDoc;
@property (nullable, nonatomic, copy) NSDate *messageTime;

@end
