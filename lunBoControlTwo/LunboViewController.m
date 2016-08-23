//
//  ViewController.m
//  无限轮播
//
//  Created by yuchen.li on 16/8/8.
//  Copyright © 2016年 zsc. All rights reserved.
//

#import "LunboViewController.h"
#import "LYCFlowLayout.h"
#import "LYCWaveView.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
@interface LunboViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)  NSMutableArray*imageArray;
@property (nonatomic , strong) NSTimer *timer;
@property (nonatomic, strong)LYCWaveView *waveView;


@end

@implementation LunboViewController
{
    UICollectionView* _collectionView;
    UIPageControl*_pageControl;

}
-(NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray=[[NSMutableArray alloc]init];
    }
    return _imageArray;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    LYCFlowLayout*flowLayOut=[[LYCFlowLayout alloc]init];
    flowLayOut.itemSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, 200);
    flowLayOut.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    flowLayOut.minimumLineSpacing=0;

    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 200) collectionViewLayout:flowLayOut];
    [_collectionView  registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewCell"];
    _collectionView.dataSource=self;
    _collectionView.delegate=self;
    _collectionView.showsVerticalScrollIndicator=NO;
    _collectionView.pagingEnabled=YES;
    _collectionView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_collectionView];
    for (NSUInteger i=0; i<8; i++) {
        NSString *bundlePath = [[NSBundle bundleForClass:[LunboViewController class]] pathForResource:@"MyImage.bundle" ofType:nil];
        NSString*imageName=[NSString stringWithFormat:@"fj%ld.jpg",i+1];
        NSBundle *myBundle= [NSBundle bundleWithPath:bundlePath];
       NSString*localStr=[ myBundle pathForResource:imageName ofType:nil];
        
        UIImage*image=[UIImage imageWithContentsOfFile:localStr];
        [self.imageArray addObject:image];
        
    }
    LYCWaveView*waveView=[[LYCWaveView alloc]initWithFrame:CGRectMake(0, 224, SCREEN_WIDTH, 40) WithSpeed:2 WithWaveHeight:10 WithH:20];
    self.waveView=waveView;
    
    [self.view addSubview:self.waveView];
    
  
    
    _pageControl=[[UIPageControl alloc]init];
    _pageControl.center=CGPointMake(SCREEN_WIDTH*0.5, 160+64);
    _pageControl.bounds=CGRectMake(0, 0, 150, 4);
    _pageControl.numberOfPages=self.imageArray.count;
    _pageControl.pageIndicatorTintColor=[UIColor yellowColor];
    _pageControl.currentPageIndicatorTintColor=[UIColor purpleColor];
    [self.view addSubview:_pageControl];
    [self setUpTimer];
    
    

}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
     NSInteger index= _collectionView.contentOffset.x/SCREEN_WIDTH;
    _pageControl.currentPage=index;

}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self timerPause];
    
    

}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self timerBegin];
    _collectionView.layer.zPosition=50;
    _pageControl.layer.zPosition=50;
    self.waveView.layer.zPosition=100;
   [self.waveView  wave];
    

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.waveView stop];
      
        self.waveView.layer.zPosition=50;
        _collectionView.layer.zPosition=100;
        _pageControl.layer.zPosition=100;
    });
  
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"%ld",self.imageArray.count);
    return self.imageArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 200)];
    imageView.image=self.imageArray[indexPath.item];
    cell.backgroundView=imageView;
    return cell;
}
#pragma mark-添加计时器
-(void)setUpTimer{
    NSTimer*timer=[NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(nextpage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer=timer;
}
-(void)timerBegin{
    [self.timer setFireDate:[NSDate distantPast]];
}
-(void)timerPause{
    [self.timer setFireDate:[NSDate distantFuture]];

}
-(void)nextpage{
    
    NSIndexPath*currentIndexPath=[_collectionView indexPathsForVisibleItems].lastObject;
    NSIndexPath*currentIndexPathReset=[NSIndexPath indexPathForItem:currentIndexPath.row inSection:0];
    [_collectionView scrollToItemAtIndexPath:currentIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    NSInteger nextItem=currentIndexPathReset.item+1;
    NSInteger nextSection=currentIndexPathReset.section;
    if (nextItem==self.imageArray.count) {
        nextItem=0;
    }
    NSIndexPath*nextIndexPath=[NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    [_collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];

}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
