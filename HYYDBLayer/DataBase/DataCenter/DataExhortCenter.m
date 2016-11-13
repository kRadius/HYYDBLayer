//
//  DataExhortCenter.m
//  haoyayi_doctor
//
//  Created by kRadius on 15/11/25.
//  Copyright © 2015年 zhourx5211. All rights reserved.
//

#import "DataExhortCenter.h"
#import "DataDictCenter.h"
//Facade
#import "ExhortFacade.h"
//Category
#import "HYYBaseTable+Query.h"
#import "HYYBaseTable+Insert.h"
#import "HYYBaseTable+Delete.h"
#import "HYYBaseTable+Update.h"
//Table
#import "TableExhort.h"
#import "TableDataVersion.h"

//医嘱
static NSString *DataVersionDentistExhort = @"DentistExhort";

@implementation DataExhortCenter

#pragma mark - 同步

//版本控制
+ (void)updateExhortWithVersion:(NSString *)versionName {
    [ExhortFacade fetchAllSystemExhortSuccess:^(NSArray *success) {
        
        [self saveAllSystemExhorts:success versionName:versionName];
        
    } failure:^(NSError *error) {
        DebugLog(@"同步：获取系统医嘱失败.%@",error.localizedDescription);
    }];
}

+ (void)saveAllSystemExhorts:(NSArray *)systemExhorts versionName:(NSString *)versionName{
    TableExhort *table = [[TableExhort alloc] init];
    HYYQueryCondition *condtion = [HYYQueryCondition conditionWithField:fieldExhortType equalValue:@0];
    
    NSMutableArray *allExhorts = [[NSMutableArray alloc] init];
    [systemExhorts enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RowExhortModel *model = [[RowExhortModel alloc] init];
        model.exhortId = obj[@"id"];
        model.parentId = obj[@"parentId"];
        model.dentistId = @0;
        model.content = obj[@"content"];
        model.addTime = obj[@"addTime"];
        model.updateTime = obj[@"modTime"];
        model.type = @0;
        [allExhorts addObject:model];
    }];
    
    [[DBManager sharedInstance] inTransaction:^(BOOL *rollback) {
        if ([table deleteAllWithConditions:@[condtion]]) {
            
            if ([table insertRows:allExhorts]) {
                DebugLog(@"同步系统医嘱成功");
                //更新版本
                [DataDictCenter setDataVersionWithName:DataVersionDentistExhort versionName:versionName];
            } else {
                *rollback = YES;
                DebugLog(@"同步系统医嘱过程中失败:Rollback");
            }
                
        } else {
            *rollback = YES;
            DebugLog(@"删除旧系统医嘱失败");
        }
    }];
    
}

//最新一次的addtime
+ (void)lastestAddCustomExhortTimeWithDentistId:(NSNumber *)dentsitId success:(void(^)(NSString *addTime))success{
    
    TableExhort *table = [[TableExhort alloc] init];
    HYYQueryParams *param = [[HYYQueryParams alloc] init];
    HYYQueryCondition *condtion = [HYYQueryCondition conditionWithField:fieldExhortDentistId equalValue:dentsitId];
    [param setConditionArray:@[condtion]];
    [param setOrderBy:ORDERBY(fieldExhortAddTime, ASC)];
    [param setLimit:LIMIT(@0,@1)];
    
    __block RowExhortModel *model = nil;
    [[DBManager sharedInstance] inDatabaseQueue:^{
        model = (RowExhortModel *)[table findWithParams:param];
    } completion:^{
        success(model.addTime);
    }];
}

//最新一次的updateTime
+ (void)lastestUpdateCustomExhortTimeWithDentistId:(NSNumber *)dentsitId success:(void(^)(NSString *updateTime))success{
    TableExhort *table = [[TableExhort alloc] init];
    HYYQueryParams *param = [[HYYQueryParams alloc] init];
    HYYQueryCondition *condtion = [HYYQueryCondition conditionWithField:fieldExhortDentistId equalValue:dentsitId];
    [param setConditionArray:@[condtion]];
    [param setOrderBy:ORDERBY(fieldExhortUpdateTime, ASC)];
    [param setLimit:LIMIT(@0,@1)];
    
    __block RowExhortModel *model = nil;
    [[DBManager sharedInstance] inDatabaseQueue:^{
        model = (RowExhortModel *)[table findWithParams:param];
    } completion:^{
        success(model.updateTime);
    }];
}

//所有自定义医嘱
+ (void)synAllCustomExhort:(NSArray *)exhorts {
    TableExhort *table = [[TableExhort alloc] init];
    NSMutableArray *rows = [[NSMutableArray alloc] init];
    [exhorts enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RowExhortModel *model = [[RowExhortModel alloc] init];
        model.exhortId = obj[@"id"];
        model.parentId = @0;
        model.dentistId = obj[@"dentistId"];
        model.addTime = obj[@"addTime"];
        model.content = obj[@"content"];
        model.updateTime = obj[@"modTime"];
        model.type = @1;
        [rows addObject:model];
    }];
    
    [[DBManager sharedInstance] inTransaction:^(BOOL *rollback) {
        
        if ([table insertRows:rows]) {
            DebugLog(@"synAllCustomExhort success");
        } else {
            DebugLog(@"synAllCustomExhort failured:Rollback");
            *rollback = YES;
        }
    }];
    
}
//部分
+ (void)synUpdatedCustomExhort:(NSArray *)exhorts {
    TableExhort *table = [[TableExhort alloc] init];
    NSMutableArray *rows = [[NSMutableArray alloc] init];
    [exhorts enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RowExhortModel *model = [[RowExhortModel alloc] init];
        model.exhortId = obj[@"id"];
        model.parentId = @0;
        model.dentistId = obj[@"dentistId"];
//        model.addTime = obj[@"addTime"];
        model.updateTime = obj[@"modTime"];
        model.type = @1;
        [rows addObject:model];
    }];
    
    [[DBManager sharedInstance] inTransaction:^(BOOL *rollback) {
        
        if ([table updateRows:rows]) {
            DebugLog(@"synUpdatedCustomExhort success");
        } else {
            DebugLog(@"synUpdatedCustomExhort failured");
            *rollback = YES;
        }
    }];

}

#pragma mark - 医嘱
/**
 *  系统医嘱-一级
 *  dentistID 为0 parentID为0
 */
+ (void)fetchSystemDoctorAdviceSuccess:(void (^)(NSArray *success))success
                               failure:(void (^)(NSError *error))failure {
    TableExhort *exhort = [[TableExhort alloc] init];
    __block NSArray *exhortResut = nil;
    [[DBManager sharedInstance] inDatabaseQueue:^{
        exhortResut = [exhort fetchSystemLevel1Exhort];
        
    } completion:^{
        
        if (!exhortResut.count) {
            [ExhortFacade fetchSystemDoctorAdviceSuccess:^(NSArray *exhorts) {
                success(exhorts);
            } failure:^(NSError *error) {
                failure(error);
                DebugLog(@"获取一级系统医嘱失败");
            }];
        } else {
            success(exhortResut);
        }
    }];
    
}
/**
 *  系统医嘱-二级
 *  dentistID 为0 parentID为传进来
 */
+ (void)fetchSystemDoctorAdviceWithID:(NSNumber *)ID
                              success:(void (^)(NSArray *success))success
                              failure:(void (^)(NSError *error))failure {
    TableExhort *exhort = [[TableExhort alloc] init];
    __block NSArray *exhortResut = nil;
    [[DBManager sharedInstance] inDatabaseQueue:^{
        exhortResut = [exhort fetchSystemLevel2ExhortWithParentId:ID];
    } completion:^{
        if (!exhortResut.count) {
            [ExhortFacade fetchSystemDoctorAdviceSuccess:^(NSArray *exhorts) {
                success(exhorts);
            } failure:^(NSError *error) {
                failure(error);
                DebugLog(@"获取二级系统医嘱失败");
            }];
        } else {
            success(exhortResut);
        }
    }];
    
}
/**
 *  自定义医嘱-Create
 */
+ (void)addCustomDoctorAdviceWithContent:(NSString *)content
                                 success:(void (^)(NSDictionary *success))success
                                 failure:(void (^)(NSError *error))failure {
    [ExhortFacade addCustomDoctorAdviceWithContent:content success:^(NSDictionary *exhort) {
        NSDictionary *dict = exhort.allValues.firstObject;
        
        [[DBManager sharedInstance] inDatabaseQueue:^{
            TableExhort *table = [[TableExhort alloc] init];
            [table addCustomExhortWithExhort:dict];
        } completion:^{
            success(exhort);
        }];
        
    } failure:^(NSError *error) {
        DebugLog(@"新增自定义医嘱失败");
    }];
}

/**
 *  自定义医嘱-Upate
 */
+ (void)updateCustomDoctorAdviceWithID:(NSNumber *)ID
                               content:(NSString *)content
                               success:(void (^)(NSDictionary *success))success
                               failure:(void (^)(NSError *error))failure {
    [ExhortFacade updateCustomDoctorAdviceWithID:ID content:content success:^(NSDictionary *s) {
        NSDictionary *dict = s.allValues.firstObject;
        [[DBManager sharedInstance] inDatabaseQueue:^{
            TableExhort *table = [[TableExhort alloc] init];
            [table updateCustomExhortWithId:dict[@"id"] content:dict[@"content"] modTime:dict[@"modTime"]];
        } completion:^{
            success(s);
        }];
        
    } failure:^(NSError *error) {
        DebugLog(@"更新自定义医嘱失败:%@",error.localizedDescription);
        failure(error);
    }];
}

/**
 *  自定义医嘱-Read
 */
+ (void)fetchCustomDoctorAdviceWithDentistId:(NSNumber *)dentistId
                                 success:(void (^)(NSArray *))success
                                 failure:(void (^)(NSError *))failure {
    TableExhort *exhort = [[TableExhort alloc] init];
    __block NSArray *exhortResut = nil;
    
    [[DBManager sharedInstance] inDatabaseQueue:^{
        exhortResut = [exhort fetchCustomExhortWithDentistId:dentistId];
    } completion:^{
        if (!exhortResut.count) {
            [ExhortFacade fetchCustomDoctorAdviceWithDentistId:dentistId success:^(NSArray *exhorts) {
                success(exhorts);
            } failure:^(NSError *error) {
                DebugLog(@"获取自定义医嘱失败");
            }];
            
        } else {
            success(exhortResut);
        }
    }];
    
}

/**
 *  自定义医嘱-Delete
 */
+ (void)deleteCustomDoctorAdviceWithID:(NSNumber *)ID
                               success:(void (^)(NSDictionary *success))success
                               failure:(void (^)(NSError *error))failure {
    [ExhortFacade deleteCustomDoctorAdviceWithID:ID success:^(NSDictionary *s) {
        //删除数据库的
        [[DBManager sharedInstance] inDatabaseQueue:^{
            TableExhort *exhort = [[TableExhort alloc] init];
            [exhort deleteCustomExhortWithId:ID];
        } completion:^{
            success(s);
        }];
    } failure:^(NSError *error) {
        DebugLog(@"删除失败");
        failure(error);
    }];
}
@end
