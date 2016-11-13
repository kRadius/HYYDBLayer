//
//  HYYQueryParams.h
//  haoyayi_doctor
//
//  Created by zhourx5211 on 11/17/15.
//  Copyright © 2015 zhourx5211. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYYQueryCondition.h"
#import "HYYOrderBy.h"
#import "HYYLimit.h"

@interface HYYQueryParams : NSObject

@property (assign, nonatomic) BOOL distinct;
@property (strong, nonatomic) NSArray *fields;
@property (strong, nonatomic) NSArray *conditionArray;
@property (strong, nonatomic) NSArray *orderByArray;
@property (strong, nonatomic) HYYLimit *limit;

- (void)addCondition:(HYYQueryCondition *)condition;
- (void)setOrderBy:(HYYOrderBy *)orderBy;

@end
