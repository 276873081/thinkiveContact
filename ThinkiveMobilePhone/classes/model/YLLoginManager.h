//
//  YLLoginManager.h
//  ThinkiveMobilePhone
//
//  Created by kill on 16/1/9.
//  Copyright © 2016年 kill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface YLLoginManager : NSObject

@property(nonatomic,assign,readonly,getter=isLogin) BOOL login;
@property(nonatomic,strong) AFHTTPSessionManager *sessionManager;
@property(nonatomic,strong) NSString *userRealName;
@property(nonatomic,strong) NSString * userId;

-(void)loginByUserName:(NSString *)userName Password:(NSString*)password complete:(void(^)(YLLoginManager* manager,NSString* errorInfo))callBack;
+(instancetype)shareManager;
-(void)autoLoginComplete:(void (^)(YLLoginManager *, NSString *))callBack;
@end
