//
//  WZZScene2.m
//  WZZMotionGameDemo
//
//  Created by 王泽众 on 16/9/22.
//  Copyright © 2016年 wzz. All rights reserved.
//

#import "WZZScene2.h"
#define DefaultColor [UIColor colorWithRed:0.2314f green:0.9882f blue:0.2039f alpha:1.0f]
#define LOADWIDTH [UIScreen mainScreen].bounds.size.width;

@import CoreMotion;

@interface WZZScene2 ()<SKPhysicsContactDelegate>
{
    SKSpriteNode * player;
    CMMotionManager * manager;
    NSTimer * moveTimer;
    NSTimer * timer;
    NSTimeInterval rockTime;
    NSTimeInterval refreshTime;
    void(^_gameOverBlock)();
}
@end

static const uint32_t playerCate = 0x1<<0;
static const uint32_t rockCate = 0x1<<1;

@implementation WZZScene2


- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        
        manager = [[CMMotionManager alloc] init];
        [manager startAccelerometerUpdates];
        [self startGame];
    }
    return self;
}

- (void)startGame {
    const CGFloat spriteWH = 8;
    player = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(spriteWH, spriteWH)];
    player = [SKSpriteNode spriteNodeWithImageNamed:@"ship2"];
    [self addChild:player];
    player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:player.frame.size];
    player.physicsBody.dynamic = YES;
    player.physicsBody.categoryBitMask = playerCate;
    player.physicsBody.contactTestBitMask = rockCate;
    player.physicsBody.collisionBitMask = 0;
    player.physicsBody.usesPreciseCollisionDetection = YES;
    player.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    [moveTimer invalidate];
    moveTimer = nil;
    moveTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(moveChange) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:moveTimer forMode:NSRunLoopCommonModes];
    
    [timer invalidate];
    timer = nil;
    timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(makeARock) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)moveChange {
    CGFloat x = manager.accelerometerData.acceleration.x;
    CGFloat y = manager.accelerometerData.acceleration.y;
    CGPoint po;
    po.x = x*self.frame.size.width/2+self.frame.size.width/2;
    po.y = y*self.frame.size.height/2+self.frame.size.height/2;
    [self.physicsWorld setGravity:CGVectorMake(x, y)];
    if (![self containsPoint:player.position]) {
        NSLog(@"game over");
    }
    player.zRotation = atan2(-x, y);
}

- (void)makeARock {
    int rWH = arc4random()%10+10;
    SKSpriteNode * rock = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(rWH, rWH)];
    
    [self addChild:rock];
    CGFloat YYY = 0;
    CGFloat XXX = 0;
    int xyType = arc4random()%4;
    switch (xyType) {
        case 0:
        {
            XXX = arc4random()%(int)(self.frame.size.width);
            YYY = self.frame.size.height+rWH;
        }
            break;
        case 1:
        {
            XXX = arc4random()%(int)(self.frame.size.width);
            YYY = -rWH;
        }
            break;
        case 2:
        {
            XXX = -rWH;
            YYY = arc4random()%(int)(self.frame.size.height);
        }
            break;
        case 3:
        {
            XXX = self.frame.size.width+rWH;
            YYY = arc4random()%(int)(self.frame.size.height);
        }
            break;
            
        default:
            break;
    }
    [rock setPosition:CGPointMake(XXX, YYY)];
    rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rock.frame.size];
    rock.physicsBody.categoryBitMask = rockCate;
    rock.physicsBody.dynamic = YES;
    rock.physicsBody.contactTestBitMask = playerCate;
    rock.physicsBody.collisionBitMask = 0;
    rock.physicsBody.usesPreciseCollisionDetection = YES;
    
#if 0//等级
    level++;
    
    if (level%5 == 0) {
        refreshTime -= 0.1;
        if (refreshTime < 0.1) {
            refreshTime = 0.1;
        }
        [letimer invalidate];
        letimer = nil;
        letimer = [NSTimer scheduledTimerWithTimeInterval:refreshTime target:self selector:@selector(makeARock) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:letimer forMode:NSRunLoopCommonModes];
    }
#endif
    CGFloat YYYEnd = 0;
    CGFloat XXXEnd = 0;
    int xyType2 = arc4random()%4;
    switch (xyType2) {
        case 0:
        {
            XXX = arc4random()%(int)(self.frame.size.width);
            YYY = self.frame.size.height+rWH;
        }
            break;
        case 1:
        {
            XXX = arc4random()%(int)(self.frame.size.width);
            YYY = -rWH;
        }
            break;
        case 2:
        {
            XXX = -rWH;
            YYY = arc4random()%(int)(self.frame.size.height);
        }
            break;
        case 3:
        {
            XXX = self.frame.size.width+rWH;
            YYY = arc4random()%(int)(self.frame.size.height);
        }
            break;
            
        default:
            break;
    }
    //动画
    SKAction * a1 = [SKAction moveTo:CGPointMake(XXXEnd, YYYEnd) duration:2.0f];
    SKAction * a2 = [SKAction removeFromParent];
    [rock runAction:[SKAction sequence:@[a1, a2]]];
}

- (void)gameoverBlock:(void (^)())gob {
    if (_gameOverBlock != gob) {
        _gameOverBlock = gob;
    }
}

#pragma mark - 开始碰撞
- (void)didBeginContact:(SKPhysicsContact *)contact {
    [timer invalidate];
    timer = nil;
    [moveTimer invalidate];
    moveTimer = nil;
    [self removeAllChildren];
    NSLog(@"game over");
    if (_gameOverBlock) {
        _gameOverBlock();
    }
}

@end
