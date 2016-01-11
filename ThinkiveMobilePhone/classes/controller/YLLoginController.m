//
//  YLLoginController.m
//  ThinkiveMobilePhone
//
//  Created by kill on 16/1/8.
//  Copyright © 2016年 kill. All rights reserved.
//
#define itemDistance 30

#import "YLLoginController.h"
#import "YLTabBarController.h"
#import "MBProgressHUD.h"
typedef void(^loginCallBack) (YLLoginManager*);
@interface YLLoginController ()
{
    loginCallBack callBack;
}
@property(nonatomic,strong) UIImageView* backgroundView;
@property(nonatomic,strong) UITextField* userNameField;
@property(nonatomic,strong) UITextField* passwordField;
@property(nonatomic,strong) UIButton* loginButton;

@end

@implementation YLLoginController

-(instancetype)initWithSuccessBlock:(void (^)(YLLoginManager *))block
{
    self = [super init];
    if(self)
    {
        callBack = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self autoInputUserName];
}

-(void)autoInputUserName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [defaults objectForKey:@"userName"];
    
    if(userName)
    {
        _userNameField.text = userName;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setupSubviews
{
    _backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"backgroundthree"]];
    _backgroundView.frame = self.view.bounds;
    
    [self.view addSubview:_backgroundView];
    
    _userNameField = [[UITextField alloc]init];
    float usernameW = self.view.frame.size.width * 0.6;
    float usernameH = 30;
    float usernameX = self.view.frame.size.width * 0.2;
    float usernameY = self.view.frame.size.height * 0.15;
    _userNameField.frame = CGRectMake(usernameX, usernameY, usernameW, usernameH);
    _userNameField.placeholder = @"用户名";
    _userNameField.backgroundColor = [UIColor whiteColor];
    _userNameField.alpha = 0.8;
    _userNameField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_userNameField];
    
    _passwordField = [[UITextField alloc]init];
    float passwordW = usernameW;
    float passwordH = usernameH;
    float passwordX = usernameX;
    float passwordY = CGRectGetMaxY(_userNameField.frame) + itemDistance;
    _passwordField.frame = CGRectMake(passwordX, passwordY, passwordW, passwordH);
    _passwordField.placeholder = @"密码";
    _passwordField.backgroundColor = [UIColor whiteColor];
    _passwordField.alpha = 0.8;
    _passwordField.borderStyle = UITextBorderStyleRoundedRect;
    _passwordField.secureTextEntry = YES;
    [self.view addSubview:_passwordField];
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    float loginBtnW = passwordW;
    float loginBtnH = passwordH;
    float loginBtnX = passwordX;
    float loginBtnY = CGRectGetMaxY(_passwordField.frame) + itemDistance;
    _loginButton.frame = CGRectMake(loginBtnX, loginBtnY, loginBtnW, loginBtnH);
    _loginButton.backgroundColor = [UIColor whiteColor];
    _loginButton.alpha = 0.8;
    _loginButton.layer.cornerRadius = 5;
    [_loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    
    [_loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    
    UIImage *logoImage = [UIImage imageNamed:@"logo"];
    UIImageView *logoView = [[UIImageView alloc]initWithImage:logoImage];
    float logoW = logoImage.size.width;
    float logoH = logoImage.size.height;
    float logoX = loginBtnX;
    float logoY = self.view.frame.size.height * 0.51;
    logoView.frame = CGRectMake(logoX, logoY, logoW, logoH);
    [self.view addSubview:logoView];

//    _userNameField.text = @"yul@thinkive.com";
//    _passwordField.text = @"a5201314";

}

-(void)login
{
    [self.view endEditing:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText = @"正在登陆...";
    NSString *username = _userNameField.text;
    NSString *password = _passwordField.text;
    if(username.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入用户名!" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    if(password.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入密码!" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    YLLoginManager *loginManager = [YLLoginManager shareManager];
    [loginManager loginByUserName:username Password:password complete:^(YLLoginManager *manager, NSString *errorInfo) {
        if(manager.isLogin)
        {
            [self loginSuccess:manager];
        }
        else
        {
            [self  loginFail:manager errorInfo:errorInfo];
        }
    }];
}

-(void)loginSuccess:(YLLoginManager *)manager
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    CATransition *transition = [CATransition animation];
    transition.duration = 2;
    transition.type = @"rippleEffect";
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    callBack(manager);
}
-(void)loginFail:(YLLoginManager *)manager errorInfo:(NSString *)errorInfo
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登陆失败" message:errorInfo delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alert show];
}

@end
