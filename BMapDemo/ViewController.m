//
//  ViewController.m
//  BMapDemo
//
//  Created by lh on 15/7/23.
//  Copyright (c) 2015年 lh. All rights reserved.
//

#import "ViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "CellInfor.h"

#import "LocationViewController.h"
#import "AnnotationViewController.h"
#import "SearchViewController.h"
#import "RadarViewController.h"

@interface ViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate, UITableViewDelegate, UITableViewDataSource>
{

    BMKGeoCodeSearch *_searcher;
}
@property (nonatomic, weak)UITableView *tabelView;
@property (nonatomic, retain)NSMutableArray *sectionRow;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tabelView = tableView;

    [self loadData];
    
    NSLog(@"viewDidLoad");
    
}

-(void)loadData{
    self.sectionRow = [[NSMutableArray alloc] init];
    
    [self.sectionRow addObject:[CellInfor infoWithTitle:@"定位" viewController:[[LocationViewController alloc] init]]];
    
    [self.sectionRow addObject:[CellInfor infoWithTitle:@"标注" viewController:[[AnnotationViewController alloc] init]]];
    
    [self.sectionRow addObject:[CellInfor infoWithTitle:@"检索" viewController:[[SearchViewController alloc] init]]];
    
    [self.sectionRow addObject:[CellInfor infoWithTitle:@"雷达" viewController:[[RadarViewController alloc] init]]];
    
    
    
    
  
}

#pragma mark -- 
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.sectionRow count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
    }
    CellInfor *cellInfor = self.sectionRow[indexPath.row];
    
    cell.textLabel.text = cellInfor.title;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CellInfor *cellInfor = self.sectionRow[indexPath.row];
    
    [self.navigationController pushViewController:cellInfor.viewController animated:YES];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
