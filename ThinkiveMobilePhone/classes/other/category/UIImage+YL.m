//
//  UIImage+YL.m
//  ThinkiveMobilePhone
//
//  Created by kill on 15/12/30.
//  Copyright © 2015年 kill. All rights reserved.
//

#import "UIImage+YL.h"

@implementation UIImage (YL)

-(instancetype) resize:(CGSize)size
{
    [self beginContextWithSize:size];
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizeImage;
}

- (instancetype)marginImage:(UIEdgeInsets)edge
{
    
    CGSize newSize = CGSizeMake(self.size.width+edge.left+edge.right, self.size.height+edge.top+edge.bottom);
    
    [self beginContextWithSize:newSize];
    [self drawInRect:CGRectMake(edge.left, edge.top, self.size.width, self.size.height)];
    UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *data  = UIImagePNGRepresentation(resizeImage);
    [data writeToFile:@"/Users/yulei/Downloads/1.png" atomically:YES];
    return resizeImage;
}

-(void)beginContextWithSize:(CGSize)size
{
    if([UIScreen mainScreen].scale == 2.0)
    {
        UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    }
    else
    {
        UIGraphicsBeginImageContext(size);
    }
}

@end
