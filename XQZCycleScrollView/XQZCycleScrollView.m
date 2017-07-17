//
//  XQZCycleScrollView.m
//  XQZCycleScrollView
//
//  Created by liwei on 2016/7/15.
//  Copyright © 2016年 PioneerLee. All rights reserved.
//

#import "XQZCycleScrollView.h"

@interface XQZCycleScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *contentView;        /**< 内容视图 */
@property (nonatomic, strong) UIImageView *leftImageView;       /**< 左边图片 */
@property (nonatomic, strong) UIImageView *middleImageView;     /**< 中间图片 */
@property (nonatomic, strong) UIImageView *rightImageView;      /**< 右边图片 */
@property (nonatomic, assign) NSInteger currentPageIndex;       /**< 当前页面索引 */
@property (nonatomic, weak) NSTimer *timer; /**< 定时器 */

@end

@implementation XQZCycleScrollView

#pragma mark - init method

+ (instancetype)xqz_cycleScrollViewWithFrame:(CGRect)frame {
    XQZCycleScrollView *cycleView = [[self alloc] initWithFrame:frame];
    return cycleView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setupConfig];
        _contentView = [[UIScrollView alloc] init];
        _contentView.frame = self.bounds;
        _contentView.contentSize = CGSizeMake(frame.size.width * 3, frame.size.height);
        _contentView.pagingEnabled = YES;
        _contentView.backgroundColor = [UIColor redColor];
        _contentView.contentOffset = CGPointMake(frame.size.width, 0);
        _contentView.delegate = self;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.bounces = NO;
        
        [_contentView addSubview:self.leftImageView];
        [_contentView addSubview:self.middleImageView];
        [_contentView addSubview:self.rightImageView];
        
        // 开启定时器
        [self startTimer];
        
        [self addSubview:_contentView];
    }
    
    return self;
}

/**
 设置默认初始值
 */
- (void)setupConfig {
    _isAutoCycle = YES;
    _currentPageIndex = 1;
    _timeInterval = 2;
}

#pragma mark - getter

- (UIImageView *)leftImageView {
    if (_leftImageView == nil) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.image = [UIImage imageNamed:@"h0.jpg"];
        _leftImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [_contentView addSubview:_leftImageView];
    }
    return _leftImageView;
}

- (UIImageView *)middleImageView {
    if (_middleImageView == nil) {
        _middleImageView = [[UIImageView alloc] init];
        _middleImageView.image = [UIImage imageNamed:@"h1.jpg"];
        _middleImageView.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        [_contentView addSubview:_middleImageView];
    }
    return _middleImageView;
}

- (UIImageView *)rightImageView {
    if (_rightImageView == nil) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.image = [UIImage imageNamed:@"h2.jpg"];
        _rightImageView.frame = CGRectMake(2 * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        [_contentView addSubview:_rightImageView];
    }
    return _rightImageView;
}

#pragma mark - setter

- (void)setIsAutoCycle:(BOOL)isAutoCycle {
    _isAutoCycle = isAutoCycle;
    
    if (!isAutoCycle) {
        [_timer invalidate];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // scrollView的偏移量
    CGPoint contentOffset = scrollView.contentOffset;
    
    if (contentOffset.x == 2 * scrollView.frame.size.width) {
        
        self.currentPageIndex++;
        
        [self updateImageWithScrollView:scrollView];
        
    } else if (contentOffset.x == 0) {
        
        self.currentPageIndex--;
        [self updateImageWithScrollView:scrollView];
    }
}

/**
 开始滑动 ScrollView 的时候调用

 @param scrollView 当前的 ScrollView
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if (self.isAutoCycle) { // 如果是自动轮播的话，在开始滑动前将定时器停掉，否则不需要处理
        
        // 停止定时器
        [self invalidateTimer];
    }
}

/**
 当 ScrollView 停止滑动的时候回调

 @param scrollView 当前的 ScrollView
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (self.isAutoCycle) { // 如果是自动轮播的话，每次结束滑动后自动开启定时器
        
        // 开启定时器
        [self startTimer];
    }
}

#pragma mark - private method

- (void)updateImageWithScrollView:(UIScrollView *)scrollView {
    
    NSInteger middlePageIndex = [self calculaeMiddlePageIndexWithCurrentPageIndex:self.currentPageIndex imageCount:3];
    NSInteger leftPageIndex = middlePageIndex - 1  < 0 ? 2 : middlePageIndex - 1;
    NSInteger rightPageIndex = middlePageIndex + 1 > 2 ? 0 : middlePageIndex + 1;
    
    NSString *middleStr = [NSString stringWithFormat:@"h%ld.jpg",middlePageIndex];
    NSString *leftStr = [NSString stringWithFormat:@"h%ld.jpg",leftPageIndex];
    NSString *rightStr = [NSString stringWithFormat:@"h%ld.jpg",rightPageIndex];
    
    scrollView.contentOffset = CGPointMake(scrollView.frame.size.width, 0);
    
    _leftImageView.image = [UIImage imageNamed:leftStr];
    _middleImageView.image = [UIImage imageNamed:middleStr];
    _rightImageView.image = [UIImage imageNamed:rightStr];
    
}

- (NSInteger)calculaeMiddlePageIndexWithCurrentPageIndex:(NSInteger)currentPageIndex imageCount:(NSInteger)count {
    NSInteger pageIndex = 0;
    
    // 这种写法直观
//    if (currentPageIndex >= 0) {
//        pageIndex = currentPageIndex % count;
//    } else {
//        pageIndex = currentPageIndex % count == 0 ? currentPageIndex % count : (currentPageIndex % count + count);
//    }
    
    // 这种写法简洁
    pageIndex = currentPageIndex % count >= 0 ? currentPageIndex % count : (currentPageIndex % count + count);
    
    return pageIndex;
}

/**
 改变 ScrollView 的偏移量
 */
- (void)changedScorllViewContentOffset {
    [self.contentView setContentOffset:CGPointMake(2 * self.contentView.frame.size.width, 0) animated:YES];
}

/**
 开启定时器
 */
- (void)startTimer {
    // 默认开启定时器轮播图片
    _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(changedScorllViewContentOffset) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

/**
 销毁定时器
 */
- (void)invalidateTimer {
    [_timer invalidate];
}

@end
