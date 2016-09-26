//
//  AppDelegate.m
//  WZZMotionGameDemo
//
//  Created by 王泽众 on 16/9/9.
//  Copyright © 2016年 wzz. All rights reserved.
//

#import "AppDelegate.h"
#import "GameViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    GameViewController * game = [[GameViewController alloc] init];
    [self.window setRootViewController:game];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
