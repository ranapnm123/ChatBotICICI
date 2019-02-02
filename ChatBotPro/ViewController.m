//
//  ViewController.m
//  ChatBot
//
//  Created by Ashish Kr Singh on 13/07/18.
//  Copyright © 2018 Ashish Kr Singh. All rights reserved.
//

#import "ViewController.h"

#import "SenderTableViewCell.h"
#import "ReciverTableViewCell.h"
#import "SenderImageTableViewCell.h"
#import "ImageReceiverTableViewCell.h"
#import "MessageInfo.h"
#import "MenuTableViewCell.h"
#import "CollectionViewTableViewCell.h"
#import "CarausalCollectionViewCell.h"
#import "UIImage+animatedGIF.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVKit/AVKit.h>
#import "Header.h"
#import "AlertView.h"
#import "OptionsTableViewCell.h"
#import "ProgressCell.h"
#import "AttachmentCell.h"
#import "CoreDataHelper.h"
#import <AWSS3/AWSS3.h>
//#import <AWSCore/AWSCore.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAsset.h>
#import "IDMPhotoBrowser.h"
#import "TTTAttributedLabel.h"
#import <SafariServices/SafariServices.h>
#import <Speech/Speech.h>

// for live
//#define kBaseUrl @"https://early-salary-backend.herokuapp.com/ios/JUBI15Q9uk_EarlySalary"
//project id for live
//JUBI15Q9uk_EarlySalary

// for testing
#define kBaseUrl @"https://product-test-backend.herokuapp.com/ios/JUBIzMjyA_sasasasas"
//project id for testing
//JUBIzMjyA_sasasasas

#define kAWSBucketName @"mobile-dev-jubi"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIDocumentMenuDelegate,UIDocumentPickerDelegate, UIPopoverPresentationControllerDelegate, TTTAttributedLabelDelegate, SFSpeechRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
    @property (weak, nonatomic) IBOutlet UIButton *attachmentBtn;
@property (weak, nonatomic) IBOutlet UIButton *audioBtn;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *menuContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstant;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (strong, nonatomic) UIImageView *previewImage;
@property (strong, nonatomic) NSString *projectID;
@property (strong, nonatomic) NSString *baseURL;
@property (strong, nonatomic) NSMutableArray *arrayToReplace;
@end

@implementation ViewController
{
    CGPoint centerView;
    NSArray *menuList;
    NSArray *carausalList;
    BOOL isAllSender;
    SFSpeechRecognizer *speechRecognizer;
    SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
    SFSpeechRecognitionTask *recognitionTask;
    AVAudioEngine *audioEngine;
    BOOL audioEnable;

}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    audioEnable = true;
    [self initialSetup];
    [self setDummyData];
    
    _projectID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ChatBotProjectID"];
    _baseURL = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ChatBotBaseURL"];
    


    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"TestNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(collectionCellButtonAction:)
                                                 name:@"collectionCellButtonActionNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(initialApiCall)
                                                 name:@"initialCallNotification"
                                               object:nil];
    
    [self setUpCognitoCredentials];
    _arrayToReplace = [NSMutableArray arrayWithObjects:@"|br|", nil];
    [self speechRecognition];
    
    _attachmentBtn.hidden = true;
    _audioBtn.translatesAutoresizingMaskIntoConstraints = false;
    [[_audioBtn.rightAnchor constraintEqualToAnchor:_sendBtn.leftAnchor constant:-10] setActive:true];
    
    _messageTextField.translatesAutoresizingMaskIntoConstraints = false;
    [[_messageTextField.rightAnchor constraintEqualToAnchor:_audioBtn.leftAnchor constant:-10] setActive:true];
    
    [self deActivateMic];
}

  
    

    
#pragma mark - SFSpeechRecognizerDelegate Delegate Methods
    
    -(void)speechRecognition {
       
        [self deActivateMic];
        
        
        
        // Initialize the Speech Recognizer with the locale, couldn't find a list of locales
        // but I assume it's standard UTF-8 https://wiki.archlinux.org/index.php/locale
        speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        
        // Set speech recognizer delegate
        speechRecognizer.delegate = self;
        
        // Request the authorization to make sure the user is asked for permission so you can
        // get an authorized response, also remember to change the .plist file, check the repo's
        // readme file or this project's info.plist
        [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
            switch (status) {
                case SFSpeechRecognizerAuthorizationStatusAuthorized:
                NSLog(@"Authorized");
                break;
                case SFSpeechRecognizerAuthorizationStatusDenied:
                NSLog(@"Denied");
                break;
                case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                NSLog(@"Not Determined");
                break;
                case SFSpeechRecognizerAuthorizationStatusRestricted:
                NSLog(@"Restricted");
                break;
                default:
                break;
            }
        }];
        
    }

- (void)activateMic {
    UIImage *microImg = self.audioBtn.imageView.image;
    if ([microImg respondsToSelector:@selector(imageWithRenderingMode:)]) {
        UIImage *colorlessImg = [microImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]; // crash for ios6, not in ios 7
        [self.audioBtn setImage:colorlessImg forState:UIControlStateNormal];
//        self.audioBtn.imageView.tintColor = UIColor.blueColor;
    }
}

- (void)deActivateMic {
    NSBundle *resourceBundle = [Utility getBundleForChatBotPro];
    UIImage *img = [UIImage imageNamed:@"Microphone" inBundle:resourceBundle compatibleWithTraitCollection:nil];
    [_audioBtn setImage:img forState:UIControlStateNormal];

//    UIImage *microImg = self.audioBtn.imageView.image;
//    if ([microImg respondsToSelector:@selector(imageWithRenderingMode:)]) {
//        UIImage *colorlessImg = [microImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]; // crash for ios6, not in ios 7
//        [self.audioBtn setImage:colorlessImg forState:UIControlStateNormal];
//        self.audioBtn.imageView.tintColor = UIColor.lightGrayColor;
//    }
}
    
    - (void)startListening {
        
        // Initialize the AVAudioEngine
        audioEngine = [[AVAudioEngine alloc] init];
        
        // Make sure there's not a recognition task already running
        if (recognitionTask) {
            [recognitionTask cancel];
            recognitionTask = nil;
        }
        
        // Starts an AVAudio Session
        NSError *error;
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryRecord error:&error];
        [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
        
        // Starts a recognition process, in the block it logs the input or stops the audio
        // process if there's an error.
        recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
        AVAudioInputNode *inputNode = audioEngine.inputNode;
        recognitionRequest.shouldReportPartialResults = YES;
        recognitionTask = [speechRecognizer recognitionTaskWithRequest:recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
            BOOL isFinal = NO;
            if (result) {
                // Whatever you say in the microphone after pressing the button should be being logged
                // in the console.
                NSLog(@"RESULT:%@",result.bestTranscription.formattedString);
                self.messageTextField.text = result.bestTranscription.formattedString;
                isFinal = !result.isFinal;
                
                
            }
            if (error) {
                [self->audioEngine stop];
                [inputNode removeTapOnBus:0];
                self->recognitionRequest = nil;
                self->recognitionTask = nil;
            }
        }];
        
        // Sets the recording format
        AVAudioFormat *recordingFormat = [inputNode outputFormatForBus:0];
        [inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
            [self->recognitionRequest appendAudioPCMBuffer:buffer];
        }];
        
        // Starts the audio engine, i.e. it starts listening.
        [audioEngine prepare];
        [audioEngine startAndReturnError:&error];
        NSLog(@"Say Something, I'm listening");
    }
    
    - (IBAction)microPhoneTapped:(id)sender {
        if (audioEngine.isRunning) {
            [audioEngine stop];
            [recognitionRequest endAudio];
        } else {
            [self activateMic];
            [self startListening];
        }
    }
    
- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available {
    NSLog(@"Availability:%d",available);
}
    
    
-(void)initialApiCall{
    NSUInteger count = [CoreDataHelper getMessagesCount];
    if(count == 0){
     [self callAPIToSubmitAnswer:@"Start over"];
    }
    else{
        [self refreshData];
    }
}

- (void) receiveTestNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    NSLog(@"userInfo %@",notification.object);
    
    [self removeProgressCell];
    
    [self addMessageReplyToArray:notification.object];
    
}


-(void)initialSetup{
    self.messageTextField.layer.masksToBounds = true;
    self.messageTextField.layer.cornerRadius = self.messageTextField.frame.size.height / 2;
    self.messageTextField.layer.borderWidth = 1.0;
    self.messageTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.messageTextField.leftView = paddingView;
    self.messageTextField.leftViewMode = UITextFieldViewModeAlways;

    
    self.messageTextField.delegate = self;
    centerView = self.view.center;
    self.containerView.layer.cornerRadius = 4;
    self.containerView.layer.masksToBounds = true;
    //keyboard notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.menuContainerView.layer.cornerRadius = 8;
    self.menuContainerView.layer.masksToBounds = false;
    
    self.menuContainerView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.menuContainerView.layer.shadowOffset = CGSizeMake(0, 1);
    self.menuContainerView.layer.shadowOpacity = 1;
    self.menuContainerView.layer.shadowRadius = 2.0;

    self.menuView.layer.cornerRadius = 8;
    self.menuView.clipsToBounds = true;
    self.heightConstant.constant = 0;
    self.widthConstant.constant = 0;
    
    
}
-(void)setDummyData{
    self.messageList = [[NSMutableArray alloc] init];
    

    menuList = [[NSArray alloc] initWithObjects:@"Invest Now",@"Talk to Agent"  ,@"Cancel",nil];
    
}

#pragma mark - Keyboard methods

- (void)keyboardShow:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
  
    CGRect keyboard = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGFloat heightKeyboard = keyboard.size.height;
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        if (@available(iOS 11.0, *)) {
            self.view.center = CGPointMake(self->centerView.x, self->centerView.y - heightKeyboard + self.view.safeAreaInsets.bottom);
        } else {
            // Fallback on earlier versions
        }
    } completion:nil];
   
    [[UIMenuController sharedMenuController] setMenuItems:nil];
}

- (void)keyboardHide:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    NSTimeInterval duration = [[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.view.center = self->centerView;
    } completion:nil];
}

- (void)dismissKeyboard{
    [self.view endEditing:YES];
}

- (void)openMediaOption{
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionCamera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self openCameraForPhoto];
        
    }];
    UIAlertAction *actionPhoto = [UIAlertAction actionWithTitle:@"Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self openGalleryForPhoto];
        
    }];
    UIAlertAction *actionVideo = [UIAlertAction actionWithTitle:@"Video" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self openGalleryForVideo];
        
    }];
    UIAlertAction *actionDocument = [UIAlertAction actionWithTitle:@"Document" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self openDoc];
        
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    [actionSheet addAction:actionCamera];
    [actionSheet addAction:actionPhoto];
    [actionSheet addAction:actionVideo];
    [actionSheet addAction:actionDocument];
    [actionSheet addAction:actionCancel];

    [self presentViewController:actionSheet animated:YES completion:nil];
}

-(void)openGalleryForPhoto{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

-(void)openGalleryForVideo{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeMovie, nil];
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

-(void)openCameraForPhoto{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
        cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraPicker.delegate = self;
//        if (![self isPhotoSelection:photoSelectionType]) cameraPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
        [self presentViewController:cameraPicker animated:YES completion:nil];
    }
}

-(void)openDoc{
//    @[@"public.data",@"public.content",@"public.audiovisual-content",@"public.movie",@"public.audiovisual-content",@"public.video",@"public.audio",@"public.text",@"public.data",@"public.zip-archive",@"com.pkware.zip-archive",@"public.composite-content",@"public.text"]
    UIDocumentMenuViewController *documentProviderMenu =
    [[UIDocumentMenuViewController alloc] initWithDocumentTypes:@[@"public.data"]
                                                         inMode:UIDocumentPickerModeImport];
    [UINavigationBar appearance].tintColor = [UIColor colorWithRed:0 green:204/255 blue:217/255 alpha:1.0];
    documentProviderMenu.delegate = self;
    documentProviderMenu.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:documentProviderMenu animated:YES completion:nil];
    
}



#pragma mark - Selector Methods


-(void)docBtnAction:(UIButton*)sender{
    
    MessageInfo *info = [self.messageList objectAtIndex:sender.tag - 200];
    
}

-(void)playBtnAction:(UIButton*)sender{
    
    MessageInfo *info = [self.messageList objectAtIndex:sender.tag - 100];
    
    NSArray *arr = [[NSString stringWithFormat:@"%@",info.videoURL] componentsSeparatedByString:@"/"];
    NSString* saveFileName = [arr lastObject];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingString:@"/Images"];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:saveFileName];

    
    NSURL *vedioURL =[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@",path]];
    if (info.videoURL != nil) {
        AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
        playerViewController.player = [AVPlayer playerWithURL:vedioURL];
        [self presentViewController:playerViewController animated:YES completion:nil];
    }
   
    
}



#pragma mark - UIImagePicker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if (@available(iOS 11.0, *)) {
        NSURL *imageURL;
        if ([mediaType isEqualToString:@"public.image"]) {
            
            
            UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
            if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
                NSString *fileName = [NSString stringWithFormat:@"%@.jpg",[NSDate date]];
                fileName = [Utility getFileNameFromURL:fileName];
   
                NSData * imageData = UIImageJPEGRepresentation(chosenImage, .5);
                NSString *filePath = [Utility saveImage:imageData withName:fileName];
                imageURL = [NSURL URLWithString:filePath];
                
            }
            else{
                NSString *fileName = [NSString stringWithFormat:@"%@.jpg",[NSDate date]];
                fileName = [Utility getFileNameFromURL:fileName];
                NSData * imageData = UIImageJPEGRepresentation(chosenImage, .5);
                NSString *filePath = [Utility saveImage:imageData withName:fileName];
                imageURL = [NSURL URLWithString:filePath];


            }
            
            
            
            MessageInfo *info1 = [MessageInfo new];
            info1.imageName = chosenImage;
            info1.fileNameStr = [imageURL lastPathComponent];
            info1.gifImage = [NSString stringWithFormat:@"file://%@",imageURL];
            info1.isSender = true;

            
            ///save sent message to local db
            [CoreDataHelper saveSentMessageDataTolocalDB:info1];

            [self.messageList addObject:info1];
            
            [self addMessageToTableView];
            


            [self uploadFileToServer:info1];
            
        } else if ([mediaType isEqualToString:@"public.movie"]){
            
            NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
            
            
            AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
            AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
            gen.appliesPreferredTrackTransform = YES;
            CMTime time = CMTimeMakeWithSeconds(0.0, 600);
            NSError *error = nil;
            CMTime actualTime;

            CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
            UIImage *thumbnail = [[UIImage alloc] initWithCGImage:image];
            CGImageRelease(image);
            
            //for thumbnail
            NSString *fileName2 = [NSString stringWithFormat:@"%@_thumbnail.jpg",[NSDate date]];
            fileName2 = [Utility getFileNameFromURL:fileName2];
            NSData * imageData2 = UIImageJPEGRepresentation(thumbnail, .5);
            NSString *filePath2 = [Utility saveImage:imageData2 withName:fileName2];
            NSURL *thumbnailImgUrl = [NSURL URLWithString:fileName2];
            ///end///
            
            
            NSString *fileName = [NSString stringWithFormat:@"%@.MOV",[NSDate date]];
            fileName = [Utility getFileNameFromURL:fileName];
            NSData * imageData = [NSData dataWithContentsOfURL:videoURL];
            NSString *filePath = [Utility saveImage:imageData withName:fileName];
            imageURL = [NSURL URLWithString:filePath];

            MessageInfo *info1 = [MessageInfo new];
            info1.thumbnailImage = thumbnailImgUrl;
            info1.fileNameStr = imageURL.lastPathComponent;
            info1.videoURL = imageURL;
            info1.isSender = true;
            ///save sent message to local db
            [CoreDataHelper saveSentMessageDataTolocalDB:info1];
            
            [self.messageList addObject:info1];
            
            [self addMessageToTableView];
            
            [self uploadFileToServer:info1];
        }
    } else {
        // Fallback on earlier versions
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIDocumentPicker Delegate

- (void)documentMenu:(nonnull UIDocumentMenuViewController *)documentMenu didPickDocumentPicker:(nonnull UIDocumentPickerViewController *)documentPicker {
    
    documentPicker.delegate = self;
    [UINavigationBar appearance].tintColor = [UIColor redColor];
    [self presentViewController:documentPicker animated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    NSLog(@"picked %@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"extenstion %@", [request.URL lastPathComponent]);
    MessageInfo *info1 = [MessageInfo new];
    info1.videoURL = url;
    info1.message = [request.URL lastPathComponent];
    info1.fileNameStr = [request.URL lastPathComponent];
    info1.isDoc = true;
    info1.isSender = true;
    
    ///save sent message to local db
    [CoreDataHelper saveSentMessageDataTolocalDB:info1];
    //
    [self.messageList addObject:info1];
    
    [self addMessageToTableView];
    
    [self uploadFileToServer:info1];

}

#pragma mark - UITextField Delegate Methode

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSBundle *resourceBundle = [Utility getBundleForChatBotPro];
    UIImage *img = [UIImage imageNamed:@"sendActive.png" inBundle:resourceBundle compatibleWithTraitCollection:nil];
    [self.sendBtn setImage:img forState:UIControlStateNormal];

}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([_messageTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0){
        NSBundle *resourceBundle = [Utility getBundleForChatBotPro];
        UIImage *img = [UIImage imageNamed:@"send.png" inBundle:resourceBundle compatibleWithTraitCollection:nil];
       [self.sendBtn setImage:img forState:UIControlStateNormal];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.returnKeyType == UIReturnKeyDone) {
        [textField resignFirstResponder];

    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.text.length >= 265 && range.length == 0){
        return NO;
    }
    
    return YES;
}

#pragma mark - UITableViewDelegate & DataSource Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.menuTableView) {
        return menuList.count;
    }
    return self.messageList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.myTableView){
        MessageInfo *info = [self.messageList objectAtIndex:indexPath.row];
        if(info.isDoc){
            NSURL *fileUrl = info.videoURL;
            NSData *data = [NSData dataWithContentsOfURL:fileUrl];
        }
        return;
    }
    [UIView animateWithDuration:0.85 delay:0 options:UIViewAnimationOptionCurveLinear  animations:^{
        self.heightConstant.constant = 0;
        self.widthConstant.constant = 0;
    } completion:^(BOOL finished) {
        
        //code for completion
    }];
    self.menuBtn.selected = false;

//    
//    //send request to bot
    
     NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[menuList objectAtIndex:indexPath.row],@"text",[menuList objectAtIndex:indexPath.row],@"data", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"collectionCellButtonActionNotification" object:dict];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.menuTableView) {
        MenuTableViewCell *cell = (MenuTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"MenuTableViewCell"];
        cell.titleLabel.textColor = [UIColor colorWithRed:22/255.0 green:188/255.0 blue:206/255.0 alpha:1];
        cell.titleLabel.text = [menuList objectAtIndex:indexPath.row];
        return cell;
    }
    
    MessageInfo *info = [self.messageList objectAtIndex:indexPath.row];
    if (info.isProgress) {
        ProgressCell *cell = (ProgressCell *)[tableView dequeueReusableCellWithIdentifier:@"ProgressCell"];
        return cell;
    }
    
 
    
    if (info.isSender) {
        
        if (info.message.length > 0 && info.isDoc == false) {
            SenderTableViewCell *cell = (SenderTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"SenderTableViewCell"];
            cell.messageLabel.text = info.message;
            cell.messageLabel.delegate = self;
            return cell;
        }
        
        else if (info.gifImage.length > 0 ) {
            SenderImageTableViewCell *cell = (SenderImageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"SenderImageTableViewCell"];
            cell.playBtn.hidden = true;
            UIImage *img = [UIImage imageWithContentsOfFile:info.gifImage];
            if(img == nil){
                NSArray *arr = [info.gifImage componentsSeparatedByString:@"/"];
                NSString *imgName = [arr lastObject];
                NSData *dt = [Utility getreceivedFileInDocDir:imgName];
                img = [UIImage imageWithData:dt];
            }
            
            cell.messageImageView.image = img;

            UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            imgBtn.frame = cell.messageImageView.frame;
            imgBtn.tag = indexPath.row + 300;;
            [imgBtn addTarget:self action:@selector(imageBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:imgBtn];
            return cell;
            
            
        }
        
       else if(info.isDoc){
            AttachmentCell *cell = (AttachmentCell*)[tableView dequeueReusableCellWithIdentifier:@"AttachmentCell"];
            cell.messageTitle.text = info.message;
            return cell;
        }
        
        else if (info.videoURL != nil) {
            SenderImageTableViewCell *cell = (SenderImageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"SenderImageTableViewCell"];
            cell.playBtn.hidden = false;
            
            
            
            
            NSURL *videoURL = info.videoURL;
            
           
            UIImage *thumbnail = [Utility retrieveImage:[NSString stringWithFormat:@"%@",info.thumbnailImage]];

            UIButton *imgBtn2 = (UIButton *)[self.view viewWithTag:indexPath.row + 300];
            [imgBtn2  removeFromSuperview];
            
            UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            imgBtn.frame = cell.messageImageView.frame;
            imgBtn.tag = indexPath.row + 100;;
            [imgBtn addTarget:self action:@selector(playBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:imgBtn];
//            cell.playBtn.tag = indexPath.row + 100;
//            [cell.playBtn addTarget:self action:@selector(playBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            
            
            cell.messageImageView.image = thumbnail;
            return cell;
        }
     
    }else {
        if (info.message.length>0) {
            ReciverTableViewCell *cell = (ReciverTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"ReciverTableViewCell"];
            NSString *text = info.message;
            cell.messageTitle.text = [self checkForSpecialCharacter:text];
            cell.messageTitle.delegate = self;
            return cell;
        }

        
        if (info.gifImage.length > 0) {
            ImageReceiverTableViewCell *cell = (ImageReceiverTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"ImageReceiverTableViewCell"];
            
            NSURL *url = [NSURL URLWithString:info.gifImage];
            
            
            NSData *fileData = [Utility getFileInDocDir:info.gifImage];
            if(fileData != nil){
                cell.messageImageView.image = [UIImage animatedImageWithAnimatedGIFData:fileData];
            }
            else{
                
                
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue, ^{
                    NSData * imageData = [NSData dataWithContentsOfURL:url];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.messageImageView.image = [UIImage animatedImageWithAnimatedGIFData:imageData];
                    });
                });
            }
            
            UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            imgBtn.frame = cell.messageImageView.frame;
            imgBtn.tag = indexPath.row + 300;;
            [imgBtn addTarget:self action:@selector(imageBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:imgBtn];
            
            return cell;
            
        }
        
        if (info.isCarausal) {
            CollectionViewTableViewCell *cell = (CollectionViewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"CollectionViewTableViewCell"];
            cell.myCollectionView.delegate = cell;
            cell.myCollectionView.dataSource = cell;
            NSArray *articleData = info.carausalArray;
            [cell setCollectionData:articleData];
            return cell;
        }
        
        if (info.isOption) {
            OptionsTableViewCell *cell = (OptionsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"OptionsTableViewCell"];
            [cell setData:info.optionsArray];
            return cell;
        }
        

      
        
       
    }
    
    
    return nil;
}

-(void)imageBtnTapped:(UIButton *)sender{
    MessageInfo *info = [self.messageList objectAtIndex:sender.tag - 300];
    UIImage *image = [UIImage imageWithContentsOfFile:info.gifImage];
    if(image == nil){
    NSArray *arr = [info.gifImage componentsSeparatedByString:@"/"];
    NSString *imgName = [arr lastObject];
    NSData *dt = [Utility getreceivedFileInDocDir:imgName];
    image = [UIImage imageWithData:dt];
    }
    if(!info.isSender){
        NSData *fileData = [Utility getFileInDocDir:info.gifImage];
        image = [UIImage animatedImageWithAnimatedGIFData:fileData];
    }
    
    IDMPhoto *photos = [IDMPhoto photoWithImage:image];
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:[NSArray arrayWithObject:photos]];
    [browser setDisplayToolbar:NO];
    [self presentViewController:browser animated:YES completion:nil];


    
}



-(void)removeImageVIew{
    [_previewImage removeFromSuperview];
}

#pragma mark- UIButton Action Methods

-(void)readMoreBtn:(UIButton*)sender{
    MessageInfo *info = [MessageInfo new];
    info.message = @"Read more";
    info.isSender = true;
    ///save sent message to local db
    [CoreDataHelper saveSentMessageDataTolocalDB:info];
    
    [self.messageList addObject:info];
    
    [self addMessageToTableView];

}

- (IBAction)sendBtnAction:(id)sender {
    
     [self.view endEditing:true];
    if ([self.messageTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length != 0) {
        MessageInfo *info = [MessageInfo new];
        info.message = self.messageTextField.text;
        info.isSender = true;
        
        ///save sent message to local db
        [CoreDataHelper saveSentMessageDataTolocalDB:info];
        
        [self.messageList addObject:info];
        
        [self addMessageToTableView];
        

        
        NSBundle *resourceBundle = [Utility getBundleForChatBotPro];
        UIImage *img = [UIImage imageNamed:@"send.png" inBundle:resourceBundle compatibleWithTraitCollection:nil];
        [self.sendBtn setImage:img forState:UIControlStateNormal];

        //send request to bot
        [self callAPIToSubmitAnswer:self.messageTextField.text];
         [self.messageTextField setText:@""];
        if (audioEngine.isRunning) {
            [audioEngine stop];
            [recognitionRequest endAudio];
            [recognitionTask cancel];
            [self deActivateMic];
        }
    }
}

- (IBAction)menuBtnAction:(UIButton*)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        [UIView animateWithDuration:0.85 delay:0 options:UIViewAnimationOptionCurveLinear  animations:^{

        } completion:^(BOOL finished) {
            self.heightConstant.constant = 220;
            self.widthConstant.constant = 294;
            //code for completion
        }];
    }else{
        [UIView animateWithDuration:0.85 delay:0 options:UIViewAnimationOptionCurveLinear  animations:^{

        } completion:^(BOOL finished) {
            self.heightConstant.constant = 0;
            self.widthConstant.constant = 0;
            //code for completion
        }];
    }
    
    

}
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    
    return UIModalPresentationNone;
}

- (IBAction)closeMenuAction:(id)sender {
    [UIView animateWithDuration:0.85 delay:0 options:UIViewAnimationOptionCurveLinear  animations:^{
        
    } completion:^(BOOL finished) {
        self.heightConstant.constant = 0;
        self.widthConstant.constant = 0;
        self.menuBtn.selected = false;
    }];
}

- (IBAction)uploadBtnAction:(id)sender {
    [self openMediaOption];
}

- (IBAction)downBtnACtion:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)showProgressCell{
    MessageInfo *info = [MessageInfo new];
    info.isSender = false;
    info.isProgress = YES;
    [self.messageList addObject:info];
    
    [self addMessageToTableView];
   
}

-(void)addMessageToTableView{
    dispatch_async(dispatch_get_main_queue(), ^{
    [self.myTableView beginUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messageList.count-1 inSection:0];
    [self.myTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.myTableView endUpdates];
    
    [self.myTableView
     scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageList.count-1
                                               inSection:0]
     atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    });
}

-(void)RemoveMessageToTableView:(NSIndexPath *)indexPath{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.myTableView beginUpdates];
        [self.myTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.myTableView endUpdates];
        
        [self.myTableView
         scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageList.count-1
                                                   inSection:0]
         atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    });
}



-(void)removeProgressCell{
    for(MessageInfo *info in self.messageList){
        if (info.isProgress) {
             [self.messageList removeObject:info];
            [self.myTableView beginUpdates];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messageList.count inSection:0];
            [self.myTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.myTableView endUpdates];
            
            if(self.messageList.count > 0){
            [self.myTableView
             scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageList.count-1
                                                       inSection:0]
             atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }
    }
}

#pragma mark - Service Helper Methods
-(void)callAPIToSubmitAnswer:(NSString *)message{
    double delayInSeconds = .5;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
                   {
                       [self showProgressCell];
                       
                   });
    
    
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    
    NSMutableDictionary * requestDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         message, @"lastAnswer",
                                         token, @"iosId",_projectID,@"projectId",nil];

    [[OPServiceHelper sharedServiceHelper] PostAPICallWithParameter:requestDict apiName:_baseURL methodName:WebMethodLogin WithComptionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!error){
                if([[result objectForKeyNotNull:pRESPONSE_CODE expectedObj:@"0"] integerValue] == 200){
                    
                    

                } else{

                }
            }
        });
    }];
}

-(void)callAPIToSubmitAttachment:(NSString *)url{
    [self showProgressCell];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSMutableDictionary * requestDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         @"uploaded file", @"lastAnswer",
                                         @"attachment", @"type",url,@"url",
                                         token, @"iosId",@"JUBI15Q9uk_EarlySalary",@"projectId",nil];
    
    [[OPServiceHelper sharedServiceHelper] PostAPICallWithParameter:requestDict apiName:_baseURL methodName:WebMethodLogin WithComptionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self removeProgressCell];
            if(!error){
                if([[result objectForKeyNotNull:pRESPONSE_CODE expectedObj:@"0"] integerValue] == 200){
                   
                } else{
                    
                }
            }
        });
    }];
}

-(void)addMessageReplyToArray:(NSDictionary *)messageDict{
     [MBProgressHUD hideHUDForView:[Utility getWindow] animated:YES];
    if([[messageDict objectForKey:@"answerType"] isEqualToString:@"text"] || [[messageDict objectForKey:@"answerType"] isEqualToString:@"persist-option"]){
        id object = [self dictionaryFromString:[messageDict objectForKey:@"botMessage"]];
        if ([object isKindOfClass:[NSArray class]]) {
            NSLog(@"arrclass");
            double delayInSeconds = 0.0;
            for(NSDictionary *dict in object){
                delayInSeconds += .5;
                
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
                               {
                                   NSLog(@"Block");
                                   [self performSelectorOnMainThread:@selector(addInfo:)
                                                          withObject:dict
                                                       waitUntilDone:NO];
                                   
                               });
            }
        }
        }
    else if([[messageDict objectForKey:@"answerType"] isEqualToString:@"generic"]){
        id object = [self dictionaryFromString:[messageDict objectForKey:@"botMessage"]];
        
        ///added delay because want to save bot messages first
        id optionsObject = [self dictionaryFromString:[messageDict objectForKey:@"options"]];
        [self performSelector:@selector(addCaraousalOptionsToArray:) withObject:optionsObject afterDelay:3.0];
        
        if ([object isKindOfClass:[NSArray class]]) {
            NSLog(@"arrclass");
            double delayInSeconds = 0.0;
            for(NSDictionary *dict in object){
                 delayInSeconds += .5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
                               {
                                   NSLog(@"Block");
                                   [self performSelectorOnMainThread:@selector(addInfo:)
                                                          withObject:dict
                                                       waitUntilDone:NO];
//                                   if ([object lastObject] == dict) {
//                                       id optionsObject = [self dictionaryFromString:[messageDict objectForKey:@"options"]];
//                                       [self addCaraousalOptionsToArray:optionsObject];
//                                   }
                               });

                NSLog(@"done with for loop");
            }
        }
        
        
    }
    else if([[messageDict objectForKey:@"answerType"] isEqualToString:@"option"]){
        id object = [self dictionaryFromString:[messageDict objectForKey:@"botMessage"]];
        
        ///added delay because want to save bot messages first
         id optionsObject = [self dictionaryFromString:[messageDict objectForKey:@"options"]];
        [self performSelector:@selector(addTempOptionsToArray:) withObject:optionsObject afterDelay:3.0];
        
        if ([object isKindOfClass:[NSArray class]]) {
            NSLog(@"arrclass");
            double delayInSeconds = 0.0;
            for(NSDictionary *dict in object){
                delayInSeconds += .5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
                               {
                                   NSLog(@"Block");
                                   [self performSelectorOnMainThread:@selector(addInfo2:)
                                                          withObject:dict
                                                       waitUntilDone:NO];

                               });

                
            }
        }
       
       
    }
}

/*-(void)saveMessageDataTolocalDB:(MessageInfo *)msgInfo{
    //Save to persistant storage
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext){
        Messages *message = [Messages MR_createEntityInContext:localContext];
        message.message = msgInfo.message;
        message.descriptionStr = msgInfo.descriptionStr;
        
        message.videoURL = [NSString stringWithFormat:@"%@",msgInfo.videoURL];
            if(msgInfo.gifImage.length == 0){
            message.imageName = msgInfo.gifImage;
            }
            else{
        message.gifImage = msgInfo.gifImage;
            }
            
            if(msgInfo.carausalArray.count>0){
                    message.carausalArrayData = [NSKeyedArchiver archivedDataWithRootObject:msgInfo.carausalArray];
            }
            
            if(msgInfo.optionsArray.count>0){
                
                    message.optionsArrayData = [NSKeyedArchiver archivedDataWithRootObject:msgInfo.optionsArray];
            }
        message.isSender = msgInfo.isSender;
        message.isCarausal = msgInfo.isCarausal;
        message.isOption = msgInfo.isOption;
        message.isProgress = msgInfo.isProgress;
        message.isDoc = msgInfo.isDoc;
        message.messageTime = [NSDate date];
        
        }
                  completion:^(BOOL success, NSError *error){
                      
                      [self refreshData];
                  }];
}
*/

-(void) refreshData
{
    [self.messageList removeAllObjects];
    NSArray *allRecords = [CoreDataHelper getMessagesData];//[Messages MR_findAllSortedBy:@"messageTime" ascending:YES];
    if (allRecords.count == 0) {
        return;
    }
    for (Messages *message in allRecords){
            NSLog(@"messagetime %@",message.messageTime);
        MessageInfo *msgInfo = [MessageInfo new];
         msgInfo.message = message.message ;
        msgInfo.descriptionStr = message.descriptionStr ;
        
        NSString *val = message.thumbnailImage;
        if(![val isEqual:@"(null)"])
        msgInfo.thumbnailImage =   [NSURL URLWithString:message.thumbnailImage];
        
        NSString *val2 = message.videoURL;
        if(![val2 isEqual:@"(null)"])
        msgInfo.videoURL = [NSURL URLWithString:message.videoURL];
        
        msgInfo.gifImage = message.gifImage ;
        if(message.carausalArrayData != 0){
            msgInfo.carausalArray = [NSKeyedUnarchiver unarchiveObjectWithData:message.carausalArrayData];
        }
        if(message.optionsArrayData != 0){
            msgInfo.optionsArray = [NSKeyedUnarchiver unarchiveObjectWithData:message.optionsArrayData];
        }
        msgInfo.isSender = message.isSender ;
        msgInfo.isCarausal = message.isCarausal;
        msgInfo.isOption = message.isOption;
        msgInfo.isProgress = message.isProgress;
        msgInfo.isDoc = message.isDoc;
        msgInfo.messageTime = message.messageTime;
        [self.messageList addObject:msgInfo];
    }
    [self.myTableView reloadData];
    [self.myTableView
     scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageList.count-1
                                               inSection:0]
     atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


-(void)addInfo:(NSDictionary*)dict{
    MessageInfo *info = [MessageInfo new];
    if([[dict objectForKey:@"type"] isEqualToString:@"text"]){
        info.message = [dict objectForKey:@"value"];
    }
    else if([[dict objectForKey:@"type"] isEqualToString:@"image"]){
        info.gifImage = [dict objectForKey:@"value"];
        [Utility saveFile:info.gifImage];
    }
    info.messageId = [[dict objectForKey:@"id"] intValue];
    info.isSender = false;
    if(info.message.length != 0 || info.gifImage.length != 0){
        ///save sent message to local db
        [CoreDataHelper saveSentMessageDataTolocalDB:info];
        
        [self.messageList addObject:info];
        
        [self addMessageToTableView];

    }

}

-(void)addInfo2:(NSDictionary*)dict{
    MessageInfo *info = [MessageInfo new];
    if([[dict objectForKey:@"type"] isEqualToString:@"text"]){
        info.message = [dict objectForKey:@"value"];
    }
    else if([[dict objectForKey:@"type"] isEqualToString:@"image"]){
        info.gifImage = [dict objectForKey:@"value"];
        [Utility saveFile:info.gifImage];
    }
    info.messageId = [[dict objectForKey:@"id"] intValue];
    info.isSender = false;
    if(info.message.length != 0 || info.gifImage.length != 0){
        ///save sent message to local db
        [CoreDataHelper saveSentMessageDataTolocalDB:info];
        
        [self.messageList addObject:info];
        
        [self addMessageToTableView];
        
    }
   
}

-(void)addCaraousalOptionsToArray:(id)options{
    MessageInfo *info2 = [MessageInfo new];
    info2.isSender = false;
    info2.isCarausal = true;
    if ([options isKindOfClass:[NSArray class]]) {
        info2.carausalArray = options;
    }
    ///save sent message to local db
    [CoreDataHelper saveSentMessageDataTolocalDB:info2];
    
    [self.messageList addObject:info2];
    
    [self addMessageToTableView];
    

    
}

-(void)addTempOptionsToArray:(id)options{
    if ([options isKindOfClass:[NSArray class]]) {
        MessageInfo *info = [MessageInfo new];
        
        info.isSender = false;
        info.isOption = true;
        NSMutableArray *tempArr = [NSMutableArray new];
        for (NSDictionary *dict in options) {
            [tempArr addObject:[dict objectForKey:@"text"]];
            
        }
        info.optionsArray = tempArr;
        ///save sent message to local db
        [CoreDataHelper saveSentMessageDataTolocalDB:info];
        
        [self.messageList addObject:info];
        
        [self addMessageToTableView];

    }
    
}

- (NSDictionary*)dictionaryFromString:(NSString*)strActionData
{
    if(strActionData){
        NSString *str = [strActionData stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSError* error = nil;
        NSDictionary *dictActionData = [NSJSONSerialization JSONObjectWithData:data options:0
                                                                         error:&error];
        
        return dictActionData;
    }
    else
        return nil;
}

-(void)collectionCellButtonAction:(NSNotification *) notification
{
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.messageList];
    for(MessageInfo *msgInfo in tempArray){
        if (msgInfo.isOption) {
            [self.messageList removeObject:msgInfo];
        }
    }
    
//    NSLog(@"userInfo %@",notification.object);
    MessageInfo *info = [MessageInfo new];
    NSString *selectedText = [Utility getSelectedTextFromTitle:notification.object];
    info.message = selectedText;
    info.isSender = true;
   
    ///save sent message to local db
    [CoreDataHelper saveSentMessageDataTolocalDB:info];
    
    [self.messageList addObject:info];
    
    [self.myTableView reloadData];

    
    [self performSelector:@selector(callApi:) withObject:selectedText afterDelay:1];
    
}

-(void)callApi:(NSString*)text{
    
    [self callAPIToSubmitAnswer:text];
}

#pragma mark - AWS3 file upload methods
-(void)setUpCognitoCredentials{
    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionAPSouth1 identityPoolId:@"ap-south-1:392c5499-a210-4b1d-b55a-b170cd1cd7fa"];
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionAPSouth1 credentialsProvider:credentialsProvider];
    AWSServiceManager.defaultServiceManager.defaultServiceConfiguration = configuration;
}

-(void)uploadFileToServer:(MessageInfo *)info{
    NSURL *uploadingFileURL;
    if(info.videoURL != nil || info.isDoc == YES){
        uploadingFileURL = info.videoURL;
    }
    if(info.gifImage.length>0){
        uploadingFileURL = [NSURL URLWithString:info.gifImage];
    }
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    
    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
    [uploadRequest setACL:AWSS3ObjectCannedACLPublicRead];
    uploadRequest.bucket = kAWSBucketName;
    uploadRequest.key = info.fileNameStr;
    uploadRequest.body = uploadingFileURL;
    
    
    
    
    [[transferManager upload:uploadRequest] continueWithExecutor:[AWSExecutor mainThreadExecutor]
                                                       withBlock:^id(AWSTask *task) {
                                                           if (task.error) {
                                                               if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                                                                   switch (task.error.code) {
                                                                       case AWSS3TransferManagerErrorCancelled:
                                                                       case AWSS3TransferManagerErrorPaused:
                                                                           break;
                                                                           
                                                                       default:
                                                                           NSLog(@"Error: %@", task.error);
                                                                           break;
                                                                   }
                                                               }
                                                               else {
                                                                   // Unknown error.
                                                                   NSLog(@"Error: %@", task.error);
                                                               }
                                                           }
                                                           
                                                           if (task.result) {
                                                               AWSS3TransferManagerUploadOutput *uploadOutput = task.result;
                                                               
                                                               
                                                               NSString *s3URL = [NSString stringWithFormat:@"https://s3-ap-south-1.amazonaws.com/%@/%@",kAWSBucketName,info.fileNameStr];
                                                               NSLog(@"%@, The file uploaded successfully.",s3URL);
                                                               
//                                                               [Utility removeImage:info.fileNameStr];
//                                                               [Utility saveFile:s3URL];
//                                                               
//                                                              [CoreDataHelper updateMessageDataTolocalDBFrom:info.gifImage to:s3URL];
//                                                               MessageInfo *newInfo = info;
//                                                               newInfo.message = @"";
//                                                               if(newInfo.gifImage.length>0){
//                                                               newInfo.gifImage = [NSString stringWithFormat:@"%@",s3URL];
//                                                               }
//                                                               else{
//                                                                   newInfo.videoURL = [NSURL URLWithString:s3URL];
//                                                               }
                                                               
                                                               [self callAPIToSubmitAttachment:s3URL];
//                                                               NSURL *downloadingFileURL = [NSURL URLWithString:s3URL];
//
//                                                               AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new];
//
//                                                               downloadRequest.bucket = uploadRequest.bucket;
//                                                               downloadRequest.key = uploadRequest.key;
//                                                               downloadRequest.downloadingFileURL = downloadingFileURL;
//                                                               [[transferManager download:downloadRequest ] continueWithExecutor:[AWSExecutor mainThreadExecutor]
//                                                                                                                       withBlock:^id(AWSTask *task) {
//                                                                                                                           if (task.error){
//                                                                                                                               if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
//                                                                                                                                   switch (task.error.code) {
//                                                                                                                                       case AWSS3TransferManagerErrorCancelled:
//                                                                                                                                       case AWSS3TransferManagerErrorPaused:
//                                                                                                                                           break;
//
//                                                                                                                                       default:
//                                                                                                                                           NSLog(@"Error: %@", task.error);
//                                                                                                                                           break;
//                                                                                                                                   }
//
//                                                                                                                               } else {
//                                                                                                                                   NSLog(@"Error: %@", task.error);
//                                                                                                                               }
//                                                                                                                           }
//
//                                                                                                                           if (task.result) {
//                                                                                                                               AWSS3TransferManagerDownloadOutput *downloadOutput = task.result;
//                                                                                                                           }
//                                                                                                                           return nil;
//                                                                                                                       }];
//                                                               [self.messageList addObject:info];
//                                                               [self.myTableView reloadData];
//                                                               [self.myTableView
//                                                                scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageList.count-1
//                                                                                                          inSection:0]
//                                                                atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//
////                                                               [self callAPIToSubmitAttachment:s3URL];
                                                           }
                                                           return nil;
                                                       }];
}

///TTTAttributedLabel delegate method
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    SFSafariViewController *sfVC = [[SFSafariViewController alloc] initWithURL:url];
    [self presentViewController:sfVC animated:true completion:nil];
    
}

- (NSString *)checkForSpecialCharacter:(NSString *)text {
    for (NSString *stringToReplace in _arrayToReplace) {
        text = [text stringByReplacingOccurrencesOfString:stringToReplace withString:@" "];
    }
    return text;
}

#pragma mark - Memory Warning Methods
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//[[AlertView sharedManager] displayInformativeAlertwithTitle:fcmToken andMessage:fcmToken onController:]




@end
