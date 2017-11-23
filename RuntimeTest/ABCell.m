//
//  ABCell.m
//  RuntimeTest
//
//  Created by Hongfei Zhai on 2017/11/22.
//  Copyright © 2017年 Hongfei Zhai. All rights reserved.
//

#import "ABCell.h"

@implementation ABCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code 可以拉线也可以直接添加
    [self.callBtn addTarget:self action:@selector(callBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)callBtnAction:(UIButton *)sender {
    if (self.callBlock) {
        self.callBlock(sender);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
