//
//  OPServiceHelper.m
//  Openia
//
//  Created by Sunil Verma on 25/03/16.
//  Copyright © 2016 Mobiloitte Inc. All rights reserved.
//

#import "OPServiceHelper.h"

#import<CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "Header.h"
#import "AppManager.h"

#define kHudHideAnimationTime   0.0



@interface OPServiceHelper()<NSURLSessionDelegate, NSURLSessionTaskDelegate>
{
    NSUInteger responseCode;
    NSURLSession *getRequestSession;
    NSURLSession *postRequestSession;
    NSURLSession *downLoadsession;
    
    
}
@property (nonatomic, strong)    NSMutableData		   *downLoadedData;

@end

static OPServiceHelper *serviceHelper = nil;

@implementation OPServiceHelper



+(id)sharedServiceHelper
{
    
    if (!serviceHelper) {
        
        serviceHelper = [[OPServiceHelper alloc] init];
    }
    
    return serviceHelper;
}


-(void)cancelGetRequestSession
{
    [getRequestSession invalidateAndCancel];
}
-(void)cancelPostRequestSession
{
    [postRequestSession invalidateAndCancel];
}

//-(NSString *)getAuthHeader
//{
//    NSData *basicAuthCredentials = [[NSString stringWithFormat:@"%@:%@", @"admin", @"1234"] dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *base64AuthCredentials = [basicAuthCredentials base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];
//
//  return [NSString stringWithFormat:@"Basic %@", base64AuthCredentials];
//}



/// Session


-(void)GetAPICallWithParameter:(NSMutableDictionary *)parameterDict apiName:(NSString *)apiName WithComptionBlock:(OPRequestComplitopnBlock)block
{
    
    OPRequestComplitopnBlock completionBlock = [block copy];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(![[AppManager sharedManager] isReachable])
        {
            [OPRequestTimeOutView showWithMessage:kNetworkErrorMessage forTime:3.0];
            completionBlock(nil, [NSError errorWithDomain:@"com.mpos" code:100 userInfo:nil]);
            
            return;
        }
    });
    NSMutableString *urlString;
    if([[parameterDict valueForKey:@"isForVersionUpdate"] boolValue]){
        urlString = [NSMutableString stringWithString:@"http://itunes.apple.com/lookup?id=1182925323"];
        [parameterDict removeAllObjects];
    }else{
        urlString = [NSMutableString stringWithString:SERVICE_BASE_URL];
        [urlString appendFormat:@"%@",apiName];
    }
    
    BOOL isFirst = YES;
    
    for (NSString *key in [parameterDict allKeys]) {
        
        id object = parameterDict[key];
        if ([object isKindOfClass:[NSArray class]]) {
            
            for (id eachObject in object) {
                [urlString appendString: [NSString stringWithFormat:@"%@%@=%@", isFirst ? @"?": @"&", key, eachObject]];
                isFirst = NO;
            }
        }
        else {
            [urlString appendString: [NSString stringWithFormat:@"%@%@=%@", isFirst ? @"?": @"&", key, parameterDict[key]]];
        }
        
        isFirst = NO;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    
    
   
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    
    NSLog(@"Request URL :%@   Params:  %@",urlString,parameterDict);
    
    if (!getRequestSession) {
        NSURLSessionConfiguration *sessionConfig =  [NSURLSessionConfiguration defaultSessionConfiguration];
        [sessionConfig setTimeoutIntervalForRequest:70.0];
        
        getRequestSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    }
    
    
    [[getRequestSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            
            // success response
            id result = [NSDictionary dictionaryWithContentsOfJSONURLData:data];
//            NSLog(@"Response:  %@   error  %@  ",[NSString getStringFromData:data],error);
            
            
            if ([[result objectForKey:@"responseCode"] integerValue] == 401) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                });
            }
            completionBlock(result,  error);
            
            
        }else{
            completionBlock(data, error);
        }
    }] resume];
    
}

-(void)PostAPICallWithParameter:(NSMutableDictionary *)parameterDict apiName:(NSString *)apiName methodName:(WebMethodType)methodName WithComptionBlock:(OPRequestComplitopnBlock)block
{
    
    OPRequestComplitopnBlock completionBlock = [block copy];
    
//    if(![APPDELEGATE isReachable])
//    {
//        [OPRequestTimeOutView showWithMessage:kNetworkErrorMessage forTime:3.0];
//        
//        completionBlock(nil, [NSError errorWithDomain:@"com.mpos" code:100 userInfo:nil]);
//        
//        return;
//    }
    NSMutableString *urlString = [NSMutableString stringWithString:apiName];
    
   // [urlString appendFormat:@"%@",apiName];
    //api/users/
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"Super Agent/0.0.1" forHTTPHeaderField:@"User-Agent"];

    NSLog(@"Request URL :%@   Params:  %@",urlString,[[NSString alloc] initWithData:[parameterDict toJSON] encoding:NSUTF8StringEncoding]);
    
    [request setHTTPBody:[parameterDict toJSON]];
    
    
    
    if (!postRequestSession) {
        NSURLSessionConfiguration *sessionConfig =  [NSURLSessionConfiguration defaultSessionConfiguration];
        [sessionConfig setTimeoutIntervalForRequest:30.0];
        postRequestSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
        
    }
    
    
    [[postRequestSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            // success response
            
            NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
            
            NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@" error : %@   Code: %ld  ResponseStr......   %@     ",error,(long)[res statusCode],responseStr);
            
            id result = [NSDictionary dictionaryWithContentsOfJSONURLData:data];
            NSLog(@"response - %@",result);
            
            completionBlock(result, error);
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [OPRequestTimeOutView showWithMessage:kNetworkErrorMessageOnline forTime:3.0f];
                
            });
            completionBlock(data, error);
        }
    }] resume];
    
}






#pragma mark NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error
{
    
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler
{
    
    completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    
}


#pragma mark NSURLSessionTaskDelegate


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * __nullable))completionHandler
{
    
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler
{
    completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
    
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
 needNewBodyStream:(void (^)(NSInputStream * __nullable bodyStream))completionHandler
{
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    NSLog(@"");
    
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
    NSLog(@"");
    
}



//
//#pragma mark NSURLSessionDownloadDelegate
//
//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
//didFinishDownloadingToURL:(NSURL *)location
//{
//    downloadCompletionBlock(0, 0,0,YES , nil);
//
//#warning Needed to implement block
//    NSLogInfo(@"");
//
//}
//
//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
//      didWriteData:(int64_t)bytesWritten
// totalBytesWritten:(int64_t)totalBytesWritten
//totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
//{
//#warning Needed to implement block
//
//    downloadCompletionBlock(bytesWritten, totalBytesWritten,totalBytesExpectedToWrite, NO , nil);
//    NSLogInfo(@"");
//
//}
//
//
//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
// didResumeAtOffset:(int64_t)fileOffset
//expectedTotalBytes:(int64_t)expectedTotalBytes
//{
//#warning Needed to implement block
//
//    NSLogInfo(@"");
//
//}







@end
