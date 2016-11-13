//
//  RowDataVersionModel.h
//  haoyayi_doctor
//
//  Created by zhourx5211 on 11/17/15.
//  Copyright © 2015 zhourx5211. All rights reserved.
//

#import "HYYRowModel.h"

extern NSString *const fieldDataVersionId;
extern NSString *const fieldDataName;
extern NSString *const fieldDataVersion;
extern NSString *const fieldDataVersionName;

/**
 * 数据版本
 */
@interface RowDataVersionModel : HYYRowModel

@property (copy, nonatomic) NSNumber *dataVersionId;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSNumber *version;
@property (copy, nonatomic) NSString *versionName;

@end
