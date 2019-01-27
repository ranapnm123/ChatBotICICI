//
//  Utility.m
//  ChatBot
//
//  Created by PULP on 24/07/18.
//  Copyright © 2018 Ashish Kr Singh. All rights reserved.
//

#import "Utility.h"
#import "AppManager.h"

@implementation Utility

+(NSData *)getFileInDocDir:(NSString *)strUrl{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    documentsPath = [documentsPath stringByAppendingString:@"/Images"];
    
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    
    
    NSString *fileName = [Utility getFileNameFromURL:strUrl];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName]; //Add the file name
    
    NSData *dataImage = [NSData dataWithContentsOfFile:filePath];
    
    return dataImage;
}

+(NSData *)getreceivedFileInDocDir:(NSString *)strUrl{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    documentsPath = [documentsPath stringByAppendingString:@"/Images"];
    
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    
    
    NSString *fileName = strUrl;
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName]; //Add the file name
    
    NSData *dataImage = [NSData dataWithContentsOfFile:filePath];
    
    return dataImage;
}

+(NSData *)getFileFromTempDir:(NSString *)strUrl{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    documentsPath = NSTemporaryDirectory() ;
    
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    
    
    NSString *fileName = [Utility getFileNameFromURL:strUrl];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName]; //Add the file name
    
    NSData *dataImage = [NSData dataWithContentsOfFile:filePath];
    
    return dataImage;
}

+(NSString *)getFileUrlInDocDir:(NSString *)strUrl{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    documentsPath = [documentsPath stringByAppendingString:@"/Images"];
    
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    
    
    NSString *fileName = [Utility getFileNameFromURL:strUrl];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName]; //Add the file name
    
    
    return filePath;
}

+(void)saveFile:(NSString *)strUrl{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    documentsPath = [documentsPath stringByAppendingString:@"/Images"];
    
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    
    
    NSString *fileName = [Utility getFileNameFromURL:strUrl];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName]; //Add the file name
    
        NSData *dataImage = [NSData dataWithContentsOfFile:filePath];
    
    // Image not saved in file system. Download and save image in file system
    if (dataImage == nil)
    {
        
        
        NSURL *urlImage = [NSURL URLWithString:strUrl];
        NSOperationQueue *myQueue = [[NSOperationQueue alloc] init];
        myQueue.name = @"DownloadQueue";
        myQueue.maxConcurrentOperationCount = 1;
        
        
        
        BOOL imageInQueue = [Utility urlImageInQueueForURLString:strUrl];
        
        if (!imageInQueue)
        {
            
            //Image in download queue
            [[[AppManager sharedManager] mDictImageForURL] setObject:[NSNumber numberWithBool:YES] forKey:strUrl];
            
            
            [myQueue addOperationWithBlock:^{
                
                NSError *error = nil;
                NSData *dataImageDownloaded = [NSData dataWithContentsOfURL:urlImage options:NSDataReadingMappedAlways error:&error];
                
                if (dataImageDownloaded) {
                    
                    
                    
                    @try
                    {
                        //Save Image in file system
                        [dataImageDownloaded writeToFile:filePath atomically:YES];
                        
                        //Set the image
//                        UIImage *image = [UIImage imageWithData:dataImageDownloaded];
//                        [self setImageWithEffect:image];
                        
                        
                        //Image no longer in download queue
                        [[[AppManager sharedManager] mDictImageForURL] setObject:[NSNumber numberWithBool:NO] forKey:strUrl];
//                        [_wcActivityIndicator stopAnimating];
//                        _completed = YES;
                        
                        
                        //Image Downloaded Successfully
//                        [self postNotificationWithString:strUrl];
                        
                    }
                    
                    @catch(NSException *e)
                    {
                        NSLog(@"Exception in saving image to filesystem");
                        //Image no longer in download queue
                        [[[AppManager sharedManager] mDictImageForURL] setObject:[NSNumber numberWithBool:NO] forKey:strUrl];
//                        [_wcActivityIndicator stopAnimating];
//                        _completed = YES;
                        
                    }
                    //                        });
                    //                    }
                }
                
                
                //Handle failure
                else
                {
                    //Image no longer in download queue
                    [[[AppManager sharedManager] mDictImageForURL] setObject:[NSNumber numberWithBool:NO] forKey:strUrl];
//                    [_wcActivityIndicator stopAnimating];
//                    _completed = YES;
                    
                }
            }];
        }
        
        else
        {
            
            NSLog(@"In Queue");
            
            @try
            {
                //Add Observer to listen for notification when the image has downloaded successfully
                
            }
            @catch(NSException *e)
            {
                NSLog(@"Exception while adding observer");
            }
            
            
        }
        
    }
    else
    {
        //Set the image
//        UIImage *image = [UIImage imageWithData:dataImage];
//        [self setImageWithEffect:image];
        //Image no longer in download queue
        [[[AppManager sharedManager] mDictImageForURL] setObject:[NSNumber numberWithBool:NO] forKey:strUrl];
//        [_wcActivityIndicator stopAnimating];
//        _completed = YES;
        
    }
}

+(BOOL)urlImageInQueueForURLString:(NSString*)strURL{
    BOOL bVal = [[[AppManager sharedManager] mDictImageForURL] valueForKey:strURL];
    return bVal;
}

+(NSString*)getFileNameFromURL :(NSString*) URL
{
    NSString* fileName=nil;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^a-zA-Z0-9_]+" options:0 error:nil];
    //Check if URL is empty string
    if(!URL.length){
        return @"";
    }
    else
    {
        NSString *extension = [self getExtensionOfFileInUrl:URL];
        fileName = [regex stringByReplacingMatchesInString:URL options:0 range:NSMakeRange(0, URL.length) withTemplate:@"_"];
        fileName = [fileName stringByAppendingString:@"."];
        fileName = [fileName stringByAppendingString:extension];
        
    }
    
    return fileName;
}

+ (NSString *)getExtensionOfFileInUrl:(NSString *)urlString
{
    NSString *fileExtension;
    
    if(urlString!=nil&&![urlString isEqualToString:@""])
    {
        NSArray *componentsArray = [urlString componentsSeparatedByString:@"."];
        fileExtension = [componentsArray lastObject];
    }
    
    return  fileExtension;
}

+(UIWindow *)getWindow{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    return window;
}

+(NSBundle *)getBundleForChatBotPro{
    NSBundle *bundle = [NSBundle bundleForClass:ViewController.classForCoder];
    NSURL *bundleURL = [[bundle resourceURL] URLByAppendingPathComponent:@"ChatBotPro.bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithURL:bundleURL];
    return resourceBundle;
}

+(NSString *)saveImage:(NSData*)imageData withName:(NSString*)imageName

{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //Get the docs directory
    
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    
    NSString *folderPath = [documentsDirectoryPath  stringByAppendingPathComponent:@"Images"];  // subDirectory
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
        
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath  withIntermediateDirectories:NO attributes:nil error:nil];
    
    
    
    //Add the FileName to FilePath
    
    NSString *filePath = [folderPath stringByAppendingPathComponent:imageName];
    
    //Write the file to documents directory
    
    [imageData writeToFile:filePath atomically:YES];

    return filePath;
    
}

+(UIImage*)retrieveImage:(NSString*)fileNamewhichtoretrieve

{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //Get the docs directory
    
    NSString *documentsPath = [paths objectAtIndex:0];
    
    
    
    NSString *folderPath = [documentsPath   stringByAppendingPathComponent:@"Images"];  // subDirectory
    
    
    
    NSString *filePath = [folderPath stringByAppendingPathComponent:fileNamewhichtoretrieve];
    
    
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        
        return [[UIImage alloc] initWithContentsOfFile:filePath];
    
    else
        
        return nil;
    
}

+ (void)removeImage:(NSString *)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //Get the docs directory
    
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    
    NSString *folderPath = [documentsDirectoryPath  stringByAppendingPathComponent:@"Images"];  // subDirectory
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
        
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath  withIntermediateDirectories:NO attributes:nil error:nil];
    
    
    
    //Add the FileName to FilePath
    
    NSString *filePath = [folderPath stringByAppendingPathComponent:filename];
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    if (success) {
         NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}

+ (BOOL)renameFileFrom:(NSString*)oldName to:(NSString *)newName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    //Get the docs directory
    
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    
    NSString *folderPath = [documentsDirectoryPath  stringByAppendingPathComponent:@"Images"];  // subDirectory
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
        
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath  withIntermediateDirectories:NO attributes:nil error:nil];
    
    NSString *oldPath = [folderPath stringByAppendingPathComponent:oldName];
    NSString *newPath = [folderPath stringByAppendingPathComponent:newName];
    
    NSError *error = nil;
    if (![[NSFileManager defaultManager] moveItemAtPath:oldPath toPath:newPath error:&error])
    {
        NSLog(@"Failed to move '%@' to '%@': %@", oldPath, newPath, [error localizedDescription]);
        return NO;
    }
    return YES;
}

+(NSString *)getSelectedTextFromTitle:(NSDictionary *)dict {
    NSString *text = dict[@"text"];
    NSString *dataText = dict[@"data"];
    if ([dataText containsString:@"[similar]"]) {
    text = dataText;
    text = [text stringByReplacingOccurrencesOfString:@"[similar]" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"[/similar]" withString:@""];
        NSArray *textArray = [text componentsSeparatedByString:@"|"];
        return textArray.firstObject;
}
else if ([dataText containsString:@"[nomatch]"]) {
    return @"I am looking for something else";
}
    return text;
}

@end
