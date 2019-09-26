//
//  YAHMutiPhotoConfig.m
//  Pods-Demo
//
//  Created by yahua on 2019/9/26.
//

#import "YAHMutiPhotoConfig.h"

@implementation YAHMutiPhotoConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        _saveToAlbum = NO;
        _durationAnimation = 0.3f;
    }
    return self;
}

@end
