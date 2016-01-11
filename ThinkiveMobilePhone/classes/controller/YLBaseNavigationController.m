//
//  YLBaseNavigationController.m
//  ThinkiveMobilePhone
//
//  Created by kill on 15/12/30.
//  Copyright © 2015年 kill. All rights reserved.
//

#import "YLBaseNavigationController.h"
#import "UIImage+YL.h"
@interface YLBaseNavigationController ()

@end

@implementation YLBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}


-(void)settingTabBarImage:(UIImage*)image selectedImage:(UIImage*)selectImage title:(NSString *)title
{
    self.tabBarItem.image = [image resize:CGSizeMake(30, 30)];
    self.tabBarItem.selectedImage = [selectImage resize:CGSizeMake(30, 30)];
    self.tabBarItem.title = title;
}

-(instancetype) initWithTabBarIcon:(NSString*)iconName selectedIcon:(NSString *)selectedIconName title:(NSString *)title
{
    self = [super init];
    if(self)
    {
        [self settingTabBarImage:[UIImage imageNamed:iconName]selectedImage:[UIImage imageNamed:selectedIconName] title:title];
    }
    return self;
}
@end
