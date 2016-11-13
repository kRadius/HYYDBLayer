//
//  DBManager.m
//  haoyayi_doctor
//
//  Created by zhourx5211 on 11/17/15.
//  Copyright © 2015 zhourx5211. All rights reserved.
//

#import "DBManager.h"

static const void * const kDispatchQueueSpecificKey = &kDispatchQueueSpecificKey;
static const void * const kDispatchQueueSpecificReadKey = &kDispatchQueueSpecificReadKey;
static NSString *kDataBaseName = @"HYYDatabase.sqlite";

typedef enum : NSUInteger {
    DBManagerTypeNormal,
    DBManagerTypeReadOnly,
} DBManagerType;

@interface DBManager () {
    dispatch_queue_t _queue;
}

@end

@implementation DBManager

- (id)initWithType:(DBManagerType)type {
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        NSString *databasePath = [documentDirectory stringByAppendingPathComponent:kDataBaseName];
        DebugLog(@"dataBasePath = %@",databasePath);
        _database = [[FMDatabase alloc] initWithPath:databasePath];
#if SQLITE_VERSION_NUMBER >= 3005000
        BOOL success;
        if (type == DBManagerTypeNormal) {
            success = [_database openWithFlags:SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE];
        } else {
            success = [_database openWithFlags:SQLITE_OPEN_READONLY];
        }
#else
        BOOL success = [_database open];
#endif
        if (!success) {
            NSLog(@"Could not create database queue for path %@", databasePath);
            return nil;
        }
        
        _queue = dispatch_queue_create([[NSString stringWithFormat:@"com.51haoyayi.%@", self] UTF8String], NULL);
        if (type == DBManagerTypeNormal) {
            dispatch_queue_set_specific(_queue, kDispatchQueueSpecificKey, (__bridge void *)self, NULL);
        } else {
            dispatch_queue_set_specific(_queue, kDispatchQueueSpecificReadKey, (__bridge void *)self, NULL);
        }

    }
    return self;
}

+ (instancetype)sharedInstance {
    static DBManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[DBManager alloc] initWithType:DBManagerTypeNormal];
    });
    return _sharedInstance;
}

+ (instancetype)sharedReadDatabase {
    static DBManager *_sharedReadDatabase = nil;
    static dispatch_once_t oncePredicateRead;
    dispatch_once(&oncePredicateRead, ^{
        _sharedReadDatabase = [[DBManager alloc] initWithType:DBManagerTypeReadOnly];
    });
    return _sharedReadDatabase;
}

- (void)inDatabaseQueue:(void (^)())block {
    dispatch_async(_queue, ^() {
        block();
    });
}

- (void)inDatabaseQueue:(void (^)())block completion:(void (^)())completion {
    dispatch_async(_queue, ^() {
        block();
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), completion);
        }
    });
}

- (void)inTransaction:(void (^)(BOOL *rollback))block {
    [self beginTransaction:NO withBlock:block completion:nil];
}

- (void)inTransaction:(void (^)(BOOL *rollback))block completion:(void (^)())completion {
    [self beginTransaction:NO withBlock:block completion:completion];
}

- (void)inDeferredTransaction:(void (^)(BOOL *rollback))block {
    [self beginTransaction:YES withBlock:block completion:nil];
}

- (void)inDeferredTransaction:(void (^)(BOOL *rollback))block completion:(void (^)())completion {
    [self beginTransaction:YES withBlock:block completion:completion];
}

- (void)beginTransaction:(BOOL)useDeferred withBlock:(void (^)(BOOL *rollback))block  completion:(void (^)())completion {
    dispatch_async(_queue, ^() {
        
        BOOL shouldRollback = NO;
        
        if (useDeferred) {
            [_database beginDeferredTransaction];
        } else {
            [_database beginTransaction];
        }
        
        block(&shouldRollback);
        
        if (shouldRollback) {
            [_database rollback];
        } else {
            [_database commit];
        }
        
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), completion);
        }
    });
}

@end
