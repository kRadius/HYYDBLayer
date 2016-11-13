//
//  TableExhort.m
//  haoyayi_doctor
//
//  Created by kRadius on 15/11/25.
//  Copyright © 2015年 zhourx5211. All rights reserved.
//

#import "TableExhort.h"
#import "HYYBaseTable+Query.h"
#import "HYYBaseTable+Delete.h"
#import "HYYBaseTable+Update.h"
#import "HYYBaseTable+Insert.h"

@implementation TableExhort

//数据库表名
+ (NSString *)tableName {
    return @"exhort";
}
//定义表结构
+ (NSDictionary *)columnInfo {
    return @{
             fieldExhortId:@"INTEGER PRIMARY KEY",
             fieldExhortParentId:@"INTEGER",
             fieldExhortContent:@"VARCHAR(2000) NOT NULL",
             fieldExhortDentistId:@"INTEGER",
             fieldExhortIcon:@"VARCHAR(1000)",
             fieldExhortType:@"INTEGER",
             fieldExhortAddTime:@"TIMESTAMP",
             fieldExhortUpdateTime:@"TIMESTAMP"
             };
}
//关联的RowModel类
+ (Class)modelClass {
    return [RowExhortModel class];
}
#pragma mark - Public 

//获取一级系统医嘱
- (NSArray *)fetchSystemLevel1Exhort {
    HYYQueryParams *param = [[HYYQueryParams alloc] init];
    [param setOrderBy:ORDERBY(fieldExhortId, ASC)];
    [param addCondition:[HYYQueryCondition conditionWithField:fieldExhortDentistId equalValue:@0]];
    [param addCondition:[HYYQueryCondition conditionWithField:fieldExhortParentId equalValue:@0]];
    NSArray *tempResult = [self fetchWithParams:param];
    
    //转化成需要的字典数组
    NSMutableArray *exhortResult = [[NSMutableArray alloc] init];
    [tempResult enumerateObjectsUsingBlock:^(RowExhortModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *dictM = [[NSMutableDictionary alloc] init];
        [dictM setObject:obj.exhortId forKey:@"id"];
        [dictM setObject:obj.content forKey:@"content"];
        [dictM setObject:obj.addTime forKey:@"addTime"];
        [exhortResult addObject:dictM];
    }];
    
    return exhortResult;
}
//获取二级系统医嘱
- (NSArray *)fetchSystemLevel2ExhortWithParentId:(NSNumber *)parentId {
    HYYQueryParams *param = [[HYYQueryParams alloc] init];
    [param setOrderBy:ORDERBY(fieldExhortId, ASC)];
    [param addCondition:[HYYQueryCondition conditionWithField:fieldExhortDentistId equalValue:@0]];
    [param addCondition:[HYYQueryCondition conditionWithField:fieldExhortParentId equalValue:parentId]];
    NSArray *tempResult = [self fetchWithParams:param];
    
    //转化成需要的字典数组
    NSMutableArray *exhortResult = [[NSMutableArray alloc] init];
    [tempResult enumerateObjectsUsingBlock:^(RowExhortModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *dictM = [[NSMutableDictionary alloc] init];
        [dictM setObject:obj.exhortId forKey:@"id"];
        [dictM setObject:obj.content forKey:@"content"];
        [dictM setObject:obj.addTime forKey:@"addTime"];
        [exhortResult addObject:dictM];
    }];
    
    return exhortResult;
}

//获取自定义医嘱
- (NSArray *)fetchCustomExhortWithDentistId:(NSNumber *)dentistId {
    HYYQueryParams *param = [[HYYQueryParams alloc] init];
    [param setOrderBy:ORDERBY(fieldExhortId, ASC)];
    [param addCondition:[HYYQueryCondition conditionWithField:fieldExhortDentistId equalValue:dentistId]];
    
    NSArray *tempResult = [self fetchWithParams:param];
    
    //转化成需要的字典数组
    NSMutableArray *exhortResult = [[NSMutableArray alloc] init];
    [tempResult enumerateObjectsUsingBlock:^(RowExhortModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *dictM = [[NSMutableDictionary alloc] init];
        [dictM setObject:obj.exhortId forKey:@"id"];
        [dictM setObject:obj.content forKey:@"content"];
        [dictM setObject:obj.addTime forKey:@"addTime"];
        [exhortResult addObject:dictM];
    }];
    
    return exhortResult;
}
//删除医嘱
- (void)deleteCustomExhortWithId:(NSNumber *)Id {
    RowExhortModel *model = [[RowExhortModel alloc] init];
    model.exhortId = Id;
    if ([self deleteRow:model]) {
        DebugLog(@"刪除成功");
    } else {
        DebugLog(@"刪除失敗");
    }
}
//更新自定义医嘱
- (void)updateCustomExhortWithId:(NSNumber *)Id content:(NSString *)content modTime:(NSString *)modTime{
    RowExhortModel *model = [[RowExhortModel alloc] init];
    model.exhortId = Id;
    model.content = content;
    model.updateTime = modTime;
    if ([self updateRow:model]) {
        DebugLog(@"更新成功");
    } else {
        DebugLog(@"更新失败");
    }
}
//添加自定义医嘱
- (void)addCustomExhortWithExhort:(NSDictionary *)exhort {
    RowExhortModel *model = [[RowExhortModel alloc] init];
    model.parentId = exhort[@"parentId"];
    model.dentistId = exhort[@"dentistId"];
    model.content = exhort[@"content"];
    model.exhortId = exhort[@"id"];
    model.type = @1;
    model.addTime = exhort[@"addTime"];
    model.updateTime = exhort[@"modTime"];
    if ([self insertRow:model]) {
        DebugLog(@"插入自定义医嘱成功");
    } else {
        DebugLog(@"插入自定义医嘱失败");
    }
}
@end
