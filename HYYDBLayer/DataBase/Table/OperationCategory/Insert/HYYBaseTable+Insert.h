//
//  HYYBaseTable+Insert.h
//  haoyayi_doctor
//
//  Created by kRadius on 15/11/19.
//  Copyright © 2015年 zhourx5211. All rights reserved.
//

#import "HYYBaseTable.h"

@interface HYYBaseTable (Insert) <HYYBaseTableProtocol>

- (BOOL)insertRow:(HYYRowModel *)model;
- (BOOL)insertRows:(NSArray<HYYRowModel *> *)models;

@end
