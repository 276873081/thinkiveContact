//
//  YLTabBarController.m
//  ThinkiveMobilePhone
//
//  Created by kill on 15/12/30.
//  Copyright © 2015年 kill. All rights reserved.
//

#import "YLBaseNavigationController.h"
#import "YLTabBarController.h"
#import "YLCollectionContorller.h"
#import "YLHistoryController.h"
#import "YLPhoneListController.h"
#import "YLDialingController.h"
@interface YLTabBarController ()

@end

@implementation YLTabBarController

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        [self setupViewContorllers];
    }
    return self;
}

-(void)setupViewContorllers
{
    
    YLCollectionContorller *collectionCtrl = [[YLCollectionContorller alloc]init];
    [self setupChildViewContorller:collectionCtrl tabBarIconName:@"stark-menu-favorites" tabBarSelectedIconName:@"stark-menu-favorites-selected" title:@"个人收藏"];
    
    YLHistoryController *historyCtrl = [[YLHistoryController alloc]init];
    [self setupChildViewContorller:historyCtrl tabBarIconName:@"stark-menu-recents" tabBarSelectedIconName:@"stark-menu-recents-selected" title:@"最近通话"];
    
    YLPhoneListController *phoneListCtrl = [[YLPhoneListController alloc]init];
    [self setupChildViewContorller:phoneListCtrl tabBarIconName:@"stark-menu-contacts" tabBarSelectedIconName:@"stark-menu-contacts-selected" title:@"通讯录"];
   
    YLDialingController *dialingCtrl = [[YLDialingController alloc]init];
    [self setupChildViewContorller:dialingCtrl tabBarIconName:@"stark-menu-keypad" tabBarSelectedIconName:@"stark-menu-keypad-selected" title:@"拨号键盘"];
    
    self.selectedIndex = 2;
    
}

-(void)setupChildViewContorller:(YLBaseViewController *)vc tabBarIconName:(NSString*)iconName tabBarSelectedIconName:(NSString *)selectedIconName title:(NSString*)title
{
    YLBaseNavigationController *navigationVC = [[YLBaseNavigationController alloc]initWithTabBarIcon:iconName selectedIcon:selectedIconName title:title];
    vc.title = title;
    [navigationVC addChildViewController:vc];
    [self addChildViewController:navigationVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}




@end
