//
//  ViewController.m
//  AVPlayerDemo
//
//  Created by LaoWen on 16/6/3.
//  Copyright © 2016年 LaoWen. All rights reserved.
//

#import "ViewController.h"
#import "LWVideoView.h"
#import "LWVideoPlayer.h"
#import "Masonry.h"

@interface ViewController ()

@end

@implementation ViewController
{
    LWVideoView *_videoView;
    LWVideoPlayer *_videoPlayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onDeviceOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    NSURL *videoUrl = [[NSBundle mainBundle]URLForResource:@"1.mp4" withExtension:nil];
    _videoView = [[NSBundle mainBundle]loadNibNamed:@"LWVideoView" owner:self options:nil][0];
    [self.view addSubview:_videoView];
    _videoPlayer = [[LWVideoPlayer alloc]initWithVideoView:_videoView andVideoUrl:videoUrl];
    __block typeof(self) weakSelf = self;
    [_videoView setPortraitLayout:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view.mas_left);
        make.top.mas_equalTo(weakSelf.view.mas_top).with.offset(40);
        make.right.mas_equalTo(weakSelf.view.mas_right);
        CGSize size = weakSelf.view.frame.size;
        CGFloat width = MIN(size.width, size.height);
        CGFloat height = MAX(size.width, size.height);
        height = width/height*width;//播放器的高度与宽度的比值与全屏是的从值相同。
        make.height.equalTo(@(height));
    } andLandscapelayout:^(MASConstraintMaker *make) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        CGFloat width = MAX(size.width, size.height);
        CGFloat height = MIN(size.width, size.height);
        
        make.width.equalTo(@(width));
        make.height.equalTo(@(height));
        make.center.equalTo([[[UIApplication sharedApplication]delegate] window]);
    }];
    [_videoPlayer play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)onDeviceOrientationChanged:(NSNotification *)notification {
    CGSize size = [UIScreen mainScreen].bounds.size;
    NSLog(@"width:%f, height:%f", size.width, size.height);
}

@end
