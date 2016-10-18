//
//  WZZScene2.m
//  WZZMotionGameDemo
//
//  Created by 王泽众 on 16/9/22.
//  Copyright © 2016年 wzz. All rights reserved.
//

#import "WZZScene2.h"
#import "WZZUserInfo.h"
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
    NSTimer * scoreTimer;
    NSString * currentText;
    void(^_gameOverBlock)(NSString *);
    NSInteger currentScore;
}
@end

static const uint32_t playerCate = 0x1<<0;
static const uint32_t rockCate = 0x1<<1;

@implementation WZZScene2


- (instancetype)initWithSize:(CGSize)size currentShip:(NSString *)ship
{
    self = [super initWithSize:size];
    if (self) {
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        manager = [[CMMotionManager alloc] init];
        [manager startAccelerometerUpdates];
        _currentImageName = ship;
        [self startGame];
    }
    return self;
}

- (void)setSpaceShip:(SpaceShipType)spaceShipType {
    switch (spaceShipType) {
        case SpaceShipType_normal:
        {
            
        }
            break;
        case SpaceShipType_GreenGhost:
        {
            
        }
            break;
            
        default:
            break;
    }
}

- (void)startGame {
    const CGFloat spriteWH = 8;
    player = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(spriteWH, spriteWH)];
    player = [SKSpriteNode spriteNodeWithImageNamed:_currentImageName];
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
    
    [scoreTimer invalidate];
    scoreTimer = nil;
    scoreTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(scoreAdd) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
//    dispatch_queue_t tt = dispatch_queue_create("tt", DISPATCH_QUEUE_SERIAL);
//    dispatch_async(tt, ^{
//        for (int i = 0; i < 5; i++) {
//            [NSThread sleepForTimeInterval:5.0f];
//            [timer invalidate];
//            timer = nil;
//            timer = [NSTimer scheduledTimerWithTimeInterval:2/(i+1) target:self selector:@selector(makeARock) userInfo:nil repeats:YES];
//            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//        }
//    });
    
    _scoreLabel.text = @"当前分数:0";
    [_scoreLabel setTextColor:[UIColor whiteColor]];
    [_scoreLabel setFont:[UIFont systemFontOfSize:13]];
    [_scoreLabel setTextAlignment:NSTextAlignmentLeft];
}

- (void)moveChange {
    CGFloat x = manager.accelerometerData.acceleration.x;
    CGFloat y = manager.accelerometerData.acceleration.y;
    CGPoint po;
    po.x = x*self.frame.size.width/2+self.frame.size.width/2;
    po.y = y*self.frame.size.height/2+self.frame.size.height/2;
    [self.physicsWorld setGravity:CGVectorMake(x, y)];

    CGFloat px = player.position.x;
    CGFloat py = player.position.y;
    if ((px < 0)||(px > self.frame.size.width)||(py < 0)||(py > self.frame.size.height)) {
        currentText = @"你驶离了安全区域";
        [self gameOver];
    }

    player.zRotation = atan2(-x, y);
}

- (void)scoreAdd {
    _scoreLabel.text = [NSString stringWithFormat:@"当前分数:%ld", ++currentScore];
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
    SKAction * a1 = [SKAction moveTo:CGPointMake(XXXEnd, YYYEnd) duration:3.0f];
    SKAction * a2 = [SKAction removeFromParent];
    [rock runAction:[SKAction sequence:@[a1, a2]]];
}

- (void)gameoverBlock:(void (^)(NSString *))gob {
    if (_gameOverBlock != gob) {
        _gameOverBlock = gob;
    }
}

- (void)gameOver {
    if ([WZZUserInfo sharedWZZUserInfo].highScore < currentScore) {
        [WZZUserInfo sharedWZZUserInfo].highScore = currentScore;
        [[WZZUserInfo sharedWZZUserInfo] saveUserInfoToSanbox];
    }
    [timer invalidate];
    timer = nil;
    [moveTimer invalidate];
    moveTimer = nil;
    [scoreTimer invalidate];
    scoreTimer = nil;
    
    currentScore = 0;
    [self removeAllChildren];
    NSLog(@"game over");
    if (_gameOverBlock) {
        _gameOverBlock(currentText);
    }
}

#pragma mark - 开始碰撞
- (void)didBeginContact:(SKPhysicsContact *)contact {
    currentText = @"你被陨石砸了个稀巴烂";
    
    [self gameOver];
}

@end
