//
//  HYYBaseTable+Delete.m
//  haoyayi_doctor
//
//  Created by kRadius on 15/11/19.
//  Copyright © 2015年 zhourx5211. All rights reserved.
//

#import "HYYBaseTable+Delete.h"

@implementation HYYBaseTable (Delete)


- (BOOL)deleteRow:(HYYRowModel *)model {
    
    NSString *primaryKey = [[model class] primaryKey];
    id primarykeyValue = [model valueForKey:primaryKey];
    
    if (!primarykeyValue) {
        DebugLog(@"删除:%@ model 主键的值不正确",NSStringFromClass([model class]));
        return NO;
    }
    
    NSDictionary *rowModelDict = [[model toDictionary] filterNullValue];
    //模型和字段的映射关系
    NSDictionary *map = [[model class] map];
    NSString *primaryDBKey = map[primaryKey];
    
    NSMutableString *deleteSql = [[NSMutableString alloc] initWithFormat:@"DELETE FROM `%@` WHERE `%@` = %@",[[self class] tableName],primaryDBKey,[rowModelDict[primaryKey] dbValue]];
    DebugLog(@"deleteSql = %@",deleteSql);
    
    return [self.manager.database executeUpdate:deleteSql];
}

- (BOOL)deleteAll {
    NSMutableString *deleteSql = [[NSMutableString alloc] initWithFormat:@"DELETE FROM `%@`",[[self class] tableName]];
    return [self.manager.database executeUpdate:deleteSql];
}

- (BOOL)deleteAllWithConditions:(NSArray *)conditions {
    NSMutableString *deleteSql = [[NSMutableString alloc] initWithFormat:@"DELETE FROM `%@`",[[self class] tableName]];
    //whdere
    if (conditions) {
        [deleteSql appendFormat:@" WHERE "];
        [conditions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx > 0) {
                [deleteSql appendString:@"AND "];
            }
            HYYQueryCondition *condition = (HYYQueryCondition *)obj;
            NSString *sqlString = [condition sqlString];
            if (sqlString) {
                [deleteSql appendFormat:@"%@ ", sqlString];
            }
        }];
    }
    DebugLog(@"deleteSql = %@",deleteSql);
    return [self.manager.database executeUpdate:deleteSql];
}

@end
