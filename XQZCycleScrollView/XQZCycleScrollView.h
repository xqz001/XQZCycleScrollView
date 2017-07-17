//
//  XQZCycleScrollView.h
//  XQZCycleScrollView
//
//  Created by liwei on 2016/7/15.
//  Copyright © 2016年 PioneerLee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XQZCycleScrollView : UIView

@property (nonatomic, assign) BOOL isAutoCycle; /**< 是否自动轮播 */
@property (nonatomic, assign) NSTimeInterval timeInterval; /**< 轮播图的时间间隔 */

+ (instancetype)xqz_cycleScrollViewWithFrame:(CGRect)frame;

@end
