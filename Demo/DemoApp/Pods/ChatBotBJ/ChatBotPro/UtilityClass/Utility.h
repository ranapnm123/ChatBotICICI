//
//  Utility.h
//  ChatBot
//
//  Created by PULP on 24/07/18.
//  Copyright © 2018 Ashish Kr Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface Utility : NSObject
+(NSData *)getFileInDocDir:(NSString *)strUrl;
+(void)saveFile:(NSString *)strUrl;
+(UIWindow *)getWindow;
+(NSBundle *)getBundleForChatBotPro;
+(NSString *)getFileUrlInDocDir:(NSString *)strUrl;
+(NSData *)getFileFromTempDir:(NSString *)strUrl;
+(NSString *)saveImage:(NSData*)imageData withName:(NSString*)imageName;
+(UIImage*)retrieveImage:(NSString*)fileNamewhichtoretrieve;
+ (void)removeImage:(NSString *)filename;
+ (BOOL)renameFileFrom:(NSString*)oldName to:(NSString *)newName;
+(NSString*)getFileNameFromURL :(NSString*) URL;
+(NSData *)getreceivedFileInDocDir:(NSString *)strUrl;
+(NSString *)getSelectedTextFromTitle:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
