//
//  NSString+Validator.m
//  Apple-O-Pol
//
//  Created by KrishnaKant kaira on 04/06/14.
//  Copyright (c) 2014 Mobiloitte. All rights reserved.
//

#import "NSString+Validator.h"

@implementation NSString (Validator)

- (CGFloat)getEstimatedHeightWithFont:(UIFont*)font withWidth:(CGFloat)width {
    
    if (!self || !self.length)
        return 0;
    
    CGFloat labelSize = 0.0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        
//        CGSize constraintSize = CGSizeMake(width, MAXFLOAT);
//        labelSize = [self sizeWithFont : font
//                     constrainedToSize : constraintSize
//                         lineBreakMode : NSLineBreakByWordWrapping].height;
    }
    else {
        CGRect rect = [self boundingRectWithSize : (CGSize){width, CGFLOAT_MAX}
                                         options : NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes : @{ NSFontAttributeName: font }
                                         context : nil];
        labelSize = rect.size.height;
    }
    
    return labelSize;
}



- (CGRect)getEstimatedRectWithFont:(UIFont*)font withWidth:(CGFloat)width {
    
//    if (!self || !self.length)
//        return 0.0;
    
    CGRect rect;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        
        //        CGSize constraintSize = CGSizeMake(width, MAXFLOAT);
        //        labelSize = [self sizeWithFont : font
        //                     constrainedToSize : constraintSize
        //                         lineBreakMode : NSLineBreakByWordWrapping].height;
    }
    else {
         rect = [self boundingRectWithSize : (CGSize){width, CGFLOAT_MAX}
                                         options : NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes : @{ NSFontAttributeName: font }
                                         context : nil];
        //labelSize = rect.size.height;
    }
    
    return rect;
}

// Checking if String is Empty
-(BOOL)isBlank {

//    return ((self == nil) || [self isEqualToString:@"(null)"] || ([[self removeWhiteSpacesFromString] length] == 0));
    return ([[self removeWhiteSpacesFromString] isEqualToString:@""]) ? YES : NO;
}

//Checking if String is empty or nil
-(BOOL)isValid {
    
    return ([[self removeWhiteSpacesFromString] isEqualToString:@""] || self == nil || [self isEqualToString:@"(null)"]) ? NO :YES;
}

// remove white spaces from String
- (NSString *)removeWhiteSpacesFromString {
    
	NSString *trimmedString = [self stringByTrimmingCharactersInSet:
							   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	return trimmedString;
}

// Counts number of Words in String
- (NSUInteger)countNumberOfWords {
    
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	
    NSUInteger count = 0;
    while ([scanner scanUpToCharactersFromSet: whiteSpace  intoString: nil])
        count++;
	
    return count;
}

// If string contains substring
- (BOOL)containsString:(NSString *)subString {
    return ([self rangeOfString:subString].location == NSNotFound) ? NO : YES;
}

// If my string starts with given string
- (BOOL)isBeginsWith:(NSString *)string {
    return ([self hasPrefix:string]) ? YES : NO;
}

// If my string ends with given string
- (BOOL)isEndssWith:(NSString *)string {
    return ([self hasSuffix:string]) ? YES : NO;
}


// Replace particular characters in my string with new character
- (NSString *)replaceCharcter:(NSString *)olderChar withCharcter:(NSString *)newerChar {
    return  [self stringByReplacingOccurrencesOfString:olderChar withString:newerChar];
}

// Get Substring from particular location to given lenght
- (NSString*)getSubstringFrom:(NSInteger)begin to:(NSInteger)end {
    
	NSRange r;
	r.location = begin;
	r.length = end - begin;
	return [self substringWithRange:r];
}

// Add substring to main String
- (NSString *)addString:(NSString *)string {
    
    if(!string || string.length == 0)
        return self;
    
    return [self stringByAppendingString:string];
}

// Remove particular sub string from main string
-(NSString *)removeSubString:(NSString *)subString {
    
    if ([self containsString:subString]) {
        NSRange range = [self rangeOfString:subString];
        return  [self stringByReplacingCharactersInRange:range withString:@""];
    }
    return self;
}

// If my string contains ony letters
- (BOOL)containsOnlyLetters {
    
    NSCharacterSet *letterCharacterset = [[NSCharacterSet letterCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:letterCharacterset].location == NSNotFound);
}

// If my string contains only numbers
- (BOOL)containsOnlyNumbers {
    
    NSCharacterSet *numbersCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@".0123456789"] invertedSet];
    return ([self rangeOfCharacterFromSet:numbersCharacterSet].location == NSNotFound);
}

// If my string contains only numbers with sign +/-
- (BOOL)containsOnlyNumbersWithSign {
    
    NSCharacterSet *numbersCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"+-.0123456789"] invertedSet];
    return ([self rangeOfCharacterFromSet:numbersCharacterSet].location == NSNotFound);
}

// If my string contains letters and numbers
- (BOOL)containsOnlyNumbersAndLetters {
    
    NSCharacterSet *numAndLetterCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:numAndLetterCharSet].location == NSNotFound);
}

// If my string is available in particular array
- (BOOL)isInThisarray:(NSArray*)array {
    
    for(NSString *string in array) {
        if([self isEqualToString:string])
            return YES;
    }
    return NO;
}

// Get String from array
+ (NSString *)getStringFromArray:(NSArray *)array {
    return [array componentsJoinedByString:@" "];
}

// Convert Array from my String
- (NSArray *)getArray {
    return [self componentsSeparatedByString:@" "];
}

// Get My Application Version number
+ (NSString *)getMyApplicationVersion {
    
	NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
	NSString *version = [info objectForKey:@"CFBundleVersion"];
	return version;
}

// Get My Application name
+ (NSString *)getMyApplicationName {
    
	NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
	NSString *name = [info objectForKey:@"CFBundleDisplayName"];
	return name;
}

// Convert string to NSData
- (NSData *)convertToData {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

// Get String from NSData
+ (NSString *)getStringFromData:(NSData *)data {
    return [[NSString alloc] initWithData:data
                                 encoding:NSUTF8StringEncoding];
}

// Is Valid Email
- (BOOL)isValidEmail {
    
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTestPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [emailTestPredicate evaluateWithObject:self];
}

// Is Valid Phone
- (BOOL)isVAlidPhoneNumber {
    
    NSString *regex = @"\\+?[0-9]{10,13}";
    
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [test evaluateWithObject:self];
}

// Is Valid Phone
- (BOOL)isVAlidNumberFormat {
    
    NSString *regex = @"^([0-9]+)?(([0-9]{1,2})?)?$";
    
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [test evaluateWithObject:self];
}

// Is Valid URL
- (BOOL)isValidUrl {
    
    NSString *regex =@"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:self];
}

//new methods added
-(NSString*)getFirstName {
    
    NSArray *nameComponents = [[self removeWhiteSpacesFromString] componentsSeparatedByString:@" "];
    NSString *firstName = @"";
    
    /*
    if ([nameComponents count] > 0)
        firstName = [nameComponents firstObject];
     */
    
    if ([nameComponents count] == 1)
        firstName = [nameComponents firstObject];
    else if ([nameComponents count] > 1)
        firstName = [[nameComponents subarrayWithRange:NSMakeRange(0, nameComponents.count-1)] componentsJoinedByString:@" "];
    
    return firstName;
}

-(NSString*)getLastName {
    
    NSArray *nameComponents = [[self removeWhiteSpacesFromString] componentsSeparatedByString:@" "];
    NSString *lastName = @"";
    
    /*
    if ([nameComponents count] > 1) {
        
        NSMutableString *lastNameComonents = [NSMutableString string];
        for (int index = 1; index < [nameComponents count]; index++)
            [lastNameComonents appendFormat:@" %@",[nameComponents objectAtIndex:index]];
        
        lastName = [lastNameComonents removeWhiteSpacesFromString];
    }
     */
    
    if ([nameComponents count] > 1)
        lastName = [nameComponents lastObject];
    
    
    return lastName;
}

-(BOOL)isValidIPAddress {
    
    NSString *ipRegEx =
    @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@",ipRegEx];
    BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:self];
    return myStringMatchesRegEx;
}

-(BOOL)isIdenticaleTo:(NSString*)string {
    return (self && (self.length>0) && ([self caseInsensitiveCompare:string] == NSOrderedSame));
}

@end
