//
//  HYYBaseTable+Query.m
//  haoyayi_doctor
//
//  Created by kRadius on 15/11/19.
//  Copyright © 2015年 zhourx5211. All rights reserved.
//

#import "HYYBaseTable+Query.h"

@implementation HYYBaseTable (Query)

- (NSArray<HYYRowModel *> *)fetchWithParams:(HYYQueryParams *)params {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    FMResultSet *result = [self.manager.database executeQuery:[self sqlWithParams:params]];
    while ([result next]){
        HYYRowModel *rowModel = [[[[self class] modelClass] alloc] init];
        [rowModel setValuesForKeysWithDictionary:[result resultDictionary]];
        [resultArray addObject:rowModel];
    }
    return [resultArray copy];
}

- (NSDictionary *)fetchWithParams:(HYYQueryParams *)params groupBy:(const NSString *)groupByField {
    if (!groupByField) {
        return nil;
    }
    NSMutableDictionary *resultDictionary = [[NSMutableDictionary alloc] init];
    FMResultSet *result = [self.manager.database executeQuery:[self sqlWithParams:params]];
    while ([result next]){
        HYYRowModel *rowModel = [[[[self class] modelClass] alloc] init];
        [rowModel setValuesForKeysWithDictionary:[result resultDictionary]];
        NSString *fieldValue = [result objectForColumnName:[groupByField copy]];
        NSMutableArray *models = resultDictionary[fieldValue];
        if (!models) {
            models = [[NSMutableArray alloc] init];
            resultDictionary[fieldValue] = models;
        }
        [models addObject:rowModel];
    }
    return [resultDictionary copy];
}

- (HYYRowModel *)findWithParams:(HYYQueryParams *)params {
    NSArray *results = [self fetchWithParams:params];
    if (results.count > 0) {
        return results.firstObject;
    }
    return nil;
}

- (id)maxWithField:(NSString *)field {
    if (field.length < 1) {
        return nil;
    }
    NSString *sql = [NSString stringWithFormat:@"SELECT MAX(%@) FROM %@", field, [[self class] tableName]];
    FMResultSet *result = [self.manager.database executeQuery:sql];
    while ([result next]){
        id value = [result objectForColumnIndex:0];
        return value;
    }
    return nil;
}

- (NSString *)sqlWithParams:(HYYQueryParams *)params {
    NSMutableString *sql = [NSMutableString stringWithString:@"SELECT "];
    //distinct
    if (params.distinct) {
        [sql appendString:@"DISTINCT "];
    }
    //fields
    if (params.fields) {
        [params.fields enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == params.fields.count - 1) {
                [sql appendFormat:@"%@ ", obj];
            } else {
                [sql appendFormat:@"%@,", obj];
            }
        }];
    } else {
        [sql appendString:@"* "];
    }
    //from
    [sql appendFormat:@"FROM %@ ", [[self class] tableName]];
    //where
    if (params.conditionArray) {
        [sql appendFormat:@"WHERE "];
        [params.conditionArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx > 0) {
                [sql appendString:@"AND "];
            }
            HYYQueryCondition *condition = (HYYQueryCondition *)obj;
            NSString *sqlString = [condition sqlString];
            if (sqlString) {
                [sql appendFormat:@"%@ ", sqlString];
            }
        }];
    }
    //order by
    if (params.orderByArray) {
        [sql appendString:@"ORDER BY "];
        [params.orderByArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx > 0) {
                [sql appendString:@", "];
            }
            HYYOrderBy *orderBy = (HYYOrderBy *)obj;
            NSString *sqlString = [orderBy sqlString];
            if (sqlString) {
                [sql appendFormat:@"%@ ", sqlString];
            }
        }];
    }
    //limit
    if (params.limit) {
        [sql appendString:@"LIMIT "];
        if (params.limit.limitOffset && params.limit.limitCount) {
            [sql appendFormat:@"%ld,%ld", params.limit.limitOffset.longValue, params.limit.limitCount.longValue];
        }
    }
    return [sql copy];
}

@end
