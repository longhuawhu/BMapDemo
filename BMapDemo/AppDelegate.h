//
//  AppDelegate.h
//  BMapDemo
//
//  Created by lh on 15/7/23.
//  Copyright (c) 2015年 lh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  BMKMapManager;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BMKMapManager* _mapManager;
}

@property (strong, nonatomic) UIWindow *window;

@end

