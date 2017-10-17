//
//  MusicProCell.m
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 2017/4/24.
//  Copyright © 2017年 HanYouApp. All rights reserved.
//

#import "MusicProCell.h"

@implementation MusicProCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    // slider开始滑动事件
    [self.progressView addTarget:self action:@selector(SliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    // slider滑动中事件
    [self.progressView addTarget:self action:@selector(SliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    // slider结束滑动事件
    [self.progressView addTarget:self action:@selector(SliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
    
}

- (void)SliderTouchBegan:(UISlider *)slider{

    [self.delegate TouchBeganSlider:slider];
}
- (void)SliderValueChanged:(UISlider *)slider{

    [self.delegate ValueChangedSlider:slider];
}
- (void)SliderTouchEnded:(UISlider *)slider{

    [self.delegate TouchEndedSlider:slider];
}
- (IBAction)startOrStopClick:(UIButton *)sender {
    
    [self.delegate clickStopOrStart:sender];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
