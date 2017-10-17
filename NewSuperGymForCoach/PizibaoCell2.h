//
//  PizibaoCell2.h
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 2017/6/7.
//  Copyright © 2017年 HanYouApp. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PizibaoCellDelegate2 <NSObject>

-(void)chooseone2:(UIButton *)btn;
-(void)choosetwo2:(UIButton *)btn;
-(void)choosethree2:(UIButton *)btn;
-(void)choosefour2:(UIButton *)btn;

@end

@interface PizibaoCell2 : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *questionLab;
@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *towBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourBtn;

@property (nonatomic, weak) id<PizibaoCellDelegate2> delegate;

@end
