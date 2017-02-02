//
//  SPNSnapshotWindowController.m
//  Snapin
//
//  Created by 杨弘宇 on 2017/1/31.
//  Copyright © 2017年 杨弘宇. All rights reserved.
//

#import <Carbon/Carbon.h>

#import "SPNSnapshotWindowController.h"
#import "SPNImageViewerWindowController.h"
#import "SPNCropView.h"
#import "AppDelegate.h"

@interface SPNSnapshotWindowController ()

@property (weak) IBOutlet NSImageView *imageView;
@property (weak) IBOutlet SPNCropView *cropView;

@end

@implementation SPNSnapshotWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.window.level = NSScreenSaverWindowLevel;
    self.window.styleMask = NSWindowStyleMaskTitled | NSWindowStyleMaskFullScreen;
    
    NSSize screenSize = CGDisplayBounds(CGMainDisplayID()).size;
    [self.window setFrame:NSMakeRect(0, 0, screenSize.width, screenSize.height) display:NO];
    
    self.imageView.image = self.image;
    
    self.cropView.target = self;
    self.cropView.action = @selector(cropViewDidCommitSelection:);
}

- (IBAction)closeWindow:(id)sender {
    [self close];
}

- (void)cropViewDidCommitSelection:(id)sender {
    SPNImageViewerWindowController *wc = [[SPNImageViewerWindowController alloc] initWithWindowNibName:@"SPNImageViewerWindowController"];
    wc.image = [self croppedImage:self.image withRect:self.cropView.cropRect];
    
    NSRect proposedRect = self.cropView.cropRect;
    if (proposedRect.size.width < 100) {
        proposedRect.size.width = 100;
    }
    
    if (proposedRect.size.height < 100) {
        proposedRect.size.height = 100;
    }
    [wc.window setFrame:proposedRect display:YES];
    
    [NSAppDelegate addActiveViewerWindowController:wc];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(200 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        [wc showWindow:sender];
    });
    
    [self close];
}

- (NSImage *)croppedImage:(NSImage *)image withRect:(NSRect)rect {
    CGFloat scale = image.size.width / CGDisplayBounds(CGMainDisplayID()).size.width;
    
    CGRect flippedRect = rect;
    flippedRect.origin.x *= scale;
    flippedRect.origin.y *= scale;
    flippedRect.size.width *= scale;
    flippedRect.size.height *= scale;
    flippedRect.origin.y = image.size.height - flippedRect.origin.y - flippedRect.size.height;
    
    NSData *imageData = [image TIFFRepresentation];
    if (imageData) {
        // Crop.
        CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef) imageData, NULL);
        CGImageRef cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
        CGImageRef croppedCGImage = CGImageCreateWithImageInRect(cgImage, flippedRect);
        
        NSImage *finalImage = [[NSImage alloc] initWithCGImage:croppedCGImage size:rect.size];
        
        CFRelease(imageSource);
        CGImageRelease(cgImage);
        CGImageRelease(croppedCGImage);
        
        return finalImage;
    }
    
    return nil;
}

@end
