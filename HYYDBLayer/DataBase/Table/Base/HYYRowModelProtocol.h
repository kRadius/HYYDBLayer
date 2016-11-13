//
//  HYYRowModelProtocol.h
//  haoyayi_doctor
//
//  Created by kRadius on 15/11/17.
//  Copyright © 2015年 zhourx5211. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HYYRowModelProtocol <NSObject>
@required
/**
 *  数据库字段和属性的对应关系
 */
+ (NSDictionary *)map;
/**
 *  数据库主键对应的模型属性
 */
+ (id)primaryKey;
@optional
/**
 *  数据库字段的默认值,默认是null,key为数据库字段名
 */
+ (NSDictionary *)defaultValueMap;

@end
