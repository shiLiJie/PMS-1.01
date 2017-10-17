//
//  PizibaoCell2.m
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 2017/6/7.
//  Copyright © 2017年 HanYouApp. All rights reserved.
//

#import "PizibaoCell2.h"

@implementation PizibaoCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (IBAction)oneClick:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        [self.delegate chooseone2:sender];
//        [sender setTintColor:[UIColor redColor]];
        [self chooseBtn:sender change1:self.towBtn change2:self.threeBtn change3:self.fourBtn];
    }
    
}
- (IBAction)twoClick:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        [self.delegate choosetwo2:sender];
//        [sender setTintColor:[UIColor redColor]];
        [self chooseBtn:sender change1:self.oneBtn change2:self.threeBtn change3:self.fourBtn];
    }
    
}
- (IBAction)threeClick:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        [self.delegate choosethree2:sender];
//        [sender setTintColor:[UIColor redColor]];
        [self chooseBtn:sender change1:self.towBtn change2:self.oneBtn change3:self.fourBtn];
    }
}
- (IBAction)fourClick:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        [self.delegate choosefour2:sender];
//        [sender setTintColor:[UIColor redColor]];
        [self chooseBtn:sender change1:self.towBtn change2:self.threeBtn change3:self.oneBtn];
    }
}

-(void)chooseBtn:(UIButton *)btn
         change1:(UIButton *)btn1
         change2:(UIButton *)btn2
         change3:(UIButton *)btn3
{
    if (btn.selected) {
        btn1.selected = NO;
        btn2.selected = NO;
        btn3.selected = NO;
//        [btn1 setTintColor:[UIColor blueColor]];
//        [btn2 setTintColor:[UIColor blueColor]];
//        [btn3 setTintColor:[UIColor blueColor]];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
