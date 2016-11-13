//
//  HYYBaseTableProtocol.h
//  haoyayi_doctor
//
//  Created by kRadius on 15/11/16.
//  Copyright © 2015年 zhourx5211. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HYYBaseTableProtocol <NSObject>

@required
//数据库表名
+ (NSString *)tableName;
//定义表结构
+ (NSDictionary *)columnInfo;
//操作的model类
+ (Class)modelClass;

@end
