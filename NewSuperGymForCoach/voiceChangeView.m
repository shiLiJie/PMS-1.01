//
//  voiceChangeView.m
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 2017/6/19.
//  Copyright © 2017年 BaYinApp. All rights reserved.
//

#import "voiceChangeView.h"

@implementation voiceChangeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //ARRewardView : 自定义的view名称
        NSArray *nibView =  [[NSBundle mainBundle] loadNibNamed:@"voiceChangeView"owner:self options:nil];
        self = [nibView objectAtIndex:0];
        
        self.toumingBg.layer.borderColor = UIColor.grayColor.CGColor;
        self.toumingBg.layer.borderWidth = 1;
        self.toumingBg.layer.cornerRadius = 6;
        self.toumingBg.layer.masksToBounds = YES;
 
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // slider开始滑动事件
    [self.voicePro addTarget:self action:@selector(SliderTouchBegan1:) forControlEvents:UIControlEventTouchDown];
    // slider滑动中事件
    [self.voicePro addTarget:self action:@selector(SliderValueChanged1:) forControlEvents:UIControlEventValueChanged];
    // slider结束滑动事件
    [self.voicePro addTarget:self action:@selector(SliderTouchEnded1:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
    

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
    [self.delegate remove];
}

- (void)SliderTouchBegan1:(UISlider *)slider{
[self.delegate changeMusicVoeic:slider];

}
- (void)SliderValueChanged1:(UISlider *)slider{
[self.delegate changeMusicVoeic:slider];

}
- (void)SliderTouchEnded1:(UISlider *)slider{

    [self.delegate changeMusicVoeic:slider];
}


@end
