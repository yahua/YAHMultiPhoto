//
//  ViewController.m
//  Demo
//
//  Created by yahua on 16/5/17.
//  Copyright © 2016年 wangsw. All rights reserved.
//

#import "ViewController.h"

#import "YAHMultiPhotoViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *frameList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *imageNames = @[@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg", @"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg"];
    self.frameList = [NSMutableArray arrayWithCapacity:1];
    for (NSInteger i =0; i<8; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.tag = 1000 + i;
        imageView.frame = CGRectMake((i%4)*80, 10+(i/4)*100, 80, 80);
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
                     @"http://d.hiphotos.baidu.com/image/pic/item/b58f8c5494eef01fa9b12dcbe2fe9925bc317d12.jpg",
                     @"http://a.hiphotos.baidu.com/image/pic/item/9f2f070828381f30c1a448a4ab014c086e06f07a.jpg",
                     @"http://a.hiphotos.baidu.com/image/pic/item/fd039245d688d43fb7be394a7f1ed21b0ef43b76.jpg",
                     @"http://static2.dmcdn.net/static/video/340/086/44680043:jpeg_preview_small.jpg?20120509180118",
                     @"http://static2.dmcdn.net/static/video/666/645/43546666:jpeg_preview_small.jpg?20120412153140",
                     @"http://static2.dmcdn.net/static/video/771/577/44775177:jpeg_preview_small.jpg?20120509183230",
                     @"http://static2.dmcdn.net/static/video/810/508/44805018:jpeg_preview_small.jpg?20120508125339",
                     @"http://static2.dmcdn.net/static/video/152/008/44800251:jpeg_preview_small.jpg?20120508103336",
                     nil];
    for (NSString *url in urls) {
        NSURL *image = [NSURL URLWithString:url];
        [photos addObject:[YAHMutiZoomPhoto photoWithUrl:image]];
    }
    YAHMultiPhotoViewController *vc = [[YAHMultiPhotoViewController alloc] initWithImage:photos thumbImage:thumbPhotos originFrame:self.frameList selectIndex:selectIndex];
    vc.dismissBlock = ^(YAHMultiPhotoViewController *multiCtr){
        [multiCtr dismissViewControllerAnimated:NO completion:nil];
    };
    
    [self presentViewController:vc animated:NO completion:nil];
}

@end
