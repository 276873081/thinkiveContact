//
//  YLHistoryController.m
//  ThinkiveMobilePhone
//
//  Created by kill on 15/12/30.
//  Copyright © 2015年 kill. All rights reserved.
//

#import "YLHistoryController.h"

@interface YLHistoryController ()

@end

@implementation YLHistoryController


- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)initNavigationBar
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = rightItem;
}



@end
