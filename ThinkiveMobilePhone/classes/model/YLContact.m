//
//  YLContact.m
//  ThinkiveMobilePhone
//
//  Created by kill on 16/1/6.
//  Copyright © 2016年 kill. All rights reserved.
//

#import "YLContact.h"
#import <objc/runtime.h>
#import "MJExtension.h"
@implementation YLContact

//// Insert code here to add functionality to your managed object subclass
//- (void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues
//{
//    unsigned int count;
//    objc_property_t *properties = class_copyPropertyList(self.class,&count);
//    for(int i = 0 ; i < count ;i++)
//    {
//        objc_property_t property = properties[i];
//        NSString *propertyName = [[NSString alloc]initWithUTF8String:property_getName(property)];
//        
//        NSString *propertyAttr = [NSString stringWithUTF8String:property_getAttributes(property)];
//        
//        id value = [keyedValues objectForKey:[propertyName uppercaseString]];
//        NSLog(@"%@",propertyAttr);
//        if(value)
//        {
//            [self setValue:value forKey:propertyName];
//        }
//        
//    }
//}

+ (void)initialize
{
    [super initialize];
    
    [self mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
    
        NSMutableDictionary *keyToKey = [NSMutableDictionary dictionary];
        unsigned int count;
        objc_property_t *properties = class_copyPropertyList(self.class,&count);
        for(int i = 0 ; i < count ;i++)
        {
            objc_property_t property = properties[i];
            NSString *propertyName = [[NSString alloc]initWithUTF8String:property_getName(property)];
            [keyToKey setObject:[propertyName uppercaseString] forKey:propertyName];
        }
        return keyToKey;
    }];
}

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if(property.type.typeClass == [NSDate class])
    {
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd";
        return [fmt dateFromString:oldValue];
    }
    return oldValue;
}



@end
