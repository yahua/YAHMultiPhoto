//
//  ZoomPhoto.h
//  YHMultiPhotoViewController
//
//  Created by wangshiwen on 15/9/14.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import <UIKit/UIKit.h>

// Notifications
#define MWPHOTO_LOADING_DID_END_NOTIFICATION @"MWPHOTO_LOADING_DID_END_NOTIFICATION"
#define MWPHOTO_PROGRESS_NOTIFICATION @"MWPHOTO_PROGRESS_NOTIFICATION"
#define MWPHOTO_FAIl_NOTIFICATION @"MWPHOTO_FAIl_NOTIFICATION"

@interface YAHMutiZoomPhoto : NSObject

@property (nonatomic, strong) UIImage *displayImage;
@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, copy, readonly) NSURL *photoUrl;

+ (YAHMutiZoomPhoto *)photoWithImage:(UIImage *)image;
+ (YAHMutiZoomPhoto *)photoWithUrl:(NSURL *)url;

- (id)initWithImage:(UIImage *)image;
- (id)initWithURL:(NSURL *)url;

- (void)downLoadDisplayImage;

@end
