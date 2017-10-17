//
//  YaliCell.m
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 2017/6/6.
//  Copyright © 2017年 HanYouApp. All rights reserved.
//

#import "YaliCell.h"

@implementation YaliCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)sure:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        [self.delegate choose:sender];
    }else{
        sender.selected = NO;
        [self.delegate dischoose:sender];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
