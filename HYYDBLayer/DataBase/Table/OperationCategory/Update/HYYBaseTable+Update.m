//
//  HYYBaseTable+Update.m
//  haoyayi_doctor
//
//  Created by kRadius on 15/11/19.
//  Copyright © 2015年 zhourx5211. All rights reserved.
//

#import "HYYBaseTable+Update.h"

@implementation HYYBaseTable (Update)

//
- (BOOL)updateRow:(HYYRowModel *)model {
    
    //转化成字典并去除空值
    NSDictionary *rowModelDict = [[model toDictionary] filterNullValue];
    NSMutableString *updateSql = [[NSMutableString alloc] initWithFormat:@"UPDATE `%@` SET ",[[self class] tableName]];
    
    //模型和字段的映射关系
    NSDictionary *map = [[model class] map];
    NSString *primaryKey = [[model class] primaryKey];
    
    __block NSInteger idx = 0;
    
    [rowModelDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *mapKey = [map valueForKey:key];
        NSAssert(mapKey.length, @"数据库字段映射有问题,请检查RowModel");
        
        if (++idx < rowModelDict.count) {
            [updateSql appendFormat:@"`%@` = %@,",mapKey,[obj dbValue]];
        } else {
            [updateSql appendFormat:@"`%@` = %@",mapKey,[obj dbValue]];
        }
    }];
    //where
    NSString *primaryDBKey = map[primaryKey];
    NSString *primarkKeyValue = [rowModelDict[primaryKey] dbValue];
    if (!primarkKeyValue) {
        return NO;
    }
    [updateSql appendFormat:@" where (`%@` = %@)",primaryDBKey,primarkKeyValue];
//    DebugLog(@"updateSql = %@",updateSql);
    return [self.manager.database executeUpdate:updateSql];
}

/**
 *  批量修改，需要传入一个主键，其余的是更改的值
 */
- (BOOL)updateRows:(NSArray<HYYRowModel *> *)models {
    BOOL success = YES;
    for (HYYRowModel *rowModel in models) {
        if (![self updateRow:rowModel]) {
            success = NO;
        }
    }
    return success;
}

/**
 *  带条件的修改
 */
- (BOOL)updateRow:(HYYRowModel *)model conditions:(NSArray *)conditions {
    //转化成字典并去除空值
    NSDictionary *rowModelDict = [[model toDictionary] filterNullValue];
    NSMutableString *updateSql = [[NSMutableString alloc] initWithFormat:@"UPDATE `%@` SET ",[[self class] tableName]];
    
    //模型和字段的映射关系
    NSDictionary *map = [[model class] map];
//    NSString *primaryKey = [[model class] primaryKey];
    
    __block NSInteger idx = 0;
    
    [rowModelDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *mapKey = [map valueForKey:key];
        NSAssert(mapKey.length, @"数据库字段映射有问题,请检查RowModel");
        
        if (++idx < rowModelDict.count) {
            [updateSql appendFormat:@"`%@` = %@,",mapKey,[obj dbValue]];
        } else {
            [updateSql appendFormat:@"`%@` = %@",mapKey,[obj dbValue]];
        }
    }];
    //where
    if (conditions) {
        [updateSql appendFormat:@" WHERE "];
        [conditions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx > 0) {
                [updateSql appendString:@"AND "];
            }
            HYYQueryCondition *condition = (HYYQueryCondition *)obj;
            NSString *sqlString = [condition sqlString];
            if (sqlString) {
                [updateSql appendFormat:@"%@ ", sqlString];
            }
        }];
    }

    DebugLog(@"updateSql = %@",updateSql);
    return [self.manager.database executeUpdate:updateSql];

}
@end
