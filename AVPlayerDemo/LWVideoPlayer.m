//
//  LWVideoPlayer.m
//  AVPlayerDemo
//
//  Created by LaoWen on 16/6/3.
//  Copyright © 2016年 LaoWen. All rights reserved.
//

#import "LWVideoPlayer.h"
#import <AVFoundation/AVFoundation.h>

@implementation LWVideoPlayer
{
    AVPlayerItem *_avPlayerItem;
    AVPlayer *_avPlayer;
}

- (id)initWithVideoView:(UIView *)videoView andVideoUrl:(NSURL *)videoUrl {
    if (self = [super init]) {
        _avPlayerItem = [[AVPlayerItem alloc]initWithURL:videoUrl];
        _avPlayer = [[AVPlayer alloc]initWithPlayerItem:_avPlayerItem];
        [(AVPlayerLayer *)videoView.layer setPlayer: _avPlayer];//音频播放可以不要这个
        [self addObservers];
    }
    return self;
}

- (void)addObservers {
    //添加观察者最后一个参数的作用，nil观察者接收所有对象发现的通知，否则观察者只接收这个对象发出的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onVideoEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [_avPlayerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    [_avPlayerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    [_avPlayerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    [_avPlayerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    [_avPlayerItem addObserver:self forKeyPath:@"playbackBufferFull" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    [_avPlayerItem addObserver:self forKeyPath:@"presentationSize" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

- (void)onVideoEnd:(NSNotification *)notification {
    NSLog(@"onVideoEnd");
}

//KVO 播放信息
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        if (_avPlayerItem.status == AVPlayerItemStatusReadyToPlay) {
            CGFloat duration = _avPlayerItem.duration.value/_avPlayerItem.duration.timescale;
            NSLog(@"影片时长:%f", duration);
            [_avPlayer addPeriodicTimeObserverForInterval:CMTimeMake(5, 1) queue:nil usingBlock:^(CMTime time) {
                CGFloat currentTime = _avPlayerItem.currentTime.value/_avPlayerItem.currentTime.timescale;
                //NSLog(@"currentTime: %f", currentTime);
            }];
        } else if (_avPlayerItem.status == AVPlayerItemStatusFailed) {
            NSLog(@"无法播放");
        } else if (_avPlayerItem.status == AVPlayerItemStatusUnknown) {
            NSLog(@"未知错误");
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray *loadTimeRanges = _avPlayerItem.loadedTimeRanges;
        CMTimeRange timeRange = [loadTimeRanges[0] CMTimeRangeValue];
        CGFloat start = CMTimeGetSeconds(timeRange.start);
        CGFloat duration = CMTimeGetSeconds(timeRange.duration);
        NSLog(@"缓冲 start:%f, duration:%f", start, duration);
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        NSLog(@"KeepUp:%d", _avPlayerItem.playbackLikelyToKeepUp);
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
        NSLog(@"BufferEmpty");
    } else if ([keyPath isEqualToString:@"playbackBufferFull"]) {
        NSLog(@"BufferFull");
    } else if ([keyPath isEqualToString:@"presentationSize"]) {
        NSLog(@"得到视频大小:%@", NSStringFromCGSize(_avPlayerItem.presentationSize));
    }
}

- (void)play {
    [_avPlayer play];
}

- (void)pause {
    [_avPlayer pause];
}

@end
