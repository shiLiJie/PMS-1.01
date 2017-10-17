//
//  MusicCell.h
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 16/3/16.
//  Copyright © 2016年 HanYouApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellButton.h"

@protocol MusicCellDelegate <NSObject>

//代理方法传过来音乐名称和当前按钮
-(void)changeMusicName:(NSString *)text button:(CellButton *)btn;
//选择一个音乐
-(void)choosedMusic:(UIButton *)sender;
//取消选中一个音乐
-(void)dismissMusic:(UIButton *)sender;

@end


@interface MusicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *MusicLabel;//歌曲名
@property (weak, nonatomic) IBOutlet CellButton *shoucangBtn;//音乐加入患者按钮
@property (weak, nonatomic) IBOutlet UIButton *chooseMusicbtn;//选择音乐按钮
@property (weak, nonatomic) IBOutlet UILabel *musicIndexLab;//选择音乐时候的顺序标记lab
@property (weak, nonatomic) IBOutlet UIImageView *shuxianImage;//竖线image

@property (nonatomic, weak) id<MusicCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellBottom;

@end
