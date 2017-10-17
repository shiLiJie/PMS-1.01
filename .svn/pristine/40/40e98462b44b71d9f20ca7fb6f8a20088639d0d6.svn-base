//
//  UserDetailCell.m
//  NewSuperGymForCoach
//
//  Created by slj on 2017/5/26.
//  Copyright © 2017年 HanYouApp. All rights reserved.
//

#import "UserDetailCell.h"

@implementation UserDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.xingming.delegate = self;
    self.lianxifangshi.delegate = self;
    
    self.oneTextView.delegate = self;
    self.twoTextView.delegate = self;
    
    self.oneTextView.layer.borderColor = UIColor.grayColor.CGColor;
    self.oneTextView.layer.borderWidth = 1;
    self.oneTextView.layer.cornerRadius = 6;
    self.oneTextView.layer.masksToBounds = YES;
    
    self.twoTextView.layer.borderColor = UIColor.grayColor.CGColor;
    self.twoTextView.layer.borderWidth = 1;
    self.twoTextView.layer.cornerRadius = 6;
    self.twoTextView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//
//{
//    
//    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    
//    if (textField == self.xingming) {
//        
//
//    }
//    if (textField == self.lianxifangshi) {
//    }
//    
//    return YES;
//}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.xingming) {
        [self.delegate trainName:textField.text];
        
    }
    if (textField == self.lianxifangshi) {
        [self.delegate trainPhoneNum:textField.text];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView == self.oneTextView) {
        
        [self.delegate trainONe:textView.text];
    }
    if (textView == self.twoTextView) {
        [self.delegate trainTwo:textView.text];
    }
}

//- (void)textViewDidChange:(UITextView *)textView{
//    if (textView == self.oneTextView) {
//        
//        
//    }
//    if (textView == self.twoTextView) {
//    }
//}



@end

