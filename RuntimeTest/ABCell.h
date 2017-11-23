//
//  ABCell.h
//  RuntimeTest
//
//  Created by Hongfei Zhai on 2017/11/22.
//  Copyright © 2017年 Hongfei Zhai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CallBtnBlock)(UIButton *callBtn);

@interface ABCell : UITableViewCell

@property (nonatomic, copy) CallBtnBlock callBlock;
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;

@end
