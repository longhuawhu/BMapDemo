//
//  CellInfor.m
//  BMapDemo
//
//  Created by lh on 15/7/29.
//  Copyright (c) 2015年 lh. All rights reserved.
//

#import "CellInfor.h"

@implementation CellInfor
+(instancetype)infoWithTitle:(NSString *)title viewController:(UIViewController *)viewController;
{
    CellInfor *info = [[CellInfor alloc] init];
    info.title = title;
    info.viewController = viewController;
    return info;
}
@end
