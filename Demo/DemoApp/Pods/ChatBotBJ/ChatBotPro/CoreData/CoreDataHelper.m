//
//  CoreDataHelper.m
//  ChatBot
//
//  Created by PULP on 07/08/18.
//  Copyright © 2018 Ashish Kr Singh. All rights reserved.
//

#import "CoreDataHelper.h"
#import <CoreData/CoreData.h>
#import "Header.h"

@implementation CoreDataHelper


+(NSData *)jsonStringFromDictionary:(NSDictionary *)dict{
NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithDictionary:dict];

NSError *error;
NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tempDict
                                                   options:0
                                                     error:&error];
    return jsonData;
}

+(NSDictionary *)dictionaryFromData:(NSData *)data{
NSError *jsonerror;
NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                          options:0
                                                            error:&jsonerror];
    return dict;
}

+(void)saveSentMessageDataTolocalDB:(MessageInfo *)msgInfo{
    //Save to persistant storage
//    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext){
//        Messages *message = [Messages MR_createEntityInContext:localContext];
        //        message.messageId = msgInfo.messageId;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Messages"];
    
    NSError *error;
    NSArray *arrResults = [[[CoreDataManager sharedManager] managedObjectContext] executeFetchRequest:request error:&error];
    
    if (!arrResults || error){
        
        // Handle Error
        //NSLog(@"************** Error in add Screen to core data method");
        return;
    }
    
    Messages *message = [NSEntityDescription insertNewObjectForEntityForName:@"Messages" inManagedObjectContext:[[CoreDataManager sharedManager] managedObjectContext]];
    
  
        message.message = msgInfo.message;
        message.descriptionStr = msgInfo.descriptionStr;
        
        //            message.thumbnailImage = msgInfo.thumbnailImage;
        message.videoURL = [NSString stringWithFormat:@"%@",msgInfo.videoURL];
        message.thumbnailImage = [NSString stringWithFormat:@"%@",msgInfo.thumbnailImage];
        if(msgInfo.gifImage.length == 0){
            message.imageName = msgInfo.gifImage;
        }
        else{
            message.gifImage = msgInfo.gifImage;
        }
        
        if(msgInfo.carausalArray.count>0){
            message.carausalArrayData = [NSKeyedArchiver archivedDataWithRootObject:msgInfo.carausalArray];
        }
        
        if(msgInfo.optionsArray.count>0){
            
            message.optionsArrayData = [NSKeyedArchiver archivedDataWithRootObject:msgInfo.optionsArray];
        }
        //        message.data = msgInfo.data;
        message.isSender = msgInfo.isSender;
        message.isCarausal = msgInfo.isCarausal;
        message.isOption = msgInfo.isOption;
        message.isProgress = msgInfo.isProgress;
        message.isDoc = msgInfo.isDoc;
        message.messageTime = [NSDate date];
    
      [[CoreDataManager sharedManager] saveContext];
//    }
//                      completion:^(BOOL success, NSError *error){
//
//                      }];
}

+(NSUInteger)getMessagesCount
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Messages"];
    
    NSError *error;
    NSArray *arrResults = [[[CoreDataManager sharedManager] managedObjectContext] executeFetchRequest:request error:&error];
    
    if (!arrResults || error)
    {
        
    }
    else
    {
        
        
        return arrResults.count;
        
    }
    return 0;
}

+(NSArray *)getMessagesData
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Messages"];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"messageTime" ascending:YES];
    [request setSortDescriptors:@[sort]];
    NSError *error;
    NSArray *arrResults = [[[CoreDataManager sharedManager] managedObjectContext] executeFetchRequest:request error:&error];
    
    if (!arrResults || error)
    {
        
    }
    else
    {
        
        
        return arrResults;
        
    }
    return nil;
}

+(void)updateMessageDataTolocalDBFrom:(NSString *)oldVal to:(NSString *)newVal{

    
//    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext){
//        NSPredicate *imageFilter = [NSPredicate predicateWithFormat:@"gifImage == %@",oldVal];
//        Messages *message = [Messages MR_findFirstWithPredicate:imageFilter inContext:localContext];
//        message.gifImage = newVal;
//        
//    }
//                      completion:^(BOOL success, NSError *error){
//                          
//                      }];
}
@end
