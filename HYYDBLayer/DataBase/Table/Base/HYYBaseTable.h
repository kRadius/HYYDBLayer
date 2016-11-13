//
//  HYYBaseTable.h
//  haoyayi_doctor
//
//  Created by kRadius on 15/11/16.
//  Copyright © 2015年 zhourx5211. All rights reserved.
//

#import <Foundation/Foundation.h>
//Model
#import "HYYRowModel.h"
#import "HYYQueryParams.h"
#import "DBManager.h"
//Protocol
#import "HYYBaseTableProtocol.h"
//Category
#import "NSObject+ModelToDict.h"
#import "NSObject+ToDBValue.h"
#import "NSDictionary+Filter.h"

#import "HYYQueryCondition+SQL.h"
#import "HYYOrderBy+SQL.h"

@interface HYYBaseTable : NSObject<HYYBaseTableProtocol>

@property (weak, nonatomic) DBManager *manager;

+ (void)createTable;

@end
