//
//  YPBaseViewController.m
//  CanXinTong
//
//  Created by 喻平 on 13-1-28.
//  Copyright (c) 2013年 喻平. All rights reserved.
//

#import "YPBaseViewController.h"
#import "UIView+UIViewEXT.h"
@interface YPBaseViewController ()
{
    
}
@end

@implementation YPBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_bgImageView && IPHONE5) {
        _bgImageView.height += 88;
    }
    if (IOS7_AND_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_keyboardNotiEnabled) {
        [self registerKeyboardNotification];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_keyboardNotiEnabled) {
        [self removeKeyboardNotification];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewInBackground]) {
        NSLog(@"%@-->didReceiveMemoryWarning", [[self class] description]);
        self.progressHUD = nil;
        self.view = nil;
        [self removeKeyboardNotification];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleBlackOpaque;
}



- (BOOL)isViewInBackground
{
    return [self isViewLoaded] && self.view.window == nil;
}

- (void)showWhiteProgressWithText:(NSString *)text
{
    [self showProgressWithText:text];
    _progressHUD.backgroundColor = [UIColor whiteColor];
}

- (void)showProgressWithText:(NSString *)text
{
    [self showProgressOnView:self.view text:text userInteractionEnabled:YES];
}

- (void)showProgressOnWindowWithText:(NSString *)text
{
    [self showProgressOnView:self.view.window text:text userInteractionEnabled:YES];
}

- (void)showProgressOnView:(UIView *)view text:(NSString *)text userInteractionEnabled:(BOOL)enabled
{
    if (_progressHUD == nil) {
        self.progressHUD = [[MBProgressHUD alloc] initWithView:view];
        [view addSubview:_progressHUD];
        _progressHUD.delegate = self;
        [_progressHUD show:YES];
    }
    _progressHUD.labelText = text;
    NSLog(@"show");
    _progressHUD.userInteractionEnabled = enabled;
}



- (void)showToast:(NSString *)text onView:(UIView *)view inCenter:(BOOL)inCenter hideAfterDelay:(NSTimeInterval)delay {
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	
	// Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
	hud.labelText = text;
	hud.margin = 10.f;
    if (inCenter) {
        hud.center = view.center;
    } else{
        hud.yOffset = view.frame.size.height * 0.2f;
    }
	
	hud.removeFromSuperViewOnHide = YES;
	hud.userInteractionEnabled = NO;
	[hud hide:YES afterDelay:delay];
}

- (void)showToast:(NSString *)text hideAfterDelay:(NSTimeInterval)delay
{
    [self showToast:text onView:self.view.window inCenter:NO hideAfterDelay:delay];
}

- (void)showToast:(NSString *)text inCenter:(BOOL)inCenter
{
    [self showToast:text onView:self.view.window inCenter:inCenter hideAfterDelay:1.5f];
}

- (void)showToast:(NSString *)text
{
    [self showToast:text hideAfterDelay:1.5f];
}


- (void)hudWasHidden:(MBProgressHUD *)hud
{
    if (_progressHUD) {
        [_progressHUD removeFromSuperview];
        self.progressHUD = nil;
        NSLog(@"hide progress");
    }   
}

- (void)hideProgress
{
    if (_progressHUD) {
        [_progressHUD hide:YES];
    }
    
}
- (void)pushViewControllerWithName:(NSString *)name
{
    Class class = NSClassFromString(name);
    UIViewController *controller = [[class alloc] initWithNibName:name bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)setKeyboardNotificationEnabled:(BOOL)enabled
{
    _keyboardNotiEnabled = enabled;
}
- (void)registerKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKeyboardNotification
{
    NSLog(@"removeKeyboardNotification");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];

    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    NSLog(@"show-->%@  duration-->%f", NSStringFromCGRect([aValue CGRectValue]), animationDuration);
    [self keyboardWillShowWithRect:keyboardRect animationDuration:animationDuration];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    NSLog(@"hide-->%@  duration-->%f", NSStringFromCGRect([aValue CGRectValue]), animationDuration);
    [self keyboardWillHideWithRect:keyboardRect animationDuration:animationDuration];
}

- (void)keyboardWillShowWithRect:(CGRect)keyboardRect
{
    
}

- (void)keyboardWillHideWithRect:(CGRect)keyboardRect
{
    
}

- (IBAction)textFieldDidEndOnExit:(UITextField *)textField
{
    [NativeUtil hideKeyboard];
}

- (IBAction)backgroundButtonClicked:(UIButton *)button
{
    [NativeUtil hideKeyboard];
}

- (void)addBackgroundButtonForHidingKeybord
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = self.view.bounds;
    [button addTarget:self action:@selector(backgroundButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [self.view sendSubviewToBack:button];
}

- (void)initLeftBarButtonItem:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:style target:target action:action];
}
- (void)initRightBarButtonItem:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:style target:target action:action];
}

- (void)initLeftBarButtonItem:(NSString *)title
{
    [self initLeftBarButtonItem:title style:UIBarButtonItemStyleBordered target:self action:@selector(leftBarButtonPressed:)];
}

- (void)initRightBarButtonItem:(NSString *)title
{
    [self initRightBarButtonItem:title style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarButtonPressed:)];
}

- (IBAction)rightBarButtonPressed:(id)sender
{
    
}

- (IBAction)leftBarButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
