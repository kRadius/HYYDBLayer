//
//  DBManager.h
//  haoyayi_doctor
//
//  Created by zhourx5211 on 11/17/15.
//  Copyright © 2015 zhourx5211. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DBManager : NSObject

@property (strong, nonatomic, readonly) FMDatabase *database;

+ (instancetype)sharedInstance;
+ (instancetype)sharedReadDatabase;

- (void)inDatabaseQueue:(void (^)())block;
- (void)inDatabaseQueue:(void (^)())block completion:(void (^)())completion;

- (void)inTransaction:(void (^)(BOOL *rollback))block;
- (void)inTransaction:(void (^)(BOOL *rollback))block completion:(void (^)())completion;

- (void)inDeferredTransaction:(void (^)(BOOL *rollback))block;
- (void)inDeferredTransaction:(void (^)(BOOL *rollback))block completion:(void (^)())completion;

@end
