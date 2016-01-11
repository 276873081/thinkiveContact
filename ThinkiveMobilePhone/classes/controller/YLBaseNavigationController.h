//
//  YLBaseNavigationController.h
//  ThinkiveMobilePhone
//
//  Created by kill on 15/12/30.
//  Copyright © 2015年 kill. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLBaseNavigationController : UINavigationController
-(instancetype) initWithTabBarIcon:(NSString*)iconName selectedIcon:(NSString *)selectedIconName title:(NSString *)title;
@end
