//
//  LYCFlowLayout.m
//  无限轮播
//
//  Created by yuchen.li on 16/8/8.
//  Copyright © 2016年 zsc. All rights reserved.
//

#import "LYCFlowLayout.h"

@implementation LYCFlowLayout
{
    CGSize boundsSize;
    CGFloat midX;

}
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}
-(void)prepareLayout{
    [super prepareLayout];
    boundsSize=self.collectionView.bounds.size;
    midX=boundsSize.width/2.0f;
}
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray*array=[super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes*attributes in array) {
        CGPoint contentOffset=self.collectionView.contentOffset;
        CGFloat centerX=attributes.center.x-contentOffset.x;
        CGFloat space=midX-centerX;
        CGFloat distance=ABS(space);
        CGFloat normalized=distance/midX;
//        NSLog(@"当前item中心%f----偏移值%f-----距离%f-----比例%f",attributes.center.x,contentOffset.x,distance,normalized);
//        
        CGFloat zoom=1+0.2*(1-ABS(normalized));
        attributes.transform3D=CATransform3DMakeScale(zoom, zoom, 1.0f);
    }
    return array;
}

@end
