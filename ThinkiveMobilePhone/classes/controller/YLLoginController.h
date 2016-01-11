//
//  YLLoginController.h
//  ThinkiveMobilePhone
//
//  Created by kill on 16/1/8.
//  Copyright © 2016年 kill. All rights reserved.
//

#import "YLBaseViewController.h"
#import "YLLoginManager.h"
@interface YLLoginController : YLBaseViewController

-(instancetype)initWithSuccessBlock:(void(^)(YLLoginManager*))block;

@end
