//
//  AnnotationViewController.m
//  BMapDemo
//
//  Created by lh on 15/7/29.
//  Copyright (c) 2015年 lh. All rights reserved.
//

#import "AnnotationViewController.h"
#import <BaiduMapAPI/BMapKit.h>

@interface AnnotationViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate>
{
    BMKMapView *_mapView;
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_searcher;
}


@end

@implementation AnnotationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 100)];
    [self.view addSubview:mapView];
    _mapView = mapView;
    mapView.delegate = self;

    
    _mapView.zoomLevel = 15;
    
    _mapView.showsUserLocation = YES;
    
    [self addAnnotationWithLatitude:39.915 longitude:116.404];

}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    
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
