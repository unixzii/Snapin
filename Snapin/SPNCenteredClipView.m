//
//  SPNCenteredClipView.m
//  Snapin
//
//  Created by 杨弘宇 on 2017/2/1.
//  Copyright © 2017年 杨弘宇. All rights reserved.
//

#import "SPNCenteredClipView.h"

@implementation SPNCenteredClipView

- (void)layout {
    NSView *docView = self.documentView;
    self.documentView.frame = CGRectMake((CGRectGetWidth(self.bounds) - CGRectGetWidth(docView.bounds)) / 2, (CGRectGetHeight(self.bounds) - CGRectGetHeight(docView.bounds)) / 2, CGRectGetWidth(docView.bounds), CGRectGetHeight(docView.bounds));
    self.documentView.frame = CGRectMake(0, 0, CGRectGetWidth(docView.bounds), CGRectGetHeight(docView.bounds));
}

- (NSRect)constrainBoundsRect:(NSRect)proposedBounds {
    NSRect rect = [super constrainBoundsRect:proposedBounds];
    NSRect docViewRect = self.documentView.bounds;
    
    if (rect.size.width > docViewRect.size.width) {
        rect.origin.x = (docViewRect.size.width - rect.size.width) / 2;
    }
    
    if (rect.size.height > docViewRect.size.height) {
        rect.origin.y = (docViewRect.size.height - rect.size.height) / 2;
    }
    
    return rect;
}

@end
