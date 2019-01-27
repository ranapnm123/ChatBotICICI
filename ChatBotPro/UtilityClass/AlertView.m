
#import "AlertView.h"
#import "NSString+Validator.h"

@interface AlertView () <UIAlertViewDelegate>

@property (nonatomic, strong) AlertCompletionBlock completionBlock;

@end

@implementation AlertView

+ (instancetype)sharedManager {
    
    static AlertView *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

-(void)displayInformativeAlertwithTitle:(NSString *)title andMessage:(NSString*)message onController:(UIViewController*)controller {
    
    [self presentAlertWithTitle:title message:message andButtonsWithTitle:[NSArray arrayWithObject:@"OK"] onController:controller dismissedWith:^(NSInteger index, NSString *buttonTitle) { }];
}


-(void)presentAlertWithTitle:(NSString*)title
                     message:(NSString*)message
         andButtonsWithTitle:(NSArray*)buttonTitles
                onController:(UIViewController*)controller
               dismissedWith:(AlertCompletionBlock)completionBlock {
    
    id buttonTitle = [buttonTitles firstObject];
    if (!buttonTitle || ![buttonTitle isKindOfClass:[NSString class]]) {
        return;
    }
    
    self.completionBlock = completionBlock;
    
        //display UIAlertController
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        for (NSInteger index = 0; index < buttonTitles.count; index++) {
            UIAlertAction * buttonAction = [UIAlertAction actionWithTitle:[buttonTitles objectAtIndex:index] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                //  AlertActionBLock
                self.completionBlock(index, action.title);
                
            }];
            [alertController addAction:buttonAction];
        }
        
        [controller presentViewController:alertController animated:YES completion:nil];
}
@end
