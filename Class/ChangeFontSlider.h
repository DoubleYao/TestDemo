//
//  ChangeFontSlider.h
//  SunshineNews
//
//  Created by yaoyao on 2018/4/2.
//  Copyright © 2018年 yaoyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeFontSlider : UIView

/**
 初始化滑块
 */
- (instancetype)initWithFrame:(CGRect)frame textArray:(NSArray *)titles;


@property(nonatomic, copy) void(^selectedBlock)(NSInteger index);
@end
