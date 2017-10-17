//
//  YaliCell.h
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 2017/6/6.
//  Copyright © 2017年 HanYouApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YaliCellDelegate <NSObject>

-(void)choose:(UIButton *)btn;
-(void)dischoose:(UIButton *)btn;


@end

@interface YaliCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *questionLab;

@property (weak, nonatomic) IBOutlet UIButton *SureBtn;

@property (nonatomic, weak) id<YaliCellDelegate> delegate;
@end
