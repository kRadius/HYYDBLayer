//
//  HYYBaseTable.m
//  haoyayi_doctor
//
//  Created by kRadius on 15/11/16.
//  Copyright © 2015年 zhourx5211. All rights reserved.
//

#import "HYYBaseTable.h"

@implementation HYYBaseTable

#pragma mark - LifeCycle

- (instancetype)init {
    self = [super init];

    if (self && [self conformsToProtocol:@protocol(HYYBaseTableProtocol)]) {
//        [[DBManager sharedInstance] inDatabaseQueue:^{
//            [self createTable];
//        }];
    } else {
        NSException *exception = [NSException exceptionWithName:@"HYYBaseTable init error" reason:@"the child class must conforms to protocol: <HYYBaseTableProtocol>" userInfo:nil];
        @throw exception;
    }
    
    return self;
}

- (DBManager *)manager {
    if (!_manager) {
        return [DBManager sharedInstance];
    }
    return _manager;
}

#pragma mark - Protocol
//表名
+ (NSString *)tableName {
    DebugLog(@"子类重写表名");
    return nil;
}
//定义表结构
+ (NSDictionary *)columnInfo {
    DebugLog(@"子类重写表结构");
    return nil;
}
//操作的model类
+ (Class)modelClass {
    DebugLog(@"子类重写RowModel类");
    return nil;
}
#pragma mark - Private
//按照<HYYBaseTableProtocol>协议创建table
+ (void)createTable {
    NSString *tableName = [self tableName];
    NSAssert(tableName, @"子类必须重写表名");
    NSDictionary *columnInfo = [self columnInfo];
    NSAssert(columnInfo, @"子类必须重写表结构");
    
    NSMutableString *sqlString = [[NSMutableString alloc] initWithFormat:@"CREATE TABLE IF NOT EXISTS `%@` (",tableName];
    __block NSInteger idx = 0;
    [columnInfo enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (++idx != columnInfo.count) {
            [sqlString appendFormat:@"%@ %@,",key,obj];
        } else {
            [sqlString appendFormat:@"%@ %@)",key,obj];
        }
    }];
    DebugLog(@"sqlString = %@",sqlString);
    
    [[DBManager sharedInstance].database executeUpdate:sqlString];
}


@end
