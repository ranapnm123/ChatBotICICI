//
//  MPOSUtility.m
//  MPOSApp
//
//  Created by Sachin Siwal on 16/09/15.
//  Copyright (c) 2015 Sachin Siwal. All rights reserved.
//

#import "MPOSUtility.h"
#import <UIKit/UIKit.h>
#import "Header.h"


@implementation MPOSUtility

UIImage* imageFromColor(UIColor* color) {
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[color CGColor]);
    
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

void setHintFor (id elemnt, NSIndexPath *index) {
    [elemnt setAccessibilityLabel:[NSString stringWithFormat:@"%ld,%ld",(long)index.row,(long)index.section]];
}

NSIndexPath * getIndexPathFor (id elemnt) {
    
    NSArray *accessibilityArray = [[elemnt accessibilityLabel] componentsSeparatedByString:@","];
    return (([accessibilityArray count] == 2 ) ? [NSIndexPath indexPathForRow:[[accessibilityArray firstObject] integerValue] inSection:[[accessibilityArray lastObject] integerValue]] : [NSIndexPath indexPathForRow:-1 inSection:-1]);
}

NSString * imageToNSString (UIImage *image ){
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
    NSString *imageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return (imageStr.length) ? imageStr: @"";
}



double roundValue(double value, int places) {
    
    //default value is 2
    places = (places ? places : 2);
    
    long factor = (long) pow(10, places);
    value = value * factor;
    long tmp = round(value);
    return (double) tmp / factor;
}


// Left bar Back button on navigation bar
UIBarButtonItem* backButtonForController(id controller, NSString *imgStr) {
    
    UIImage *buttonImage = [UIImage imageNamed:imgStr];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width,buttonImage.size.height);
    [backButton setImage:buttonImage forState:UIControlStateNormal];
    [backButton setImage:buttonImage forState:UIControlStateSelected];
    [backButton setImage:buttonImage forState:UIControlStateHighlighted];
    
    [backButton addTarget:controller action: @selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    return backBarButtonItem;
}

//Left bar Menu button on navigation bar
UIBarButtonItem* revealButtonForController(id controller, NSString *imgStr) {
    
    UIImage *buttonImage = [UIImage imageNamed:imgStr];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width,buttonImage.size.height);
    [backButton setImage:buttonImage forState:UIControlStateNormal];
    [backButton setImage:buttonImage forState:UIControlStateSelected];
    [backButton setImage:buttonImage forState:UIControlStateHighlighted];
    
    [backButton addTarget:controller action: @selector(revealButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    return backBarButtonItem;
}

//Right bar button on navigation bar
UIBarButtonItem* rightBarButtonForController(id controller, NSString *imgStr ) {
    
    UIImage *buttonImage = [UIImage imageNamed:imgStr];
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    barButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width,buttonImage.size.height);
    [barButton setImage:buttonImage forState:UIControlStateNormal];
    [barButton setImage:buttonImage forState:UIControlStateSelected];
    [barButton setImage:buttonImage forState:UIControlStateHighlighted];
    
    
    [barButton addTarget:controller action: @selector(rightBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    return barButtonItem;
}
/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Setting corner of button <<<<<<<<<<<<<<<<<<<<<<<<*/

UIButton *setCornerForButton (UIButton *btn) {
    
    btn.layer.cornerRadius = 3.0f;
    //btn.layer.borderWidth = 1.0f;
    // btn.layer.borderColor =  getColor(3, 175, 108, 1).CGColor;
    return btn;
}

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Setting corner of Text Field <<<<<<<<<<<<<<<<<<<<<<<<*/

UITextField *setCornerForTextField (UITextField *textField) {
    
    textField.layer.cornerRadius = 3.0f;
    //btn.layer.borderWidth = 1.0f;
    // btn.layer.borderColor =  getColor(3, 175, 108, 1).CGColor;
    return textField;
}

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Setting corner of Text View <<<<<<<<<<<<<<<<<<<<<<<<*/

UITextView *setCornerForTextView (UITextView *textView) {
    
    textView.layer.cornerRadius = 3.0f;
    //btn.layer.borderWidth = 1.0f;
    // btn.layer.borderColor =  getColor(3, 175, 108, 1).CGColor;
    return textView;
}

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Setting corner of view <<<<<<<<<<<<<<<<<<<<<<<<*/

UIView *setCornerForView (UIView *view) {
    
    [view.layer setBorderColor:[[[UIColor colorWithRed:209.0/255.0 green:209.0/255.0 blue:209.0/255.0 alpha:1.0]colorWithAlphaComponent:0.5]CGColor]];
    [view.layer setBorderWidth:2.0];
    view.layer.cornerRadius=5.0;
    view.clipsToBounds=YES;
    
    return view;
}

UIView *setCornerForTransparentView (UIView *view) {
    
    [view.layer setBorderColor:[[UIColor clearColor]CGColor]];
    [view.layer setBorderWidth:2.0];
    view.layer.cornerRadius=5.0;
    view.clipsToBounds=YES;
    
    return view;
}

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Setting rounded image <<<<<<<<<<<<<<<<<<<<<<<<*/

UIImageView *getRoundedImage (UIImageView *imgView) {
    
    imgView.layer.cornerRadius =  imgView.frame.size.height /2;
    imgView.layer.masksToBounds = YES;
    imgView.clipsToBounds = YES;
    
    return imgView;
}


/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Setting rounded button <<<<<<<<<<<<<<<<<<<<<<<<*/

UIButton *getRoundedButton (UIButton *btn) {
    
    btn.layer.cornerRadius =  btn.frame.size.height /2;
    btn.layer.masksToBounds = YES;
    btn.clipsToBounds = YES;
    
    return btn;
    
}

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Setting rounded button <<<<<<<<<<<<<<<<<<<<<<<<*/

UILabel *getRoundedLabel (UILabel *lbl) {
    
    lbl.layer.cornerRadius =  lbl.frame.size.height /2;
    lbl.layer.masksToBounds = YES;
    lbl.clipsToBounds = YES;
    
    return lbl;
    
}

/*
 * Showing Alert
 */
void showAlert (NSString *errorTitle, NSString *message){
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errorTitle message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
    
}

/*
 * Showing Alert with delegate
 */

void showAlertWithDelegate(NSString *message, NSString *title ,NSString *cancelTitle, id delegate, NSString * buttonTitle){
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:buttonTitle, nil];
    [alertView show];
    alertView = nil;
}

void showAlertWithDelegateAndTag(NSString *message, NSString *title ,NSString *cancelTitle, id delegate, NSString * buttonTitle, NSInteger tag){
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:buttonTitle, nil];
    alertView.tag = tag;
    [alertView show];
    alertView = nil;
}

void showAlerts(NSString *message, NSString *title ,NSString *cancelTitle, id delegate, NSString * buttonTitle){
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:buttonTitle, nil];
    
    [alertView show];
}

///  takin
UIImage *takeSnapshot(UIView *snapView ){
    
    UIGraphicsBeginImageContextWithOptions(snapView.frame.size, NO, [UIScreen mainScreen].scale);
    
    [snapView drawViewHierarchyInRect:snapView.bounds afterScreenUpdates:YES];
    
    // old style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Setting corner for UIView <<<<<<<<<<<<<<<<<<<<<<<<*/

UIView *settingCornerForView (UIView *view, UIColor *borderColor, CGFloat borderWidth, CGFloat cornerRadius) {
    
    view.layer.cornerRadius =  cornerRadius;
    view.layer.borderColor = [borderColor CGColor];
    view.layer.borderWidth = borderWidth;
    view.clipsToBounds = YES;
    
    return view;
}
/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Adding tool bar on text field fornext/done button <<<<<<<<<<<<<<<<<<<<<<<<*/

UIToolbar* toolBarForNumberPad(id controller, NSString *titleDoneOrNext){
    //NSString *doneOrNext;
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 50)];
    
    numberToolbar.barStyle = UIBarStyleBlackOpaque;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:titleDoneOrNext style:UIBarButtonItemStyleDone target:controller action:@selector(doneWithNumberPad)],
                           
                           nil];
    [numberToolbar sizeToFit];
    return numberToolbar;
}

UIColor *getColor (float r,float g,float b,float a) {
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a];
}

- (void)doneWithNumberPad {
    
}

-(void) backButtonAction:(id)sender {
    
    
    
}

- (void) rightBarButtonAction:(id)sender {
    
}
- (void)revealButtonAction:(id)sender {
    
}

+(void)manageToastHudWith:(NSString *)message andYoffset:(CGFloat)yOffset atView:(id)view{
    MBProgressHUD *hud = [MBProgressHUD showToastHUDAddedTo:view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = message;
    hud.margin = 15.f;
    hud.yOffset = yOffset;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:4];
}

BOOL isValidated(NSString*string){
    NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
}

BOOL isValidatedWages(NSString*string){
    NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
}



@end
