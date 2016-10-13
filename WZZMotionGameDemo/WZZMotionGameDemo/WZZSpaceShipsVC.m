//
//  WZZSpaceShipsVC.m
//  WZZMotionGameDemo
//
//  Created by 王泽众 on 16/9/27.
//  Copyright © 2016年 wzz. All rights reserved.
//

#import "WZZSpaceShipsVC.h"

@interface WZZSpaceShipsVC ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView * mainTableView;
    NSMutableArray * dataArr;
    void(^_changeOverBlock)(NSString *);
}

@end

@implementation WZZSpaceShipsVC

- (void)changeOverBlock:(void (^)(NSString *))block {
    if (_changeOverBlock != block) {
        _changeOverBlock = block;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:mainTableView];
    [mainTableView setDelegate:self];
    [mainTableView setDataSource:self];
    [mainTableView setSeparatorColor:[UIColor whiteColor]];
    [mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self loadData];
    [self.view setBackgroundColor:[UIColor blackColor]];
    [mainTableView setBackgroundColor:[UIColor blackColor]];
}

- (void)loadData {
    dataArr = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"WZZSpaceShipPlist" ofType:@"plist"]];
    [mainTableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSDictionary * dic = dataArr[indexPath.row];
    [cell.textLabel setText:dic[@"name"]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setTextAlignment:NSTextAlignmentRight];
    [cell.imageView setImage:[UIImage imageNamed:dic[@"image"]]];
    [cell setBackgroundColor:[UIColor blackColor]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_changeOverBlock) {
        _changeOverBlock(dataArr[indexPath.row][@"image"]);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
