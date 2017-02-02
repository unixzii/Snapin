//
//  SPNImageView.m
//  Snapin
//
//  Created by 杨弘宇 on 2017/2/1.
//  Copyright © 2017年 杨弘宇. All rights reserved.
//

#import "SPNImageView.h"

@implementation SPNImageView

- (BOOL)mouseDownCanMoveWindow {
    return YES;
}

- (void)updateLayer {
    if (self.layer.contents) {
        return;
    }
    self.layer.contents = [self.image layerContentsForContentsScale:1];
}

- (BOOL)wantsUpdateLayer {
    return YES;
}

- (void)drawRect:(NSRect)dirtyRect {
    
}

@end
