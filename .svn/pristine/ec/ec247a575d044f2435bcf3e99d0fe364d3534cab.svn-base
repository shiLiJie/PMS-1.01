//
//  MineViewController.h
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 16/3/16.
//  Copyright © 2016年 HanYouApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicCell.h"
#import "TAGPlayer.h"
#import "RTDragCellTableView.h"

@protocol MineViewDelegate

-(void)changeMusicLab:(NSString *)text time:(NSString *)time;
-(void)changeMusicBase;//乐库
-(void)changePatientBase;//患者库

@end

@interface MineViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,MusicCellDelegate,RTDragCellTableViewDataSource,RTDragCellTableViewDelegate>

@property (weak, nonatomic  ) IBOutlet UIButton           *LocalBtn;
@property (weak, nonatomic  ) IBOutlet UIButton           *NearBtn;
@property (weak, nonatomic  ) IBOutlet UIButton           *PrivateBtn;
@property (weak, nonatomic  ) IBOutlet UITableView        *tableView;   //音乐列表tab
@property (nonatomic, strong) RTDragCellTableView        *tableViewNew;         //音乐列表tab
@property (weak, nonatomic  ) IBOutlet NSLayoutConstraint *tableWidth;  //音乐列表宽度
@property (nonatomic, assign) BOOL isChooseing;                         //是否正在往列表里加
@property (nonatomic, assign) BOOL isXuanting;                          //是否选听状态
@property (nonatomic, assign) BOOL isXuanzhong;                         //是否选听状态
@property (nonatomic, copy) NSString *musicClassId;                     //音乐分类的id,获取分类音乐使用
@property (nonatomic, weak) id <MineViewDelegate> delegate;

//加入新的歌单列表
-(void)addNewMusicList;

//给音乐tab添加后台曲目
-(void)addMusicData;

@end
