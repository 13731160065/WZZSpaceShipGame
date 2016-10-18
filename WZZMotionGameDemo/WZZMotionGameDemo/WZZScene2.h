//
//  WZZScene2.h
//  WZZMotionGameDemo
//
//  Created by 王泽众 on 16/9/22.
//  Copyright © 2016年 wzz. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum {
    SpaceShipType_normal,
    SpaceShipType_GreenGhost
}SpaceShipType;

@interface WZZScene2 : SKScene

@property (nonatomic, copy) NSString * currentImageName;
@property (nonatomic, strong) UILabel * scoreLabel;

- (instancetype)initWithSize:(CGSize)size currentShip:(NSString *)ship;
- (void)startGame;
- (void)gameoverBlock:(void (^)(NSString * msg))gob;
- (void)setSpaceShip:(SpaceShipType)spaceShipType;

@end
