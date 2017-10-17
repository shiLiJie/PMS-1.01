//
//  SCLCell.m
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 2017/6/5.
//  Copyright © 2017年 HanYouApp. All rights reserved.
//

#import "SCLCell.h"

@implementation SCLCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)chooseOne:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        self.chooseTwo.selected = NO;
        self.chooseThree.selected = NO;
        self.chooseFour.selected = NO;
        self.chooseFive.selected = NO;
        [self.delegate chooseOne:sender];
    
//        [self chooseBtn:sender change1:self.chooseTwo change2:self.chooseThree change3:self.chooseFour change4:self.chooseFive];
    }
    
}
- (IBAction)chooseTwo:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        self.chooseOne.selected = NO;
        self.chooseThree.selected = NO;
        self.chooseFour.selected = NO;
        self.chooseFive.selected = NO;
        [self.delegate chooseTwo:sender];
    }else{
        sender.selected = NO;
    }
}
- (IBAction)chooseThree:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        self.chooseTwo.selected = NO;
        self.chooseOne.selected = NO;
        self.chooseFour.selected = NO;
        self.chooseFive.selected = NO;
        [self.delegate chooseThree:sender];
    
//        [self chooseBtn:sender change1:self.chooseTwo change2:self.chooseOne change3:self.chooseFour change4:self.chooseFive];
    }else{
        sender.selected = NO;
    }
}
- (IBAction)chooseFour:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        self.chooseTwo.selected = NO;
        self.chooseThree.selected = NO;
        self.chooseOne.selected = NO;
        self.chooseFive.selected = NO;
        [self.delegate chooseFour:sender];
    
//        [self chooseBtn:sender change1:self.chooseTwo change2:self.chooseThree change3:self.chooseOne change4:self.chooseFive];
    }else{
        sender.selected = NO;
    }
}
- (IBAction)chooseFive:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        self.chooseTwo.selected = NO;
        self.chooseThree.selected = NO;
        self.chooseFour.selected = NO;
        self.chooseOne.selected = NO;
        [self.delegate chooseFive:sender];
    
//        [self chooseBtn:sender change1:self.chooseTwo change2:self.chooseThree change3:self.chooseFour change4:self.chooseFive];
    }else{
        sender.selected = NO;
    }
}

-(void)chooseBtn:(UIButton *)btn
         change1:(UIButton *)btn1
         change2:(UIButton *)btn2
         change3:(UIButton *)btn3
         change4:(UIButton *)btn4
{
    if (btn.selected) {
        btn1.selected = NO;
        btn2.selected = NO;
        btn3.selected = NO;
        btn4.selected = NO;
    }
}

@end
