//
//  CellInfor.h
//  BMapDemo
//
//  Created by lh on 15/7/29.
//  Copyright (c) 2015年 lh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewController;
@interface CellInfor : NSObject
@property (nonatomic, retain)NSString *title;
@property (nonatomic, retain)UIViewController *viewController;

+(instancetype)infoWithTitle:(NSString *)title viewController:(UIViewController *)viewController;

@end
