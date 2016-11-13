//
//  HYYBaseTable+Delete.h
//  haoyayi_doctor
//
//  Created by kRadius on 15/11/19.
//  Copyright © 2015年 zhourx5211. All rights reserved.
//

#import "HYYBaseTable.h"

@interface HYYBaseTable (Delete)

- (BOOL)deleteRow:(HYYRowModel *)model;

- (BOOL)deleteAll;
- (BOOL)deleteAllWithConditions:(NSArray *)condition;

@end
