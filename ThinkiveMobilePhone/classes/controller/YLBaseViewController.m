//
//  YLBaseViewController.m
//  ThinkiveMobilePhone
//
//  Created by kill on 15/12/30.
//  Copyright © 2015年 kill. All rights reserved.
//

#import "YLBaseViewController.h"

@interface YLBaseViewController ()

@end

@implementation YLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)initNavigationBar{
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        
        [self initNavigationBar];
    }
    return self;
}
@end
