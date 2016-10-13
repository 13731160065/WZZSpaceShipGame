//
//  WZZUserInfo.m
//  WZZTextGame
//
//  Created by 王泽众 on 16/9/28.
//  Copyright © 2016年 wzz. All rights reserved.
//

#import "WZZUserInfo.h"

@implementation WZZUserInfo

//单利.m
static WZZUserInfo *_instance;

+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}

+ (instancetype)sharedWZZUserInfo
{
    if (_instance == nil) {
        _instance = [[WZZUserInfo alloc] init];
    }
    
    return _instance;
}

- (void)loadUserInfoFromSanbox {
    _currentShip = [[NSUserDefaults standardUserDefaults] objectForKey:CURRENTSIDKEY];
}

- (void)saveUserInfoToSanbox {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    if ([_currentShip isKindOfClass:[NSString class]]) {
        [userDefault setObject:_currentShip forKey:CURRENTSIDKEY];
    } else {
        [userDefault setObject:nil forKey:CURRENTSIDKEY];
    }
}

- (void)cleanUserInfo {
    _currentShip = @"";
    [self saveUserInfoToSanbox];
}

@end
