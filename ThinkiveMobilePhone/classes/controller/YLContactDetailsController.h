//
//  YLContactDetailsController.h
//  ThinkiveMobilePhone
//
//  Created by kill on 16/1/8.
//  Copyright © 2016年 kill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLContact.h"
#import "YLBaseViewController.h"
@interface YLContactDetailsController : YLBaseViewController


@property(nonatomic,strong) YLContact * contact;


- (instancetype)initWithContact:(YLContact *)contact;

@end
