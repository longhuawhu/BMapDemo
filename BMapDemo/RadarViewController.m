//
//  RadarViewController.m
//  BMapDemo
//
//  Created by lh on 15/7/29.
//  Copyright (c) 2015年 lh. All rights reserved.
//

#import "RadarViewController.h"
#import <BaiduMapAPI/BMapKit.h>

@interface RadarViewController () <BMKRadarManagerDelegate, BMKLocationServiceDelegate>
{
    BMKRadarManager *_radarManager;
    BMKLocationService *_locService;
    BMKMapView *_mapView;
}
@property (nonatomic, weak)UILabel *label;
@end

@implementation RadarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    BMKRadarManager *radarManager = [BMKRadarManager getRadarManagerInstance];
   // 在不需要时，通过下边的方法使引用计数减1
   // [BMKRadarManager releaseRadarManagerInstance];
    
    _radarManager = radarManager;
    
    [_radarManager addRadarManagerDelegate:self];
    
    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 100)];
    [self.view addSubview:mapView];
    _mapView = mapView;
    mapView.delegate = self;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, self.view.bounds.size.height - 100, 100, 40)];
    [self.view addSubview:label];
    label.backgroundColor = [UIColor blueColor];
    _label = label;
    NSDate *date = [NSDate date];
    double i = [date timeIntervalSince1970];
    
     _radarManager.userId = [NSString stringWithFormat:@"lh%f", i];
    label.text = _radarManager.userId;
    
    [self startLocation];
    
}

-(void)uploadLocationWithUserLocation:(BMKUserLocation *)userLocation{
    BMKRadarUploadInfo *myinfo = [[BMKRadarUploadInfo alloc] init];
    myinfo.extInfo = @"hello,world";//扩展信息
    myinfo.pt = userLocation.location.coordinate;//我的地理坐标
    //上传我的位置信息
    BOOL res = [_radarManager uploadInfoRequest:myinfo];
    if (res) {
        NSLog(@"upload 成功");
        [self startRadarWithUserLocation:userLocation];
    } else {
        NSLog(@"upload 失败");
    }
}

-(void)startRadarWithUserLocation:(BMKUserLocation *)userLocation{
    BMKRadarNearbySearchOption *option = [[BMKRadarNearbySearchOption alloc] init]
    ;
    option.radius = 1000;//检索半径
    option.sortType = BMK_RADAR_SORT_TYPE_DISTANCE_FROM_NEAR_TO_FAR;//排序方式
    option.centerPt = userLocation.location.coordinate;//检索中心点
    //发起检索
    BOOL res = [_radarManager getRadarNearbySearchRequest:option];
    if (res) {
        NSLog(@"get 成功");
    } else {
        NSLog(@"get 失败");
    }
}

-(void)startLocation{
    //设置定位精确度，默认：kCLLocationAccuracyBest
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:100.f];
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    
    //启动LocationService
    [_locService startUserLocationService];
}

#pragma mark -- BMKLocationServiceDelegate
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    [_mapView setCenterCoordinate:userLocation.location.coordinate];
    
    [self uploadLocationWithUserLocation:userLocation];
}


- (void)onGetRadarNearbySearchResult:(BMKRadarNearbyResult *)result error:(BMKRadarErrorCode)error {
    NSLog(@"onGetRadarNearbySearchResult  %d", error);
    if (error == BMK_RADAR_NO_ERROR) {
        NSArray *infoList = [result infoList];
        for (BMKRadarNearbyInfo *info in infoList) {
            NSLog(@"userid : %@",  [info userId]);
            
        }
    }
    else if (error == BMK_RADAR_NO_RESULT){
        NSLog(@"BMK_RADAR_NO_RESULT");
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    
    [_radarManager removeRadarManagerDelegate:self];
    
    [BMKRadarManager releaseRadarManagerInstance];
    
    [_locService stopUserLocationService];
    
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
