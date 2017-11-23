//
//  UIButton+block.m
//  RuntimeTest
//
//  Created by Hongfei Zhai on 2017/11/22.
//  Copyright © 2017年 Hongfei Zhai. All rights reserved.
//

#import "UIButton+block.h"

static const void *TouchKey = &TouchKey;

@implementation UIButton (block)

- (void)touchWithEvents:(UIControlEvents)controlEvents withBlock:(TouchBlock)touchBlock {
    objc_setAssociatedObject(self, TouchKey, touchBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(buttonClick:) forControlEvents:(controlEvents)];
}

- (void)buttonClick:(UIButton *)sender {
    TouchBlock touchblock = objc_getAssociatedObject(sender, TouchKey);
    if (touchblock) {
        touchblock(sender);
    }
}

@end
