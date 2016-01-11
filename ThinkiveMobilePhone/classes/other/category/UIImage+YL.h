//
//  UIImage+YL.h
//  ThinkiveMobilePhone
//
//  Created by kill on 15/12/30.
//  Copyright © 2015年 kill. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YL)
/**
 更改图片分辨率
 */
-(instancetype) resize:(CGSize)size;

-(instancetype) marginImage:(UIEdgeInsets)edge;

@end
