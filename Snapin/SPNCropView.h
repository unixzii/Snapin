//
//  SPNCropView.h
//  Snapin
//
//  Created by 杨弘宇 on 2017/1/31.
//  Copyright © 2017年 杨弘宇. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SPNCropView : NSView

@property (weak) id target;
@property (assign) SEL action;

@property (readonly, getter=cropRect) NSRect cropRect;

@end
