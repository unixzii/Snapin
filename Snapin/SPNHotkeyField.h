//
//  SPNHotkeyField.h
//  Snapin
//
//  Created by 杨弘宇 on 2017/1/31.
//  Copyright © 2017年 杨弘宇. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SPNHotkeyField : NSControl

@property (readonly, getter=keyCode) unsigned short keyCode;
@property (readonly, getter=modifierFlags) NSEventModifierFlags modifierFlags;

- (void)setKeyCode:(unsigned short)keyCode modifierFlags:(NSEventModifierFlags)flags;

@end
