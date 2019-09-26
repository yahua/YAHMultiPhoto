//
//  YAHMutiPhotoConfig.h
//  Pods-Demo
//
//  Created by yahua on 2019/9/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YAHMutiPhotoConfig : NSObject

@property (nonatomic, assign) BOOL saveToAlbum; //保存相册按钮，默认关闭

@property (nonatomic, assign) CGFloat durationAnimation;  //动画时长  default：0.3s

@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;
@property (nonatomic, strong) UIColor *pageIndicatorTintColor;

@end

NS_ASSUME_NONNULL_END
