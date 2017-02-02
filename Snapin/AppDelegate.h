//
//  AppDelegate.h
//  Snapin
//
//  Created by 杨弘宇 on 2017/1/31.
//  Copyright © 2017年 杨弘宇. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define NSAppDelegate ((AppDelegate *) [NSApp delegate])

@interface AppDelegate : NSObject <NSApplicationDelegate>

- (void)addActiveViewerWindowController:(NSWindowController *)wc;
- (void)removeActiveViewerWindowController:(NSWindowController *)wc;

- (void)setupGlobalKeyEquivalent;

@end
