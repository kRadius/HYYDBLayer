//
//  HYYRowModel.m
//  haoyayi_doctor
//
//  Created by kRadius on 15/11/16.
//  Copyright © 2015年 zhourx5211. All rights reserved.
//

#import "HYYRowModel.h"

@implementation HYYRowModel

- (instancetype)init {
    self = [super init];
    if (self) {
//        NSAssert([self map], @"子类需要定义字段映射关系");
//        NSAssert([self primaryKey], @"子类需要定义主键");
    }
    return self;
}

+ (NSDictionary *)map {
    DebugLog(@"子类需要定义字段映射关系");
    return nil;
}

+ (id)primaryKey {
    DebugLog(@"子类需要定义主键");
    return nil;
}

- (void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues {
    NSDictionary *map = [[self class] map];
    NSMutableDictionary *newKeydValues = [[NSMutableDictionary alloc] init];
    [map enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            id value = keyedValues[obj];
            if (value && ![value isKindOfClass:[NSNull class]]) {
                newKeydValues[key] = value;
            }
        }
    }];
    [super setValuesForKeysWithDictionary:newKeydValues];
}

@end
