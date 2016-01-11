//
//  YLContact+CoreDataProperties.h
//  ThinkiveMobilePhone
//
//  Created by kill on 16/1/8.
//  Copyright © 2016年 kill. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "YLContact.h"

NS_ASSUME_NONNULL_BEGIN

@interface YLContact (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *birthday;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *faxnoc;
@property (nullable, nonatomic, retain) NSString *fName;
@property (nullable, nonatomic, retain) NSDate *hireDay;
@property (nullable, nonatomic, retain) NSString *jobName;
@property (nullable, nonatomic, retain) NSString *lName;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *orgName;
@property (nullable, nonatomic, retain) NSString *phonec;
@property (nullable, nonatomic, retain) NSString *pinyinHead;
@property (nullable, nonatomic, retain) NSString *pinyinInitial;
@property (nullable, nonatomic, retain) NSString *pinyinName;
@property (nullable, nonatomic, retain) NSString *qq;
@property (nullable, nonatomic, retain) NSDate *seniorityDay;
@property (nullable, nonatomic, retain) NSNumber *status;
@property (nullable, nonatomic, retain) NSString *salutation;
@property (nullable, nonatomic, retain) NSString *department;

@end

NS_ASSUME_NONNULL_END
