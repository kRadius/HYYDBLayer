//
//  RowExhortModel.h
//  haoyayi_doctor
//
//  Created by kRadius on 15/11/25.
//  Copyright © 2015年 zhourx5211. All rights reserved.
//

#import "HYYRowModel.h"

extern NSString *const fieldExhortId;
extern NSString *const fieldExhortParentId;
extern NSString *const fieldExhortContent;
extern NSString *const fieldExhortDentistId;
extern NSString *const fieldExhortType;
extern NSString *const fieldExhortIcon;
extern NSString *const fieldExhortAddTime;
extern NSString *const fieldExhortUpdateTime;

@interface RowExhortModel : HYYRowModel

@property (strong, nonatomic) NSNumber *exhortId;
@property (strong, nonatomic) NSNumber *parentId;
@property (strong, nonatomic) NSNumber *dentistId;
//医嘱类型 0-系统，不可更改；1-自定义，可修改
@property (strong, nonatomic) NSNumber *type;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSString *addTime;
@property (strong, nonatomic) NSString *updateTime;

@end
