//
//  DBStructureManager.h
//  haoyayi_doctor
//
//  Created by kRadius on 16/4/25.
//  Copyright © 2016年 zhourx5211. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBStructureManager : NSObject

+ (DBStructureManager *)sharedInstance;

- (void)checkVersion;

@end
