//
//  YLCollectionContorller.m
//  ThinkiveMobilePhone
//
//  Created by kill on 15/12/30.
//  Copyright © 2015年 kill. All rights reserved.
//

#import "YLCollectionContorller.h"
#import "UIImage+YL.h"
#import "YLBaseNavigationController.h"
@interface YLCollectionContorller ()

@end

@implementation YLCollectionContorller



- (void)viewDidLoad {
    [super viewDidLoad];
}


-(void)initNavigationBar
{
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
    self.navigationItem.rightBarButtonItem = rightItem;
}

@end
