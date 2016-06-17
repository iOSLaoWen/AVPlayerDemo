//
//  LWVideoPlayer.h
//  AVPlayerDemo
//
//  Created by LaoWen on 16/6/3.
//  Copyright © 2016年 LaoWen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LWVideoPlayer : NSObject

- (id)initWithVideoView:(UIView *)videoView andVideoUrl:(NSURL *)videoUrl;

- (void)play;

- (void)pause;

@end
