//
//  Header.h
//  MPOSApp
//
//  Created by Sachin Siwal on 16/09/15.
//  Copyright (c) 2015 Sachin Siwal. All rights reserved.
//

#ifndef MPOSApp_Header_h
#define MPOSApp_Header_h



#define APP_COLOR [UIColor colorWithRed:50.0 green:163.0 blue:213.0 alpha:1.0]
#define APP_BLUE_COLOR [UIColor colorWithRed:0.0 green:201.0/255.0 blue:217.0/255.0 alpha:1.0]
#define APP_GREEN_COLOR [UIColor colorWithRed:78.0/255.0 green:204.0/255.0 blue:28.0/255.0 alpha:1.0]

#define APP_LANGUAGE_COLOR [UIColor colorWithRed:160.0 green:120.0 blue:189.0 alpha:1.0];
#define WIN_WIDTH [[UIScreen mainScreen]bounds].size.width
#define WIN_HEIGHT [[UIScreen mainScreen]bounds].size.height
#define App_NavBar_Font_family @"HelveticaNeue-Thin"
#define App_TextField_Font_family @"HelveticaNeue-Lightitalic"
#define NSUSERDEFAULTS          [NSUserDefaults standardUserDefaults]
#define kCellMargin 30.0
#define kSellOrderStatus                                @"saleOrderStatus"


#define kCondensedBoldFont(X) [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:X]
#define kLightFont(X) [UIFont fontWithName:@"HelveticaNeue-Light" size:X]
#define kMediumFont(X) [UIFont fontWithName:@"HelveticaNeue-Medium" size:X]

#define kRegularFont(X) [UIFont fontWithName:@"HelveticaNeue" size:X]

#define kBoldFont(X) [UIFont fontWithName:@"HelveticaNeue-Bold" size:X]

#define App_Background @"bg"
#define TRIM_SPACE(str) [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
#define Color(R,G,B,a)    [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:a]
#define WIN_HEIGHT [[UIScreen mainScreen]bounds].size.height
#define WIN_WIDTH [[UIScreen mainScreen]bounds].size.width
#define colors(color1,color2,color3,alpha) [UIColor colorWithRed:color1 green:color2 blue:color3 alpha:alpha]];
#define KBoarderColor   [UIColor colorWithRed:217/255.0 green:219/255.0 blue:220/255.0 alpha:1.0]
#define kButtonTag(tag)         (UIButton *)[self.view viewWithTag:tag]
#define kLblTag(tag)         (UILabel *)[self.view viewWithTag:tag]
#define kImageViewTag(tag)         (UIImageView *)[self.view viewWithTag:tag]
#define ARTextField(tag)   (UITextField *)[self.view viewWithTag:tag]
#define MPOSTextField(tag)   (UITextField *)[self.view viewWithTag:tag]
#define ISIOS11orHIGHER  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)



#import "ServiceHelper.h"
#import "OPServiceHelper.h"
#import "OPRequestTimeOutView.h"
#import "NSDictionary+NullChecker.h"
#import "MBProgressHUD.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFImageRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFNetworking.h"
#import "AFPropertyListRequestOperation.h"
#import "AFURLConnectionOperation.h"
#import "AFXMLRequestOperation.h"
#import "Rechability.h"
#import "UIButton+AFNetworking.h"
#import "NSDictionary+NullChecker.h"
#import "MBProgressHUD.h"
#import "MPOSUtility.h"

static NSString *pDeviceToken                  =   @"deviceToken";
static NSString * pIsRemember                  =   @"isRemenber";

#define kUSERID                                         @"id"
#define kUserLocationID                                 @"UserLocationID"
#define kUserMerchantID                                 @"merchant_id"
#define kUserTillID                                     @"UserTillID"
#define kUserTillName                                   @"UserTillName"

#define kisLoggedIn                                     @"loggedIn"
#define kSelectedVenueID                                @"selectedVenueId"
#define kEmail                                          @"kEmail"
#define kPassword                                       @"kPassword"
#define kStaffID                                        @"staffID"
#define kDefaultFloorPlanId                             @"defaultFloorPlan"
#define kDefaultRoomFloorPlanId                         @"defaultRoomFloorPlan"
#define kPasscode                                       @"PasscodeUSER"
#define kisMasterTill                                   @"isMasterTill"
#define kNotifMessage                                   @"notificationMessage"
#define kNotifPreorder                                  @"notificationPreorder"
#define kNotifCancelOrder                               @"notificationCancelOrder"
#define kNotifStaffChanged                              @"notificationStaffChanged"
#define kNotifTabOrderCompleted                         @"notificationTabOrderCompleted"
#define kNotifTabMemberLeft                             @"notificationTabMemberLeft"
#define kNotifTabMemberPayIndividually                  @"notificationTabPayIndividually"
#define kNotifSplitTabs                                 @"notificationSplitTabs"
#define kNotifColorModeOnOff                            @"notificationColorModeOnOff"
#define kNotifSaveColor                                 @"notificationSaveColor"
#define KNotifyShowModifierPopUp                        @"notificationShowmodifierPopUp"
#define kNotifyPresentChangePopup                       @"notificationPresentChangePopup"
#define kIsSecurityAfterTransaction                     @"securityAfterTransaction"
#define kSecurityTime                                   @"securityTime"
#define kScreenLockOn                                   @"screenLock"
#define kFlashOn                                        @"flash"
#define kPrintOn                                        @"print"
#define kInstantPrintOn                                 @"instantPrint"
#define kVatOn                                          @"vat"
#define kExternalCashDrawer                             @"externalCashdrawer"
#define kStaffNetworking                                @"staffNetworking"
#define kNetworking                                     @"networking"
#define kNotifMobileOrderStatus                         @"notifMobileOrderStatus"
#define kVersionNumber                                  @"versionNumber"

#define keyCommType                                     @"commType"
#define keyTimeout                                      @"timeout"
#define keySerialPort                                   @"serialPort"
#define keyDestIP                                       @"destIP"
#define keyDestPort                                     @"destPort"
#define keyBluetoothAddr                                @"bluetoothAddr"

static NSString *  pAuth_Token                      =   @"Api_auth_token";


#define kMCPSaperator                                   @"-||-"

// notification constants
static NSString * kNotifCollectionOrderRecd         =      @"notificationReceivedCollectionOrder";
static NSString * kNotifTableOrderRecd              =      @"notificationTableOrderRecvd";
static NSString * kNotifCollectionOrderRemoved      =      @"notificationRemovedCollectionOrder";
static NSString * kNotifShowTablePopup              =      @"notificationShowTablePopup";
static NSString * kNotifEditItemsOfBooking          =      @"notificationEditBookingItems";
static NSString * kNotifLoginStaff                  =      @"notificationLoginSatffAutomatically";
static NSString * kNotifLogoutStaff                 =      @"notificationLogoutSatffAutomatically";
static NSString * kNotifLogoutAllStaff              =      @"notificationLogoutAllSatffAutomatically";
static NSString *kNotifSendLatestData               =      @"notificationSendLatestData";
static NSString *kNotifCreateBooking                =      @"notificationCreateBooking";
static NSString *kNotifRefershSetting               =      @"notificationRefershSetting";


//static NSString * kNotifPayNow                      =       @"notificationPayNow";
//static NSString * KNotifyOrderChangedOnTable        =       @"notifyTableOrderChanged";
//static NSString * KNotifyReloadOrderTableData       =       @"notifyRelaodOrderTable";
//static NSString * KNotifyReceivedTableEditedOrder   =       @"notifyUpdateTableOrder";
//static NSString * KNotifyClearTableOrder            =       @"notifyClearTableOrder";
//static NSString * kNotifTabOrderCreated             =       @"notificationTabOrderCreated";

static NSString * KNotifyEnterForeground            =     @"notifyEnterForeground";


// Entity name
static NSString *kEntityNameUser        	= @"MPOS_User";
static NSString *kEntityNameVenue           = @"MPOS_Venue";
static NSString *kEntityNameCategory        = @"MPOS_Category";
static NSString *kEntityNameInventory       = @"MPOS_Inventory";
static NSString *kEntityNameModifiersCategory = @"MPOS_ModifierCategory";
static NSString *kEntityNameModifiers       = @"MPOS_Modifiers";
static NSString *kEntityNameOrder           = @"MPOS_Order";
static NSString *kEntityNameMessage         = @"MPOS_Message";
static NSString *kEntityNameVoucher         = @"MPOS_Voucher";
static NSString *kEntityNameVenueMessage    = @"MPOS_VenueMessages";
static NSString *kEntityNameModifierGroup   = @"MPOS_ModifierGroup";
static NSString *kEntityNameOffer           = @"MPOS_Offer";
static NSString *kEntityNameFloorPlan       = @"MPOS_FloorPlan";
static NSString *kEntityNameFloorItem       = @"MPOS_FloorItem";
static NSString *kEntityNameLocalSyncing    = @"MPOS_Local_Syncing";
static NSString *kkEntityNamePaymentTab     = @"MPOS_PaymentTab";
static NSString *kEntityNameMPOSTab         = @"MPOS_Tab";
static NSString *kEntityNameTier        	= @"MPOS_Tier";
static NSString *kEntityNameTierPrices      = @"MPOS_Tier_Prices";
static NSString *kEntityNamePDQ         	= @"MPOS_PDQ";
static NSString *kEntityNameSMSMessage      = @"MPOS_SMS_Messages";
static NSString *kEntityNameUserTiming      = @"MPOS_UserTiming";
static NSString *kEntityNameCustomer        = @"MPOS_Customer";
static NSString *kEntityNameTax             = @"MPOS_Tax";
static NSString *kEntityNameTips             = @"MPOS_Tips";

// Added
static NSString *kEntityAddress           	= @"MPOS_Address";
static NSString *kEntityUserClockInTiming   = @"MPOS_UserClockInTiming";

static NSString *kEntityNamePax                 = @"MPOS_PAX";


// Key parameter

static NSString *pRESPONSE_CODE  = @"response_code";

static NSString *kEntityNameMeasures        = @"MPOS_Measure";

// Constants

static NSString *pInventryStatusNon         = @"none";
static NSString *pInventryStatusExchange    = @"exchanged";
static NSString *pInventryStatusRefunded    = @"refunded";

#endif
