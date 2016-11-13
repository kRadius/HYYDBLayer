//
//  RowDataVersionModel.m
//  haoyayi_doctor
//
//  Created by zhourx5211 on 11/17/15.
//  Copyright © 2015 zhourx5211. All rights reserved.
//

#import "RowDataVersionModel.h"

NSString *const fieldDataVersionId = @"id";
NSString *const fieldDataName = @"name";
NSString *const fieldDataVersion = @"version";
NSString *const fieldDataVersionName = @"versionName";

@implementation RowDataVersionModel

+ (NSDictionary *)map {
    return @{
             @"dataVersionId":fieldDataVersionId,
             @"name":fieldDataName,
             @"version":fieldDataVersion,
             @"versionName":fieldDataVersionName
             };
}

+ (id)primaryKey {
    return @"dataVersionId";
}

@end
