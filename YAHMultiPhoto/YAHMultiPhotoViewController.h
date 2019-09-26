//
//  YHMultiPhotoViewController.h
//  YHMultiPhotoViewController
//
//  Created by wangshiwen on 15/9/14.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YAHMutiZoomPhoto.h"
#import "YAHMutiPhotoConfig.h"

@class YAHMultiPhotoViewController;
@protocol YAHMultiPhotoViewControllerDelegate <NSObject>

- (void)willHideMultiPhotoView:(YAHMultiPhotoViewController *)vc currentIndex:(NSInteger)cuurentIndex;

- (void)didHideMultiPhotoView:(YAHMultiPhotoViewController *)vc currentIndex:(NSInteger)cuurentIndex;

@end

@interface YAHMultiPhotoViewController : UIViewController

@property (nonatomic, weak) id<YAHMultiPhotoViewControllerDelegate> delegate;

@property (nonatomic, strong) YAHMutiPhotoConfig *config;

/**
 *  无动画的弹出查看大图界面
 *
 *  @param largePhotos      大图数据（ZoomPhoto）
 *  @param thumbPhotos 小图数据（ZoomPhoto）
 *  @param index       显示第几张图 第一张为0
 */
- (id)initWithConfig:(YAHMutiPhotoConfig *)config largePhotos:(NSArray *)largePhotos thumbPhotos:(NSArray *)thumbPhotos selectIndex:(NSInteger)index;

/**
 *  有动画的弹出查看大图界面
 *
 *  @param largePhotos      大图数据（ZoomPhoto）
 *  @param thumbPhotos 小图数据（ZoomPhoto）
 *  @param frames      小图的初始位置
 *  @param index       显示第几张图 第一张为0
 */
- (id)initWithConfig:(YAHMutiPhotoConfig *)config largePhotos:(NSArray *)largePhotos thumbPhotos:(NSArray *)thumbPhotos originFrame:(NSArray *)frames selectIndex:(NSInteger)index;

/** 手动关闭 */
- (void)onclose;

@end
