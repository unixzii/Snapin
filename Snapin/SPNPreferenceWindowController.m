//
//  SPNPreferenceWindowController.m
//  Snapin
//
//  Created by 杨弘宇 on 2017/1/31.
//  Copyright © 2017年 杨弘宇. All rights reserved.
//

#import <Carbon/Carbon.h>
#import <ServiceManagement/ServiceManagement.h>

#import "SPNPreferenceWindowController.h"
#import "SPNHotkeyField.h"
#import "AppDelegate.h"
#import "SPNConfig.h"

@interface SPNPreferenceWindowController ()

@property (weak) IBOutlet NSButton *startupRunButton;
@property (weak) IBOutlet NSButton *enableHotkeyButton;
@property (weak) IBOutlet SPNHotkeyField *hotkeyField;

@end

@implementation SPNPreferenceWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.startupRunButton.state = [[NSUserDefaults standardUserDefaults] boolForKey:kStartupRunDefaultsKey] ? NSOnState : NSOffState;
    self.enableHotkeyButton.state = [[NSUserDefaults standardUserDefaults] boolForKey:kEnableHotkeyDefaultsKey] ? NSOnState : NSOffState;
    self.hotkeyField.enabled = YES;
    self.hotkeyField.target = self;
    self.hotkeyField.action = @selector(applyHotkey);
    
    NSInteger hkKeyCode = [[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyKeyCodeDefaultsKey];
    if (!hkKeyCode) {
        [self resetHotkey:nil];
    } else {
        NSInteger hkModifier = [[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyModifierDefaultsKey];
        [self.hotkeyField setKeyCode:(unsigned short) (hkKeyCode & ((1 << 16) - 1)) modifierFlags:(hkModifier & ~1)];
    }
}

- (IBAction)resetHotkey:(id)sender {
    [self.hotkeyField setKeyCode:kVK_ANSI_A modifierFlags:(NSEventModifierFlagControl | NSEventModifierFlagCommand)];
    [self applyHotkey];
}

- (IBAction)startupRunButtonDidClick:(id)sender {
    BOOL enabled = self.startupRunButton.state == NSOnState;
    
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:kStartupRunDefaultsKey];
    [self setLoginItem:enabled];
}

- (IBAction)enableHotkeyButtonDidClick:(id)sender {
    BOOL enabled = self.enableHotkeyButton.state == NSOnState;
    
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:kEnableHotkeyDefaultsKey];
    [self applyHotkey];
}

- (void)setLoginItem:(BOOL)flag {
#ifdef MAS_VERSION
    SMLoginItemSetEnabled(CFSTR("com.cyandev.macapp.snapin.LoginHelper"), flag);
#else
    LSSharedFileListRef list = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    if (!list) {
        return;
    }
    
    NSString *appPath = [[NSBundle mainBundle] bundlePath];
    CFURLRef url = (__bridge CFURLRef) [NSURL fileURLWithPath:appPath];
    if (flag) {
        LSSharedFileListItemRef item = LSSharedFileListInsertItemURL(list, kLSSharedFileListItemLast, CFSTR("Snapin"), NULL, url, NULL, NULL);
        if (item) {
            CFRelease(item);
        }
    } else {
        UInt32 seed;
        NSArray *items = (__bridge_transfer NSArray *) (LSSharedFileListCopySnapshot(list, &seed));
        [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            LSSharedFileListItemRef item = (__bridge LSSharedFileListItemRef) obj;
            NSURL *resolvedURL = (__bridge_transfer NSURL *) LSSharedFileListItemCopyResolvedURL(item, kLSSharedFileListNoUserInteraction, NULL);
            if ([resolvedURL.path compare:appPath] == NSOrderedSame) {
                LSSharedFileListItemRemove(list, item);
            }
        }];
    }
    CFRelease(list);
#endif
}

- (void)applyHotkey {
    [[NSUserDefaults standardUserDefaults] setInteger:(self.hotkeyField.keyCode | (1 << 16)) forKey:kHotkeyKeyCodeDefaultsKey];
    [[NSUserDefaults standardUserDefaults] setInteger:(self.hotkeyField.modifierFlags | 1) forKey:kHotkeyModifierDefaultsKey];
    [NSAppDelegate setupGlobalKeyEquivalent];
}

@end
