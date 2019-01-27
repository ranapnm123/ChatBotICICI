//
//  CoreDataHelper.h
//  ChatBot
//
//  Created by PULP on 07/08/18.
//  Copyright © 2018 Ashish Kr Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageInfo.h"
#import "Messages+CoreDataProperties.h"
#import "CoreDataManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataHelper : NSObject
+(NSData *)jsonStringFromDictionary:(NSDictionary *)dict;
+(NSDictionary *)dictionaryFromData:(NSData *)data;
+(void)saveSentMessageDataTolocalDB:(MessageInfo *)msgInfo;
+(void)updateMessageDataTolocalDBFrom:(NSString *)oldVal to:(NSString *)newVa;
+(NSUInteger)getMessagesCount;
+(NSArray *)getMessagesData;
@end

NS_ASSUME_NONNULL_END
