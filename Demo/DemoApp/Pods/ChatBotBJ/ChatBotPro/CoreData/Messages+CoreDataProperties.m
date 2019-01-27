//
//  Messages+CoreDataProperties.m
//  ChatBot
//
//  Created by PULP on 08/08/18.
//  Copyright © 2018 Ashish Kr Singh. All rights reserved.
//
//

#import "Messages+CoreDataProperties.h"

@implementation Messages (CoreDataProperties)

+ (NSFetchRequest<Messages *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Messages"];
}

@dynamic message;
@dynamic messageId;
@dynamic messageTime;
@dynamic descriptionStr;
@dynamic imageName;
@dynamic thumbnailImage;
@dynamic videoURL;
@dynamic gifImage;
@dynamic carausalArrayData;
@dynamic optionsArrayData;
@dynamic data;
@dynamic isSender;
@dynamic isCarausal;
@dynamic isOption;
@dynamic isProgress;
@dynamic isDoc;

@end
