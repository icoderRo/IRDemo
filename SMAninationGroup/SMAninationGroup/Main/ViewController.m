//
//  ViewController.m
//  SMHeartStarAnimation
//
//  Created by simon on 16/12/16.<https://github.com/icoderRo/SMAnimation>
//  Copyright © 2016年 simon. All rights reserved.
//

#import "ViewController.h"
#import "SMEmitterViewController.h"
#import "SMDanmakuViewController.h"
#import "SMCompressViewController.h"
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    self.array = [NSMutableArray array];
    self.title = @"animations";
    [self.array addObject:@{ @"SMEmitter" : @"SMEmitterViewController"}];
    [self.array addObject:@{ @"SMDanmaku" : @"SMDanmakuViewController"}];
    [self.array addObject:@{ @"SMCompress" : @"SMCompressViewController"}];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 66;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    
    NSDictionary *dict = self.array[indexPath.row];
    NSString *text = dict.allKeys.lastObject;
    cell.textLabel.text = text;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = self.array[indexPath.row];
    NSString *className = dict.allValues.lastObject;
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *ctrl = class.new;
        ctrl.view.backgroundColor = [UIColor whiteColor];
        ctrl.title = dict.allKeys.lastObject;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}

@end
