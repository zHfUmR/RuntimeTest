//
//  UIButton+block.h
//  RuntimeTest
//
//  Created by Hongfei Zhai on 2017/11/22.
//  Copyright © 2017年 Hongfei Zhai. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <objc/runtime.h>

typedef void(^TouchBlock)(UIButton *sender);

@interface UIButton (block)

- (void)touchWithEvents:(UIControlEvents )controlEvents withBlock:(TouchBlock)touchBlock;

@end
