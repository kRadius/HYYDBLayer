//
//  TableExhort.h
//  haoyayi_doctor
//
//  Created by kRadius on 15/11/25.
//  Copyright © 2015年 zhourx5211. All rights reserved.
//

#import "HYYBaseTable.h"
#import "RowExhortModel.h"
@interface TableExhort : HYYBaseTable

//获取一级系统医嘱
- (NSArray *)fetchSystemLevel1Exhort;
//获取二级系统医嘱
- (NSArray *)fetchSystemLevel2ExhortWithParentId:(NSNumber *)parentId;
//获取自定义医嘱
- (NSArray *)fetchCustomExhortWithDentistId:(NSNumber *)dentistId;
//删除医嘱
- (void)deleteCustomExhortWithId:(NSNumber *)Id;
//更新自定义医嘱
- (void)updateCustomExhortWithId:(NSNumber *)Id content:(NSString *)content modTime:(NSString *)modTime;
//添加自定义医嘱
- (void)addCustomExhortWithExhort:(NSDictionary *)exhort;
@end
