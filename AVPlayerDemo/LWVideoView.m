//
//  LWVideoView.m
//  AVPlayerDemo
//
//  Created by LaoWen on 16/6/3.
//  Copyright © 2016年 LaoWen. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "LWVideoView.h"

@interface LWVideoView()

@property (nonatomic, copy)LayoutBlock portraitLayoutBlock;
@property (nonatomic, copy)LayoutBlock landscapeLayoutBlock;

@end

@implementation LWVideoView
{
    BOOL _isFullScreen;
    UIView *_theSuperView;
    BOOL _isInitialLandscape;//是不是一上来就横屏
    UIDeviceOrientation _lastDeviceOrientation;
}

- (void)awakeFromNib {
    _isInitialLandscape = NO;
    _lastDeviceOrientation = UIDeviceOrientationUnknown;
    _isFullScreen = NO;
    //self.view这个是只读属性，KVO不起作用，怎么解？
    
    //官方文档说必须先调这个，本人发现不调好像也没事
    [[UIDevice currentDevice]beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onDeviceOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[UIDevice currentDevice]endGeneratingDeviceOrientationNotifications];
}

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (IBAction)onBtnFullScreenClicked:(id)sender {
    if (!_isFullScreen) {
        [self enterFullScreen];
        _isFullScreen = YES;
    } else {
        [self exitFullScreen];
        _isFullScreen = NO;
    }
}

- (void)setPortraitLayout:(LayoutBlock)portraintBlock andLandscapelayout:(LayoutBlock)landscapeBlock {
    self.portraitLayoutBlock = portraintBlock;
    self.landscapeLayoutBlock = landscapeBlock;
    [self toOrientation];
}

- (void)onDeviceOrientationChanged:(NSNotification *)notification {
    //CGSize size = [UIScreen mainScreen].bounds.size;
    //NSLog(@"width:%f, height:%f", size.width, size.height);
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    switch (deviceOrientation) {
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"UIDeviceOrientationLandscapeRight");
            break;
        case UIDeviceOrientationLandscapeLeft:
            NSLog(@"UIDeviceOrientationLandscapeLeft");
            break;
        case UIDeviceOrientationPortrait:
            NSLog(@"UIDeviceOrientationPortrait");
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"UIDeviceOrientationPortraitUpsideDown");
            break;
        default:
            NSLog(@"其它方向");
            break;
    }
    if (_lastDeviceOrientation == UIDeviceOrientationUnknown && (deviceOrientation == UIDeviceOrientationLandscapeLeft || deviceOrientation == UIDeviceOrientationLandscapeRight)) {
        _isInitialLandscape = YES;
    }
    _lastDeviceOrientation = deviceOrientation;
    
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    //NSLog(@"orientation:%d, %d", deviceOrientation, interfaceOrientation);
    
    
    switch (deviceOrientation) {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
        case UIDeviceOrientationLandscapeRight:
        case UIDeviceOrientationLandscapeLeft:
            [self toOrientation];
            [[UIApplication sharedApplication]setStatusBarOrientation:deviceOrientation animated:YES];
            break;
            
        default:
            break;
    }
}

- (void)toOrientation {
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    switch (deviceOrientation) {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
            [self exitFullScreen];
            break;
            
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            [self enterFullScreen];
            break;
            
        default:
            break;
    }
}

- (void)enterFullScreen {
    _theSuperView = self.superview;
    [self removeFromSuperview];
    [[[[UIApplication sharedApplication]delegate]window]addSubview:self];
    [self mas_remakeConstraints:self.landscapeLayoutBlock];
    /*
     UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice]orientation];
     if (deviceOrientation == UIDeviceOrientationLandscapeLeft) {
     self.transform = CGAffineTransformMakeRotation(-M_PI_2);
     } else if (deviceOrientation == UIDeviceOrientationLandscapeRight) {
     self.transform = CGAffineTransformMakeRotation(M_PI_2);
     } else {
     self.transform = CGAffineTransformIdentity;
     }*/
    //如果一上来就是横屏，不能做这个transfrom，否则要做transform
    if (!_isInitialLandscape) {
        self.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }
}

- (void)exitFullScreen {
    if (_theSuperView) {
        [self removeFromSuperview];
        [_theSuperView addSubview:self];
    }
    
    self.transform = CGAffineTransformIdentity;
    [self mas_remakeConstraints:self.portraitLayoutBlock];
}


@end
