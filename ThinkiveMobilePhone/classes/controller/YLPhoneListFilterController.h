//
//  YLPhoneListFiterController.h
//  ThinkiveMobilePhone
//
//  Created by kill on 16/1/7.
//  Copyright © 2016年 kill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLContact.h"
@interface YLPhoneListFilterController : UITableViewController

@property(nonatomic,strong) NSArray<YLContact *> * contacts;


-(void)filterTableViewByFilterText:(NSString *)text;

@end
