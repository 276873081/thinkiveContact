//
//  YLNumberButton.m
//  ThinkiveMobilePhone
//
//  Created by kill on 15/12/30.
//  Copyright © 2015年 kill. All rights reserved.
//

#import "YLNumberButton.h"
#import <AVFoundation/AVFoundation.h>


@interface YLNumberButton()


@end

@implementation YLNumberButton
{
    SystemSoundID soundId;
    CAShapeLayer *animoLayer;
}



-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        UIColor *color = [UIColor colorWithRed:77/255.0 green:77/255.0 blue:77/255.0 alpha:1];
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 2;
        self.layer.borderColor = color.CGColor;
        self.titleLabel.font = [UIFont systemFontOfSize:30];
        [self setTitleColor:color forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self addTarget:self action:@selector(onTouchDown) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(onTouchUp) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(onTouchUp) forControlEvents:UIControlEventTouchUpOutside];
        [self addTarget:self action:@selector(onTouchUp) forControlEvents:UIControlEventTouchCancel];
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(onLongPress)];
        longPressRecognizer.minimumPressDuration = 1.0;
        [self addGestureRecognizer:longPressRecognizer];
        
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.layer.cornerRadius = rect.size.width / 2;
    [self setUpAnimoLayer];
    
}

-(void)onTouchDown
{
    self.backgroundColor = [UIColor colorWithRed:77/255.0 green:77/255.0 blue:77/255.0 alpha:1];
    [self.delegate numberButtonClick:self];
    [self playSound];
    [self clickAnimo];
}

-(void)setUpAnimoLayer
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, nil, self.frame.size.width/2, self.frame.size.height/2, self.layer.cornerRadius-2, 0, 2*M_PI, NO);
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame         = self.bounds;                // 与showView的frame一致
    layer.strokeColor   = [UIColor redColor].CGColor;   // 边缘线的颜色
    layer.fillColor     = [UIColor clearColor].CGColor;   // 闭环填充的颜色
    layer.lineCap       = kCALineCapRound;               // 边缘线的类型
    layer.path          = path;                    // 从贝塞尔曲线获取到形状
    layer.lineWidth     = 10.0;                           // 线条宽度
    layer.strokeStart   = 0.0f;
    layer.strokeEnd     = 0.0;
    
    CAGradientLayer *gradientLayer1 =  [CAGradientLayer layer];
    gradientLayer1.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    NSMutableArray *colors = [NSMutableArray array];
    
    [colors addObject:(id)[UIColor redColor].CGColor];
    [colors addObject:(id)[UIColor orangeColor].CGColor];
    [colors addObject:(id)[UIColor yellowColor].CGColor];
    [colors addObject:(id)[UIColor greenColor].CGColor];
    [colors addObject:(id)[UIColor cyanColor].CGColor];
    [colors addObject:(id)[UIColor blueColor].CGColor];
    [colors addObject:(id)[UIColor purpleColor].CGColor];
    
    [gradientLayer1 setColors:colors];
    [self.layer addSublayer:gradientLayer1];
    [gradientLayer1 setMask:layer];
    
    animoLayer = layer;

}

-(void)clickAnimo
{
    
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 0.6;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.3];
    pathAnimation.toValue = [NSNumber numberWithFloat:1];
    
    
    CABasicAnimation *pathAnimation2 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    pathAnimation2.duration = 0.6;
    pathAnimation2.fromValue = [NSNumber numberWithFloat:0];
    pathAnimation2.toValue = [NSNumber numberWithFloat:1];

    [animoLayer addAnimation:pathAnimation forKey:nil];
    [animoLayer addAnimation:pathAnimation2 forKey:nil];

}

-(void)onTouchUp
{
//    [animoLayer removeAllAnimations];
//    [UIView beginAnimations:@"颜色渐变" context:nil];
    [CATransaction begin];
    self.backgroundColor = [UIColor clearColor];
    [CATransaction commit];
}

-(void)onLongPress
{
    [self onTouchUp];
    [self.delegate numberButtonLongPress:self];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)playSound
{
    if(!soundId)
    {
        NSString *fileNumber;
        if([self.currentTitle isEqualToString:@"#"])
        {
            fileNumber = @"pound";
        }
        else if([self.currentTitle isEqualToString:@"*"])
        {
            fileNumber = @"star";
        }
        else
        {
            fileNumber = self.currentTitle;
        }
        
        NSString *fileName = [NSString stringWithFormat:@"sound/dtmf-%@",fileNumber];
        
        NSBundle *mainBundle = [NSBundle mainBundle];
        
        NSURL *soundUrl = [mainBundle URLForResource:fileName withExtension:@"caf"];
        if(soundUrl)
        {
            AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(soundUrl),&soundId);
        }
        else
        {
            return;
        }
    }
    AudioServicesPlaySystemSound(soundId);
}

- (void)dealloc
{
    AudioServicesRemoveSystemSoundCompletion(soundId);
}

@end
