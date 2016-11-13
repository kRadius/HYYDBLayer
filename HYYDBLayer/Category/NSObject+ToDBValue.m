//
//  NSObject+ToDBValue.m
//  haoyayi_doctor
//
//  Created by kRadius on 15/11/18.
//  Copyright © 2015年 zhourx5211. All rights reserved.
//

#import "NSObject+ToDBValue.h"

@implementation NSObject (ToDBValue)

- (id)dbValue {
    if ([self isKindOfClass:[NSString class]]) {
        // str => 'str'
        return [NSString stringWithFormat:@"\"%@\"",self];
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return @"NULL";
    }
    return self;
}

@end
