//
//  YLPhoneListFiterController.m
//  ThinkiveMobilePhone
//
//  Created by kill on 16/1/7.
//  Copyright © 2016年 kill. All rights reserved.
//

#import "YLPhoneListFilterController.h"
#import "YLContactDetailsController.h"
@interface YLPhoneListFilterController ()

@property NSMutableArray<YLContact*> *filterContacts;
@property NSString* filterText;
@property UILabel * noResultLabel;
@end

@implementation YLPhoneListFilterController

-(void)viewDidLoad
{
    [super viewDidLoad];
    _noResultLabel = [[UILabel alloc]init];
    _noResultLabel.frame = CGRectMake(0, 200, self.view.frame.size.width, 100);
    _noResultLabel.font = [UIFont systemFontOfSize:44];
    _noResultLabel.textAlignment = NSTextAlignmentCenter;
    _noResultLabel.text = @"无结果";
    _noResultLabel.textColor = [UIColor grayColor];
    _noResultLabel.hidden = YES;
    self.title = @"搜索";
    [self.view addSubview:_noResultLabel];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _filterContacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YLPhoneListFiterCell"];
    YLContact *contact = _filterContacts[indexPath.row];
    
    cell.textLabel.text = contact.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)filterTableViewByFilterText:(NSString *)text
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray *beFilterArray = _contacts;
        if(self.filterText && self.filterText.length < text.length)
        {
            beFilterArray = self.filterContacts;
        }
        
        self.filterContacts = [NSMutableArray array];
        for(YLContact *contact in beFilterArray)
        {
            BOOL filterFlag = NO;
            filterFlag = [contact.name rangeOfString:text].location != NSNotFound  ||
            [contact.pinyinName compare:text options:NSCaseInsensitiveSearch range:NSMakeRange(0, text.length > contact.pinyinName.length ? contact.pinyinName.length : text.length)] == NSOrderedSame ||
            [contact.pinyinInitial compare:text options:NSCaseInsensitiveSearch range:NSMakeRange(0, text.length > contact.pinyinInitial.length ? contact.pinyinInitial.length : text.length)] == NSOrderedSame||
            [contact.phonec rangeOfString:text].location != NSNotFound ||
            [contact.faxnoc rangeOfString:text].location != NSNotFound;
            if(filterFlag) [self.filterContacts addObject:contact];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
             [self.tableView reloadData];
            _noResultLabel.hidden = _filterContacts.count ? YES : NO;
        });
    });
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view.superview endEditing:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YLContact *selectContact = _filterContacts[indexPath.row];
    YLContactDetailsController *detailController = [[YLContactDetailsController alloc]initWithContact:selectContact];
    [self.navigationController pushViewController:detailController animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
