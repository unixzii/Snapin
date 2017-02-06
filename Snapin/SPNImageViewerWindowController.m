//
//  SPNImageViewerWindowController.m
//  Snapin
//
//  Created by 杨弘宇 on 2017/2/1.
//  Copyright © 2017年 杨弘宇. All rights reserved.
//

#import "SPNImageViewerWindowController.h"
#import "AppDelegate.h"

@interface SPNImageViewerWindowController () <NSWindowDelegate> {
    NSTrackingArea *_trackingArea;
}

@property (weak) IBOutlet NSImageView *imageView;
@property (weak) IBOutlet NSVisualEffectView *titlebarBackgroundView;

@end

@implementation SPNImageViewerWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.window.titlebarAppearsTransparent = YES;
    self.window.styleMask |= NSWindowStyleMaskFullSizeContentView;
    self.window.level = NSFloatingWindowLevel;
    self.window.movableByWindowBackground = YES;
    self.window.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantDark];
    self.window.delegate = self;
    
    self.imageView.image = self.image;
    
    self.imageView.frame = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
    self.imageView.superview.frame = self.imageView.bounds;
}

- (void)setStandardButtonsVisibility:(BOOL)flag {
    NSButton *closeButton = [self.window standardWindowButton:NSWindowCloseButton];
    NSButton *miniaturizeButton = [self.window standardWindowButton:NSWindowMiniaturizeButton];
    NSButton *zoomButton = [self.window standardWindowButton:NSWindowZoomButton];
    
    CGFloat alphaValue = flag ? 1 : 0;
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0.3];
    [closeButton animator].alphaValue = alphaValue;
    [miniaturizeButton animator].alphaValue = alphaValue;
    [zoomButton animator].alphaValue = alphaValue;
    [self.titlebarBackgroundView animator].alphaValue = alphaValue;
    [NSAnimationContext endGrouping];
}

- (void)mouseEntered:(NSEvent *)event {
    [self setStandardButtonsVisibility:YES];
}

- (void)mouseExited:(NSEvent *)event {
    [self setStandardButtonsVisibility:NO];
}

- (void)windowWillStartLiveResize:(NSNotification *)notification {
    self.window.aspectRatio = self.window.frame.size;
}

- (void)windowDidResize:(NSNotification *)notification {
    if (_trackingArea) {
        [self.window.contentView removeTrackingArea:_trackingArea];
    }
    _trackingArea = [[NSTrackingArea alloc] initWithRect:self.window.contentView.bounds options:NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingEnabledDuringMouseDrag owner:self userInfo:nil];
    [self.window.contentView addTrackingArea:_trackingArea];
}

- (void)windowWillClose:(NSNotification *)notification {
    if (_trackingArea) {
        [self.window.contentView removeTrackingArea:_trackingArea];
    }
    
    [NSAppDelegate removeActiveViewerWindowController:self];
}

@end
