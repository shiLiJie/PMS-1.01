//
//  HealingMusicVc.m
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 2017/5/23.
//  Copyright © 2017年 HanYouApp. All rights reserved.
//



#import "HealingMusicVc.h"
#import "playListCellTableViewCell.h"
#import "playListDetalCell.h"
#import "Imitation_AlertView_TextField.h"
#import "musicModel.h"
#import "MusicCell.h"
#import "musicClassModel.h"
#import "SLJAVPlayer.h"
#import "SLJPlayer.h"
#import "currentTimeView.h"
#import "RTDragCellTableView.h"
#import "voiceChangeView.h"
#import <AVFoundation/AVFoundation.h>

@interface HealingMusicVc ()<UITableViewDelegate,UITableViewDataSource,Imitation_AlertView_TextFielddelegate,playDelegate,playerDelegate,RTDragCellTableViewDataSource,RTDragCellTableViewDelegate,voiceChangeViewDelegate,MusicCellDelegate>
@property (weak, nonatomic) IBOutlet UIButton *creatListBtn;    //新街列表btn
@property (weak, nonatomic) IBOutlet UITableView *playListTab;  //左侧播放列表
@property (weak, nonatomic) IBOutlet UIImageView *imageBg;      //顶部图片
@property (weak, nonatomic) IBOutlet UIButton *playAllBtn;      //播放音乐按钮
@property (weak, nonatomic) IBOutlet RTDragCellTableView *musicListTab; //具体音乐列表
@property (weak, nonatomic) IBOutlet UIButton *danruBtn;        //淡入按钮
@property (weak, nonatomic) IBOutlet UIButton *danchuBtn;       //淡出按钮
@property (weak, nonatomic) IBOutlet UISlider *progressView;
@property (weak, nonatomic) IBOutlet UIButton *playOrStopBtn;   //暂停开始按钮
@property (weak, nonatomic) IBOutlet UIButton *nextOneBtn;      //下一曲按钮
@property (weak, nonatomic) IBOutlet UIButton *upOneBtn;        //上一曲按钮
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLab;   //当前音量lab
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLab;     //总时间lab
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;        //音量控制按钮
@property (weak, nonatomic) IBOutlet UILabel *zhuMusicName;     //主音乐名称

@property (nonatomic, strong) NSMutableArray *tempMArray; // 用于判断手风琴的某个层级是否展开
@property (nonatomic, strong) Imitation_AlertView_TextField * textFieldView;//弹框套入的文本框
@property (nonatomic, strong) NSMutableArray *dataArr;          //组名数组
@property (nonatomic, strong) NSMutableArray *mArray;           //左侧主曲叠加cell数组

@property (nonatomic, strong) NSMutableArray *musicDataArr;     //右侧具体音乐数据数组
@property (nonatomic, strong) NSMutableArray *fumusicDataArr;     //右侧具体叠加音乐数据数组
@property (nonatomic, strong) NSMutableArray *zhumusicDataArr;     //右侧具体叠加音乐数据数组


@property (nonatomic, strong) SLJAVPlayer *zhuplayer;//音乐播放器
@property (nonatomic, strong) SLJPlayer *fuplayer;//音乐播放器
//是否正在播放
@property (nonatomic, assign) BOOL iszhuPlaying;
//淡入
@property (nonatomic, assign) BOOL iszhuDanru;
//淡出
@property (nonatomic, assign) BOOL iszhuDanchu;
//当前音乐名称
@property (nonatomic, strong) NSString *zhumusicName;
//当前音量
@property (nonatomic, assign) float zhuvoice;
//当前音乐播放的索引
@property (nonatomic, strong) NSIndexPath *zhumusicIndex;
//进度条上当前时间view
@property (nonatomic, strong) currentTimeView *zhucurrentView;
//音量进度条
@property (nonatomic, strong) UISlider *zhuslider;
@property (weak, nonatomic) IBOutlet UIView *zhuView;
@property (nonatomic, assign) BOOL isChangeZhuVoice;
//判断主列表还是附列表
@property (nonatomic, assign) NSInteger zhuOrfu;
@property (nonatomic, assign) NSInteger sention;
@property (weak, nonatomic) IBOutlet UIView *fuVIew;            //附播放器控制板
@property (weak, nonatomic) IBOutlet UIButton *fudanchuBtn;     //淡出
@property (weak, nonatomic) IBOutlet UILabel *fuTotalTimeLab;   //总时长
@property (weak, nonatomic) IBOutlet UIButton *fuVoiceBtn;      //音量
@property (weak, nonatomic) IBOutlet UILabel *fuMusicNameLab;   //歌曲名Lab
@property (weak, nonatomic) IBOutlet UIButton *fuPlayOrStopBtn; //开始暂停
@property (weak, nonatomic) IBOutlet UIButton *fuNextOneBtn;    //下一曲
@property (weak, nonatomic) IBOutlet UIButton *fuUponeBtn;      //上一首
@property (weak, nonatomic) IBOutlet UILabel *fuVoiceLab;       //音量lab
@property (weak, nonatomic) IBOutlet UISlider *fuprogressView;
@property (weak, nonatomic) IBOutlet UIButton *fuDanruBtn;      //淡入

@property (nonatomic, assign) BOOL isfuPlaying;                 //是否正在播放
@property (nonatomic, assign) BOOL isfuDanru;                   //淡入
@property (nonatomic, assign) BOOL isfuDanchu;                  //淡出
@property (nonatomic, strong) NSString *fumusicName;            //当前音乐名称
@property (nonatomic, assign) float fuvoice;                    //当前音量
@property (nonatomic, strong) NSIndexPath *fumusicIndex;        //当前音乐播放的索引
@property (nonatomic, strong) currentTimeView *fucurrentView;   //进度条上当前时间view
@property (nonatomic, strong) UISlider *fuslider;               //音量进度条

@property (nonatomic, copy)   NSString *zhuTotalTime;           //主列表总时长
@property (nonatomic, copy)   NSString *fuTotalTime;            //附列表总时长
@property (weak, nonatomic) IBOutlet UILabel *fuAllTime;    //附列表总时长
@property (weak, nonatomic) IBOutlet UILabel *zhuAllTime;   //附列表总时长\\

@property (nonatomic, strong) NSMutableArray *fuMusicData1;     //右侧具体音乐数据数组

@property (nonatomic, strong) voiceChangeView *voiceChange;//大的音量调整进度条


@property (nonatomic, strong) NSMutableArray *diejiaMusic;     //所有叠加音乐

@end

@implementation HealingMusicVc

-(void)viewWillAppear:(BOOL)animated{
    //获取数据
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatNewList:self.creatListBtn];
    
    self.zhumusicDataArr = [[NSMutableArray alloc] init];
    self.fumusicDataArr = [[NSMutableArray alloc] init];
    self.musicDataArr = [[NSMutableArray alloc] init];
    
    self.diejiaMusic = [[NSMutableArray alloc] init];
    
    //为了防止进场后第一行cell是选中颜色
    self.zhuOrfu = -1;
    
    self.playListTab.delegate = self;
    self.playListTab.dataSource = self;
    
    self.musicListTab.delegate = self;
    self.musicListTab.dataSource = self;
    
    self.iszhuPlaying = NO;
    self.iszhuDanru   = NO;
    self.iszhuDanchu  = NO;
    [self.danruBtn setImage:[UIImage imageNamed:@"danchu-1"] forState:UIControlStateNormal];
    [self.danchuBtn setImage:[UIImage imageNamed:@"danru-1"] forState:UIControlStateNormal];
    self.zhuvoice = 0.5f;
    self.isfuPlaying = NO;
    self.isfuDanru   = NO;
    self.isfuDanchu  = NO;
    [self.fuDanruBtn setImage:[UIImage imageNamed:@"danru-1"] forState:UIControlStateNormal];
    [self.fudanchuBtn setImage:[UIImage imageNamed:@"danchu-1"] forState:UIControlStateNormal];
    self.fuvoice = 0.5f;
    self.zhumusicIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    self.fumusicIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    
    
    self.textFieldView = [[Imitation_AlertView_TextField alloc] initWithFatherViewFrameWidth:844 withFrameHeight:850];
    self.textFieldView.title = @"列表命名";
    [self.view addSubview:self.textFieldView];
    self.textFieldView.textMessage = @"";
    self.textFieldView.delegate = self;
    [self.textFieldView viewHidden];
    //添加音乐播放器
    [self addzhuMusicPlayer];
    [self addfuMusicPlayer];
    
    [self.musicListTab addRecognizer];
    
    //添加进度条滑块并设置约束
    self.zhucurrentView = [[currentTimeView alloc] initWithFrame:CGRectMake(self.progressView.centerX-self.progressView.frameWidth/2, self.progressView.centerY-40, 50, 30)];
    self.zhucurrentView.currentTimeLab.text = @"00:00";
    [self.zhuView addSubview:self.zhucurrentView];
    
    [self.zhucurrentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.progressView).with.offset(-23);
        make.centerY.equalTo(self.progressView).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(50,30));
    }];
    //添加进度条滑块并设置约束
    self.fucurrentView = [[currentTimeView alloc] initWithFrame:CGRectMake(self.fuprogressView.centerX-self.fuprogressView.frameWidth/2, self.fuprogressView.centerY-40, 50, 30)];
    self.fucurrentView.currentTimeLab.text = @"00:00";
    [self.fuVIew addSubview:self.fucurrentView];
    
    [self.fucurrentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fuprogressView).with.offset(-23);
        make.centerY.equalTo(self.fuprogressView).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(50,30));
    }];
    
    [SLJNotificationTools addaddObserver:self selector:@selector(loginOut) methodName:@"LOGINOUT"];
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];//创建单例对象并且使其设置为活跃状态.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:)   name:AVAudioSessionRouteChangeNotification object:nil];//设置通知
    
    [self getDiejiaMusic];

}
//退出登录的通知方法,关掉播放器
-(void)loginOut{
    self.iszhuPlaying = NO;
    self.isfuPlaying = NO;
    [self.zhuplayer resetPlayer];
    [self.fuplayer resetPlayer];
}

//获取后台所有的叠加曲目
-(void)getDiejiaMusic{
    NSString *token = [NSString md5WithString];
    NSDictionary *dict = @{
                           @"token":token,
                           @"uid":@"99"
                           };
    [[HttpRequest shardWebUtil] postNetworkRequestURLString:@"http://cloud.musiccare.cn/Api/MusicApi/get_music_cate"
     
                                                 parameters:dict
                                                    success:^(id obj) {
                                                        
                                                        NSArray *arr = obj;//取出需要的数据数组
                                                        NSMutableArray *arrayM = [NSMutableArray array];//中间中转数组
                                                        for (int i = 0; i < arr.count; i ++) {//遍历数组
                                                            NSDictionary *dict = arr[i];
                                                            
                                                            if ([dict[@"name"] isEqualToString:@"叠加"]) {
                                                                [arrayM addObject:[musicClassModel musicClassWithDict:dict]];//中转数组存放转成模型的字典
                                                                
                                                                NSDictionary *dict     = @{
                                                                                           @"token":token,
                                                                                           @"p":@"1",
                                                                                           @"num":@"20",
                                                                                           @"cate":@"33",
                                                                                           @"cate1":@""
                                                                                           };
                                                                [[HttpRequest shardWebUtil] postNetworkRequestURLString:@"http://cloud.musiccare.cn/Api/MusicApi/get_cate_music"
                                                                                                             parameters:dict
                                                                                                                success:^(id obj) {
                                                                                                                    
                                                                                                                    NSArray *arr = [obj valueForKey:@"data"];//取出需要的数据数组
                                                                                                                    NSMutableArray *arrayM = [NSMutableArray array];//中间中转数组
                                                                                                                    for (int i = 0; i < arr.count; i ++) {//遍历数组
                                                                                                                        NSDictionary *dict = arr[i];
                                                                                                                        [arrayM addObject:[musicModel musicListWithDict:dict]];//中转数组存放转成模型的字典
                                                                                                                    }
                                                                                                                    self.diejiaMusic = arrayM;
                                                                                                                    
                                                                                                                    
                                                                                                                }
                                                                                                                   fail:^(NSError *error) {
                                                                                                                       NSLog(@"error--%@",error);
                                                                                                                   }];
                                                            }
                                                            
                                                        }
  
                                                    }
                                                       fail:^(NSError *error) {

                                                       }];
}

#pragma mark - 播放器代理方法 - 
//主播放器代理
-(void)startPlay{
    self.zhuMusicName.text = self.zhumusicName;
    NSLog(@"开始播放");
    self.iszhuPlaying = YES;
    [self.playOrStopBtn setImage:[UIImage imageNamed:@"kaishiicon"] forState:UIControlStateNormal];
    
    if (self.iszhuDanru) {
        self.zhuplayer.player.volume = 0;
    }else{
        self.zhuplayer.player.volume = self.zhuvoice;
    }
    [MBProgressHUD showMessage:@"正在缓冲请稍后"];
}

-(void)endPlay{
    if (self.zhumusicIndex.row+1 == self.zhumusicDataArr.count) {
        
        self.iszhuPlaying  = NO;
        [self.playOrStopBtn setImage:[UIImage imageNamed:@"zantingicon"] forState:UIControlStateNormal];
        [self fuPlayOrStop:self.fuPlayOrStopBtn];
        return;
    }else{
        self.zhumusicIndex = [NSIndexPath indexPathForRow:self.zhumusicIndex.row+1 inSection:self.zhumusicIndex.section];
        [self nextOne];
    }
    NSLog(@"结束播放");
}

-(void)nextOne{
    
    self.iszhuPlaying  = NO;
    [self.playOrStopBtn setImage:[UIImage imageNamed:@"zantingicon"] forState:UIControlStateNormal];
    [self.zhuplayer resetPlayer];//重置播放器
    if (self.zhumusicDataArr.count == 0 || self.zhumusicIndex.row>=self.zhumusicDataArr.count) {//防止没有音乐数据崩溃
        return;
    }
    
    musicModel *model = self.zhumusicDataArr[self.zhumusicIndex.row];
    self.zhumusicName         = model.name;
    NSString *musicUrlstr     = model.url;

    if ([musicUrlstr isEqualToString:@"本地播放的"]) {
        [self getLoaclMusic];
    }else{
        NSURL *netlUrl = [NSURL URLWithString:musicUrlstr];
        [self.zhuplayer playWithUrlStr:netlUrl PlayerLayer:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-40, 220)];
    }
    
    
    
    

    [self.zhuplayer startPaly];
    if (self.zhuplayer.levelTimer) {
        [self.zhuplayer.levelTimer invalidate];
        self.zhuplayer.levelTimer   = nil;
    }
    self.zhuplayer.levelTimer       = [NSTimer scheduledTimerWithTimeInterval: 1
                                                                       target: self
                                                                     selector: @selector(zhustartTime)
                                                                    userInfo: nil repeats: YES];
    
    
    [self getDiejiaMusicModel];
    
    if (self.zhuOrfu == 0) {
        [self.musicListTab reloadData];
    }
    [self.playListTab reloadData];
    
}
//副播放器代理
- (void)startPlay1{
    self.fuMusicNameLab.text = self.fumusicName;
    NSLog(@"开始播放");
    self.isfuPlaying = YES;
    [self.fuPlayOrStopBtn setImage:[UIImage imageNamed:@"kaishiicon"] forState:UIControlStateNormal];
    
    if (self.isfuDanru) {
        self.fuplayer.player.volume = 0;
    }else{
        self.fuplayer.player.volume = self.fuvoice;
    }
    [MBProgressHUD showMessage:@"正在缓冲请稍后"];

}
- (void)endPlay1{
    if (self.fumusicIndex.row+1 == self.fumusicDataArr.count) {
        self.isfuPlaying  = NO;
        [self.fuPlayOrStopBtn setImage:[UIImage imageNamed:@"zantingicon"] forState:UIControlStateNormal];
        return;
    }else{
        self.fumusicIndex = [NSIndexPath indexPathForRow:self.fumusicIndex.row+1 inSection:self.fumusicIndex.section];
        [self fuNextOne];

    }
    NSLog(@"结束播放");
}
-(void)fuNextOne{

    self.isfuPlaying  = NO;
    [self.fuPlayOrStopBtn setImage:[UIImage imageNamed:@"zantingicon"] forState:UIControlStateNormal];
    
    if (self.fumusicDataArr.count == 0 || self.fumusicIndex.row>=self.fumusicDataArr.count) {//防止没有音乐数据奔溃
        return;
    }
    [self.fuplayer resetPlayer];//重置播放器
    
    musicModel *model = self.fumusicDataArr[self.fumusicIndex.row];
    self.fumusicName         = model.name;
    NSString *musicUrlstr     = model.url;
    
    if ([musicUrlstr isEqualToString:@"本地播放的"]) {
        [self fugetLoaclMusic];
    }else{
        NSURL *netlUrl = [NSURL URLWithString:musicUrlstr];
        [self.fuplayer playWithUrlStr:netlUrl PlayerLayer:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-40, 220)];
    }

    [self.fuplayer startPaly];
    if (self.fuplayer.levelTimer) {
        [self.fuplayer.levelTimer invalidate];
        self.fuplayer.levelTimer       = nil;
    }
    self.fuplayer.levelTimer       = [NSTimer scheduledTimerWithTimeInterval: 1
                                                                      target: self
                                                                    selector: @selector(fustartTime)
                                                                    userInfo: nil repeats: YES];
    if (self.zhuOrfu == 1) {
        [self.musicListTab reloadData];
    }
    
}

#pragma mark - 私有方法 -

//音乐锁屏信息展示
- (void)setupLockScreenInfo
{
    // 1.获取锁屏中心
    MPNowPlayingInfoCenter *playingInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
    
    //初始化一个存放音乐信息的字典
    NSMutableDictionary *playingInfoDict = [NSMutableDictionary dictionary];
    // 2、设置歌曲名
    if (self.zhumusicName) {
        [playingInfoDict setObject:self.zhumusicName forKey:MPMediaItemPropertyAlbumTitle];
    }
    // 4设置歌曲的总时长
    if (self.zhucurrentView.currentTimeLab.text) {
        [playingInfoDict setObject:[NSString stringWithFormat:@"%ld",(NSInteger)self.zhuplayer.palyItem.duration.value / self.zhuplayer.palyItem.duration.timescale] forKey:MPMediaItemPropertyPlaybackDuration];
    }
    //音乐信息赋值给获取锁屏中心的nowPlayingInfo属性
    playingInfoCenter.nowPlayingInfo = playingInfoDict;
    
    // 5.开启远程交互，只有开启这个才能进行远程操控
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

//耳机插拔监听
//通知方法的实现
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification
{
    
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
//            tipWithMessage(@"耳机插入");
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:{
//            tipWithMessage(@"耳机拔出，停止播放操作");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.iszhuPlaying = YES;
                self.isfuPlaying  = YES;
                [self playOrStop:self.playOrStopBtn];
                [self fuPlayOrStop:self.fuPlayOrStopBtn];
                
            });
            
            break;
        }
        case AVAudioSessionRouteChangeReasonCategoryChange:
//            tipWithMessage(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}

////自定提醒窗口
//NS_INLINE void tipWithMessage(NSString *message){
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
//        
//        [alerView show];
//        
//        [alerView performSelector:@selector(dismissWithClickedButtonIndex:animated:) withObject:@[@0, @1] afterDelay:0.9];
//        
//    });
//    
//}

//音量进度条滑动
- (void)SliderValueChanged:(UISlider *)slider{
    self.zhuplayer.player.volume = slider.value;
    self.zhuvoice                = slider.value;
    
}
//音量进度条滑动
- (void)SliderValueChanged1:(UISlider *)slider{
    self.fuplayer.player.volume = slider.value;
    self.fuvoice                = slider.value;
    
}

//播放器定时器一秒调用一次方法
- (void)zhustartTime {
    if (self.zhuplayer.palyItem.duration.timescale != 0) {
        
        self.progressView.value  = CMTimeGetSeconds([self.zhuplayer.palyItem currentTime]) / (self.zhuplayer.palyItem.duration.value / self.zhuplayer.palyItem.duration.timescale);//当前进度
        
        
        //当前时长进度progress
        NSInteger proMin = (NSInteger)CMTimeGetSeconds([self.zhuplayer.player currentTime]) / 60;//当前秒
        NSInteger proSec = (NSInteger)CMTimeGetSeconds([self.zhuplayer.player currentTime]) % 60;//当前分钟
        
        //duration 总时长
        NSInteger durMin = (NSInteger)self.zhuplayer.palyItem.duration.value / self.zhuplayer.palyItem.duration.timescale / 60;//总秒
        NSInteger durSec = (NSInteger)self.zhuplayer.palyItem.duration.value / self.zhuplayer.palyItem.duration.timescale % 60;//总分钟
        
        NSString *pro    = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
        NSString *pro1   = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
        //更新滑块约束
        [self.zhucurrentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.progressView).with.offset(self.progressView.frameWidth*self.progressView.value-23);
            make.centerY.equalTo(self.progressView).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(50,30));
        }];
        self.zhucurrentView.currentTimeLab.text = pro;//当前时间赋值
        self.totalTimeLab.text   = pro1;//总时间赋值
        if (![self.zhucurrentView.currentTimeLab.text isEqualToString:@"00:00"]) {
            [MBProgressHUD hideHUD];
        }
        //音量赋值
        if (self.zhuplayer.player.volume*100<0) {//防越界
            self.currentTimeLab.text = @"0";
        }else{
            self.currentTimeLab.text = [NSString stringWithFormat:@"%.0f",self.zhuplayer.player.volume*100];
        }
        //设置后台远程时间
        if ([self.zhucurrentView.currentTimeLab.text isEqualToString:@"00:00"]) {
            [self setupLockScreenInfo];
        }
        
        
        NSInteger currentSec = (NSInteger)CMTimeGetSeconds([self.zhuplayer.player currentTime]);
        NSInteger totalSec   = (NSInteger)self.zhuplayer.palyItem.duration.value / self.zhuplayer.palyItem.duration.timescale;
        //在音量控制的情况下不执行淡入淡出方法
        if (!self.zhuslider) {
            if (self.iszhuDanchu) {//淡出
                //评判淡出的标准
                if (totalSec - currentSec < 10) {
                    //淡出咯
                    if (self.zhuplayer.player > 0) {
                        if (self.zhuplayer.player.volume <= 0){
                            return;
                        }
                        self.zhuplayer.player.volume = self.zhuplayer.player.volume -=0.1;
//                        NSLog(@"淡出%f",self.zhuplayer.player.volume);
                    }
                }
            }
            if (self.iszhuDanru) {//淡入
                if (totalSec - currentSec > 10){
                    //淡入咯
                    if (self.zhuplayer.player.volume < self.zhuvoice) {
                        if (self.zhuplayer.player.volume >= self.zhuvoice){
                            return;
                        }
                        self.zhuplayer.player.volume = self.zhuplayer.player.volume +=0.1;
//                        NSLog(@"淡入%f",self.zhuplayer.player.volume);
                    }
                }
                
            }
        }
    }
}

//播放器定时器一秒调用一次方法
- (void)fustartTime {
    if (self.fuplayer.palyItem.duration.timescale != 0) {
        
        self.fuprogressView.value  = CMTimeGetSeconds([self.fuplayer.palyItem currentTime]) / (self.fuplayer.palyItem.duration.value / self.fuplayer.palyItem.duration.timescale);//当前进度
        
        //当前时长进度progress
        NSInteger proMin = (NSInteger)CMTimeGetSeconds([self.fuplayer.player currentTime]) / 60;//当前秒
        NSInteger proSec = (NSInteger)CMTimeGetSeconds([self.fuplayer.player currentTime]) % 60;//当前分钟
        
        //duration 总时长
        NSInteger durMin = (NSInteger)self.fuplayer.palyItem.duration.value / self.fuplayer.palyItem.duration.timescale / 60;//总秒
        NSInteger durSec = (NSInteger)self.fuplayer.palyItem.duration.value / self.fuplayer.palyItem.duration.timescale % 60;//总分钟
        
        NSString *pro    = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
        NSString *pro1   = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
        //更新滑块约束
        [self.fucurrentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.fuprogressView).with.offset(self.fuprogressView.frameWidth*self.fuprogressView.value-23);
            make.centerY.equalTo(self.fuprogressView).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(50,30));
        }];
        self.fucurrentView.currentTimeLab.text = pro;//当前时间赋值
        self.fuTotalTimeLab.text   = pro1;//总时间赋值
        if (![self.fucurrentView.currentTimeLab.text isEqualToString:@"00:00"]) {
            [MBProgressHUD hideHUD];
        }
        //音量赋值
        if (self.fuplayer.player.volume*100<0) {//防越界
            self.fuVoiceLab.text = @"0";
        }else{
            self.fuVoiceLab.text = [NSString stringWithFormat:@"%.0f",self.fuplayer.player.volume*100];
        }
        
        
        
        NSInteger currentSec = (NSInteger)CMTimeGetSeconds([self.fuplayer.player currentTime]);
        NSInteger totalSec   = (NSInteger)self.fuplayer.palyItem.duration.value / self.fuplayer.palyItem.duration.timescale;
        //在音量控制的情况下不执行淡入淡出方法
        if (!self.fuslider) {
            if (self.isfuDanchu) {//淡出
                //评判淡出的标准
                if (totalSec - currentSec < 10) {
                    //淡出咯
                    if (self.fuplayer.player > 0) {
                        if (self.fuplayer.player.volume <= 0){
                            return;
                        }
                        self.fuplayer.player.volume = self.fuplayer.player.volume -=0.1;
//                        NSLog(@"淡出%f",self.fuplayer.player.volume);
                    }
                }
            }
            if (self.isfuDanru) {//淡入
                if (totalSec - currentSec > 10){
                    //淡入咯
                    if (self.fuplayer.player.volume < self.fuvoice) {
                        if (self.fuplayer.player.volume >= self.fuvoice){
                            return;
                        }
                        self.fuplayer.player.volume = self.fuplayer.player.volume +=0.1;
//                        NSLog(@"淡入%f",self.fuplayer.player.volume);
                    }
                }
                
            }
        }
    }
}

-(void)addzhuMusicPlayer{
    //初始化音乐播放器
    self.zhuplayer               = [[SLJAVPlayer alloc] initWithFrame:CGRectMake(20, 120, [UIScreen mainScreen].bounds.size.width-40, 220)];
    self.zhuplayer.delegate      = self;
    
    [self.progressView setThumbImage:[self OriginImage:[UIImage imageNamed:@"jindutiao"] scaleToSize:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    [self.progressView setThumbImage:[self OriginImage:[UIImage imageNamed:@"jindutiao"] scaleToSize:CGSizeMake(10, 10)] forState:UIControlStateHighlighted];
}

-(void)addfuMusicPlayer{
    //初始化音乐播放器
    self.fuplayer               = [[SLJPlayer alloc] initWithFrame:CGRectMake(20, 120, [UIScreen mainScreen].bounds.size.width-40, 220)];
    self.fuplayer.delegate      = self;
    
    [self.fuprogressView setThumbImage:[self OriginImage:[UIImage imageNamed:@"jindutiao"] scaleToSize:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    [self.fuprogressView setThumbImage:[self OriginImage:[UIImage imageNamed:@"jindutiao"] scaleToSize:CGSizeMake(10, 10)] forState:UIControlStateHighlighted];
}

//设置进度条上的点
-(UIImage*) OriginImage:(UIImage*)image scaleToSize:(CGSize)size

{
    UIGraphicsBeginImageContext(size);//size为CGSize类型，即你所需要的图片尺寸
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}


//新建列表
- (IBAction)creatNewList:(UIButton *)sender {
    NSString *createPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileNameChart = [NSString stringWithFormat:@"%@/主列表.musiclist", createPath];
    //检查是否存在
    if(![[NSFileManager defaultManager] fileExistsAtPath:fileNameChart]){
        [[NSFileManager defaultManager] createFileAtPath:fileNameChart contents:nil attributes:nil];
        NSFileHandle *logFileChart = [NSFileHandle fileHandleForWritingAtPath:fileNameChart];
        [logFileChart seekToEndOfFile];
        //把歌单写入本地文件
        [@"分割线" writeToFile:fileNameChart atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
    

//    [self.textFieldView viewShow];
}
//淡出
- (IBAction)danru:(UIButton *)sender {
    if (self.iszhuDanchu) {
        self.iszhuDanchu = NO;
        [sender setImage:[UIImage imageNamed:@"danchu-1"] forState:UIControlStateNormal];
    }else{
        self.iszhuDanchu = YES;
        [sender setImage:[UIImage imageNamed:@"danchu"] forState:UIControlStateNormal];
    }
}
//淡入
- (IBAction)danchu:(UIButton *)sender {
    if (self.iszhuDanru) {
        self.iszhuDanru = NO;
        [sender setImage:[UIImage imageNamed:@"danru-1"] forState:UIControlStateNormal];
    }else{
        self.iszhuDanru = YES;
        [sender setImage:[UIImage imageNamed:@"danru"] forState:UIControlStateNormal];
    }
}
//下一曲
- (IBAction)nextOne:(UIButton *)sender {
    
    if (self.zhumusicDataArr.count == 0) {//防止没有音乐数据奔溃
        return;
    }
    if (self.zhumusicIndex.row+1 >= self.zhumusicDataArr.count) {
        self.zhumusicIndex = [NSIndexPath indexPathForRow:0 inSection:0];
        [self nextOne];
    }else{
        self.zhumusicIndex = [NSIndexPath indexPathForRow:self.zhumusicIndex.row+1 inSection:self.zhumusicIndex.section];
        [self nextOne];
    }
}
//上一曲
- (IBAction)upOne:(UIButton *)sender {
    if (self.zhumusicDataArr.count == 0) {//防止没有音乐数据奔溃
        return;
    }
    if (self.zhumusicIndex.row == 0) {
        self.zhumusicIndex = [NSIndexPath indexPathForRow:0 inSection:0];
        [self nextOne];
    }else{
        self.zhumusicIndex = [NSIndexPath indexPathForRow:self.zhumusicIndex.row-1 inSection:self.zhumusicIndex.section];
        [self nextOne];
    }
}
//开始/暂停
- (IBAction)playOrStop:(UIButton *)sender {
    if (self.iszhuPlaying) {
        self.iszhuPlaying = NO;
        [sender setImage:[UIImage imageNamed:@"zantingicon"] forState:UIControlStateNormal];
        [self.zhuplayer.player pause];
        self.isfuPlaying = NO;
        [self.fuPlayOrStopBtn setImage:[UIImage imageNamed:@"zantingicon"] forState:UIControlStateNormal];
        [self.fuplayer.player pause];
    }else{
        if (self.zhumusicName==nil) {
            self.zhumusicIndex = [NSIndexPath indexPathForRow:0 inSection:0];
            [self nextOne];
            return;
        }
        self.iszhuPlaying = YES;
        [sender setImage:[UIImage imageNamed:@"kaishiicon"] forState:UIControlStateNormal];
        [self.zhuplayer.player play];
    }
}
//选择音量
- (IBAction)chooseVoice:(UIButton *)sender {

    if (!self.voiceChange) {
        self.isChangeZhuVoice =  YES;
        self.voiceChange = [[voiceChangeView alloc] initWithFrame:CGRectMake(100, 200, 250, 100)];
        self.voiceChange.voicePro.value = self.zhuplayer.player.volume;
        [self.view addSubview:self.voiceChange];
        
        [self.voiceChange mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).with.offset(0);
            make.right.equalTo(self.view).with.offset(0);
            make.top.equalTo(self.view).with.offset(20);
            make.bottom.equalTo(self.view).with.offset(-self.zhuView.frameHeight);
        }];
        
        self.voiceChange.delegate = self;
    }else{
        [self.voiceChange removeFromSuperview];
        self.voiceChange = nil;
    }
}

//大的音量控制条的代理方法
//传过来调整后的音量
-(void)changeMusicVoeic:(UISlider *)slider{
    if (self.isChangeZhuVoice) {
        self.zhuplayer.player.volume = slider.value;
        self.zhuvoice                = slider.value;
        self.currentTimeLab.text     = [NSString stringWithFormat:@"%.0f",self.zhuplayer.player.volume*100];
    }else{
        self.fuplayer.player.volume = slider.value;
        self.fuvoice                = slider.value;
        self.fuVoiceLab.text     = [NSString stringWithFormat:@"%.0f",self.fuplayer.player.volume*100];
    }
    
}
//移除方法
-(void)remove{
    
    self.voiceChange = nil;
}

//播放音乐
- (IBAction)playAll:(UIButton *)sender {
    if (self.zhuOrfu == 0) {
        self.zhumusicIndex = [NSIndexPath indexPathForRow:0 inSection:0];
        [self nextOne];
    }else{
        if (!self.iszhuPlaying) {
            return;
        }
        self.fumusicIndex = [NSIndexPath indexPathForRow:0 inSection:0];
        [self fuNextOne];
    }
    
}
//淡出
- (IBAction)fuDanchu:(UIButton *)sender {
    if (self.isfuDanchu) {
        self.isfuDanchu = NO;
        [sender setImage:[UIImage imageNamed:@"danchu-1"] forState:UIControlStateNormal];
    }else{
        self.isfuDanchu = YES;
        [sender setImage:[UIImage imageNamed:@"danchu"] forState:UIControlStateNormal];
    }
}
//淡入
- (IBAction)fuDanru:(UIButton *)sender {
    if (self.isfuDanru) {
        self.isfuDanru = NO;
        [sender setImage:[UIImage imageNamed:@"danru-1"] forState:UIControlStateNormal];
    }else{
        self.isfuDanru = YES;
        [sender setImage:[UIImage imageNamed:@"danru"] forState:UIControlStateNormal];
    }
}
//音量按钮
- (IBAction)fuChangeVoice:(UIButton *)sender {
    if (!self.voiceChange) {
        self.isChangeZhuVoice =  NO;
        self.voiceChange = [[voiceChangeView alloc] initWithFrame:CGRectMake(100, 200, 250, 100)];
        self.voiceChange.voicePro.value = self.fuplayer.player.volume;
        [self.view addSubview:self.voiceChange];
        
        [self.voiceChange mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).with.offset(0);
            make.right.equalTo(self.view).with.offset(0);
            make.top.equalTo(self.view).with.offset(20);
            make.bottom.equalTo(self.view).with.offset(-self.zhuView.frameHeight);
        }];
        
        self.voiceChange.delegate = self;
    }else{
        [self.voiceChange removeFromSuperview];
        self.voiceChange = nil;
    }
}
//开始暂停
- (IBAction)fuPlayOrStop:(UIButton *)sender {
    
    if (self.isfuPlaying) {
        self.isfuPlaying = NO;
        [sender setImage:[UIImage imageNamed:@"zantingicon"] forState:UIControlStateNormal];
        [self.fuplayer.player pause];
    }else{
        if (self.fumusicDataArr.count == 0) {//防止没有音乐数据奔溃
            return;
        }
        
        if (!self.iszhuPlaying) {
            return;
        }
        if (self.fumusicName==nil) {
            if (!self.iszhuPlaying) {
                return;
            }
            self.fumusicIndex = [NSIndexPath indexPathForRow:0 inSection:0];
            [self fuNextOne];
            return;
        }
        self.isfuPlaying = YES;
        [sender setImage:[UIImage imageNamed:@"kaishiicon"] forState:UIControlStateNormal];
        [self.fuplayer.player play];
    }
}
//下一曲
- (IBAction)fuNextone:(UIButton *)sender {
    
    if (self.fumusicDataArr.count == 0) {//防止没有音乐数据奔溃
        return;
    }
    if (!self.iszhuPlaying) {
        return;
    }
    if (self.fumusicIndex.row+1 >= self.fumusicDataArr.count) {
        self.fumusicIndex = [NSIndexPath indexPathForRow:0 inSection:0];
        [self fuNextOne];
    }else{
        self.fumusicIndex = [NSIndexPath indexPathForRow:self.fumusicIndex.row+1 inSection:self.fumusicIndex.section];
        [self fuNextOne];
    }
}
//上一曲
- (IBAction)fuUpone:(UIButton *)sender {
    if (self.fumusicDataArr.count == 0) {//防止没有音乐数据奔溃
        return;
    }
    if (!self.iszhuPlaying) {
        return;
    }
    if (self.fumusicIndex.row == 0) {
        self.fumusicIndex = [NSIndexPath indexPathForRow:0 inSection:0];
        [self fuNextOne];
    }else{
        self.fumusicIndex = [NSIndexPath indexPathForRow:self.fumusicIndex.row-1 inSection:self.fumusicIndex.section];
        [self fuNextOne];
    }
}

//拿到叠加音乐列表并刷新tab
-(void)getDiejiaMusicModel{
    
    [self.fumusicDataArr removeAllObjects];
    //plist文件匹配叠加音乐
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Diejia" ofType:@"plist"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSArray *arr = [dict allKeys];
    
    //这里的 @"1" 将来要传入一个这曲目名字
    for (NSString *key in arr) {
        if ([key isEqualToString:self.zhumusicName]) {
            NSArray *arr = [dict valueForKey:key];
            
            if (arr.count != 0) {
                for (int i=0; i<arr.count; i++) {
                    musicModel *model = [[musicModel alloc] init];;
                    model.name = arr[i];
                    model.url  = @"本地播放的";
                    [self.fumusicDataArr addObject:model];
                }
            }else{
                for (int i = 0; i < self.diejiaMusic.count; i++) {
                    for (int t = 0; t < arr.count; t++) {
                        musicModel *model = self.diejiaMusic[i];
                        if ([arr[t] isEqualToString:model.name]) {
                            if ([self.fumusicDataArr containsObject:model]) {
                                return;
                            }else{
                                [self.fumusicDataArr addObject:model];
                            }
                            
                        }
                    }
                }
            }
            
        }
    }
}

#pragma mark - table代理方法 -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.playListTab) {
        return self.dataArr.count;
    }else{
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.playListTab) {
        if ([self.tempMArray[section] isEqualToString:@"0"]) {
            
            return 0;
        }else{
            // 如果是展开的则给这个分区加一个cell用来放此分区的标题cell
            //        NSArray *array = self.mArray[section][@"mArr"];
            return 2;
        }
    }else{
        if (self.zhuOrfu == 0) {
            return self.zhumusicDataArr.count;
        }else{
            return self.fumusicDataArr.count;
        }
        
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.playListTab) {
        playListDetalCell *customCell       = [tableView dequeueReusableCellWithIdentifier:@"CustomCell1"];
        NSArray *nib1          = [[NSBundle mainBundle]loadNibNamed:@"playListDetalCell" owner:nil options:nil];
        customCell                   = [nib1 lastObject];

        if (self.zhuOrfu != -1 && self.zhuOrfu == indexPath.row && self.sention == indexPath.section) {
            customCell.zhuOrdiejiaLab.textColor = RGBA(251, 166, 84, 1);
        }
        if (indexPath.row == 0) {
            NSDictionary *dic = self.mArray[indexPath.section][0];
            NSArray *zhuarr = dic[@"zhu"];
            
            customCell.zhuOrdiejiaLab.text=[NSString stringWithFormat:@"播放的音乐 (%lu)",(unsigned long)zhuarr.count];

            self.playListTab.separatorStyle = UITableViewCellSelectionStyleNone;
            return customCell;
        }else{
            [self getDiejiaMusicModel];
            customCell.zhuOrdiejiaLab.text=[NSString stringWithFormat:@"叠加的音乐 (%lu)",(unsigned long)self.fumusicDataArr.count];
            self.playListTab.separatorStyle = UITableViewCellSelectionStyleNone;
            return customCell;
        }
    }else{
        static NSString *cellIdentifier = @"cell";
        MusicCell *cell          = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSArray *nib1            = [[NSBundle mainBundle]loadNibNamed:KCellMusicCell owner:nil options:nil];
        cell                     = [nib1 lastObject];
        musicModel *model   = self.musicDataArr[indexPath.row];
        cell.MusicLabel.text     = model.name;
        cell.musicIndexLab.text  = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        cell.shuxianImage.hidden = YES;
        cell.chooseMusicbtn.hidden  = YES;
        cell.delegate            = self;
        self.playListTab.separatorStyle = UITableViewCellSelectionStyleNone;
        if (self.zhuOrfu == 0) {
            if ([cell.MusicLabel.text isEqualToString:self.zhumusicName] && self.zhumusicIndex.row == indexPath.row) {
                
                cell.MusicLabel.textColor = RGBA(251, 166, 84, 1);
                cell.musicIndexLab.textColor = RGBA(251, 166, 84, 1);
            }
            return cell;
        }else{
            if ([cell.MusicLabel.text isEqualToString:self.fumusicName] && self.fumusicIndex.row == indexPath.row) {
                
                cell.MusicLabel.textColor = RGBA(251, 166, 84, 1);
                cell.musicIndexLab.textColor = RGBA(251, 166, 84, 1);
            }
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.playListTab) {
//        [self.musicDataArr removeAllObjects];
        
        
        if (indexPath.row == 0) {
            
            self.zhuOrfu = indexPath.row;
            self.sention = indexPath.section;
            NSDictionary *dic = self.mArray[indexPath.section][0];
            NSArray *zhuarr = dic[@"zhu"];
            [self.zhumusicDataArr removeAllObjects];
            for (int i = 0; i < zhuarr.count; i++) {
                NSArray *data = [zhuarr[i] componentsSeparatedByString:@"*"];
                musicModel *model = [[musicModel alloc] init];
                model.name = data[0];
                model.url = data[1];
                //播放顺序调整后改变播放index
                if ([self.zhumusicName isEqualToString:model.name]) {
                    self.zhumusicIndex = [NSIndexPath indexPathForRow:i inSection:0];
                }
                
                [self.zhumusicDataArr addObject:model];
                self.musicDataArr = self.zhumusicDataArr;
            }
            
            [self.musicListTab reloadData];
            [self.playListTab reloadData];
            
        }else{

            self.zhuOrfu = indexPath.row;
            self.sention = indexPath.section;

            [self getDiejiaMusicModel];
            self.musicDataArr = self.fumusicDataArr;
            

            [self.musicListTab reloadData];
            [self.playListTab reloadData];
        }
    }else{
        //主曲目播放
        if (self.zhuOrfu == 0) {

            self.zhumusicIndex = indexPath;
            [self nextOne];
        }else{
        //附曲目播放
            if (!self.iszhuPlaying) {
                return;
            }
            self.fumusicIndex = indexPath;
            [self fuNextOne];
        }
    }
}

// 组的头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView == self.playListTab) {
        playListCellTableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
        NSArray *nib1          = [[NSBundle mainBundle]loadNibNamed:@"playListCellTableViewCell" owner:nil options:nil];
        headerCell                   = [nib1 lastObject];
        headerCell.listName.text = self.dataArr[section];
        headerCell.tag = section + 1000;
        headerCell.arrowBtn.selected = [self.tempMArray[section] isEqualToString:@"1"];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [headerCell addGestureRecognizer:tap];
        return headerCell;
    }else{
        return nil;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.playListTab) {
    return 80;
    }else{
        return 0;
    }
}

//左滑删除功能
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}
//左滑删除功能
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (self.zhuOrfu == 0) {
        [self.zhumusicDataArr removeObjectAtIndex:indexPath.row];
    }
    if (self.zhuOrfu == 1) {
        [self.fumusicDataArr removeObjectAtIndex:indexPath.row];
    }

    
    NSString *str = @"";
    for (int i = 0; i < self.musicDataArr.count; i ++) {
        musicModel *model = self.musicDataArr[i];

        str = [NSString stringWithFormat:@"%@%@*%@?",str,model.name,model.url];

    }
    NSString *pathDocuments=kDocument;
    NSArray *fileNameList=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathDocuments error:nil];
    NSMutableArray *arr = [fileNameList mutableCopy];
    if ([arr containsObject:@".DS_Store"]) {
        [arr removeObject:@".DS_Store"];
    }
    if ([arr containsObject:@"musicData"]) {
        [arr removeObject:@"musicData"];
    }
    if ([arr containsObject:@"user.data"]) {
        [arr removeObject:@"user.data"];
    }
    if ([arr containsObject:@"user"]) {
        [arr removeObject:@"user"];
    }
    if ([arr containsObject:@"operDB.sqlite"]) {
        [arr removeObject:@"operDB.sqlite"];
    }
    if ([arr containsObject:@"diejiamusic"]) {
        [arr removeObject:@"diejiamusic"];
    }
    NSString *path = [NSString stringWithFormat:@"%@/%@",pathDocuments,arr[self.sention]];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //改主
    if (self.zhuOrfu == 0) {
        NSArray *array = [result componentsSeparatedByString:@"分割线"];
        
        NSString *dataresult = [NSString stringWithFormat:@"%@分割线%@",str,array[1]];
        [dataresult writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }else{
        NSArray *array = [result componentsSeparatedByString:@"分割线"];
        NSString *dataresult = [NSString stringWithFormat:@"%@分割线%@",array[0],str];
        [dataresult writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    [self getData];
    [self tableView:self.playListTab didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:self.zhuOrfu inSection:self.sention]];
    
}
//左滑删除文字设置
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark - 拖动tableview代理 -
- (NSArray *)originalArrayDataForTableView:(RTDragCellTableView *)tableView{
    
    if (self.zhuOrfu==0) {
        for (int i=0; i<self.zhumusicDataArr.count; i++) {
            musicModel *model = self.zhumusicDataArr[i];
            NSLog(@"%@",model.name);
        }
        
        return self.zhumusicDataArr;
        
    }else{
        return self.fumusicDataArr;
    }
}

- (void)tableView:(RTDragCellTableView *)tableView newArrayDataForDataSource:(NSArray *)newArray{
    self.musicDataArr = [newArray mutableCopy];
    
    
    NSString *str = @"";
    if (self.zhuOrfu == 1) {
        self.fumusicDataArr = self.musicDataArr;
        
        for (int i = 0; i < self.musicDataArr.count; i ++) {
            musicModel *model = self.musicDataArr[i];
            
            str = [NSString stringWithFormat:@"%@%@*%@?",str,model.name,model.url];
        }
    }else{
        self.zhumusicDataArr = self.musicDataArr;
        
        for (int i = 0; i < self.musicDataArr.count; i ++) {
            musicModel *model = self.musicDataArr[i];
            
            str = [NSString stringWithFormat:@"%@%@*%@?",str,model.name,model.url];
        }
    }
    
    NSString *pathDocuments=kDocument;
    NSArray *fileNameList=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathDocuments error:nil];
    NSMutableArray *arr = [fileNameList mutableCopy];
    if ([arr containsObject:@".DS_Store"]) {
        [arr removeObject:@".DS_Store"];
    }
    if ([arr containsObject:@"musicData"]) {
        [arr removeObject:@"musicData"];
    }
    if ([arr containsObject:@"user.data"]) {
        [arr removeObject:@"user.data"];
    }
    if ([arr containsObject:@"user"]) {
        [arr removeObject:@"user"];
    }
    if ([arr containsObject:@"operDB.sqlite"]) {
        [arr removeObject:@"operDB.sqlite"];
    }
    if ([arr containsObject:@"diejiamusic"]) {
        [arr removeObject:@"diejiamusic"];
    }
    NSString *path = [NSString stringWithFormat:@"%@/%@",pathDocuments,arr[self.sention]];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //改主
    if (self.zhuOrfu == 0) {
        NSArray *array = [result componentsSeparatedByString:@"分割线"];
        
        NSString *dataresult = [NSString stringWithFormat:@"%@分割线%@",str,array[1]];
        [dataresult writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        [self getData];
        [self tableView:self.playListTab didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
    }else{
        NSArray *array = [result componentsSeparatedByString:@"分割线"];
        NSString *dataresult = [NSString stringWithFormat:@"%@分割线%@",array[0],str];
        [dataresult writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];

        [self getData];
        [self tableView:self.playListTab didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    }
    

}

#pragma mark - cell按钮点击收缩展开代理 - 
-(void)choosedMusic:(UIButton *)sender{
    
}

#pragma mark --- 轻拍手势的点击方法 ---
- (void)tapAction:(UITapGestureRecognizer *)sender{
    
    playListDetalCell *cell = (playListDetalCell *)sender.view;
    [self.tempMArray[cell.tag - 1000] isEqualToString:@"0"]?[self.tempMArray replaceObjectAtIndex:cell.tag - 1000 withObject:@"1"]:[self.tempMArray replaceObjectAtIndex:cell.tag - 1000 withObject:@"0"];
    [self.playListTab reloadData];
    NSLog(@"我是轻拍手势的cell===%@",cell);
}

#pragma mark - 弹窗textview点击确定的代理方法 -
//确定按钮点击
-(void)at_textViewDidEndEditing:(UITextView *)at_textView{
    
    [self.dataArr removeAllObjects];
    [self.mArray removeAllObjects];
    NSString *createPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileNameChart = [NSString stringWithFormat:@"%@/%@.musiclist", createPath,at_textView.text];
    //检查是否存在
    if(![[NSFileManager defaultManager] fileExistsAtPath:fileNameChart])
        [[NSFileManager defaultManager] createFileAtPath:fileNameChart contents:nil attributes:nil];
    
    NSFileHandle *logFileChart = [NSFileHandle fileHandleForWritingAtPath:fileNameChart];
    [logFileChart seekToEndOfFile];
    //把歌单写入本地文件
    [@"分割线" writeToFile:fileNameChart atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSString *pathDocuments=kDocument;
    NSArray *fileNameList=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathDocuments error:nil];
    NSMutableArray *arr = [fileNameList mutableCopy];
    if ([arr containsObject:@".DS_Store"]) {
        [arr removeObject:@".DS_Store"];
    }
    if ([arr containsObject:@"musicData"]) {
        [arr removeObject:@"musicData"];
    }
    if ([arr containsObject:@"user.data"]) {
        [arr removeObject:@"user.data"];
    }
    if ([arr containsObject:@"user"]) {
        [arr removeObject:@"user"];
    }
    if ([arr containsObject:@"operDB.sqlite"]) {
        [arr removeObject:@"operDB.sqlite"];
    }
    if ([arr containsObject:@"diejiamusic"]) {
        [arr removeObject:@"diejiamusic"];
    }
    NSDictionary *zhudic  = [[NSDictionary alloc] init];
    NSDictionary *fudic  = [[NSDictionary alloc] init];
    for (int i=0; i<arr.count; i++) {
        NSArray *array = [arr[i] componentsSeparatedByString:@"."];
        [self.dataArr addObject:array[0]];
        [self.tempMArray addObject:@"0"];
        NSString *path = [NSString stringWithFormat:@"%@/%@",FILEPATH,arr[i]];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSArray *array1 = [result componentsSeparatedByString:@"分割线"];
        NSArray *array2 = [array1[0] componentsSeparatedByString:@"?"];
        NSArray *array3 = [array1[1] componentsSeparatedByString:@"?"];
        NSMutableArray *zhuCount = [array2 mutableCopy];
        NSMutableArray *fuCount = [array3 mutableCopy];
        [zhuCount removeLastObject];
        [fuCount removeLastObject];
        NSLog(@"%d",zhuCount.count);
        NSLog(@"%d",fuCount.count);
        zhudic = @{@"zhu":zhuCount};
        fudic = @{@"fu":fuCount};
        
        NSMutableArray *marr = [[NSMutableArray alloc] init];
        [marr addObject:zhudic];
        [marr addObject:fudic];
        [self.mArray addObject:marr];
        
        NSLog(@"%@",self.mArray);
    }
    [self.playListTab reloadData];

}
//取消按钮点击
- (void)at_textViewCancel{

}

#pragma mark - 懒加载- 
-(NSMutableArray *)mArray{
    
    if (!_mArray) {
        
        _mArray = [[NSMutableArray alloc]init];
    }
    return _mArray;
}
- (NSMutableArray *)tempMArray{
    
    if (!_tempMArray) {
        
        _tempMArray = [[NSMutableArray alloc]init];
    }
    return _tempMArray;
}







//获取列表数据
-(void)getData{
    self.dataArr = [[NSMutableArray alloc] init];
    [self.mArray removeAllObjects];
    
    NSString *pathDocuments=kDocument;
    NSArray *fileNameList=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathDocuments error:nil];
    NSMutableArray *arr = [fileNameList mutableCopy];
    if ([arr containsObject:@".DS_Store"]) {
        [arr removeObject:@".DS_Store"];
    }
    if ([arr containsObject:@"musicData"]) {
        [arr removeObject:@"musicData"];
    }
    if ([arr containsObject:@"user.data"]) {
        [arr removeObject:@"user.data"];
    }
    if ([arr containsObject:@"user"]) {
        [arr removeObject:@"user"];
    }
    if ([arr containsObject:@"operDB.sqlite"]) {
        [arr removeObject:@"operDB.sqlite"];
    }
    if ([arr containsObject:@"diejiamusic"]) {
        [arr removeObject:@"diejiamusic"];
    }
    NSDictionary *zhudic  = [[NSDictionary alloc] init];
    NSDictionary *fudic  = [[NSDictionary alloc] init];
    for (int i=0; i<arr.count; i++) {
        NSArray *array = [arr[i] componentsSeparatedByString:@"."];
        [self.dataArr addObject:array[0]];
        [self.tempMArray addObject:@"0"];
        NSString *path = [NSString stringWithFormat:@"%@/%@",FILEPATH,arr[i]];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSArray *array1 = [result componentsSeparatedByString:@"分割线"];
        NSArray *array2 = [array1[0] componentsSeparatedByString:@"?"];
        NSArray *array3 = [array1[1] componentsSeparatedByString:@"?"];
        NSMutableArray *zhuCount = [array2 mutableCopy];
        NSMutableArray *fuCount = [array3 mutableCopy];
        [zhuCount removeLastObject];
        [fuCount removeLastObject];
//        NSLog(@"%d",zhuCount.count);
//        NSLog(@"%d",fuCount.count);
        zhudic = @{@"zhu":zhuCount};
        fudic = @{@"fu":fuCount};
        
        NSMutableArray *marr = [[NSMutableArray alloc] init];
        [marr addObject:zhudic];
        [marr addObject:fudic];
        [self.mArray addObject:marr];
    }
    
    
    [self.playListTab reloadData];
}


//获取本地所有音乐
-(void)getLoaclMusic{
    
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *createPath=[NSString stringWithFormat:@"%@/musicData/五脏/情绪心理调节",cachesPath];
    
    NSString *createPath2=[NSString stringWithFormat:@"%@/musicData/情志/轻度疼痛",cachesPath];
    NSString *createPath21=[NSString stringWithFormat:@"%@/musicData/情志/轻微疼痛",cachesPath];
    NSString *createPath22=[NSString stringWithFormat:@"%@/musicData/情志/中度疼痛",cachesPath];
    
    NSString *createPath3=[NSString stringWithFormat:@"%@/musicData/脑健康/脑神经调节",cachesPath];
    
    NSString *createPath4=[NSString stringWithFormat:@"%@/musicData/改善睡眠/帮助入眠",cachesPath];
    NSString *createPath41=[NSString stringWithFormat:@"%@/musicData/改善睡眠/深度睡眠",cachesPath];
    NSString *createPath42=[NSString stringWithFormat:@"%@/musicData/改善睡眠/音乐唤醒简短版",cachesPath];
    NSString *createPath43=[NSString stringWithFormat:@"%@/musicData/改善睡眠/唤醒音乐",cachesPath];
    NSString *createPath44=[NSString stringWithFormat:@"%@/musicData/改善睡眠/自然之声",cachesPath];
    NSString *createPath5=[NSString stringWithFormat:@"%@/musicData/叠加/叠加",cachesPath];
    
    NSMutableArray *pathArr = [[NSMutableArray alloc] init];
    [pathArr addObject:createPath];
    [pathArr addObject:createPath2];
    [pathArr addObject:createPath21];
    [pathArr addObject:createPath22];
    [pathArr addObject:createPath3];
    
    [pathArr addObject:createPath4];
    [pathArr addObject:createPath41];
    [pathArr addObject:createPath42];
    [pathArr addObject:createPath43];
    [pathArr addObject:createPath44];
    [pathArr addObject:createPath5];
    
    
    BOOL isok = NO;
    for (int i = 0; i<pathArr.count; i++) {
        if (isok) {
            return;
        }
        //检查是否存在
        if(![[NSFileManager defaultManager] fileExistsAtPath:pathArr[i]]){
            //不存在
            [[NSFileManager defaultManager] createDirectoryAtPath:pathArr[i] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSArray *oldMusicarr = [NSArray array];
        oldMusicarr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathArr[i] error:nil];
        
        for (int y=0; y<oldMusicarr.count; y++) {

            if ([self.zhumusicName isEqualToString:oldMusicarr[y]]) {
                NSURL *localUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",pathArr[i],oldMusicarr[y]]];
                [self.zhuplayer playWithUrlStr:localUrl PlayerLayer:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-40, 220)];
                isok = YES;
                return;
                
            }
        }
    }
}

//获取本地所有音乐
-(void)fugetLoaclMusic{
    
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *createPath=[NSString stringWithFormat:@"%@/musicData/五脏/情绪心理调节",cachesPath];
    
    NSString *createPath2=[NSString stringWithFormat:@"%@/musicData/情志/轻度疼痛",cachesPath];
    NSString *createPath21=[NSString stringWithFormat:@"%@/musicData/情志/轻微疼痛",cachesPath];
    NSString *createPath22=[NSString stringWithFormat:@"%@/musicData/情志/中度疼痛",cachesPath];
    
    NSString *createPath3=[NSString stringWithFormat:@"%@/musicData/脑健康/脑神经调节",cachesPath];
    
    NSString *createPath4=[NSString stringWithFormat:@"%@/musicData/改善睡眠/帮助入眠",cachesPath];
    NSString *createPath41=[NSString stringWithFormat:@"%@/musicData/改善睡眠/深度睡眠",cachesPath];
    NSString *createPath42=[NSString stringWithFormat:@"%@/musicData/改善睡眠/音乐唤醒简短版",cachesPath];
    NSString *createPath43=[NSString stringWithFormat:@"%@/musicData/改善睡眠/唤醒音乐",cachesPath];
    NSString *createPath44=[NSString stringWithFormat:@"%@/musicData/改善睡眠/自然之声",cachesPath];
    NSString *createPath5=[NSString stringWithFormat:@"%@/musicData/叠加/叠加",cachesPath];
    
    NSMutableArray *pathArr = [[NSMutableArray alloc] init];
    [pathArr addObject:createPath];
    [pathArr addObject:createPath2];
    [pathArr addObject:createPath21];
    [pathArr addObject:createPath22];
    [pathArr addObject:createPath3];
    
    [pathArr addObject:createPath4];
    [pathArr addObject:createPath41];
    [pathArr addObject:createPath42];
    [pathArr addObject:createPath43];
    [pathArr addObject:createPath44];
    [pathArr addObject:createPath5];
    
    
    BOOL isok = NO;
    for (int i = 0; i<pathArr.count; i++) {
        if (isok) {
            return;
        }
        //检查是否存在
        if(![[NSFileManager defaultManager] fileExistsAtPath:pathArr[i]]){
            //不存在
            [[NSFileManager defaultManager] createDirectoryAtPath:pathArr[i] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSArray *oldMusicarr = [NSArray array];
        oldMusicarr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathArr[i] error:nil];
        
        for (int y=0; y<oldMusicarr.count; y++) {
            
            if ([self.fumusicName isEqualToString:oldMusicarr[y]]) {
                NSURL *localUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",pathArr[i],oldMusicarr[y]]];
                [self.fuplayer playWithUrlStr:localUrl PlayerLayer:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-40, 220)];
                isok = YES;
                return;
                
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end