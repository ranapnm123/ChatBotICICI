//
//  ServiceHelper.h
//
//  Copyright (c) 2014 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Rechability.h"
#import "MBProgressHUD.h"

//Local Rahul Purohit
//static NSString *const SERVICE_BASE_URL   =     @"http://172.16.16.177:4000/api/ipad_app/";

// Local Rohan ip
//static NSString *const SERVICE_BASE_URL   =     @"http://172.16.1.71:3000/api/ipad_app/";

// Local Abhishek ip
//static NSString *const SERVICE_BASE_URL   =     @"http://172.16.16.132:5000/api/ipad_app/";

// Local Gagan ip
//static NSString *const SERVICE_BASE_URL   =  @"http://172.16.1.23:3000/api/ipad_app/";

// Local Varun ip1
//static NSString *const SERVICE_BASE_URL   =  @"http://172.16.1.32:3000/api/ipad_app/";

// Local Varun ip2
//static NSString *const SERVICE_BASE_URL   =  @"http://172.16.1.32:5000/api/ipad_app/";

// Local Chirag ip
//static NSString *const SERVICE_BASE_URL  =     @"http://172.16.1.38:3000/api/ipad_app/";

//Local URL second
///static NSString *const SERVICE_BASE_URL  =  @"http://172.16.1.95:3000/api/ipad_app/";

//Local URL third
//static NSString *const SERVICE_BASE_URL   =  @"http://172.16.5.33:3000/api/ipad_app/";

// staging URL
//static NSString *const SERVICE_BASE_URL   =  @"http://m-pos.herokuapp.com/api/ipad_app/";

//// Local Shashank ip
//static NSString *const SERVICE_BASE_URL   =  @"http://172.16.16.123:3000/api/ipad_app/";

// Local Vinod Sir
//static NSString *const SERVICE_BASE_URL   = @"http://172.16.16.238:3000/api/ipad_app/";

// staging URL (Sandbox)
static NSString *const SERVICE_BASE_URL     = @"https://www.growthsoftware.net/travego/JSON/";
//Swoopos URL (Production)
//static NSString *const SERVICE_BASE_URL    =    @"https://www.swoopos.com/api/ipad_app/";

static NSString *const kNetworkErrorMessage     =   @"Your device appears to be offline, please check your internet connection and try again.";

static NSString *const kNetworkErrorMessageOnline = @"Sorry, something went wrong! Please try again in a few seconds";

static NSString *const kTILL_PRINTER_NOT_CONFIGURE   =   @"Please ensure your device is connected with the Till Printer and you have selected this hardware from the settings menu.";

static NSString *const kKITCHEN_PRINTER_NOT_CONFIGURE   =   @"Please ensure your device is connected with the Kitchen Printer and you have selected this hardware from the settings.";

static NSString *const kCASH_DRAWER_NOT_CONNECTED   =   @"Please ensure your device is connected with the Cash Drawer and you have selected this hardware from the settings.";

static NSString *const kMOBILE_PRINTER_NOT_CONFIGURE   =   @"Please ensure your device is connected with the Mobile Printer and you have selected this hardware from the settings menu.";

#define kHudHideAnimationTime   0.0

typedef enum WebMethodCall{
    
    WebMethodLogin = 10,
    WebMethodForgotPassword,
    WebMethodGetVenueList,
    WebMethodGetTillList,
    WebMethodSetTill,
    WebMethodGetVenueDetail,
    WebMethodGetPreOrders,
    WebMethodCreateStaff,
    WebMethodUpdateStaff,
    WebMethodDeleteStaff,
    WebMethodUpdateOrderStatus,
    WebMethodUpdateTabOrderStatus,
    WebMethodCheckout,
    WebMethodStaffLogin,
    WebMethodStaffLogout,
    WebMethodpost_message,
    WebMethodCreateVoucher,
    WebMethodVoucherList,
    WebMethodGetMessageList,
    WebMethodGetMessageListForOrder,
    WebMethodGetUnreadMessageListForOrder,
    WebMethodUpdateVoucher,
    WebMethodCreateInventories,
    WebMethodGetInventories,
    WebMethodGetOffer,
    WebMethodCreateOffer,
    WebMethodGetPreviousOrderList,
    WebMethodGetBeaconList,
    WebMethodGetStats,
    WebMethodEmailReceipt,
    WebMethodManagerLogout,
    WebMethodGetFloorPlan,
    WebMethodSaveFloorPlan,
    WebMethodUpdateFloorPlan,
    WebMethodZRead,
    WebMethodDeleteBooking,
    WebMethodDeleteFloorPlan,
    WebMethodCreateBooking,
    WebMethodUpdateBooking,
    WebMethodGetBookingList,
    WebMethodGetUpcomingBookingList,
    WebMethodTypeSearchBooking,
    WebMethodRefundOrder,
    WebMethodExchangeOrder,
    WebMethodSendSMSOrder,
    WebMethodUpdateSMSOrder,
    WebMethodInviteUser,
    WebMethodChangeMobileOrderStatus,
    WebMethodGetMobileOrderStatus,
    WebMethodAcceptRejectTabRequest,
    WebMethodTypeSendSMSToJoinTab,
    WebMethodSendEmailToStaff,
    WebMethodGetAcknowledgeStatus,
    WebMethodTypeTransferBooking,
    WebMethodTypeAddTabOrder,
    WebMethodTypeDeleteTabOrderItems,
    WebMethodTypeSMSMessageUpdate,
    WebMethodTypeEmailMessageUpdate,
    WebMethodTypeGetBookingHistory,
    WebMethodTypeTakeDepositOnBooking,
    WebMethodTypeGenerateTab,
    WebMethodTypeCallTab,
    WebMethodTypeChangeMasterOnTab,
    WebMethodTypeBookingSMSMessageUpdate,
    WebMethodInventoryVisibilityStatusUpdate,
    WebMethodColorUpdation,
    WebMethodUpdateManager,
    WebMethodCreateBookingForBookingItem,
    WebMethodAddAddress,
    WebMethodForSaleAmount,
    WebMethodForDefaultFloorPlan,
    WebMethodStaffLoginLogoutOffline,
    WebMethodUpdateInventories,
    WebMethodTypeEditGuestInfo,
    WebMethodToGetIPAddressOfPax,
    WebMethodToEditTips,
} WebMethodType;


@protocol ServiceHelperDelegate <NSObject>

@optional

-(void)serviceResponse:(id)response andMethodName:(WebMethodType)methodName;
-(void)serviceError:(id)response andMethodName:(WebMethodType)methodName;

-(void)connectionFailWithErrorMessage:(NSString*)error andMethodName:(WebMethodType)methodName;

@end

@interface HTTPClient : AFHTTPClient

+ (HTTPClient *) sharedClient;

@end

@interface JSONRequestOperationQueue :AFJSONRequestOperation

@property (nonatomic, assign) NSInteger requestTag;

@end



@interface ServiceHelper : NSObject

@property (nonatomic, assign) BOOL isReachable;

@property (nonatomic, assign) id<ServiceHelperDelegate> serviceHelperDelegate;

+ (ServiceHelper *)sharedEngine;

-(void)callGetMethodWithData:(NSMutableDictionary*)dict andMethodName:(WebMethodType)methodName forPath:(NSString*)path andControllerToShowHud:(BOOL)showHud;
-(void)callPOSTMethodWithData:(NSMutableDictionary*)dict andMethodName:(WebMethodType)methodName forPath:(NSString*)path andControllerToShowHud:(BOOL)showHud;

//-(void)callPOSTMethodForMultipartRequestWithData:(NSMutableDictionary*)dict fileDataKey:(NSString*)fileKey fileName:(NSString *)file mimeType:(NSString *)mime methodName:(WebMethodType)methodName andControllerToShowHud:(BOOL)showHud;

- (void)cancelRequestwithName:(WebMethodType)methodName;

@end
