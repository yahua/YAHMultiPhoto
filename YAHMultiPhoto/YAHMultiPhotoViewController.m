//
//  YHMultiPhotoViewController.m
//  YHMultiPhotoViewController
//
//  Created by wangshiwen on 15/9/14.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import "YAHMultiPhotoViewController.h"
#import "YAHMutiZoomView.h"

#import <Photos/Photos.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <YAHBaseKit/YAHBaseKit.h>
#import <YAHUIKit/YAHUIKit.h>


#define TOOLbAR_HEIGHT  44.0

typedef NS_ENUM(NSUInteger, ScrollDirection) {
    LEFT,
    RIGHT,
};

@interface YAHMultiPhotoViewController () <
UIScrollViewDelegate>

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) YAHMutiZoomView *prevView;
@property (nonatomic, strong) YAHMutiZoomView *centerView;
@property (nonatomic, strong) YAHMutiZoomView *nextView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSMutableArray *largePhotoList;
@property (nonatomic, strong) NSMutableArray *thumbPhotoList;
@property (nonatomic, strong) NSMutableArray *frameList;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation YAHMultiPhotoViewController

- (void)dealloc
{
    
}

- (id)initWithConfig:(YAHMutiPhotoConfig *)config largePhotos:(NSArray *)largePhotos thumbPhotos:(NSArray *)thumbPhotos selectIndex:(NSInteger)index {
    
    return [self initWithConfig:config largePhotos:largePhotos thumbPhotos:thumbPhotos originFrame:nil selectIndex:index];
}

- (id)initWithConfig:(YAHMutiPhotoConfig *)config largePhotos:(NSArray *)largePhotos thumbPhotos:(NSArray *)thumbPhotos originFrame:(NSArray *)frames selectIndex:(NSInteger)index {
    
    self = [super init];
    if (self) {
        if (largePhotos && thumbPhotos) {
            _largePhotoList = [NSMutableArray arrayWithArray:largePhotos];
            _thumbPhotoList = [NSMutableArray arrayWithArray:thumbPhotos];
        }
        if (frames) {
            _frameList = [NSMutableArray arrayWithArray:frames];
        }
        _currentIndex = index;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveToAlbumAction:)];
    [self.view addGestureRecognizer:longPressGestureRecognizer];
    
    [self refreshUI];
}

- (BOOL)prefersStatusBarHidden {
    
    return YES;
}

//只支持竖屏
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationPortrait;
//}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetX = [self.scrollView contentOffset].x;
    CGFloat width = self.scrollView.frame.size.width;
    
    if (offsetX <= 0 ) {
        [self moveToDirection:RIGHT];
    } else if (offsetX >= width*2){
        [self moveToDirection:LEFT];
    }
}

#pragma mark - Action

- (void)startAnimation {
    
    if (self.frameList.count>0) {
        self.maskView.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.maskView.alpha = 1.0;
            [self.centerView rechangeNormalRdct];
        } completion:nil];
    }else {
        self.view.alpha = 0;
        self.maskView.alpha = 0;
        [self.centerView rechangeNormalRdct];
        [UIView animateWithDuration:0.2 animations:^{
            self.view.alpha = 1.0;
            self.maskView.alpha = 1.0;
        } completion:^(BOOL finished) {
            NSLog(@"");
        }];
    }
}

- (void)onclose {
    
    if ([self.delegate respondsToSelector:@selector(willHideMultiPhotoView:currentIndex:)]) {
        [self.delegate willHideMultiPhotoView:self currentIndex:self.currentIndex];
    }
    
    if (self.frameList) {
        [self.centerView resumeZoomScale];
        [UIView animateWithDuration:_config.durationAnimation animations:^{
            self.maskView.alpha = 0;
            [self.centerView rechangeInitRdct];
        } completion:^(BOOL finished) {
            if ([self.delegate respondsToSelector:@selector(didHideMultiPhotoView:currentIndex:)]) {
                [self.delegate didHideMultiPhotoView:self currentIndex:self.currentIndex];
            }
        }];
    }else {//无动画
        [UIView animateWithDuration:0.1 animations:^{
            self.view.alpha = 0;
        } completion:^(BOOL finished) {
            if ([self.delegate respondsToSelector:@selector(didHideMultiPhotoView:currentIndex:)]) {
                [self.delegate didHideMultiPhotoView:self currentIndex:self.currentIndex];
            }
        }];
    }
}

- (void)saveToAlbumAction:(UILongPressGestureRecognizer*)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self actionSheetWithTitle:@"" buttons:@[@"保存图片"] showInView:self.view onDismiss:^(NSInteger buttonIndex) {
            YAHMutiZoomPhoto *photo = [self.largePhotoList objectAtIndex:self.currentIndex];
            UIImage *image = [photo displayImage];
            [self saveImageToAblum:image];
        } onCancel:^{
            
        }];
    }
}

- (void)saveImageToAblum:(UIImage *)image {
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        NSData *data = UIImageJPEGRepresentation(image, 1);
        [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:data options:[PHAssetResourceCreationOptions new]];
    } completionHandler:^(BOOL success, NSError * _Nullable error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *tips =  error?@"保存图片失败":@"保存图片成功";
            [MBProgressHUD showTextOnlyHUD:tips];
        });
    }];
}

#pragma mark - Private

- (void)refreshUI {
    
    if ([self.largePhotoList count] == 0) {
        return;
    }else {
        [self reSetSubView:self.centerView photoIndex:self.currentIndex];
        //动画效果
        [self.centerView rechangeInitRdct];
        [self performSelector:@selector(startAnimation) withObject:nil afterDelay:0.1f];
    }
    
    if ([self.largePhotoList count] > 1) {
        
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width*3, self.scrollView.frame.size.height)];
        
        [self reSetSubView:self.prevView photoIndex:[self getPreIndex]];
        [self reSetSubView:self.nextView photoIndex:[self getNextIndex]];
        
        [self resetFrame];
    } else {
        self.centerView.frame = self.scrollView.bounds;
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    }
}

- (void)moveToDirection:(ScrollDirection)dir {
    
    YAHMutiZoomView *temp  = nil;
    if (dir == LEFT) {
        
        temp  = self.prevView;
        self.prevView = self.centerView;
        self.centerView = self.nextView;
        self.nextView = temp;
        
        self.currentIndex = [self getNextIndex];
        [self reSetSubView:self.nextView photoIndex:[self getNextIndex]];
    } else if (dir == RIGHT) {
        
        temp = self.nextView;
        self.nextView = self.centerView;
        self.centerView = self.prevView;
        self.prevView = temp;
        
        self.currentIndex = [self getPreIndex];
        [self reSetSubView:self.prevView photoIndex:[self getPreIndex]];
    }
    [self.prevView resumeZoomScale];
    [self.nextView resumeZoomScale];
    
    [self resetFrame];
}

- (void)reSetSubView:(YAHMutiZoomView *)pageView photoIndex:(NSInteger )index {
    
    if (index<0 || index>= self.largePhotoList.count) {
        return;
    }

    CGRect originFrame = CGRectZero;
    if (self.frameList) {
        originFrame = [[self.frameList objectAtIndex:index] CGRectValue];
    }
    [pageView reloadUIWithPhoto:[self.largePhotoList objectAtIndex:index] thumbPhoto:[self.thumbPhotoList objectAtIndex:index] initFrame:originFrame];
}

- (void)resetFrame {
    
    if ([self.largePhotoList count] >1) {
        
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = 0;
        [self.prevView setFrame:frame];
        
        frame.origin.x = self.scrollView.frame.size.width;
        [self.centerView setFrame:frame];
        
        frame.origin.x = self.scrollView.frame.size.width*2;
        [self.nextView setFrame:frame];
        
        CGPoint point = CGPointMake(self.scrollView.frame.size.width, 0);
        [self.scrollView setContentOffset:point];
    }
}

- (NSInteger)getNextIndex {
    
    NSInteger index = self.currentIndex +1;
    
    if (index == [self.largePhotoList count]) {
        index = 0;
    }
    
    return index;
}

- (NSInteger)getPreIndex {
    
    NSInteger index = self.currentIndex -1;
    
    if (index < 0) {
        index = [self.largePhotoList count] -1;
    }
    
    return index;
}

#pragma mark - Custom Accessors

- (UIView *)maskView {
    
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.view.bounds];
        _maskView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0;
    }
    return _maskView;
}

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
        [_scrollView setDelegate:self];
        [_scrollView setPagingEnabled:YES];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        
        self.prevView = [[YAHMutiZoomView alloc] initWithFrame:self.scrollView.bounds];
        self.prevView.multiPhotoViewCtl = self;
        [_scrollView addSubview:self.prevView];
        
        self.centerView = [[YAHMutiZoomView alloc] initWithFrame:self.scrollView.bounds];
        self.centerView.multiPhotoViewCtl = self;
        [_scrollView addSubview:self.centerView];
        
        self.nextView = [[YAHMutiZoomView alloc] initWithFrame:self.scrollView.bounds];
        self.nextView.multiPhotoViewCtl = self;
        [_scrollView addSubview:self.nextView];
    }
    return _scrollView;
}

- (YAHMutiZoomView *)prevView {
    
    if (!_prevView) {
        _prevView = [[YAHMutiZoomView alloc] initWithFrame:self.scrollView.bounds];
        _prevView.multiPhotoViewCtl = self;
        [self.scrollView addSubview:_prevView];
    }
    
    return _prevView;
}

- (YAHMutiZoomView *)centerView {
    
    if (!_centerView) {
        _centerView = [[YAHMutiZoomView alloc] initWithFrame:self.scrollView.bounds];
        _centerView.multiPhotoViewCtl = self;
        [self.scrollView addSubview:_centerView];
    }
    
    return _centerView;
}

- (YAHMutiZoomView *)nextView{
    
    if (!_nextView) {
        _nextView = [[YAHMutiZoomView alloc] initWithFrame:self.scrollView.bounds];
        _nextView.multiPhotoViewCtl = self;
        [self.scrollView addSubview:_nextView];
    }
    
    return _nextView;
}

- (UIPageControl *)pageControl {
    
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, YAH_SCREEN_SIZE_WIDTH, YAH_SCALE_ZOOM(18))];
        _pageControl.center = CGPointMake(YAH_SCREEN_SIZE_WIDTH/2, YAH_SCREEN_SIZE_HEIGHT-YAH_HOME_INDICATOR_HEIGHT-30);
        _pageControl.pageIndicatorTintColor = _config.pageIndicatorTintColor;
        _pageControl.currentPageIndicatorTintColor = _config.currentPageIndicatorTintColor;
        _pageControl.userInteractionEnabled = NO;
        _pageControl.hidesForSinglePage = YES;
        _pageControl.numberOfPages = self.largePhotoList.count;
        _pageControl.currentPage = self.currentIndex;
    }
    return _pageControl;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    
    _currentIndex = currentIndex;
    self.pageControl.currentPage = currentIndex;
}

@end
