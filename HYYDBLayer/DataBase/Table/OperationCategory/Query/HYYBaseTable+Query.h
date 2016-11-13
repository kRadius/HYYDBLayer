//
//  HYYBaseTable+Query.h
//  haoyayi_doctor
//
//  Created by kRadius on 15/11/19.
//  Copyright © 2015年 zhourx5211. All rights reserved.
//

#import "HYYBaseTable.h"

@interface HYYBaseTable (Query)

- (NSArray<HYYRowModel *> *)fetchWithParams:(HYYQueryParams *)params;
- (NSDictionary *)fetchWithParams:(HYYQueryParams *)params groupBy:(const NSString *)groupByField;
- (HYYRowModel *)findWithParams:(HYYQueryParams *)params;
- (id)maxWithField:(NSString *)field;

@end
