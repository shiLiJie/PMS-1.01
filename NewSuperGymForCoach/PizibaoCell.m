//
//  PizibaoCell.m
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 2017/6/7.
//  Copyright © 2017年 HanYouApp. All rights reserved.
//

#import "PizibaoCell.h"
@interface PizibaoCell()<UITextFieldDelegate>

@end

@implementation PizibaoCell

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField == self.oneText) {
        [self.delegate editText1:self.oneText str:textField.text];
    }
    if (textField == self.twoText) {
        [self.delegate editText2:self.twoText str:textField.text];
    }
    if (textField == self.threeText) {
        [self.delegate editText3:self.threeText str:textField.text];
    }
    if (textField == self.fourText) {
        [self.delegate editText4:self.fourText str:textField.text];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.oneText.delegate = self;
    self.twoText.delegate = self;
    self.threeText.delegate = self;
    self.fourText.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//1
- (IBAction)one1:(UIButton *)sender {
    
    [self.delegate chooseOne1:sender];
    sender.selected = YES;
    self.one2.selected = NO;
    self.one3.selected = NO;
    self.one4.selected = NO;
    
}
- (IBAction)one2:(UIButton *)sender {
    
    [self.delegate chooseOne2:sender];
    sender.selected = YES;
    self.one1.selected = NO;
    self.one3.selected = NO;
    self.one4.selected = NO;
    
}
- (IBAction)one3:(UIButton *)sender {
    
    [self.delegate chooseOne3:sender];
    sender.selected = YES;
    self.one2.selected = NO;
    self.one1.selected = NO;
    self.one4.selected = NO;
    
}
- (IBAction)one4:(UIButton *)sender {
    
    [self.delegate chooseOne4:sender];
    sender.selected = YES;
    self.one2.selected = NO;
    self.one3.selected = NO;
    self.one1.selected = NO;
    
}
//2
- (IBAction)two1:(UIButton *)sender {
    
    [self.delegate chooseTwo1:sender];
    sender.selected = YES;
    self.two2.selected = NO;
    self.two3.selected = NO;
    self.two4.selected = NO;
}

- (IBAction)two2:(UIButton *)sender {
    
    [self.delegate chooseTwo2:sender];
    sender.selected = YES;
    self.two1.selected = NO;
    self.two3.selected = NO;
    self.two4.selected = NO;
}
- (IBAction)two3:(UIButton *)sender {
    
    [self.delegate chooseTwo3:sender];
    sender.selected = YES;
    self.two2.selected = NO;
    self.two1.selected = NO;
    self.two4.selected = NO;
}
- (IBAction)two4:(UIButton *)sender {
    
    [self.delegate chooseTwo4:sender];
    sender.selected = YES;
    self.two2.selected = NO;
    self.two3.selected = NO;
    self.two1.selected = NO;
}
//3
- (IBAction)three1:(UIButton *)sender {
    
    [self.delegate chooseThree1:sender];
    sender.selected = YES;
    self.three2.selected = NO;
    self.three3.selected = NO;
    self.three4.selected = NO;
}

- (IBAction)three2:(UIButton *)sender {
    
    [self.delegate chooseThree2:sender];
    sender.selected = YES;
    self.three1.selected = NO;
    self.three3.selected = NO;
    self.three4.selected = NO;
}
- (IBAction)three3:(UIButton *)sender {
    
    [self.delegate chooseThree3:sender];
    sender.selected = YES;
    self.three2.selected = NO;
    self.three1.selected = NO;
    self.three4.selected = NO;
}
- (IBAction)three4:(UIButton *)sender {
    
    [self.delegate chooseThree4:sender];
    sender.selected = YES;
    self.three2.selected = NO;
    self.three3.selected = NO;
    self.three1.selected = NO;
}
//4
- (IBAction)four1:(UIButton *)sender {
    
    [self.delegate chooseFour1:sender];
    sender.selected = YES;
    self.four2.selected = NO;
    self.four3.selected = NO;
    self.four4.selected = NO;
}

- (IBAction)four2:(UIButton *)sender {
    
    [self.delegate chooseFour2:sender];
    sender.selected = YES;
    self.four1.selected = NO;
    self.four3.selected = NO;
    self.four4.selected = NO;
}
- (IBAction)four3:(UIButton *)sender {
    
    [self.delegate chooseFour3:sender];
    sender.selected = YES;
    self.four2.selected = NO;
    self.four1.selected = NO;
    self.four4.selected = NO;
}
- (IBAction)four4:(UIButton *)sender {
    
    [self.delegate chooseFour4:sender];
    sender.selected = YES;
    self.four2.selected = NO;
    self.four3.selected = NO;
    self.four1.selected = NO;
}


@end
