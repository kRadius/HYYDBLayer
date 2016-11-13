//
//  HYYQueryParams.m
//  haoyayi_doctor
//
//  Created by zhourx5211 on 11/17/15.
//  Copyright © 2015 zhourx5211. All rights reserved.
//

#import "HYYQueryParams.h"

@implementation HYYQueryParams

- (void)addCondition:(HYYQueryCondition *)condition {
    NSMutableArray *conditions = [self.conditionArray mutableCopy];
    if (!conditions) {
        conditions = [[NSMutableArray alloc] init];
    }
    if (condition) {
        [conditions addObject:condition];
    }
    self.conditionArray = [conditions copy];
}

- (void)setOrderBy:(HYYOrderBy *)orderBy {
    NSMutableArray *orderByArray = [self.orderByArray mutableCopy];
    if (!orderByArray) {
        orderByArray = [[NSMutableArray alloc] init];
    }
    if (orderBy) {
        [orderByArray addObject:orderBy];
    }
    self.orderByArray = [orderByArray copy];
}

@end
