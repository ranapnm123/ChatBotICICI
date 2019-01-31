//
//  MPOSValidationFields.m
//  MPOSApp
//
//  Created by Ankit Kumar Gupta on 16/09/15.
//  Copyright (c) 2015 Mobiloitte. All rights reserved.
//

#import "MPOSValidationFields.h"

@implementation MPOSValidationFields

+(BOOL)isStringVerified:(NSString*)string withPattern:(NSString*)pattern {
    
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [expr firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
    
    return (match ? FALSE : TRUE);
}

+(BOOL)validateUsername:(NSString *)userName {
    NSString *exprs = @"^[A-Z0-9a-z._]+$";
    return [MPOSValidationFields isStringVerified:userName withPattern:exprs];
}

+(BOOL)validateName:(NSString *)name {
    
    NSString *exprs =@"^[a-zA-Z\\s]+$";
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:exprs options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [expr firstMatchInString:name options:0 range:NSMakeRange(0, [name length])];
    
    return (match ? FALSE : TRUE);
}

+(BOOL)validateEmailAddress:(NSString *)emailAddress {
    
    NSString *exprs = @"[A-Z0-9a-z]+([._+-]{1}[A-Z0-9a-z]+)*@[A-Z0-9a-z]+([.-]{1}[A-Z0-9a-z]+)*(\\.[A-Za-z]{2,4}){0,1}";
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:exprs options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    
    NSTextCheckingResult *match = [expr firstMatchInString:emailAddress options:0 range:NSMakeRange(0, [emailAddress length])];
    
    return (match ? FALSE : TRUE);
}

+(BOOL)validateFirstName:(NSString *)firstName {
    
    NSString *exprs =@"^[a-zA-Z ]+$";
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:exprs options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [expr firstMatchInString:firstName options:0 range:NSMakeRange(0, [firstName length])];
    
    return (match ? FALSE : TRUE);
}

+(BOOL)validateLastName:(NSString *)lastName {
    
    NSString *exprs =@"^[a-zA-Z]+$";
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:exprs options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    
    NSTextCheckingResult *match = [expr firstMatchInString:lastName options:0 range:NSMakeRange(0, [lastName length])];
    return (match ? FALSE : TRUE);
}

+(BOOL)validateAddress:(NSString *)address {
    
    NSString *exprs =@"^[a-zA-Z]+$";
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:exprs options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [expr firstMatchInString:address options:0 range:NSMakeRange(0, [address length])];
    return (match ? FALSE : TRUE);
}

+(BOOL)validateMobileNumber:(NSString *)mobileNumber {
    
    NSString *exprs =@"^[0-9]+$";
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:exprs options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [expr firstMatchInString:mobileNumber options:0 range:NSMakeRange(0, [mobileNumber length])];
    
    return (match ? FALSE : TRUE);
}

+(BOOL)validatePhoneNumber:(NSString *)phoneNumber {
    
    NSString *exprs = @"^[0-9]+$";
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:exprs options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [expr firstMatchInString:phoneNumber options:0 range:NSMakeRange(0, [phoneNumber length])];
    return (match ? FALSE : TRUE);
}


+(BOOL)validateUrl: (NSString *) candidate {
    
    
    NSString *urlRegEx =  @"^([a-zA-Z0-9]([a-zA-Z0-9\\-]{0,61}[a-zA-Z0-9])?\\.)+[a-zA-Z]{2,6}$";
    
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [expr firstMatchInString:candidate options:0 range:NSMakeRange(0, [candidate length])];
    
    return (match ? FALSE : TRUE);
}
+(BOOL)validatePassword:(NSString *)password {
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789"] invertedSet];
    
    if ([password rangeOfCharacterFromSet:set].location != NSNotFound) {
        return FALSE;
    }else{
        return TRUE;
    }

}

@end
