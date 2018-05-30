//
//  ViewController.m
//  tableViewOpenAndClose
//
//  Created by seesea on 2018/5/30.
//  Copyright © 2018年 seesea. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *_isOpenArray;
    
}

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isOpenArray = [NSMutableArray array];
    
    for (int i=0; i<20; i++) {
        NSString *close = @"close";
        [_isOpenArray addObject:close];
    }
    
    [self.view addSubview:self.tableView];
    
}

- (UITableView*)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma --UITableViewDelegateMethod--
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSString *isOpen = _isOpenArray[section];
    if ([isOpen isEqualToString:@"open"]) {
        return 30;
    } else {
        return 0;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 20;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *indentifierid=@"tableviewCellId";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indentifierid];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifierid];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *sectionBackView=[[UILabel alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 60)];
    sectionBackView.backgroundColor=[UIColor whiteColor];
    sectionBackView.text = [NSString stringWithFormat:@"           section = %ld ",section];
    sectionBackView.userInteractionEnabled = YES;
    CALayer *line = [CALayer layer];
    line.backgroundColor =[UIColor blackColor].CGColor;
    line.frame = CGRectMake(0,59.5,self.view.frame.size.width,0.5);
    [sectionBackView.layer addSublayer:line];
    
    sectionBackView.tag = 200+section;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openOrClose:)];
    [sectionBackView addGestureRecognizer:tap];
    
    UIButton *arrowIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    arrowIcon.frame = CGRectMake(self.view.frame.size.width-50,0, 40, 60);
    [arrowIcon setImage:[UIImage imageNamed:@"icon"] forState:UIControlStateNormal];
    [sectionBackView addSubview:arrowIcon];
    [arrowIcon addTarget:self action:@selector(arrowIconClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *isOpen = _isOpenArray[section];
    
    if ([isOpen isEqualToString:@"open"]) {
        arrowIcon.transform = CGAffineTransformMakeRotation(M_PI_2);
    }else if ([isOpen isEqualToString:@"close"]) {
        arrowIcon.transform = CGAffineTransformMakeRotation(0);
    }
    
    return sectionBackView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60.f;
    
}

- (void)openOrClose:(UITapGestureRecognizer*)tap {
    [self openAndtansformIntoIcon:tap.view];
}

-(void)arrowIconClick:(UIButton*)btn {
    [self openAndtansformIntoIcon:[btn superview]];
}

- (void)openAndtansformIntoIcon:(UIView*)view {
    
    NSInteger section = view.tag - 200;
    
    NSString *isOpen = _isOpenArray[section];
    if ([isOpen isEqualToString:@"open"]) {
        isOpen = @"close";
    } else {
        isOpen = @"open";
    }
    
    [_isOpenArray replaceObjectAtIndex:section withObject:isOpen];
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:section];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    
    if ([isOpen isEqualToString:@"open"]) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
}


@end
