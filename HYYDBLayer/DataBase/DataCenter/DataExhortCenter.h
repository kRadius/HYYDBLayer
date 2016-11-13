//
//  DataExhortCenter.h
//  haoyayi_doctor
//
//  Created by kRadius on 15/11/25.
//  Copyright © 2015年 zhourx5211. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataExhortCenter : NSObject

#pragma mark - 同步
//版本控制
+ (void)updateExhortWithVersion:(NSString *)version;
//所有的
+ (void)synAllCustomExhort:(NSArray *)exhorts;
//同步一部分已经更新的
+ (void)synUpdatedCustomExhort:(NSArray *)exhorts;
//最新一次的addTime
+ (void)lastestAddCustomExhortTimeWithDentistId:(NSNumber *)dentsitId success:(void(^)(NSString *addTime))success;
//最新一次的updateTime
+ (void)lastestUpdateCustomExhortTimeWithDentistId:(NSNumber *)dentsitId success:(void(^)(NSString *updateTime))success;

#pragma mark - 医嘱
/**
 *  系统医嘱-一级
 *  dentistID 为0 parentID为0
 */
+ (void)fetchSystemDoctorAdviceSuccess:(void (^)(NSArray *success))success
                               failure:(void (^)(NSError *error))failure;
/**
 *  系统医嘱-二级
 *  dentistID 为0 parentID为传进来
 */
+ (void)fetchSystemDoctorAdviceWithID:(NSNumber *)ID
                              success:(void (^)(NSArray *success))success
                              failure:(void (^)(NSError *error))failure;
/**
 *  自定义医嘱-Create
 */
+ (void)addCustomDoctorAdviceWithContent:(NSString *)content
                                 success:(void (^)(NSDictionary *success))success
                                 failure:(void (^)(NSError *error))failure;

/**
 *  自定义医嘱-Upate
 */
+ (void)updateCustomDoctorAdviceWithID:(NSNumber *)ID
                               content:(NSString *)content
                               success:(void (^)(NSDictionary *success))success
                               failure:(void (^)(NSError *error))failure;

/**
 *  自定义医嘱-Read
 */
+ (void)fetchCustomDoctorAdviceWithDentistId:(NSNumber *)dentistId
                                 success:(void (^)(NSArray *success))success
                               failure:(void (^)(NSError *error))failure;

/**
 *  自定义医嘱-Delete
 */
+ (void)deleteCustomDoctorAdviceWithID:(NSNumber *)ID
                               success:(void (^)(NSDictionary *success))success
                               failure:(void (^)(NSError *error))failure;

@end
