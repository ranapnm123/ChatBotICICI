//
//  NSString+Validator.h
//  Apple-O-Pol
//
//  Created by KrishnaKant kaira on 04/06/14.
//  Copyright (c) 2014 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Validator)

- (CGFloat)getEstimatedHeightWithFont:(UIFont*)font withWidth:(CGFloat)width;
- (CGRect)getEstimatedRectWithFont:(UIFont*)font withWidth:(CGFloat)width ;

- (BOOL)isBlank;
- (BOOL)isValid;
- (NSString *)removeWhiteSpacesFromString;


- (NSUInteger)countNumberOfWords;
- (BOOL)containsString:(NSString *)subString;
- (BOOL)isBeginsWith:(NSString *)string;
- (BOOL)isEndssWith:(NSString *)string;

- (NSString *)replaceCharcter:(NSString *)olderChar withCharcter:(NSString *)newerChar;
- (NSString*)getSubstringFrom:(NSInteger)begin to:(NSInteger)end;
- (NSString *)addString:(NSString *)string;
- (NSString *)removeSubString:(NSString *)subString;

- (BOOL)containsOnlyLetters;
- (BOOL)containsOnlyNumbers;
- (BOOL)containsOnlyNumbersWithSign;
- (BOOL)containsOnlyNumbersAndLetters;
- (BOOL)isInThisarray:(NSArray*)array;

+ (NSString *)getStringFromArray:(NSArray *)array;
- (NSArray *)getArray;

+ (NSString *)getMyApplicationVersion;
+ (NSString *)getMyApplicationName;

- (NSData *)convertToData;
+ (NSString *)getStringFromData:(NSData *)data;

- (BOOL)isValidEmail;
- (BOOL)isVAlidPhoneNumber;
- (BOOL)isVAlidNumberFormat;
- (BOOL)isValidUrl;


//new methods added
-(NSString*)getFirstName;
-(NSString*)getLastName;

-(BOOL)isValidIPAddress;

-(BOOL)isIdenticaleTo:(NSString*)string;
@end
