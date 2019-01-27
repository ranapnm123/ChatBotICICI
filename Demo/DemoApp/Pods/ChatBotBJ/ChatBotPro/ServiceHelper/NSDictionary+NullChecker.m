#import "NSDictionary+NullChecker.h"

@implementation NSDictionary (NullChecker)

-(id)objectForKeyNotNull:(id)key expectedClass:(Class)className {
    
    id object = [self objectForKey:key];
    
    // added helper to check if in case we are getting number from server but we want a string from it
    if ([object isKindOfClass:[NSNumber class]] && (className == [NSString class])) {
        return [object stringValue];
    }
    
    // checking if object is of desired class
    if (![object isKindOfClass:className])
        return [className new];
    
    // checking if in case object is nil
    if (object == nil || object == [NSNull null])
        return [className new];
    
    // checking if in case object if of string type and we are getting nil inside quotes
   	if ([object isKindOfClass:[NSString class]]){
        if ([object isEqualToString:@"<null>"]||[object isEqualToString:@"(null)"]) {
            return [className new];
        }
    }
   
    
    return object;
}

-(id)objectForKeyNotNull:(id)key expectedObj:(id)obj {
    
    id object = [self objectForKey:key];
    
    if ((object == nil) || (object == [NSNull null])) return obj;
    
    if ([object isKindOfClass:[NSNumber class]]) {
        
        CFNumberType numberType = CFNumberGetType((CFNumberRef)object);
        if (numberType == kCFNumberFloatType || numberType == kCFNumberDoubleType || numberType == kCFNumberFloat32Type || numberType == kCFNumberFloat64Type)
            return [NSString stringWithFormat:@"%f",[object floatValue]];
        else
            return [NSString stringWithFormat:@"%ld",(long)[object integerValue]];
    }
    
    return object;
}


+(id)dictionaryWithContentsOfJSONURLData:(NSData *)JSONData
{
    __autoreleasing NSError* error = nil;
    if(JSONData == nil) {
        return [NSDictionary dictionary];
        
    }
    id result = [NSJSONSerialization JSONObjectWithData:JSONData options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result ;
}

-(NSData*)toJSON
{
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    
    
    if (error != nil) return nil;
    return result;
}


-(id)objectForKeyNotNull:(id)key {
    id object = [self objectForKey:key];
    if([object isKindOfClass:[NSString class]]){
        if ([object isEqualToString:@"<null>"]||[object isEqualToString:@"(null)"]) {
            return @"";
        }
    }
    
    if (object == nil){
        return @"";
    }
   	if (object == [NSNull null])
        return @"";
    return object;
}
@end
