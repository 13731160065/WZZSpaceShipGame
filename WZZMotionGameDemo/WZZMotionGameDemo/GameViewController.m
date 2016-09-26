//
//  GameViewController.m
//  WZZMotionGameDemo
//
//  Created by 王泽众 on 16/9/9.
//  Copyright (c) 2016年 wzz. All rights reserved.
//

#import "GameViewController.h"
#import "WZZScene2.h"
#import "AppDelegate.h"

@interface GameViewController ()
{
    WZZScene2 * scene;
    UIButton * button;
}

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    // Configure the view.
    SKView * skView = [[SKView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:skView];
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;

    scene = [[WZZScene2 alloc] initWithSize:[UIScreen mainScreen].bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [scene gameoverBlock:^{
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:[UIScreen mainScreen].bounds];
        [self.view addSubview:button];
        [button addTarget:self action:@selector(restart) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"开始游戏" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }];
    
    // Present the scene.
    [skView presentScene:scene];
}

- (void)restart {
    [button removeFromSuperview];
    [scene startGame];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
