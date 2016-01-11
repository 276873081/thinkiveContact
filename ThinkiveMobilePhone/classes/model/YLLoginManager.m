//
//  YLLoginManager.m
//  ThinkiveMobilePhone
//
//  Created by kill on 16/1/9.
//  Copyright © 2016年 kill. All rights reserved.
//

#import "YLLoginManager.h"
static YLLoginManager* loginManager;
@interface YLLoginManager()

@end

@implementation YLLoginManager

+(instancetype)shareManager
{
    if(!loginManager) loginManager = [[YLLoginManager alloc]init];
    return loginManager;
}
-(void)autoLoginComplete:(void (^)(YLLoginManager *, NSString *))callBack

{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [defaults objectForKey:@"userName"];
    NSString *password = [defaults objectForKey:@"password"];
    
    if(userName && password)
    {
        [self loginByUserName:userName Password:password complete:callBack];
    }
    else
    {
        callBack(self,@"未保存账号密码.");
    }
}

-(void)loginByUserName:(NSString *)userName Password:(NSString *)password complete:(void (^)(YLLoginManager *, NSString *))callBack
{
    if (!_sessionManager) _sessionManager = [AFHTTPSessionManager manager];
    
    _sessionManager.completionQueue = dispatch_queue_create("networkQueue", NULL);
    _sessionManager.responseSerializer = [[AFHTTPResponseSerializer alloc]init];
    _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@/ess/framework/login/doLogin?forceSingle=true&issub=false&userid=%@&userpwd=%@",baseUrl,userName,password];
    [_sessionManager POST:requestUrl parameters:nil success:
     ^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         NSString * htmlStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary *userInfo = [self parseUserInfo:htmlStr];
         self.userRealName = [userInfo objectForKey:@"userName"];
         if(!self.userRealName)
         {
             NSString *errorInfo = [userInfo objectForKey:@"errorInfo"];
             dispatch_async(dispatch_get_main_queue(), ^{
                 callBack(self,errorInfo);
             });
            return;
         }
          NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
         [defaults setObject:userName forKey:@"userName"];
         [defaults setObject:password forKey:@"password"];
         [defaults synchronize];
         _login = YES;
         self.userId = [userInfo objectForKey:@"userId"];
         dispatch_async(dispatch_get_main_queue(), ^{
             callBack(self,nil);
         });
        
     }
    failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             callBack(self,error.localizedDescription);
         });
     }];
}

-(NSDictionary *)parseUserInfo:(NSString *)html
{
    NSRange range = [html rangeOfString:@"userInfo.userName = '.+'" options:NSRegularExpressionSearch];
    
    if(range.location == NSNotFound)
    {
        NSRange errorInfoRange = [html rangeOfString:@"<span style=\"color:red;font-size:13px;\">\\s+.+" options:NSRegularExpressionSearch];
        NSString *errorInfo = [html substringWithRange:errorInfoRange];
        errorInfoRange = [errorInfo rangeOfString:@"\\S+$" options:NSRegularExpressionSearch];
        errorInfo = [errorInfo substringWithRange:errorInfoRange];
        return @{@"errorInfo":errorInfo};
    }
    
    
    NSString *userName = [html substringWithRange:range];
    range = [userName rangeOfString:@"'"];
    userName = [userName substringFromIndex:range.location];
    userName = [userName stringByReplacingOccurrencesOfString:@"'" withString:@""];
    
    NSRange idRange = [html rangeOfString:@"userInfo.userId = '.+'" options:NSRegularExpressionSearch];
    NSString *userId = [html substringWithRange:idRange];
    range = [userId rangeOfString:@"'"];
    userId = [userId substringFromIndex:range.location];
    userId = [userId stringByReplacingOccurrencesOfString:@"'" withString:@""];
    
    return @{@"userName":userName,@"userId":userId};
}


@end
