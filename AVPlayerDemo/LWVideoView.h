//
//  LWVideoView.h
//  AVPlayerDemo
//
//  Created by LaoWen on 16/6/3.
//  Copyright © 2016年 LaoWen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

typedef void (^LayoutBlock)(MASConstraintMaker *make);

@interface LWVideoView : UIView

+ (Class)layerClass;

- (void)setPortraitLayout:(LayoutBlock)portraintBlock andLandscapelayout:(LayoutBlock)landscapeBlock;

@end
