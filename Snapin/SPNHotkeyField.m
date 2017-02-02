//
//  SPNHotkeyField.m
//  Snapin
//
//  Created by 杨弘宇 on 2017/1/31.
//  Copyright © 2017年 杨弘宇. All rights reserved.
//

#import "SPNHotkeyField.h"
#import "DDHotKeyUtilities.h"

@interface SPNHotkeyField () {
    BOOL _firstResponder;
    unsigned short _keyCode;
    NSEventModifierFlags _modifierFlags;
}

@property (strong) NSTextField *textField;

@end

@implementation SPNHotkeyField

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
    _textField = [[NSTextField alloc] init];
    _textField.bezeled = NO;
    _textField.editable = NO;
    _textField.alignment = NSTextAlignmentCenter;
    _textField.backgroundColor = [NSColor clearColor];
    _textField.placeholderString = @"未设置";
    [self addSubview:_textField];
}

- (void)layout {
    [super layout];
    
    _textField.frame = CGRectInset(self.bounds, 4, 6);
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    CGRect drawRect = CGRectInset(self.bounds, 4, 4);
    NSBezierPath *drawPath = [NSBezierPath bezierPathWithRect:drawRect];
    
    CGContextRef context = [NSGraphicsContext currentContext].CGContext;
    CGContextSetFillColorWithColor(context, [NSColor whiteColor].CGColor);
    CGContextSetStrokeColorWithColor(context, [NSColor colorWithRed:0.81 green:0.81 blue:0.81 alpha:1.00].CGColor);
    CGContextFillRect(context, drawRect);
    [drawPath fill];
    [drawPath stroke];
    
    if (_firstResponder) {
        [NSGraphicsContext saveGraphicsState];
        NSSetFocusRingStyle(NSFocusRingBelow);
        [drawPath fill];
        [NSGraphicsContext restoreGraphicsState];
    }
}

- (BOOL)becomeFirstResponder {
    if (!self.enabled) {
        return NO;
    }
    
    _firstResponder = YES;
    [self setNeedsDisplay];
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    _firstResponder = NO;
    [self setNeedsDisplay];
    return [super resignFirstResponder];
}

- (void)mouseDown:(NSEvent *)event {
    [self.window makeFirstResponder:self];
}

- (void)keyDown:(NSEvent *)event {
    if (!event.modifierFlags) {
        return;
    }
    
    [self setKeyCode:event.keyCode modifierFlags:event.modifierFlags];
    [self sendAction:self.action to:self.target];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    
    [self.window makeFirstResponder:nil];
}

- (void)setKeyCode:(unsigned short)keyCode modifierFlags:(NSEventModifierFlags)flags {
    _keyCode = keyCode;
    _modifierFlags = flags;
    _textField.stringValue = [DDStringFromKeyCode(_keyCode, _modifierFlags) uppercaseString];
}

- (unsigned short)keyCode {
    return _keyCode;
}

- (NSEventModifierFlags)modifierFlags {
    return _modifierFlags;
}

@end
