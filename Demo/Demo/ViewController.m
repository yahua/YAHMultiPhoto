//
//  ViewController.m
//  Demo
//
//  Created by yahua on 16/5/17.
//  Copyright © 2016年 wangsw. All rights reserved.
//

#import "ViewController.h"

#import <YAHMultiPhoto/YAHMultiPhotoViewController.h>

@interface ViewController () <YAHMultiPhotoViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *frameList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *imageNames = @[@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg", @"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg"];
    CGFloat width = CGRectGetWidth(self.view.frame)/4;
    self.frameList = [NSMutableArray arrayWithCapacity:1];
    for (NSInteger i =0; i<8; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.tag = 1000 + i;
        imageView.frame = CGRectMake((i%4)*width, 20+(i/4)*200, width, width);
        imageView.userInteractionEnabled = YES;
        imageView.clipsToBounds = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tapped:)];
        [imageView addGestureRecognizer:tap];
        [self.view addSubview:imageView];
        
        NSValue *value = [NSValue valueWithCGRect:imageView.frame];
        [self.frameList addObject:value];
    }
}

- (void) Tapped:(UIGestureRecognizer *) gesture
{
    UIImageView *imageView = (UIImageView *)gesture.view;
    NSInteger selectIndex = imageView.tag - 1000;
    
    NSArray *imageNames = @[@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg", @"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg"];
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *thumbPhotos = [NSMutableArray arrayWithCapacity:1];
    for (NSString *imageName in imageNames) {
        UIImage *image = [UIImage imageNamed:imageName];
        [thumbPhotos addObject:[YAHMutiZoomPhoto photoWithImage:image]];
    }
    NSArray *urls = [NSArray arrayWithObjects:
                     @"http://image.baidu.com/search/down?tn=download&ipn=dwnl&word=download&ie=utf8&fr=result&url=http%3A%2F%2Fh.hiphotos.baidu.com%2Fimage%2Fw%253D310%2Fsign%3Dbc968ede9545d688a302b4a594c37dab%2F024f78f0f736afc3065a7888b419ebc4b645128c.jpg&thumburl=http%3A%2F%2Fh.hiphotos.baidu.com%2Fimage%2Fh%253D200%2Fsign%3De8dfbdc69a16fdfac76cc1ee848e8cea%2F738b4710b912c8fc8cfeb020fb039245d78821c9.jpg",
                     @"http://image.baidu.com/search/down?tn=download&ipn=dwnl&word=download&ie=utf8&fr=result&url=http%3A%2F%2Fimg14.poco.cn%2Fmypoco%2Fmyphoto%2F20130131%2F22%2F17323571520130131221457027_640.jpg&thumburl=http%3A%2F%2Fc.hiphotos.baidu.com%2Fimage%2Fh%253D200%2Fsign%3D7b991b465eee3d6d3dc680cb73176d41%2F96dda144ad3459829813ed730bf431adcaef84b1.jpg",
                     @"http://image.baidu.com/search/down?tn=download&ipn=dwnl&word=download&ie=utf8&fr=result&url=http%3A%2F%2Fimg.taopic.com%2Fuploads%2Fallimg%2F110906%2F1382-110Z611025585.jpg&thumburl=http%3A%2F%2Fb.hiphotos.baidu.com%2Fimage%2Fh%253D200%2Fsign%3D52b5924e8b5494ee982208191df4e0e1%2Fc2fdfc039245d6887554a155a3c27d1ed31b24e8.jpg",
                     @"http://image.baidu.com/search/down?tn=download&ipn=dwnl&word=download&ie=utf8&fr=result&url=http%3A%2F%2Fimg01.taopic.com%2F150920%2F240455-1509200H31810.jpg&thumburl=http%3A%2F%2Fe.hiphotos.baidu.com%2Fimage%2Fh%253D200%2Fsign%3D3ef3e55ee7fe9925d40c6e5004a95ee4%2F8694a4c27d1ed21b0a2ed37eaa6eddc450da3f41.jpg",
                     @"http://image.baidu.com/search/down?tn=download&ipn=dwnl&word=download&ie=utf8&fr=result&url=http%3A%2F%2Fimgst-dl.meilishuo.net%2Fpic%2F_o%2F84%2Fa4%2Fa30be77c4ca62cd87156da202faf_1440_900.jpg&thumburl=http%3A%2F%2Fimg3.imgtn.bdimg.com%2Fit%2Fu%3D1924893621%2C661118346%26fm%3D21%26gp%3D0.jpg",
                     @"http://image.baidu.com/search/down?tn=download&ipn=dwnl&word=download&ie=utf8&fr=result&url=http%3A%2F%2Fs2.nuomi.bdimg.com%2Fupload%2Fdeal%2F2014%2F1%2FV_L%2F623682-1391756281052.jpg&thumburl=http%3A%2F%2Fimg4.imgtn.bdimg.com%2Fit%2Fu%3D16705507%2C1328875785%26fm%3D21%26gp%3D0.jpg",
                     @"http://image.baidu.com/search/down?tn=download&ipn=dwnl&word=download&ie=utf8&fr=result&url=http%3A%2F%2Fimg.club.pchome.net%2Fkdsarticle%2F2013%2F11small%2F21%2Ffd548da909d64a988da20fa0ec124ef3_1000x750.jpg&thumburl=http%3A%2F%2Fimg4.imgtn.bdimg.com%2Fit%2Fu%3D3598461135%2C406107685%26fm%3D21%26gp%3D0.jpg",
                     @"http://image.baidu.com/search/down?tn=download&ipn=dwnl&word=download&ie=utf8&fr=result&url=http%3A%2F%2Fimg13.3lian.com%2F201312%2F04%2Fa290524b9c59f165b8d8ac87f7a4c0bf.jpg&thumburl=http%3A%2F%2Fimg5.imgtn.bdimg.com%2Fit%2Fu%3D1898795798%2C2798655787%26fm%3D21%26gp%3D0.jpg",
                     nil];
    for (NSString *url in urls) {
        NSURL *image = [NSURL URLWithString:url];
        [photos addObject:[YAHMutiZoomPhoto photoWithUrl:image]];
    }
    YAHMutiPhotoConfig *config = [YAHMutiPhotoConfig new];
    config.pageIndicatorTintColor = [UIColor whiteColor];
    config.currentPageIndicatorTintColor = [UIColor greenColor];
    YAHMultiPhotoViewController *vc = [[YAHMultiPhotoViewController alloc] initWithConfig:config largePhotos:photos thumbPhotos:thumbPhotos originFrame:nil selectIndex:selectIndex];
    vc.delegate = self;
    vc.config = config;
    
    [self presentViewController:vc animated:NO completion:nil];
}

#pragma mark - YAHMultiPhotoViewControllerDelegate

- (void)willHideMultiPhotoView:(YAHMultiPhotoViewController *)vc currentIndex:(NSInteger)cuurentIndex {
    
    NSLog(@"willHideMultiPhotoView cuurentIndex: %td",cuurentIndex);
}

- (void)didHideMultiPhotoView:(YAHMultiPhotoViewController *)vc currentIndex:(NSInteger)cuurentIndex {
    
    [vc dismissViewControllerAnimated:NO completion:nil];
    NSLog(@"didHideMultiPhotoView cuurentIndex: %td",cuurentIndex);
}

@end
