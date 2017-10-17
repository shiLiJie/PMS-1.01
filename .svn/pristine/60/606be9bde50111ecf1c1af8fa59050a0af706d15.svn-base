//
//  musicListCell.m
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 2017/4/17.
//  Copyright © 2017年 HanYouApp. All rights reserved.
//

#import "musicListCell.h"

@implementation musicListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [SLJNotificationTools addaddObserver:self selector:@selector(bofang) methodName:@"BOFANGZANTING"];
    [SLJNotificationTools addaddObserver:self selector:@selector(zanting) methodName:@"BOFANGKAISHI"];
}

-(void)bofang{
    [self.starOrPauseBtn setImage:[UIImage imageNamed:@"zantingicon"] forState:UIControlStateNormal];
}

-(void)zanting{
    [self.starOrPauseBtn setImage:[UIImage imageNamed:@"kaishi"] forState:UIControlStateNormal];
}

- (IBAction)startOrPause:(UIButton *)sender {
    
    [self.delegate clickStartOrStopbutton:sender];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
