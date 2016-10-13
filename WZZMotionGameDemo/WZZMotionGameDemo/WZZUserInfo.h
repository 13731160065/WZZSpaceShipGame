//
//  WZZUserInfo.h
//  WZZTextGame
//
//  Created by 王泽众 on 16/9/28.
//  Copyright © 2016年 wzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#define CURRENTSIDKEY @"CURRENTSIDKEY"

@interface WZZUserInfo : NSObject

@property (nonatomic, copy) NSString * currentShip;

+ (instancetype)sharedWZZUserInfo;
- (void)loadUserInfoFromSanbox;
- (void)saveUserInfoToSanbox;

@end
