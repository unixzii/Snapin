//
//  AppDelegate.m
//  LoginHelper
//
//  Created by 杨弘宇 on 2017/1/31.
//  Copyright © 2017年 杨弘宇. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    __block BOOL alreadyRunning = NO;
    NSArray *running = [[NSWorkspace sharedWorkspace] runningApplications];
    [running enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[((NSRunningApplication *) obj) bundleIdentifier] isEqualToString:@"com.cyandev.macapp.snapin"]) {
            alreadyRunning = YES;
        }
    }];
    
    if (!alreadyRunning) {
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSMutableArray *pathComponents = [NSMutableArray arrayWithArray:path.pathComponents];
        [pathComponents removeLastObject];
        [pathComponents removeLastObject];
        [pathComponents removeLastObject];
        [pathComponents addObject:@"MacOS"];
        [pathComponents addObject:@"Snapin"];
        [[NSWorkspace sharedWorkspace] launchApplication:[NSString pathWithComponents:pathComponents]];
    }
    
    [NSApp terminate:nil];
}

@end
