//
//  SPNAutoScaleScrollView.m
//  Snapin
//
//  Created by 杨弘宇 on 2017/2/6.
//  Copyright © 2017年 杨弘宇. All rights reserved.
//

#import "SPNAutoScaleScrollView.h"

@interface SPNAutoScaleScrollView () {
    BOOL _shouldAutoScale;
}

@end

@implementation SPNAutoScaleScrollView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _shouldAutoScale = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollViewWillStartLiveMagnify:) name:NSScrollViewWillStartLiveMagnifyNotification object:self];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layout {
    if (_shouldAutoScale) {
        self.magnification = CGRectGetWidth(self.bounds) / CGRectGetWidth(self.contentView.documentView.bounds);
    }
}

- (void)scrollViewWillStartLiveMagnify:(NSNotification *)notification {
    _shouldAutoScale = NO;
}

@end
