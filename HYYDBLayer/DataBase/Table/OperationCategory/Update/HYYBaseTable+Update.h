//
//  HYYBaseTable+Update.h
//  haoyayi_doctor
//
//  Created by kRadius on 15/11/19.
//  Copyright © 2015年 zhourx5211. All rights reserved.
//

#import "HYYBaseTable.h"

@interface HYYBaseTable (Update)
/**
 *  需要传入一个主键，其余的是更改的值
 */
- (BOOL)updateRow:(HYYRowModel *)model;
/**
 *  批量修改，需要传入一个主键，其余的是更改的值
 */
- (BOOL)updateRows:(NSArray<HYYRowModel *> *)models;

/**
 *  带条件的修改
 */
- (BOOL)updateRow:(HYYRowModel *)model conditions:(NSArray *)conditions;

@end
