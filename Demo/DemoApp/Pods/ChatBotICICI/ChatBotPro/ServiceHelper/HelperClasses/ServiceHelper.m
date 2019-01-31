//
//  ServiceHelper.m
//
//  Copyright (c) 2014 Mobiloitte. All rights reserved.
//

#import "ServiceHelper.h"
#import "Header.h"
#import "AppManager.h"
#import "Utility.h"

#pragma mark - HTTPClient class definition

static HTTPClient *_sharedClient;

@implementation HTTPClient

+ (HTTPClient *) sharedClient {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HTTPClient alloc] initWithBaseURL:[NSURL URLWithString:SERVICE_BASE_URL]];
    });
    
    return _sharedClient;
}

-(id) initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    self.parameterEncoding = AFJSONParameterEncoding;
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    //    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/plain"]];
    
    if (!self) {
        return nil;
    }
    return self;
}

@end

#pragma mark - JSONRequestOperationQueue class definition

@implementation JSONRequestOperationQueue

@end

@interface ServiceHelper () <MBProgressHUDDelegate>{
    
    MBProgressHUD *HUD;
}

@end


#pragma mark - ServiceHelper class definition

static ServiceHelper *_sharedHelper;

@implementation ServiceHelper

+ (ServiceHelper *)sharedEngine {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHelper = [[ServiceHelper alloc] init];
    });
    
    return _sharedHelper;
}

//
-(void)callWebServiceWithRequest:(NSURLRequest*)request andMethodName:(WebMethodType)methodName andControllerToShowHud:(BOOL)showHud{
    
    if (![[AppManager sharedManager] isReachable]) {
        if (methodName == WebMethodLogin || methodName == WebMethodForgotPassword) {
            showAlert(@"Sorry", @"Your internet connection appears to be offline.Please check and try again.");
        }
        return;
    }
    
    if (showHud) {
        
        [MBProgressHUD hideHUDForView:[Utility getWindow] animated:YES];
        [MBProgressHUD showHUDAddedTo:[Utility getWindow] animated:YES];
    }
    
    NSLog(@"request URL : %@", [request URL]);
    NSLog(@"Request body %@", [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding]);
    
    JSONRequestOperationQueue* operation =[JSONRequestOperationQueue JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [HUD hide:YES afterDelay:kHudHideAnimationTime];
        if (showHud) {
            
            [MBProgressHUD hideHUDForView:[Utility getWindow] animated:YES];
        }
        
        if (!self || !self.serviceHelperDelegate)
            return;
        
        if ([[JSON objectForKey:pRESPONSE_CODE] integerValue] == 200) {
            NSDictionary *dictionary = [response allHeaderFields];
            
            if ([self.serviceHelperDelegate respondsToSelector:@selector(serviceResponse:andMethodName:)])
                [self.serviceHelperDelegate serviceResponse:JSON andMethodName:methodName];
        }
        else {
            
            if ([self.serviceHelperDelegate respondsToSelector:@selector(serviceError:andMethodName:)])
                [self.serviceHelperDelegate serviceError:JSON andMethodName:methodName];
        }
        //        if ([self.serviceHelperDelegate respondsToSelector:@selector(serviceResponse:andMethodName:)])
        //            [self.serviceHelperDelegate serviceResponse:[self validatedDataForResponseMessage:JSON forMethod:methodName] andMethodName:methodName];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [HUD hide:YES afterDelay:kHudHideAnimationTime];
        [MBProgressHUD hideHUDForView:[Utility getWindow] animated:YES];
        if ([error code] == NSURLErrorCancelled)
            return ;
        if (!self || !self.serviceHelperDelegate)
            return ;
        if ([self.serviceHelperDelegate respondsToSelector:@selector(connectionFailWithErrorMessage:andMethodName:)]) {
            [self.serviceHelperDelegate connectionFailWithErrorMessage:@"Sorry, something went wrong! Please try again in a few seconds" andMethodName:methodName];
        }
    }];
    
    [operation setRequestTag:methodName];
    [[[HTTPClient sharedClient] operationQueue] addOperation:operation];
}


#pragma mark - Request formation
/**
 ** Returns a POST multipart request from the passed parameter dictionary and file data
 **/
-(NSURLRequest*)getMultipartRequest:(NSDictionary*)dict withFileKey:(NSString *)fileKey path:(NSString*)path fileName:(NSString *)file andMIMEType:(NSString *)mime {
    
    NSURLRequest *request = nil;
    
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [requestDict removeObjectForKey:fileKey];
    
    NSData *data = [dict objectForKey:fileKey];
    
    request = [[HTTPClient sharedClient] multipartFormRequestWithMethod:@"POST" path:path parameters:requestDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:fileKey fileName:file mimeType:mime];
    }];
    
    return request;
}


#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    HUD = nil;
}

#pragma mark - Webservice Call Helper Methods

-(void)callGetMethodWithData:(NSMutableDictionary*)dict andMethodName:(WebMethodType)methodName forPath:(NSString*)path andControllerToShowHud:(BOOL)showHud{
    HTTPClient *client = [HTTPClient sharedClient];
    //    [client setAuthorizationHeaderWithToken:@"b6be92cb33ffa6160f39c9ac3c460cdd"];
   
    NSURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:dict];
    [self callWebServiceWithRequest:request andMethodName:methodName andControllerToShowHud:showHud];
}

-(void)callPOSTMethodWithData:(NSMutableDictionary*)dict andMethodName:(WebMethodType)methodName forPath:(NSString*)path  andControllerToShowHud:(BOOL)showHud {
    
    HTTPClient *client = [HTTPClient sharedClient];
    
    NSURLRequest *request;
    if ((methodName == WebMethodUpdateStaff) || (methodName == WebMethodUpdateVoucher) || (methodName == WebMethodUpdateFloorPlan) || methodName == WebMethodUpdateBooking) {
        request = [client requestWithMethod:@"PUT" path:path parameters:dict];
    }else if (methodName == WebMethodDeleteBooking){
        request = [client requestWithMethod:@"DELETE" path:path parameters:dict];
    }else{
        request = [client requestWithMethod:@"POST" path:path parameters:dict];
    }
    [self callWebServiceWithRequest:request andMethodName:methodName andControllerToShowHud:showHud];
}

//-(void)callPOSTMethodForMultipartRequestWithData:(NSMutableDictionary*)dict fileDataKey:(NSString*)fileKey fileName:(NSString *)file mimeType:(NSString *)mime methodName:(WebMethodType)methodName andControllerToShowHud:(BOOL)showHud; {
//
//    NSURLRequest *request = [self getMultipartRequest:dict withFileKey:fileKey path:[self getMethodName:methodName] fileName:file andMIMEType:mime];
//    [self callWebServiceWithRequest:request andMethodName:methodName andControllerToShowHud:showHud];
//}

- (void)cancelRequestwithName:(WebMethodType)methodName {
    NSArray *operationArray = [[[HTTPClient sharedClient] operationQueue] operations];
    
    for (JSONRequestOperationQueue *queueOperation in operationArray) {
        if (queueOperation.requestTag == methodName) {
            [queueOperation cancel];
        }
    }
}

@end
