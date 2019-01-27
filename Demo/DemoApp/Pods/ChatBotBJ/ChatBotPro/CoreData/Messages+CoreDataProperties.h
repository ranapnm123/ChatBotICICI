//
//  Messages+CoreDataProperties.h
//  ChatBot
//
//  Created by PULP on 08/08/18.
//  Copyright © 2018 Ashish Kr Singh. All rights reserved.
//
//

#import "Messages+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Messages (CoreDataProperties)

+ (NSFetchRequest<Messages *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *message;
@property (nonatomic) int16_t messageId;
@property (nullable, nonatomic, copy) NSDate *messageTime;
@property (nullable, nonatomic, copy) NSString *descriptionStr;
@property (nullable, nonatomic, copy) NSString *imageName;
@property (nullable, nonatomic, copy) NSString *thumbnailImage;
@property (nullable, nonatomic, copy) NSString *videoURL;
@property (nullable, nonatomic, copy) NSString *gifImage;
@property (nullable, nonatomic, retain) NSData *carausalArrayData;
@property (nullable, nonatomic, retain) NSData *optionsArrayData;
@property (nullable, nonatomic, retain) NSData *data;
@property (nonatomic) BOOL isSender;
@property (nonatomic) BOOL isCarausal;
@property (nonatomic) BOOL isOption;
@property (nonatomic) BOOL isProgress;
@property (nonatomic) BOOL isDoc;

@end

NS_ASSUME_NONNULL_END
