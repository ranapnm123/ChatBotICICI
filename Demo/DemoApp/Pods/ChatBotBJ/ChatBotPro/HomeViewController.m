    //
    //  HomeViewController.m
    //  ChatBot
    //
    //  Created by PULP on 24/07/18.
    //  Copyright © 2018 Ashish Kr Singh. All rights reserved.
    //

    #import "HomeViewController.h"
    #import "ViewController.h"

    @interface HomeViewController ()<UIGestureRecognizerDelegate>

    @end

    @implementation HomeViewController

    - (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setFrame];

    _containerView.layer.masksToBounds = YES;
    _containerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _containerView.layer.borderWidth = 1.0;
    _containerView.layer.cornerRadius = 5.0;
    _containerView.hidden = YES;
    _startBotBtn.layer.masksToBounds = YES;
    _startBotBtn.layer.cornerRadius = 30;

    UIPanGestureRecognizer *objGesture= [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveButton:)];
    objGesture.delegate = self;
    [_startBotBtn addGestureRecognizer:objGesture];
    }

    -(void)moveButton:(UIPanGestureRecognizer *)recognizer
    {
    if (recognizer.state == UIGestureRecognizerStateChanged ||
        recognizer.state == UIGestureRecognizerStateEnded) {
        
        UIView *draggedButton = recognizer.view;
        CGPoint translation = [recognizer translationInView:self.view];
        
        CGRect newButtonFrame = draggedButton.frame;
            newButtonFrame.origin.x += translation.x;
        if (newButtonFrame.origin.x < 0) {
            newButtonFrame.origin.x = 0;
        }
        else if(newButtonFrame.origin.x > (self.view.frame.size.width - newButtonFrame.size.width)){
            newButtonFrame.origin.x = (self.view.frame.size.width - newButtonFrame.size.width);
        }

        newButtonFrame.origin.y += translation.y;
        if (newButtonFrame.origin.y < 0) {
            newButtonFrame.origin.y = 0;
        }
        else if(newButtonFrame.origin.y > (self.view.frame.size.height - newButtonFrame.size.height)){
            newButtonFrame.origin.y = (self.view.frame.size.height - newButtonFrame.size.height);
        }
        draggedButton.frame = newButtonFrame;
        
        [recognizer setTranslation:CGPointZero inView:self.view];
    }
    }

    -(void)setFrame{
    NSBundle *resourceBundle = [Utility getBundleForChatBotPro];
    UIImage *img = [UIImage imageNamed:@"floating" inBundle:resourceBundle compatibleWithTraitCollection:nil];
    _startBotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_startBotBtn setFrame:CGRectMake(self.view.frame.size.width - 80, self.view.frame.size.height - 120, 60, 60)];
    [_startBotBtn setBackgroundImage:img forState:UIControlStateNormal];
    [_startBotBtn addTarget:self action:@selector(startBotAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startBotBtn];

    _containerView = [[UIView alloc] init];
    [_containerView setFrame:CGRectMake(self.view.frame.size.width - 276, self.view.frame.size.height - (92+70+10), 256, 92)];
    [self.view addSubview:_containerView];

    _textView = [[UITextView alloc] init];
    [_textView setFrame:CGRectMake(8, 17, 228, 70)];
    [_textView setBackgroundColor:[UIColor clearColor]];
    [_textView setEditable:NO];
    [_textView setText:@"Hi, I can help you find all your answers regarding loans"];
    [_textView setFont:[UIFont systemFontOfSize:16]];
    [_containerView addSubview:_textView];

    UIImage *crossImg = [UIImage imageNamed:@"cross" inBundle:resourceBundle compatibleWithTraitCollection:nil];
    _crossBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_crossBtn setFrame:CGRectMake(232, 7, 16, 16)];
    [_crossBtn setBackgroundImage:crossImg forState:UIControlStateNormal];
    [_crossBtn addTarget:self action:@selector(crossBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_containerView addSubview:_crossBtn];
    }

    -(void)crossBtnAction:(id)sender{
    _containerView.hidden = YES;
    }
    -(void)startBotAction:(id)sender{
    NSBundle *resourceBundle = [Utility getBundleForChatBotPro];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:resourceBundle];
    ViewController *VC = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self presentViewController:VC animated:YES completion:^{
      [[NSNotificationCenter defaultCenter] postNotificationName:@"initialCallNotification" object:nil];
    }];
    }
    /*
    #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */

    @end
