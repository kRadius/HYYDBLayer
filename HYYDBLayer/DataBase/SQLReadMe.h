//
//  SQLReadMe.h
//  haoyayi_doctor
//
//  Created by kRadius on 15/11/19.
//  Copyright © 2015年 zhourx5211. All rights reserved.
//
//

//事务
//- (void)testTransaction {
//    TableDentistTitle *dentistTitleTable = [[TableDentistTitle alloc] init];
//    RowDentistTitleModel *insert1 = [[RowDentistTitleModel alloc] init];
//    insert1.titleID = @10137;
//    insert1.titleName = @"变形金刚2";
//    RowDentistTitleModel *insert2 = [[RowDentistTitleModel alloc] init];
//    insert2.titleID = @10139;
//    insert2.titleName = @"变形金刚2";
//    
//    
//    [[DBManager sharedInstance] inTransaction:^(BOOL *rollback) {
//        
//        [dentistTitleTable insertRow:insert1];
//        [dentistTitleTable insertRow:insert2];
//        
//    }];
//}
// 插入、删除、修改
//- (void)testDataBase {
//    TableDentistTitle *dentistTitle = [[TableDentistTitle alloc] init];
//    
//    RowDentistTitleModel *insert = [[RowDentistTitleModel alloc] init];
//    insert.titleID = @10136;
//    insert.titleName = @"变形金刚2";
//    
//    if ([dentistTitle insertRow:insert]) {
//        NSLog(@"插入成功");
//    } else {
//        NSLog(@"插入失败");
//    }
//    RowDentistTitleModel *update = [[RowDentistTitleModel alloc] init];
//    update.titleID = @10136;
//    update.titleName = @"变形金刚4";
//    
//    if ([dentistTitle updateRow:update]) {
//        NSLog(@"修改成功");
//    } else {
//        NSLog(@"修改失败");
//    }
//    RowDentistTitleModel *delete = [[RowDentistTitleModel alloc] init];
//    delete.titleID = @10135;
//    if ([dentistTitle deleteRow:delete]) {
//        NSLog(@"删除成功");
//    } else {
//        NSLog(@"删除失败");
//    }
//}
// 查询
//
//- (void)testQuery {
//    TableDentistTitle *dentistTitle = [[TableDentistTitle alloc] init];
//    HYYQueryParams *params = [[HYYQueryParams alloc] init];
//    params.fields = @[fieldTitleID, fieldTitleName];
//    [params addCondition:[HYYQueryCondition conditionWithField:fieldTitleID equalValue:@10136]];
//    //    RowDentistTitleModel *titleModel = (RowDentistTitleModel *)[dentistTitle findWithParams:params];
//    //    NSLog(@"%@", titleModel.titleID);
//    //    NSLog(@"%@", titleModel.titleName);
//    NSDictionary *groupByResult = [dentistTitle fetchWithParams:params groupBy:fieldTitleID];
//    NSLog(@"%@", groupByResult);
//}
//
//条件update
//- (void)testConditionUpdate {
//TableDentistTitle *table = [[TableDentistTitle alloc] init];
//
//RowDentistTitleModel *rowModel = [[RowDentistTitleModel alloc] init];
//rowModel.titleName = @"擎天柱";
//
//HYYQueryCondition *condition1 = [HYYQueryCondition conditionWithField:fieldTitleName equalValue:@"主任医师"];
//
//[table updateRow:rowModel conditions:@[condition1]];
//}
