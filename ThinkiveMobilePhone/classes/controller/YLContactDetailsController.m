//
//  YLContactDetailsController.m
//  ThinkiveMobilePhone
//
//  Created by kill on 16/1/8.
//  Copyright © 2016年 kill. All rights reserved.
//

#import "YLContactDetailsController.h"

//边距
#define margin 30

//控件之间的距离
#define itemDistance 10
@interface YLContactDetailsController ()

@property(nonatomic,strong) UIImageView *photoView;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *cityLabel;
@property(nonatomic,strong) UILabel *orgLabel;
@property(nonatomic,strong) UILabel *phoneLabel;
@property(nonatomic,strong) UILabel *emailLabel;
@property(nonatomic,strong) UILabel *workDayLabel;
@property(nonatomic,strong) UILabel *statusLabel;


@end

@implementation YLContactDetailsController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@ 的详情",_contact.name];
    [self.navigationController setNavigationBarHidden:NO];
    [self setupSubViews];
    [self setupBackGestureRecognizer];
}

-(instancetype)initWithContact:(YLContact *)contact
{
    self = [super init];
    
    if(self)
    {
        _contact = contact;
    }
    
    return self;
}

-(void)setupBackGestureRecognizer
{
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(popSelf)];
    [self.view addGestureRecognizer:swipe];
}

-(void)popSelf
{
    [self.navigationController popViewControllerAnimated:YES];
}


+(NSString *)localSalutation:(NSString*)salutation
{
    NSDictionary *dict = @{@"MRS" : @"女士",@"MR" : @"先生"};
    return [dict objectForKey:salutation];
}

+(NSString*)parseCity:(NSString *)city
{
    NSDictionary *dict = @{@"BJ" : @"北京",
                           @"CS" : @"长沙",
                           @"SZ" : @"深圳",
                           @"GZ" : @"广州",
                           @"ZZ" : @"郑州",
                           @"LZ" : @"兰州",
                           @"SH" : @"上海"
                           };
    return [dict objectForKey:city];
}

+(UIView *)craeteSeparatorToViewBottom:(UIView *)view
{
    UIView *separator = [[UIView alloc]init];
    float separatorW = 480;
    float separatorH = 1;
    float separatorX = view.frame.origin.x;
    float separatorY = CGRectGetMaxY(view.frame) + itemDistance;
    separator.frame =  CGRectMake(separatorX, separatorY, separatorW, separatorH);
    separator.backgroundColor = [UIColor grayColor];
    separator.alpha = 0.3;
    return separator;
}

-(void)setupSubViews
{
    float topViewX = margin ;
    float topViewY = margin + YLTopBarHeight + YLStatusBarHeight;
    float topViewW = CGRectGetWidth(self.view.frame) - 2*margin;
    float topViewH = CGRectGetHeight(self.view.frame) - 2*margin;
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(topViewX, topViewY, topViewW, topViewH)];
    
    
    float photoViewX = 0;
    float photoViewY = 0;
    float photoViewH = 132;
    float photoViewW = 132;
    _photoView = [[UIImageView alloc]init];
    _photoView.layer.cornerRadius = 10;
    _photoView.frame = CGRectMake(photoViewX, photoViewY, photoViewW, photoViewH);
    
    NSString *ImgName = [NSString stringWithFormat:@"headImg_%@",_contact.salutation];
    UIImage *image = [UIImage imageNamed:ImgName];
    if(image)
    {
        _photoView.image = image;
    }
    else
    {
        _photoView.image = [UIImage imageNamed:@"headImg_MR"];
    }
    [topView addSubview:_photoView];
    
    _nameLabel = [[UILabel alloc]init];
    float nameX = CGRectGetMaxY(_photoView.frame) + itemDistance;
    float nameY = photoViewY;
    float nameW = CGRectGetWidth(self.view.frame) - nameX - itemDistance - margin;
    float nameH = _photoView.frame.size.height / 3;
    _nameLabel.frame = CGRectMake(nameX, nameY, nameW, nameH);
    NSString *localSalutation = [YLContactDetailsController localSalutation:_contact.salutation];
    NSString *text = [NSString stringWithFormat:@"%@  %@",_contact.name,localSalutation ? localSalutation : @""];
    _nameLabel.text = text;
    [topView addSubview:_nameLabel];
    
    _cityLabel = [[UILabel alloc]init];
    float cityW = nameW;
    float cityH = nameH;
    float cityX = nameX;
    float cityY = CGRectGetMaxY(_nameLabel.frame);
    _cityLabel.frame = CGRectMake(cityX, cityY, cityW, cityH);
    NSString *city = [YLContactDetailsController parseCity:_contact.department];
    _cityLabel.text = city ? city : @"宝宝解析不了的城市编码";
    [topView addSubview:_cityLabel];
    
    _orgLabel = [[UILabel alloc]init];
    float orgW = cityW;
    float orgH = cityH;
    float orgX = cityX;
    float orgY = CGRectGetMaxY(_cityLabel.frame);
    _orgLabel.frame = CGRectMake(orgX, orgY, orgW, orgH);
    _orgLabel.text = _contact.orgName;
    [topView addSubview:_orgLabel];
    
    _phoneLabel = [[UILabel alloc]init];
    float phoneX = photoViewX;
    float phoneY = CGRectGetMaxY(_photoView.frame) + margin;
    float phoneW = topViewW;
    float phoneH = 20;
    _phoneLabel.frame = CGRectMake(phoneX, phoneY, phoneW, phoneH);
    NSString *phoneNumberStr = [NSString stringWithFormat:@"电话:  %@",_contact.faxnoc];
    _phoneLabel.text = phoneNumberStr;
    [topView addSubview:_phoneLabel];
    UIButton *cleanButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cleanButton.frame = _phoneLabel.frame;
    [cleanButton addTarget:self action:@selector(tellPhone) forControlEvents:UIControlEventTouchUpInside];
    [cleanButton setBackgroundImage:[UIImage imageNamed:@"stark_menu_button_selected"] forState:UIControlStateHighlighted];
    [topView addSubview:cleanButton];
    
    
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    float buttonW = 20;
    float buttonH = 20;
    float buttonX = topViewW - buttonW;
    float buttonY = phoneY;
    phoneButton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    [phoneButton setImage:[UIImage imageNamed:@"facetime_audio"] forState:UIControlStateNormal];
    [phoneButton addTarget:self action:@selector(tellPhone) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:phoneButton];

    UIButton *msgButton = [UIButton buttonWithType:UIButtonTypeSystem];
    float msgW = 20;
    float msgH = 20;
    float msgX = topViewW - msgW - buttonW - itemDistance;
    float msgY = phoneY;
    msgButton.frame = CGRectMake(msgX, msgY, msgW, msgH);
    [msgButton setTitle:@"💌" forState:UIControlStateNormal];
    [msgButton addTarget:self action:@selector(sendMsg) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:msgButton];
    
    UIView *separator = [YLContactDetailsController craeteSeparatorToViewBottom:_phoneLabel];
    [topView addSubview:separator];

    
    _emailLabel = [[UILabel alloc]init];
    float emailX = photoViewX;
    float emailY = CGRectGetMaxY(separator.frame) + itemDistance;
    float emailW = topViewW;
    float emailH = 20;
    _emailLabel.frame = CGRectMake(emailX, emailY, emailW, emailH);
    NSString *emailStr = [NSString stringWithFormat:@"邮箱:  %@",_contact.email];
    _emailLabel.text = emailStr;
    [topView addSubview:_emailLabel];
    
    UIButton *emailButton = [UIButton buttonWithType:UIButtonTypeSystem];
    float emailBtnW = 21;
    float emailBtnH = 21;
    float emailBtnX = msgX;
    float emailBtnY = emailY;
    emailButton.frame = CGRectMake(emailBtnX, emailBtnY, emailBtnW, emailBtnH);
    [emailButton setTitle:@"✉️" forState:UIControlStateNormal];
    [emailButton addTarget:self action:@selector(sendEmail) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:emailButton];

    UIView *separator2 = [YLContactDetailsController craeteSeparatorToViewBottom:_emailLabel];
    [topView addSubview:separator2];
    
    _workDayLabel = [[UILabel alloc]init];
    float workX = photoViewX;
    float workY = CGRectGetMaxY(separator2.frame) + itemDistance;
    float workW = topViewW;
    float workH = 20;
    _workDayLabel.frame = CGRectMake(workX, workY, workW, workH);
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [format stringFromDate:_contact.hireDay];
    NSString *dateText = [NSString stringWithFormat:@"入职日期:  %@",dateStr];
    _workDayLabel.text = dateText;
    [topView addSubview:_workDayLabel];
    
    
    UIView *separator3 = [YLContactDetailsController craeteSeparatorToViewBottom:_workDayLabel];
    [topView addSubview:separator3];

    _statusLabel = [[UILabel alloc]init];
    float statusX = photoViewX;
    float statusY = CGRectGetMaxY(separator3.frame) + itemDistance;
    float statusW = topViewW;
    float statusH = 20;
    _statusLabel.frame = CGRectMake(statusX, statusY, statusW, statusH);
    NSString *statusStr = [NSString stringWithFormat:@"员工状态:  %@",_contact.status.intValue == 1 ? @"在职" : @"本宝宝解析不了的状态"];
    _statusLabel.text = statusStr;
    [topView addSubview:_statusLabel];

    UIView *separator4 = [YLContactDetailsController craeteSeparatorToViewBottom:_statusLabel];
    [topView addSubview:separator4];
    
    [self.view addSubview:topView];
}



-(void) tellPhone
{
    NSString *phoneStr = [NSString stringWithFormat:@"tel://%@",_contact.faxnoc];
    NSURL *phoneUrl = [NSURL URLWithString:phoneStr];
    [[UIApplication sharedApplication] openURL:phoneUrl];
}

-(void)sendMsg
{
    NSString *phoneStr = [NSString stringWithFormat:@"sms://%@",_contact.faxnoc];
    NSURL *phoneUrl = [NSURL URLWithString:phoneStr];
    [[UIApplication sharedApplication] openURL:phoneUrl];
}

-(void)sendEmail
{
    NSString *phoneStr = [NSString stringWithFormat:@"mailto://%@",_contact.email];
    NSURL *phoneUrl = [NSURL URLWithString:phoneStr];
    [[UIApplication sharedApplication] openURL:phoneUrl];
}

@end
