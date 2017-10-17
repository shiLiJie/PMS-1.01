//
//  PizibaoCell.h
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 2017/6/7.
//  Copyright © 2017年 HanYouApp. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PizibaoCellDelegate <NSObject>


-(void)editText1:(UITextField *)textfield str:(NSString *)str;
-(void)editText2:(UITextField *)textfield str:(NSString *)str;
-(void)editText3:(UITextField *)textfield str:(NSString *)str;
-(void)editText4:(UITextField *)textfield str:(NSString *)str;

-(void)chooseOne1:(UIButton *)btn;
-(void)chooseOne2:(UIButton *)btn;
-(void)chooseOne3:(UIButton *)btn;
-(void)chooseOne4:(UIButton *)btn;

-(void)chooseTwo1:(UIButton *)btn;
-(void)chooseTwo2:(UIButton *)btn;
-(void)chooseTwo3:(UIButton *)btn;
-(void)chooseTwo4:(UIButton *)btn;

-(void)chooseThree1:(UIButton *)btn;
-(void)chooseThree2:(UIButton *)btn;
-(void)chooseThree3:(UIButton *)btn;
-(void)chooseThree4:(UIButton *)btn;

-(void)chooseFour1:(UIButton *)btn;
-(void)chooseFour2:(UIButton *)btn;
-(void)chooseFour3:(UIButton *)btn;
-(void)chooseFour4:(UIButton *)btn;


@end

@interface PizibaoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *oneText;
@property (weak, nonatomic) IBOutlet UITextField *twoText;
@property (weak, nonatomic) IBOutlet UITextField *threeText;
@property (weak, nonatomic) IBOutlet UITextField *fourText;

@property (weak, nonatomic) IBOutlet UIButton *one1;
@property (weak, nonatomic) IBOutlet UIButton *one2;
@property (weak, nonatomic) IBOutlet UIButton *one3;
@property (weak, nonatomic) IBOutlet UIButton *one4;

@property (weak, nonatomic) IBOutlet UIButton *two1;
@property (weak, nonatomic) IBOutlet UIButton *two2;
@property (weak, nonatomic) IBOutlet UIButton *two3;
@property (weak, nonatomic) IBOutlet UIButton *two4;

@property (weak, nonatomic) IBOutlet UIButton *three1;
@property (weak, nonatomic) IBOutlet UIButton *three2;
@property (weak, nonatomic) IBOutlet UIButton *three3;
@property (weak, nonatomic) IBOutlet UIButton *three4;

@property (weak, nonatomic) IBOutlet UIButton *four1;
@property (weak, nonatomic) IBOutlet UIButton *four2;
@property (weak, nonatomic) IBOutlet UIButton *four3;
@property (weak, nonatomic) IBOutlet UIButton *four4;


@property (nonatomic, weak) id<PizibaoCellDelegate> delegate;


@end
