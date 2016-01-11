//
//  YLNumberButton.h
//  ThinkiveMobilePhone
//
//  Created by kill on 15/12/30.
//  Copyright © 2015年 kill. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YLNumberButton;
@protocol YLNumberButtonDelegate <NSObject>
    @optional
    -(void)numberButtonClick:(YLNumberButton *)button;
    -(void)numberButtonLongPress:(YLNumberButton*)button;
@end
@interface YLNumberButton : UIButton
@property(nonatomic,weak) id<YLNumberButtonDelegate> delegate;
@end
