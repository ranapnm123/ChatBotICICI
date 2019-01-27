//
//  OPServiceHelper.h
//  Openia
//
//  Created by Sunil Verma on 25/03/16.
//  Copyright © 2016 Mobiloitte Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Header.h"


typedef void(^OPRequestComplitopnBlock)(id result, NSError  *error);



@interface OPServiceHelper : NSObject


+(id)sharedServiceHelper;

-(void)cancelGetRequestSession;
-(void)cancelPostRequestSession;




// use to call get apis

-(void)GetAPICallWithParameter:(NSMutableDictionary *)parameterDict apiName:(NSString *)apiName  WithComptionBlock:(OPRequestComplitopnBlock)block;

// Use to call post apis
-(void)PostAPICallWithParameter:(NSMutableDictionary *)parameterDict apiName:(NSString *)apiName methodName:(WebMethodType)methodName WithComptionBlock:(OPRequestComplitopnBlock)block;





@end
