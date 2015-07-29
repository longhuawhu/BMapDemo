//
//  SearchViewController.m
//  BMapDemo
//
//  Created by lh on 15/7/29.
//  Copyright (c) 2015年 lh. All rights reserved.
//

#import "SearchViewController.h"
#import <BaiduMapAPI/BMapKit.h>

@interface SearchViewController ()<BMKGeoCodeSearchDelegate>
{
    BMKGeoCodeSearch *_searcher;
}


@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 80, 40)];
    [btn1 addTarget:self action:@selector(startSearcher) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitle:@"geo检索" forState:UIControlStateNormal];
    [btn1 setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 180, 80, 40)];
    [btn2 addTarget:self action:@selector(startReverseSearch) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setTitle:@"反geo检索" forState:UIControlStateNormal];
    [btn2 setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:btn2];
    
    self.view.backgroundColor = [UIColor whiteColor];
}


-(void)startSearcher{
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geoCodeSearchOption.city= @"北京市";
    geoCodeSearchOption.address = @"海淀区上地10街10号";
    BOOL flag = [_searcher geoCode:geoCodeSearchOption];
    
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
}

-(void)startReverseSearch{
    // 发起反向地理编码检索
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){39.915, 116.404};
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
                                                            BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
    
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}

#pragma mark -- BMKGeoCodeSearchDelegate
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        NSLog(@"latitude: %f longitude:%f", result.location.latitude, result.location.longitude);
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

//接收反向地理编码结果
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result
                       errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        // 在此处理正常结果
        NSLog(@"%@", result.address);
        NSLog(@"POI:%@", result.poiList);
        int i = 0;
        for (BMKPoiInfo *poi in result.poiList) {
            NSLog(@"POI %d :%@", i, poi.name);
            i++;
        }
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
