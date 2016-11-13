//
//  RowExhortModel.m
//  haoyayi_doctor
//
//  Created by kRadius on 15/11/25.
//  Copyright © 2015年 zhourx5211. All rights reserved.
//

#import "RowExhortModel.h"

NSString *const fieldExhortId = @"exhort_id";
NSString *const fieldExhortParentId = @"parent_id";
NSString *const fieldExhortContent = @"content";
NSString *const fieldExhortDentistId = @"dentist_id";
NSString *const fieldExhortType = @"type";
NSString *const fieldExhortIcon = @"icon";
NSString *const fieldExhortAddTime = @"add_time";
NSString *const fieldExhortUpdateTime = @"update_time";

@implementation RowExhortModel


+ (NSDictionary *)map {
    return @{
             @"exhortId":fieldExhortId,
             @"parentId":fieldExhortParentId,
             @"dentistId":fieldExhortDentistId,
             @"type":fieldExhortType,
             @"content":fieldExhortContent,
             @"icon":fieldExhortIcon,
             @"addTime":fieldExhortAddTime,
             @"updateTime":fieldExhortUpdateTime
             };
}

+ (id)primaryKey {
    return @"exhortId";
}

@end
