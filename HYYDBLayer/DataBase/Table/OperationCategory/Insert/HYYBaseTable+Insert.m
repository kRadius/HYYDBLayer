//
//  HYYBaseTable+Insert.m
//  haoyayi_doctor
//
//  Created by kRadius on 15/11/19.
//  Copyright © 2015年 zhourx5211. All rights reserved.
//

#import "HYYBaseTable+Insert.h"
#import "NSArray+Utility.h"

@implementation HYYBaseTable (Insert)

//insert
- (BOOL)insertRow:(HYYRowModel *)model {
//    //转化成字典并去除空值
//    NSDictionary *rowModelDict = [[model toDictionary] filterNullValue];
//    
//    //模型和字段的映射关系
//    NSDictionary *map = [[model class] map];
//    
//    NSMutableString *insertString = [[NSMutableString alloc] initWithFormat:@"INSERT INTO `%@` (",[self tableName]];
//    NSMutableString *valueStrig = [[NSMutableString alloc] initWithFormat:@"VALUES ("];
//    
//    __block NSInteger idx = 0;
//    [rowModelDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//        NSString *mapKey = [map valueForKey:key];
//        NSAssert(mapKey.length, @"数据库字段映射有问题,请检查RowModel");
//        
//        if (++idx < rowModelDict.count) {
//            //取出映射关系
//            [insertString appendFormat:@"`%@`,",[map valueForKey:key]];
//            [valueStrig appendFormat:@"%@,",[obj dbValue]];
//        } else {
//            [insertString appendFormat:@"`%@`)",[map valueForKey:key]];
//            [valueStrig appendFormat:@"%@)",[obj dbValue]];
//        }
//    }];
//    NSString *wholeSql = [NSString stringWithFormat:@"%@ %@;",insertString,valueStrig];
    if (!model) {
        return NO;
    }
    return [self insertRows:@[model]];
}

- (BOOL)insertRows:(NSArray<HYYRowModel *> *)models {
    BOOL success = YES;
    NSArray *modelsArray = [models splitArrayByCount:300];
    for (NSArray<HYYRowModel *> *tmpModels in modelsArray) {
        NSString *wholeSql = [self insertSqlStringFromRows:tmpModels];
//        DebugLog(@"insertSql = %@",wholeSql);
        if (![self.manager.database executeUpdate:wholeSql]) {
            success = NO;
        }
    }
    return success;
}

- (NSMutableString *)insertSqlStringFromRows:(NSArray<HYYRowModel *> *)models {
    if (!models.count) {
        return nil;
    }
    Class modelClass = [models.firstObject class];
    //模型和字段的映射关系
    NSMutableDictionary *map = [[modelClass map] mutableCopy];
    
    //判断是否插入主键
    HYYRowModel *model = models.firstObject;
    NSDictionary *rowModelDict = [model toDictionary];
    id primaryKey = rowModelDict[[modelClass primaryKey]];
    if (!primaryKey || [primaryKey isKindOfClass:[NSNull class]]) {
        [map removeObjectForKey:[modelClass primaryKey]];
    }
    
    NSDictionary * defaultValueMap = nil;
    if ([modelClass respondsToSelector:@selector(defaultValueMap)]) {
        defaultValueMap = [modelClass defaultValueMap];
    }

    NSMutableString *insertString = [[NSMutableString alloc] initWithFormat:@"INSERT INTO `%@` (",[[self class] tableName]];
    for (int i = 0; i < map.count; i++) {
        NSString *propertyName = map.allKeys[i];
        NSString *fieldName = map[propertyName];
        if (i == map.count - 1) {
            [insertString appendFormat:@"`%@`)",fieldName];
        } else {
            [insertString appendFormat:@"`%@`,",fieldName];
        }
    };
    [insertString appendString:@" VALUES "];
    for (int i = 0; i < models.count; i++) {
        HYYRowModel *model = models[i];
        [insertString appendString:@"("];
        NSDictionary *rowModelDict = [model toDictionary];
        for (int j = 0; j < map.count; j++) {
            NSString *propertyName = map.allKeys[j];
            NSString *fieldName = map[propertyName];
            id value = rowModelDict[propertyName];
            if ([value isKindOfClass:[NSNull class]]) {
                id defaultValue = defaultValueMap[fieldName];
                if (!defaultValue) {
                    defaultValue = [NSNull null];
                }
                value = [defaultValue dbValue];
            } else {
                value = [value dbValue];
            }
            if (j == map.count - 1) {
                [insertString appendFormat:@"%@", value];
            } else {
                [insertString appendFormat:@"%@,", value];
            }
        };
        if (i == models.count - 1) {
            [insertString appendString:@");"];
        } else {
            [insertString appendString:@"),"];
        }
    };
    return insertString;
}

@end
