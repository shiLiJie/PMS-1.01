//
//  musicListCell.h
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 2017/4/17.
//  Copyright © 2017年 HanYouApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol musicListDelegate <NSObject>

//代理方法传过来音乐名称和当前按钮
-(void)clickStartOrStopbutton:(UIButton *)btn;

@end

@interface musicListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *musicNameLab;
@property (weak, nonatomic) IBOutlet UIButton *starOrPauseBtn;

@property (nonatomic, weak) id<musicListDelegate> delegate;

@end
