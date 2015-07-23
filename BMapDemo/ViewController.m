//
//  ViewController.m
//  BMapDemo
//
//  Created by lh on 15/7/23.
//  Copyright (c) 2015年 lh. All rights reserved.
//

#import "ViewController.h"
#import <BaiduMapAPI/BMapKit.h>

@interface ViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>
{
    BMKMapView *_mapView;
    BMKLocationService *_locService;
    
    BMKGeoCodeSearch *_searcher;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 100)];
    [self.view addSubview:mapView];
    _mapView = mapView;
    mapView.delegate = self;
    
    [self startLocation];
    
    _mapView.zoomLevel = 15;
    
    _mapView.showsUserLocation = YES;
   
    
    [self addAnnotationWithLatitude:39.915 longitude:116.404];
    
    
    NSLog(@"viewDidLoad");
    
    [self startReverseSearch];
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
#pragma mark -- annotation
-(void)addAnnotationWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude{
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = latitude;
    coor.longitude = longitude;
    annotation.coordinate = coor;
    annotation.title = @"这里是北京";
    
    [_mapView addAnnotation:annotation];
}

-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        newAnnotationView.image = [UIImage imageNamed:@"map"];
        
        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
        customView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
        imageView.image = [UIImage imageNamed:@"Head"];
        [customView addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 80, 20)];
        [customView addSubview:titleLabel];
        [titleLabel setFont:[UIFont systemFontOfSize:13]];
        titleLabel.text = @"绿茶餐厅";
        
        UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, 80, 20)];
        
        subTitleLabel.text = @"现磨咖啡店";
        [subTitleLabel setFont:[UIFont systemFontOfSize:13]];
        [customView addSubview:subTitleLabel];
        
        BMKActionPaopaoView *paopaoView = [[BMKActionPaopaoView  alloc] initWithCustomView:customView];
        newAnnotationView.paopaoView = paopaoView;
        
        [newAnnotationView setDraggable:YES];
        
        newAnnotationView.enabled3D = YES;
    
        return newAnnotationView;
    }
    return nil;
}


-(void)viewWillDisappear:(BOOL)animated
{
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
