//
//  YLPhoneListController.m
//  ThinkiveMobilePhone
//
//  Created by kill on 15/12/30.
//  Copyright © 2015年 kill. All rights reserved.
//

#import "YLPhoneListController.h"
#import <CoreData/CoreData.h>
#import "YLContact+CoreDataProperties.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "YLPhoneListFilterController.h"
#import "MBProgressHUD.h"
#import "YLContactDetailsController.h"
#import "YLLoginManager.h"
#import "YLLoginController.h"
#define dataBaseFileName @"db.data"
@interface YLPhoneListController ()
@property(nonatomic,strong) UITableView * tableView;

@property(nonatomic,strong) YLPhoneListFilterController * fiterController;


@property(nonatomic,strong) UISearchBar * searchBar;
@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) NSManagedObjectContext *dataContext;
@property(nonatomic,strong) NSMutableDictionary<NSString *,NSMutableArray *> *groupContacts;
@property(nonatomic,strong) NSMutableArray<NSString *>* groupNames;
@property(nonatomic,strong) YLLoginManager* loginManager;
@end

@implementation YLPhoneListController
{
    UIView *shadeView;
}
#pragma mark 初始化部分
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    return self;
    
}

-(YLLoginManager *)loginManager
{
    if(!_loginManager) _loginManager = [YLLoginManager shareManager];
    return _loginManager;
}

-(void)setupSubView
{
    
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    UISearchBar *bar = [[UISearchBar alloc]init];
    bar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    bar.placeholder = @"搜索";
    bar.keyboardType = UIKeyboardTypeASCIICapable;
    bar.delegate = self;
    _searchBar = bar;
    [_topView addSubview:bar];
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    float tableViewX = 0;
    float tableViewY = CGRectGetMaxY(bar.frame);
    float tableViewW = _topView.frame.size.width;
    float tableViewH = _topView.frame.size.height - 48 - tableViewY;
    _tableView.frame = CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_topView addSubview:_tableView];
    
    shadeView = [[UIView alloc] initWithFrame:_topView.bounds];
    shadeView.backgroundColor = [UIColor grayColor];
    shadeView.alpha = 0.5;
    shadeView.hidden = YES;
    [_topView addSubview:shadeView];
    
    _fiterController = [[YLPhoneListFilterController alloc]initWithStyle:UITableViewStylePlain];
    
    float fiterViewX = tableViewX;
    float fiterViewY = tableViewY;
    float fiterViewW = tableViewW;
    float fiterViewH = _topView.frame.size.height - fiterViewY;
    
    _fiterController.view.frame = CGRectMake(fiterViewX, fiterViewY, fiterViewW, fiterViewH);
    _fiterController.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _fiterController.view.hidden =YES;
    [self addChildViewController:_fiterController];
    [_topView addSubview:_fiterController.view];
    
    [_topView bringSubviewToFront:bar];
    [self.view addSubview:_topView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubView];
    [self loadData];
    
}
-(void)initNavigationBar
{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    
}

#pragma mark 搜索bar代理
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    
    [self searchBarBeginEditAnimation];
    return YES;
}

-(void)searchBarBeginEditAnimation
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
    _searchBar.placeholder = @"姓名/拼音/拼音首字母/电话号码..";
    
    [UIView beginAnimations:@"搜索渐变动画" context:nil];
    CGRect f = _topView.frame;
    f.origin.y = 20;
    _topView.frame = f;
    shadeView.hidden = NO;
    _searchBar.showsCancelButton = YES;
    [UIView commitAnimations];
}

-(void)searchBarEndEditAnimation
{
    _searchBar.placeholder = @"搜索";
    [self.view endEditing:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [UIView beginAnimations:@"搜索渐变动画取消" context:nil];
    CGRect f = _topView.frame;
    f.origin.y = 64;
    _topView.frame = f;
    
    shadeView.hidden = YES;
    _searchBar.showsCancelButton = NO;
    
    _fiterController.view.hidden = YES;
    
    [UIView commitAnimations];
    _searchBar.text = @"";
    
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(![searchText isEqualToString:@""])
    {
        _fiterController.view.hidden = NO;
        [_fiterController filterTableViewByFilterText:searchText];
    }
    else
    {
        _fiterController.view.hidden = YES;
    }
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    [self searchBarEndEditAnimation];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
}
#pragma mark 数据库相关

-(void)reload
{
    self.groupNames = nil;
    self.groupContacts = nil;
    [self queryPhoneListClearOldData:YES];
    [_tableView reloadData];
    [self loadData];
}

-(NSManagedObjectContext *)dataContext
{
    
    if(_dataContext) return _dataContext;
    NSString *documentPath = YLDocumentPath;
//    documentPath = @"/Users/yulei/Documents/安装包";
    NSString *dataBaseFileFullPath =[documentPath stringByAppendingPathComponent:dataBaseFileName];
    NSManagedObjectContext *context;
    //打开模型文件，参数为nil则打开包中所有模型文件并合并成一个
    NSManagedObjectModel *model=[NSManagedObjectModel mergedModelFromBundles:nil];
    //创建解析器
    NSPersistentStoreCoordinator *storeCoordinator=[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    //创建数据库保存路径
    NSURL *url=[NSURL fileURLWithPath:dataBaseFileFullPath];
    //添加SQLite持久存储到解析器
    NSError *error;
    [storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if(error){
        NSLog(@"数据库打开失败！错误:%@",error.localizedDescription);
        return nil;
    }else{
        context=[[NSManagedObjectContext alloc]init];
        context.persistentStoreCoordinator=storeCoordinator;
        _dataContext = context;
    }
    return _dataContext;
}




- (void) deleteContacts
{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"YLContact"];
    NSBatchDeleteRequest *deleteRequst = [[NSBatchDeleteRequest alloc]initWithFetchRequest:request];
    NSError *error;
    [[self dataContext] executeRequest:deleteRequst error:&error];
    if(error)
    {
        NSLog(@"删除失败");
    }
    
}


-(NSArray *)queryPhoneListClearOldData:(BOOL)clearFlag
{
    [self loginOrReloginComplete:^(YLLoginManager *manager) {
        self.loginManager.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        NSLog(@"%@",[NSThread currentThread]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"正在获取通讯录数据..";
        });
        
        
        _loginManager.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSString *queryUrl = [NSString stringWithFormat:@"%@/ess/contacts/contacts/findColleaguesGridDatas",baseUrl];
        NSDictionary *param = @{@"page" : @"0",@"start" : @"0",@"limit" : @"9999" , @"sessionuser" : _loginManager.userId};
        [_loginManager.sessionManager POST:queryUrl parameters:param success:
         ^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                 hud.labelText = @"正在解析数据...";
                 hud.mode = MBProgressHUDModeAnnularDeterminate;
                 hud.progress = 0.0f;
             });
             NSArray *contactsDic = responseObject[@"fields"];
             if(clearFlag) [self deleteContacts];
             [self saveContacts:contactsDic];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.tableView reloadData];
             });
         }
        failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
         {
             if(error.code == 3840)
             {
                 [manager autoLoginComplete:^(YLLoginManager *manager, NSString *error) {
                     if(manager.isLogin)
                         [self queryPhoneListClearOldData:clearFlag];
                     else
                     {
                         UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                         [alertView show];
                     }
                     return;
                 }];
             }
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:error.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                 [alertView show];
             });
         }];
    }];
    
    
    return  nil;
}

-(void)saveContacts:(NSArray*)contactsDic
{
    NSLog(@"保存用的队列-%@",[NSThread currentThread]);
    NSManagedObjectContext *context =  self.dataContext;
    NSMutableArray<YLContact*> *contacts = nil;
    contacts = [YLContact mj_objectArrayWithKeyValuesArray:contactsDic context:context];
    
    for (int i = 0;i<contacts.count;i++) {
        YLContact * contact = contacts[i];
        //转成了可变字符串
        NSMutableString *str = [NSMutableString stringWithString:contact.name];
        
        //先转换为带声调的拼音
        CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
        //再转换为不带声调的拼音
        CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
        //转化为大写拼音
        NSString *pinYin = [str capitalizedString];
        contact.pinyinHead = [pinYin substringToIndex:1];
        contact.pinyinName = [pinYin stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSArray *splitStrs = [pinYin componentsSeparatedByString:@" "];
        NSMutableString *first = [NSMutableString string];
        for(NSString * str in splitStrs)
        {
            [first appendString:[str substringToIndex:1]];
        }
        contact.pinyinInitial = first;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
            float progress = (float)i / contacts.count;
            hud.progress = progress;
        });
    }
    NSError *error;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"正在保存数据..";
    });
    
    [context save:&error];
    if(error)
    {
        NSLog(@"保存数据失败!%@",error);
    }
    else
    {
        [self parseGroup:contacts];
        NSLog(@"保存成功.");
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}


-(void) parseGroup:(NSArray<YLContact*> *)contacts
{
    _fiterController.contacts = contacts;
    self.groupContacts = [NSMutableDictionary dictionary];
    self.groupNames = [NSMutableArray array];
    for (YLContact* contact in contacts) {
        NSString *pyHead = contact.pinyinHead;
        NSMutableArray<YLContact*> *groupContacts = [_groupContacts objectForKey:pyHead];
        if(!groupContacts)
        {
            groupContacts = [NSMutableArray array];
            [self.groupNames addObject:pyHead];
        }
        
        [groupContacts addObject:contact];
        [_groupContacts setObject:groupContacts forKey:pyHead];
    }
    self.groupNames = [[self.groupNames sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult result = [obj1 compare:obj2];
        return result;
    }] mutableCopy];
}

-(void)loginOrReloginComplete:(void (^)(YLLoginManager *))callBack
{
    if (self.loginManager.isLogin)
    {
        callBack(self.loginManager);
    }
    else
    {
        [_loginManager autoLoginComplete:^(YLLoginManager *manager, NSString *errorInfo) {
            if(manager.isLogin)
            {
                callBack(self.loginManager);
            }
            else
            {
                YLLoginController *loginCtrl = [[YLLoginController alloc]initWithSuccessBlock:^(YLLoginManager * manager) {
                    callBack(manager);
                }];
                [self presentViewController:loginCtrl animated:YES completion:nil];
            }
        }];
        
    }
}
-(void)loadData
{
    
        NSManagedObjectContext *context = self.dataContext;
        NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"YLContact"];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"pinyinInitial" ascending:YES];
        request.sortDescriptors = @[sort];
        NSInteger count = [context countForFetchRequest:request error:nil];
        
        if(count == 0)
        {
            [self loginOrReloginComplete:^(YLLoginManager *manager) {
                [self queryPhoneListClearOldData:NO];
                self.navigationItem.title = manager.userRealName;
            }];
        }
        else
        {
            
            //读取数据
            NSError *error;
            NSArray *contacts =  [context executeFetchRequest:request error:&error];
            if(error)
            {
                NSLog(@"读取数据失败,原因:%@",error.localizedDescription);
            }
            [self parseGroup:[contacts mutableCopy]];
            [self.tableView reloadData];
        }
}

#pragma mark 数据源相关
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = self.groupNames[section];
    NSMutableArray *cs = [self.groupContacts objectForKey:key];
    return cs.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groupNames.count;
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.groupNames;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.groupNames[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"YLConctaceCell"];
    
    NSString *key = self.groupNames[indexPath.section];
    NSMutableArray *cs = [self.groupContacts objectForKey:key];
    YLContact *contact = cs[indexPath.row];
    
    cell.textLabel.text = contact.name;
    cell.detailTextLabel.text = contact.orgName;
    return cell;
}

#pragma mark TableView代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = _groupNames[indexPath.section];
    NSArray *contacts = [_groupContacts objectForKey:key];
    YLContact *selectContact = contacts[indexPath.row];
    YLContactDetailsController *detailController = [[YLContactDetailsController alloc]initWithContact:selectContact];
    [self.navigationController pushViewController:detailController animated:YES];
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
