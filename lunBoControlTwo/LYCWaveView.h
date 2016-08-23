//
//  LYCWaveView.h
//  无限轮播
//
//  Created by yuchen.li on 16/8/8.
//  Copyright © 2016年 zsc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYCWaveView : UIView
@property (nonatomic, assign) CGFloat speed;
@property (nonatomic, assign) CGFloat waveHeight;

- (void)wave;
- (void)stop;
-(instancetype)initWithFrame:(CGRect)frame WithSpeed:(CGFloat)speed WithWaveHeight:(CGFloat)waveHeight WithH:(CGFloat)h;
@end
