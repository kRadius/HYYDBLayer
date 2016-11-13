//
//  NSObject+ModelToDict.h
//
//  Copyright (c) 2014年 Xinfa Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ModelToDict)
/**
 *  获得当前对象的所有成员变量（包括了值）列表，以字典返回
 *
 *  @return dictionary
 */
- (NSDictionary *)toDictionary;

/**
 *  获取一个对象的所有属性
 *
 *  @param isWrite 如果isWrite为YES，返回的字典中同时包含了属性值，否则属性值为空
 *
 *  @return dictionary
 */
- (NSDictionary *)propertyList:(BOOL)isWrite;

/**
 *  获取一个对象的所有属性
 *
 *  @param isWrite 同上
 *  @param depth 深度，表示追溯到父类的层级
 *
 *  @return dictionary
 */
- (NSDictionary *)propertyList:(BOOL)isWrite depth:(NSInteger)depth;

@end
