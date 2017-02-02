//
//  AppDelegate.m
//  Snapin
//
//  Created by 杨弘宇 on 2017/1/31.
//  Copyright © 2017年 杨弘宇. All rights reserved.
//

#import "AppDelegate.h"
#import "SPNPreferenceWindowController.h"
#import "SPNSnapshotWindowController.h"
#import "SPNConfig.h"
#import "DDHotKeyCenter.h"

@interface AppDelegate ()

@property (strong) SPNPreferenceWindowController *prefWindowController;
@property (strong) SPNSnapshotWindowController *snapshotWindowController;
@property (strong) NSMutableArray<NSWindowController *> *viewerWindowControllers;
@property (strong) NSStatusItem *statusItem;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    self.prefWindowController = [[SPNPreferenceWindowController alloc] initWithWindowNibName:@"SPNPreferenceWindowController"];
    
    self.viewerWindowControllers = [NSMutableArray array];
    
    [self setupStatusItem];
    [self setupGlobalKeyEquivalent];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)setupStatusItem {
    NSStatusItem *item = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    NSImage *iconImage = [NSImage imageNamed:@"StatusItemIcon"];
    [iconImage setTemplate:YES];
    [item.button setImage:iconImage];
    
    NSMenu *menu = [[NSMenu alloc] init];
    [menu addItemWithTitle:@"截屏" action:@selector(snapshot:) keyEquivalent:@""];
    [menu addItem:[NSMenuItem separatorItem]];
    [menu addItemWithTitle:@"首选项..." action:@selector(showPreferenceWindow:) keyEquivalent:@""];
    [menu addItemWithTitle:@"关于 Snapin" action:@selector(orderFrontStandardAboutPanel:) keyEquivalent:@""];
    [menu addItem:[NSMenuItem separatorItem]];
    [menu addItemWithTitle:@"退出" action:@selector(terminate:) keyEquivalent:@""];
    
    [item setMenu:menu];
    
    self.statusItem = item;
}

- (void)setupGlobalKeyEquivalent {
    DDHotKeyCenter *center = [DDHotKeyCenter sharedHotKeyCenter];
    [center unregisterAllHotKeys];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kEnableHotkeyDefaultsKey]) {
        return;
    }
    
    NSInteger keyCode = [[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyKeyCodeDefaultsKey];
    if (!keyCode) {
        keyCode = 1 << 16;
    }
    
    NSInteger modifier = [[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyModifierDefaultsKey];
    if (!modifier) {
        modifier = (NSEventModifierFlagControl | NSEventModifierFlagCommand) | 1;
    }
    
    [center registerHotKeyWithKeyCode:(unsigned short) (keyCode & ((1 << 16) - 1)) modifierFlags:(modifier & ~1) target:self action:@selector(snapshot:) object:nil];
}

- (void)addActiveViewerWindowController:(NSWindowController *)wc {
    // Retain.
    [self.viewerWindowControllers addObject:wc];
}

- (void)removeActiveViewerWindowController:(NSWindowController *)wc {
    // Release.
    [self.viewerWindowControllers removeObject:wc];
}

#pragma mark - Actions

- (void)snapshot:(id)sender {
    CGDirectDisplayID mainDisplayID = CGMainDisplayID();
    CGImageRef cgImage = CGDisplayCreateImage(mainDisplayID);
    NSImage *image = [[NSImage alloc] initWithCGImage:cgImage size:NSMakeSize(CGImageGetWidth(cgImage), CGImageGetHeight(cgImage))];
    
    if (self.snapshotWindowController.window.visible) {
        return;
    }
    
    self.snapshotWindowController = [[SPNSnapshotWindowController alloc] initWithWindowNibName:@"SPNSnapshotWindowController"];
    self.snapshotWindowController.image = image;
    [self.snapshotWindowController showWindow:sender];
    [self.snapshotWindowController.window makeKeyAndOrderFront:nil];
    
    [NSApp activateIgnoringOtherApps:YES];
    
    CGImageRelease(cgImage);
}

- (void)showPreferenceWindow:(id)sender {
    [self.prefWindowController showWindow:sender];
    [self.prefWindowController.window orderFrontRegardless];
    
    [NSApp activateIgnoringOtherApps:YES];
}

@end
