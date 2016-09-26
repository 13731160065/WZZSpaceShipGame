//
//  WZZScene2.h
//  WZZMotionGameDemo
//
//  Created by 王泽众 on 16/9/22.
//  Copyright © 2016年 wzz. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface WZZScene2 : SKScene

- (void)startGame;
- (void)gameoverBlock:(void(^)())gob;

@end
