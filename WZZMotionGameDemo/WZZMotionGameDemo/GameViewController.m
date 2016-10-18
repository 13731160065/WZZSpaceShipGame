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
#import "WZZSpaceShipsVC.h"
#import "WZZUserInfo.h"

@interface GameViewController ()
{
    WZZScene2 * scene;
    UIButton * button;
    UILabel * label;
    UIButton * changeShip;
    NSString * currentShip;
    UILabel * screenLabel;
    UILabel * highLabel;
}

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[WZZUserInfo sharedWZZUserInfo] loadUserInfoFromSanbox];
    NSString * shippp = [WZZUserInfo sharedWZZUserInfo].currentShip;
    currentShip = shippp?shippp:@"ship2";
    
    // Configure the view.
    SKView * skView = [[SKView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:skView];
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    screenLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, [UIScreen mainScreen].bounds.size.width-16, 20)];
    [self.view addSubview:screenLabel];
    [screenLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [screenLabel setTextColor:[UIColor whiteColor]];
    [screenLabel setTextAlignment:NSTextAlignmentLeft];
    [screenLabel setText:@"当前分数:0"];

    scene = [[WZZScene2 alloc] initWithSize:[UIScreen mainScreen].bounds.size currentShip:currentShip];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.scoreLabel = screenLabel;
    
    [scene gameoverBlock:^(NSString *msg) {
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:[UIScreen mainScreen].bounds];
        [self.view addSubview:button];
        [button addTarget:self action:@selector(restart) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"再次出发" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2-50, [UIScreen mainScreen].bounds.size.width, 30)];
        [self.view addSubview:label];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:msg];
        
        changeShip = [UIButton buttonWithType:UIButtonTypeCustom];
        [changeShip setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2+50, [UIScreen mainScreen].bounds.size.width, 30)];
        [self.view addSubview:changeShip];
        [changeShip addTarget:self action:@selector(changeShipClick) forControlEvents:UIControlEventTouchUpInside];
        [changeShip setTitle:@"更换战舰" forState:UIControlStateNormal];
        [changeShip.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [changeShip setBackgroundColor:[UIColor whiteColor]];
        [changeShip setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [screenLabel setTextColor:[UIColor blackColor]];
        [self.view bringSubviewToFront:screenLabel];
        [screenLabel setFont:[UIFont systemFontOfSize:15]];
        [screenLabel setTextAlignment:NSTextAlignmentCenter];
        
        highLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8*2+20, [UIScreen mainScreen].bounds.size.width-16, 20)];
        [self.view addSubview:highLabel];
        [highLabel setTextAlignment:NSTextAlignmentCenter];
        [highLabel setText:[NSString stringWithFormat:@"最高分:%ld", [WZZUserInfo sharedWZZUserInfo].highScore]];
        [highLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }];
    
    [skView presentScene:scene];
}

- (void)changeShipClick {
    WZZSpaceShipsVC * vc = [[WZZSpaceShipsVC alloc] init];
    [vc changeOverBlock:^(NSString *imageName) {
        currentShip = imageName;
        [WZZUserInfo sharedWZZUserInfo].currentShip = currentShip;
        [[WZZUserInfo sharedWZZUserInfo] saveUserInfoToSanbox];
    }];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)restart {
    [button removeFromSuperview];
    [changeShip removeFromSuperview];
    [label removeFromSuperview];
    [highLabel removeFromSuperview];
    [scene setCurrentImageName:currentShip];
    [scene startGame];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
