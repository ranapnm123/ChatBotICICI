//
//  MPOSValidationFields.h
//  MPOSApp
//
//  Created by Ankit Kumar Gupta on 16/09/15.
//  Copyright (c) 2015 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPOSValidationFields : NSObject

+(BOOL)validateFirstName:(NSString *)firstName;
+(BOOL)validateLastName:(NSString *)lastName;
+(BOOL)validatePhoneNumber:(NSString *)phoneNumber;
+(BOOL)validateMobileNumber:(NSString *)mobileNumber;
+(BOOL)validateEmailAddress:(NSString *)emailAddress;
+(BOOL)validateAddress:(NSString *)address;
+(BOOL)validateUsername:(NSString *)userName;
+(BOOL)validateName:(NSString *)name;
+(BOOL) validateUrl: (NSString *) candidate ;
+(BOOL)validatePassword:(NSString *)password;
@end
