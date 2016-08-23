//
//  LYCWaveView.m
//  无限轮播
//
//  Created by yuchen.li on 16/8/8.
//  Copyright © 2016年 zsc. All rights reserved.
//

#import "LYCWaveView.h"

@implementation LYCWaveView
{
 CADisplayLink *_link;
 CGFloat _offset;
 CAShapeLayer *_layer;
 CAShapeLayer *_layer2;
 CGFloat _waveWidth;
 CGFloat _h;
}
-(instancetype)initWithFrame:(CGRect)frame WithSpeed:(CGFloat)speed WithWaveHeight:(CGFloat)waveHeight WithH:(CGFloat)h

{
    if (self=[super initWithFrame:frame]) {
        _speed=speed;
        _h=h;
        _waveHeight=waveHeight;
        [self setUp];
    }
    return self;
}
-(void)setUp{
    _waveWidth=self.frame.size.width;
    _layer=[CAShapeLayer layer];
    _layer.frame=self.bounds;
    _layer.opacity=1;
    [self.layer addSublayer:_layer];
}
-(void)wave{
    _link=[CADisplayLink displayLinkWithTarget:self selector:@selector(beginAnimation)];
    [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];

}
-(void)stop{
    [_link invalidate];
    _link=nil;

}
-(void)beginAnimation{
    _offset+=_speed;
    CGMutablePathRef pathRef=CGPathCreateMutable();
    CGFloat startY=_waveHeight*sinf(_offset*M_PI/_waveWidth);
    CGPathMoveToPoint(pathRef, NULL, 0, startY);
    for (int i=0; i<_waveWidth; i++) {
       CGFloat y =_waveHeight*sinf(2.5*M_PI*i/_waveWidth + _offset*M_PI/_waveWidth) + _h;
        CGPathAddLineToPoint(pathRef, NULL, i, y);
    }
    CGPathAddLineToPoint(pathRef, NULL, _waveWidth, 40);
    CGPathAddLineToPoint(pathRef, NULL, 0, 40);
    CGPathCloseSubpath(pathRef);
    
    _layer.path=pathRef;
    _layer.fillColor=[UIColor blueColor].CGColor;
    CGPathRelease(pathRef);

}
@end
