//
//  MPOSUtility.h
//  MPOSApp
//
//  Created by Sachin Siwal on 16/09/15.
//  Copyright (c) 2015 Sachin Siwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MPOSUtility : NSObject

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define IS_IPAD_PRO_1366 (IS_IPAD && MAX(SCREEN_WIDTH,SCREEN_HEIGHT) == 1366.0)
#define IS_IPAD_PRO_1024 (IS_IPAD && MAX(SCREEN_WIDTH,SCREEN_HEIGHT) == 1024.0)

// App enums
typedef NS_ENUM(NSUInteger, userType) {
    userType_merchant,
    userType_staff,
    userType_manager
};

typedef NS_ENUM(NSUInteger, passcodeType) {
    passcodeType_LoginStaff,
    passcodeType_Validate,
    passcodeType_Enter,
    passcodeType_EnterStaff,
    passcodeType_LogoutStaff,
    passcodeType_Refund,
    passcodeType_Settings,
    passcodeType_Email,
    passcodeType_Exchange,
    passcodeType_Edit,
    passcodeType_Verification,
    passcodeType_Discount,
    passcodeType_ValidateManager,
    passcodeType_NoSale,
    passcodeType_DiscountToAll,
    passcodeType_ClockIn,
    passcodeType_ClockOut
};

typedef NS_ENUM(NSUInteger, syncStatus) {
    syncStatus_New,
    syncStatus_Synced,
    syncStatus_NotSynced
};

typedef NS_ENUM(NSUInteger, messageType) {
    messageType_Booking,
    messageType_Transfer,
    messageType_AdvancedBooking
};

UIImage *imageFromColor(UIColor* color);

void navigateToNewContoller(id controller);

void setHintFor(id elemnt, NSIndexPath *index);

NSIndexPath *getIndexPathFor (id elemnt);


NSString * imageToNSString (UIImage *image );

double roundValue(double value, int places);

UIBarButtonItem* backButtonForController (id controller, NSString *imgStr);

UIBarButtonItem* revealButtonForController (id controller, NSString *imgStr);

UIBarButtonItem* rightBarButtonForController(id controller, NSString *imgStr);

UIButton *setCornerForButton (UIButton *btn);

UITextField *setCornerForTextField (UITextField *btn);

UITextView *setCornerForTextView (UITextView *btn);

UIView *setCornerForView (UIView *view);

UIButton *getRoundedButton (UIButton *btn);

UILabel *getRoundedLabel (UILabel *btn);

UIImageView *getRoundedImage (UIImageView *imgView);

UIImage *takeSnapshot(UIView *snapView );

UIColor *getColor (float r,float g,float b,float a);
BOOL isValidated(NSString*string);
BOOL isValidatedWages(NSString*string);
NSString *getUniqueTabNumber();
    
void showAlert (NSString *errorTitle, NSString *message);

void showAlertWithDelegate(NSString *message, NSString *title ,NSString *cancelTitle, id delegate, NSString * buttonTitle);
void showAlertWithDelegateAndTag(NSString *message, NSString *title ,NSString *cancelTitle, id delegate, NSString * buttonTitle, NSInteger tag);
void showAlerts(NSString *message, NSString *title ,NSString *cancelTitle, id delegate, NSString * buttonTitle);
UIView *settingCornerForView (UIView *view, UIColor *borderColor, CGFloat borderWidth, CGFloat cornerRadius);
UIToolbar* toolBarForNumberPad(id controller, NSString *titleDoneOrNext);
+(void)manageToastHudWith:(NSString *)message andYoffset:(CGFloat)yOffset atView:(id)view;



NSDate* convertToDate(NSString* dateString, NSString* format, BOOL isGMT);
NSString* convertToString(NSDate* date, NSString* format, BOOL isGMT);

BOOL checkIfDateExistBetweenTwoDate(NSDate *startDate,NSDate *dateTobeChecked,NSDate *endDate);
UIView *setCornerForTransparentView (UIView *view) ;

@end
