//
//  SPNCropView.m
//  Snapin
//
//  Created by 杨弘宇 on 2017/1/31.
//  Copyright © 2017年 杨弘宇. All rights reserved.
//

#import "SPNCropView.h"

@interface SPNCropView () {
    NSRect _cropRect;
    BOOL _isDragResizing;
    NSPoint _mouseDownPos;
    NSTrackingArea *_activeTrackingArea;
}

@end

@implementation SPNCropView

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _cropRect = NSZeroRect;
    _activeTrackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingActiveAlways | NSTrackingEnabledDuringMouseDrag | NSTrackingMouseMoved | NSTrackingAssumeInside owner:self userInfo:nil];
    [self addTrackingArea:_activeTrackingArea];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    CGContextRef context = [NSGraphicsContext currentContext].CGContext;
    
    BOOL cropRectValid = !(_cropRect.size.width == 0 || _cropRect.size.height == 0);
    
    // Draw the dim layer.
    NSBezierPath *path = [NSBezierPath bezierPath];
    if (!cropRectValid) {
        [path appendBezierPathWithRect:self.bounds];
    } else {
        [path appendBezierPathWithRect:NSMakeRect(0, 0, CGRectGetWidth(self.bounds), CGRectGetMinY(_cropRect))];
        [path appendBezierPathWithRect:NSMakeRect(0, CGRectGetMaxY(_cropRect), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - CGRectGetMaxY(_cropRect))];
        [path appendBezierPathWithRect:NSMakeRect(0, CGRectGetMinY(_cropRect), CGRectGetMinX(_cropRect), CGRectGetHeight(_cropRect))];
        [path appendBezierPathWithRect:NSMakeRect(CGRectGetMaxX(_cropRect), CGRectGetMinY(_cropRect), CGRectGetWidth(self.bounds) - CGRectGetMaxX(_cropRect), CGRectGetHeight(_cropRect))];
    }
    CGContextSetFillColorWithColor(context, [NSColor colorWithWhite:0 alpha:0.6].CGColor);
    [path fill];
    
    // Draw the frame layer.
    if (cropRectValid) {
        CGContextSetStrokeColorWithColor(context, [NSColor blackColor].CGColor);
        CGFloat lengths[] = { 4, 4 };
        CGContextSetLineDash(context, 0, lengths, 2);
        [[NSBezierPath bezierPathWithRect:CGRectInset(_cropRect, 1, 1)] stroke];
    }
}

- (void)updateTrackingAreas {
    if (_activeTrackingArea) {
        [self removeTrackingArea:_activeTrackingArea];
    }
    _activeTrackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingActiveAlways | NSTrackingEnabledDuringMouseDrag | NSTrackingMouseMoved | NSTrackingAssumeInside owner:self userInfo:nil];
    [self addTrackingArea:_activeTrackingArea];
}

- (void)mouseDown:(NSEvent *)event {
    _mouseDownPos = [event locationInWindow];
    _isDragResizing = YES;
}

- (void)mouseDragged:(NSEvent *)event {
    // Marshal all mouse movement events for future extendibility.
    [self mouseMoved:event];
}

- (void)mouseMoved:(NSEvent *)event {
    if (!_isDragResizing) {
        return;
    }
    
    NSPoint mouseCurrentPos = [event locationInWindow];
    CGFloat x = MIN(mouseCurrentPos.x, _mouseDownPos.x);
    CGFloat y = MIN(mouseCurrentPos.y, _mouseDownPos.y);
    CGFloat w = fabs(mouseCurrentPos.x - _mouseDownPos.x);
    CGFloat h = fabs(mouseCurrentPos.y - _mouseDownPos.y);
    _cropRect = NSMakeRect(x, y, w, h);
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)event {
    _isDragResizing = NO;
    
    if (_cropRect.size.width < 20 || _cropRect.size.height < 20) {
        _cropRect = NSZeroRect;
        [self setNeedsDisplay:YES];
        return;
    }
    
    if (_target) {
        if ([_target respondsToSelector:_action]) {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[_target methodSignatureForSelector:_action]];
            invocation.selector = _action;
            [invocation setArgument:(void *) &self atIndex:2];
            [invocation invokeWithTarget:_target];
        }
    }
}

- (NSRect)cropRect {
    return _cropRect;
}

@end
