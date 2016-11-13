//
//  DBStructureManager.m
//  haoyayi_doctor
//
//  Created by kRadius on 16/4/25.
//  Copyright © 2016年 zhourx5211. All rights reserved.
//

#import "DBStructureManager.h"
#import "DBManager.h"

//Table
#import "TableDentistTitle.h"
#import "TableDentistAcademic.h"
#import "TableDentistGraduate.h"
#import "TableDentistSpecial.h"
#import "TableDentistWorkingLife.h"
#import "TableBookTag.h"
#import "TableChinaProvince.h"
#import "TableChinaArea.h"
#import "TableChinaCity.h"
#import "TableDataVersion.h"
#import "TableTopicArea.h"
#import "TableClinic.h"
#import "TableWorkClinic.h"
#import "TableExhort.h"
#import "TableRelation.h"
#import "TableRelationTag.h"
#import "TableRelationTagMap.h"
#import "TableFriend.h"
#import "TableGroup.h"

//Key
static NSString * const kDBUpgradePlist = @"DBUpgrade";
static NSString * const kDBLastestVersionKey = @"DBLastestVersionKey";

@interface DBStructureManager ()

@property (strong, nonatomic) NSDictionary *currentVersionInfo;
@property (strong, nonatomic) NSArray *sortedVerArr;
@end

@implementation DBStructureManager

#pragma mark - Initialize
+ (DBStructureManager *)sharedInstance {
    static DBStructureManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DBStructureManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        //创建表
        [self p_createTables];
    }
    return self;
}

- (void)p_createTables {
    [[DBManager sharedInstance] inDatabaseQueue:^{
        
        [TableDentistTitle createTable];
        
        [TableDentistAcademic createTable];
        
        [TableDentistGraduate createTable];
        
        [TableDentistSpecial createTable];
        
        [TableDentistWorkingLife createTable];
        
        [TableBookTag createTable];
        
        [TableChinaProvince createTable];
        
        [TableChinaArea createTable];
        
        [TableChinaCity createTable];
        
        [TableDataVersion createTable];
        
        [TableTopicArea createTable];
        
        [TableClinic createTable];
        
        [TableWorkClinic createTable];
        
        [TableExhort createTable];
        
        [TableRelation createTable];
        
        [TableRelationTag createTable];
        
        [TableRelationTagMap createTable];
        
        [TableFriend createTable];
        
        [TableGroup createTable];
    }];
}
#pragma mark - Public

- (void)checkVersion {
    
    NSString *oldVersion = NSUSERDEFAULTS(kDBLastestVersionKey);
    NSString *bundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];

    if (!oldVersion && [kDBStartUpgradeVersion compare:bundleVersion options:NSNumericSearch] == NSOrderedAscending) {
        //老用户的初始值
        oldVersion = @"Version0.0";
    }
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:kDBUpgradePlist ofType:@"plist"];
    self.currentVersionInfo = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    self.sortedVerArr = [[self.currentVersionInfo allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSString *lastestVersion = [self.sortedVerArr lastObject];
    
    if (!oldVersion) {
        //设置最新版本
        SETNSUSERDEFAULTS(lastestVersion, kDBLastestVersionKey);
        SYNCHRONIZED_NSUSERDEFAULTS;
    } else if ([oldVersion compare:lastestVersion] == NSOrderedAscending) {
        [self upgradeFromOldVersion:oldVersion];
    }
}

- (void)upgradeFromOldVersion:(NSString *)oldVersion {
    //取出所有要更新的版本
    NSArray *allNewVersion = [self.sortedVerArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF > %@",oldVersion]];
    
    if (!allNewVersion.count) {
        return;
    }
    
    //所有更新的内容
    NSMutableArray *allNewContent = [[NSMutableArray alloc] init];
    [allNewVersion enumerateObjectsUsingBlock:^(id  _Nonnull verKey, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *tempArr = [self.currentVersionInfo objectForKey:verKey];
        [allNewContent addObjectsFromArray:tempArr];
    }];
    
    //执行
    [[DBManager sharedInstance] inTransaction:^(BOOL *rollback) {
        [allNewContent enumerateObjectsUsingBlock:^(id  _Nonnull sql, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![[DBManager sharedInstance].database executeUpdate:sql]) {
                *rollback = YES;
                *stop = YES;
                DebugLog(@"升级失败:%@",sql);
            } else {
                DebugLog(@"升级:%@",sql);
            }
        }];
        if (!*rollback) {
            //设置最新的值
            SETNSUSERDEFAULTS(self.sortedVerArr.lastObject, kDBLastestVersionKey);
            SYNCHRONIZED_NSUSERDEFAULTS;
        }
    }];
}

@end
