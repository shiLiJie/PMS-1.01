//
//  MusicProCell.h
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 2017/4/24.
//  Copyright © 2017年 HanYouApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MusicProCellDelegate <NSObject>


-(void)TouchBeganSlider:(UISlider *)progressView;
-(void)ValueChangedSlider:(UISlider *)progressView;
-(void)TouchEndedSlider:(UISlider *)progressView;

-(void)clickStopOrStart:(UIButton *)btn;

@end

@interface MusicProCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel  *musicName;//音乐名称
@property (weak, nonatomic) IBOutlet UIButton *startOrStop;//停止或暂停按钮
@property (weak, nonatomic) IBOutlet UILabel  *currentTime;//当前时间lab
@property (weak, nonatomic) IBOutlet UILabel  *totalTime;//总时间lab
@property (weak, nonatomic) IBOutlet UISlider *progressView;//进度条

@property (nonatomic, weak) id<MusicProCellDelegate> delegate;

@end
