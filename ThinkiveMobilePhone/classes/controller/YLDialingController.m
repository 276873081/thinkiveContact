//
//  YLDialingController.m
//  ThinkiveMobilePhone
//
//  Created by kill on 15/12/30.
//  Copyright © 2015年 kill. All rights reserved.
//

#import "YLDialingController.h"


#define margin 35
#define spacing 8
@interface YLDialingController ()

@property UILabel * numberLabel;
@property UIButton * deleteButton;
@property NSMutableArray<YLNumberButton*> * numberButtons;
@property YLNumberButton *musicButton;

@end

@implementation YLDialingController
{
    dispatch_source_t longTimer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.view.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
}


-(void)initNavigationBar
{
}

-(void)setupSubViews
{
    
    
    self.numberLabel = [[UILabel alloc]init];
    
    float labelX = margin;
    float labelY = IOS6Plus?20:0;
    float labelWidth = self.view.frame.size.width - 2*labelX;
    float labelHeight = self.view.frame.size.height * 0.1 ;
    _numberLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
    _numberLabel.text = @"";
    _numberLabel.font = [UIFont systemFontOfSize:35];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.lineBreakMode = NSLineBreakByTruncatingHead;
    _numberLabel.adjustsFontSizeToFitWidth =YES;
    _numberLabel.minimumScaleFactor = 0.6;
    [self.view addSubview:_numberLabel];

    _deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_deleteButton setImage:[[UIImage imageNamed:@"Keypad-Delete-Button"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    _deleteButton.tintColor = [UIColor blueColor];
    _deleteButton.hidden = YES;
    
    float deleteButtonWidth = 25;
    float deleteButtonHeight = 23;
    float deleteButtonX = CGRectGetMaxX(_numberLabel.frame);
    float deleteButtonY = labelY + labelHeight / 2 - deleteButtonHeight / 2;
    
    _deleteButton.frame = CGRectMake(deleteButtonX, deleteButtonY, deleteButtonWidth, deleteButtonHeight);
    [_deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchDown];
    
    
    UILongPressGestureRecognizer *longRecognizer = [[UILongPressGestureRecognizer alloc]init];
    longRecognizer.minimumPressDuration = 0.7;
    [longRecognizer addTarget:self action:@selector(deleteButtonLongPress:)];
    [_deleteButton addGestureRecognizer:longRecognizer];
    [self.view addSubview:_deleteButton];
    
    
    UIView *numberButtonView = [[UIView alloc]init];
    float buttonViewX = margin;
    float buttonViewY = CGRectGetMaxY(_numberLabel.frame) + spacing;
    float buttonViewW = self.view.frame.size.width - 2*margin;
    float buttonViewH = self.view.frame.size.height * 0.6;
    numberButtonView.frame = CGRectMake(buttonViewX, buttonViewY, buttonViewW, buttonViewH);
    
    
    [self.view addSubview:numberButtonView];
    
    float buttonH = (numberButtonView.frame.size.height - 3 * spacing) / 4 ;
    
    
    float buttonW = buttonH;
    float buttonHorizontalSpacing = (buttonViewW - buttonW * 3) / 2;
    
    NSArray *buttonTitles = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"*",@"0",@"#"];
    self.numberButtons = [NSMutableArray array];
    for(int i = 0 ; i < 12 ; i++)
    {
        YLNumberButton *button = [YLNumberButton buttonWithType:UIButtonTypeCustom];
        float buttonX = i % 3 * (buttonW + buttonHorizontalSpacing);
        float buttonY = i / 3 * (spacing + buttonH);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        [button setTitle:buttonTitles[i] forState:UIControlStateNormal];
        button.delegate = self;
        [numberButtonView addSubview:button];
        [_numberButtons addObject:button];
    }
    
    
    UIButton *callButton = [UIButton buttonWithType:UIButtonTypeSystem];
    float callButtonX = numberButtonView.frame.origin.x + buttonW + buttonHorizontalSpacing;
    float callButtonY = CGRectGetMaxY(numberButtonView.frame) + spacing;
    float callButtonW = buttonW;
    float callButtonH = buttonH;
    callButton.frame = CGRectMake(callButtonX, callButtonY, callButtonW, callButtonH);
    [callButton setImage:[[UIImage imageNamed:@"stark_voicemail_callback"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    callButton.backgroundColor = [UIColor colorWithRed:83/255.0 green:215/255.0 blue:105/255.0 alpha:1];
    callButton.tintColor = [UIColor whiteColor];
    callButton.layer.borderWidth = 0;
    callButton.layer.masksToBounds = YES;
    callButton.titleLabel.font = [UIFont systemFontOfSize:30];
    callButton.layer.cornerRadius = callButtonW / 2;
    [callButton addTarget:self action:@selector(callButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:callButton];
    
    _musicButton = [[YLNumberButton alloc]init];
    float musicBtnW = 40;
    float musicBtnH = 40;
    float musicBtnX = self.view.frame.size.width - musicBtnW - margin;
    float musicBtnY = self.view.frame.size.height - musicBtnH - margin - YLBottomBarHeight;
    _musicButton.frame = CGRectMake(musicBtnX, musicBtnY, musicBtnW, musicBtnH);
    [_musicButton setTitle:@"🎶" forState:UIControlStateNormal];
    [_musicButton addTarget:self action:@selector(randomMusic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_musicButton];
    
    
}


-(void)numberButtonClick:(YLNumberButton *)button
{
    _numberLabel.text = [NSString stringWithFormat:@"%@%@",_numberLabel.text,button.currentTitle];
    _deleteButton.hidden =  NO;
}

-(void)numberButtonLongPress:(YLNumberButton *)button
{
    NSString *text = button.currentTitle;
    if([text isEqualToString:@"0"])
    {
        NSString *text  =  [_numberLabel.text substringToIndex:_numberLabel.text.length - 1];
        _numberLabel.text = [NSString stringWithFormat:@"%@%@",text,@"+"];
    }
    else if([text isEqualToString:@"#"])
    {
        NSString *text  =  [_numberLabel.text substringToIndex:_numberLabel.text.length - 1];
        _numberLabel.text = [NSString stringWithFormat:@"%@%@",text,@";"];
    }
}

-(void)deleteButtonClick:(UIButton *)button
{
    if(_numberLabel.text.length)
    {
        _numberLabel.text =  [_numberLabel.text substringToIndex:_numberLabel.text.length - 1];
    }
    else
    {
        _deleteButton.hidden = YES;
    }
}

-(void)deleteButtonLongPress:(UILongPressGestureRecognizer*)longPress
{
   if(longPress.state == UIGestureRecognizerStateBegan)
   {
       dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
       dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
       longTimer = timer;
       dispatch_source_set_event_handler(timer, ^{
           [self deleteButtonClick:nil];
       });
       dispatch_resume(timer);
   }
   else
   {
       dispatch_source_cancel(longTimer);
   }
    
}

-(void)callButtonClick
{
    
    if(!_numberLabel.text.length)
    {
        return;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"tel://%@",_numberLabel.text];
    NSURL *phoneUrl = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication] openURL:phoneUrl];
}

-(void)randomMusic
{
    
    CABasicAnimation *animo = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animo.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    animo.duration = 2.0;
    animo.repeatCount = MAXFLOAT;
    [_musicButton.layer addAnimation:animo forKey:@"rotateAnimo"];
    _musicButton.enabled = NO;
    NSString *music = @"356 6 678 8 897 7 6556  356 6 678 8 897 7 656  356 6 689 9 9*0 0 *9*6 678 8 9*6 687 7 656  356 6 678 8 897 7 6556  356 6 678 8 897 7 656  356 6 689 9 9*0 0 *9*6 678 8 9*6 687 7 656  678 8 9*6 687 7  656 678 8  9*    863  0   964 * 0 ** *9  9     8     7 8 7 76";
    dispatch_async(dispatch_queue_create("musicQueuq", 0), ^{
        for(int i = 0;i<music.length;i++)
        {
            NSString *key = [music substringWithRange:NSMakeRange(i, 1)];
            if(![key isEqualToString:@" "])
            {
                int keyi;
                if([key isEqualToString:@"*"])
                {
                    keyi = 9;
                }
                else if([key isEqualToString:@"0"])
                {
                    keyi = 10;
                }
                else if([key isEqualToString:@"#"])
                {
                    keyi = 11;
                }
                else
                    keyi = key.intValue-1;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.numberButtons[keyi] sendActionsForControlEvents:UIControlEventTouchDown];
                });
                [NSThread sleepForTimeInterval:1.0f/8];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.numberButtons[keyi] sendActionsForControlEvents:UIControlEventTouchUpInside];
                });
            }
            else
            {
                [NSThread sleepForTimeInterval:1.0f/8];
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            _musicButton.enabled = YES;
            [_musicButton.layer removeAnimationForKey:@"rotateAnimo"];
        });

    });
    
}

@end
