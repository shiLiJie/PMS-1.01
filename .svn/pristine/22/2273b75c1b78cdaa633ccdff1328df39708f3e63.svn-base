//
//  SCLCell.h
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 2017/6/5.
//  Copyright © 2017年 HanYouApp. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SCLCellDelegate <NSObject>

-(void)chooseOne:(UIButton *)btn;
-(void)chooseTwo:(UIButton *)btn;
-(void)chooseThree:(UIButton *)btn;
-(void)chooseFour:(UIButton *)btn;
-(void)chooseFive:(UIButton *)btn;

@end

@interface SCLCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *qusetionLab;

@property (weak, nonatomic) IBOutlet UIButton *chooseOne;
@property (weak, nonatomic) IBOutlet UIButton *chooseTwo;
@property (weak, nonatomic) IBOutlet UIButton *chooseThree;
@property (weak, nonatomic) IBOutlet UIButton *chooseFour;
@property (weak, nonatomic) IBOutlet UIButton *chooseFive;

@property (nonatomic, weak) id<SCLCellDelegate> delegate;
@end
