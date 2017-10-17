//
//  currentTimeView.m
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 2017/5/24.
//  Copyright © 2017年 HanYouApp. All rights reserved.
//

#import "currentTimeView.h"

@implementation currentTimeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //ARRewardView : 自定义的view名称
        NSArray *nibView =  [[NSBundle mainBundle] loadNibNamed:@"currentTimeView"owner:self options:nil];
        self = [nibView objectAtIndex:0];

    }
    return self;
}



@end
