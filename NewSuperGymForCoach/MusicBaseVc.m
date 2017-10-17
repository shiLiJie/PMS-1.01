//
//  MusicBaseVc.m
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 2017/5/23.
//  Copyright © 2017年 HanYouApp. All rights reserved.
//

#import "MusicBaseVc.h"
#import "collectionCell.h"
#import "musicClassModel.h"
#import "DetailCell.h"
#import "musicModel.h"
#import "MusicCell.h"
#import "SLJAVPlayer.h"
#import "currentTimeView.h"
#import "ICInfomationView.h"
#import "SLJInfomationView.h"
#import "voiceChangeView.h"
#import <AVFoundation/AVFoundation.h>

#define kChannels   2
#define kOutputBus  0
#define kInputBus   1
#define AUDIO_SAMPLE_RATE 44100 //采样频率
#define _IOBASEFREQUENCY  613 //每位采样时间
#define BufferSize (int)(AUDIO_SAMPLE_RATE / _IOBASEFREQUENCY/2)*2 //每段波形上数据点数


@interface MusicBaseVc ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,playerDelegate,MusicCellDelegate,voiceChangeViewDelegate>
{
    
    AURenderCallbackStruct		_inputProc;
    Float64						_hwSampleRate;//采样频率
    SignedByte                  _outHighHighBuffer[BufferSize];//波形为0，波峰
    SignedByte                  _outHighLowBuffer[BufferSize];//波形为1，半个波峰+半个波底
    SignedByte                  _outLowHighBuffer[BufferSize];//波形为1，半个波底+半个波峰
    SignedByte                  _outLowLowBuffer[BufferSize];//波形为0，波底
    BOOL                         bSend;//数据发送标志位，如果需要发送数据置为True
    NSData                       *_sendData;//发送数据
    NSUInteger                   _sendBufIndex;//数据发送的索引
}
//音乐曲库的collection
@property (nonatomic, strong) UICollectionView *collectionView;
//左侧音乐类型列表
@property (weak, nonatomic) IBOutlet UITableView *musicCalssTab;
//类型对应的具体音乐列表
@property (weak, nonatomic) IBOutlet UITableView *musicDetalTable;
//音乐库名称
@property (nonatomic, strong) NSMutableArray *listArr;
//音乐库对应的具体音乐
@property (nonatomic, strong) NSMutableArray *dataArr;
//当前音乐库名称
@property (nonatomic, strong) NSString *musicClassName;
//当前音乐名称
@property (nonatomic, strong) NSString *musicName;
//返回按钮
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
//顶部背景图
@property (weak, nonatomic) IBOutlet UIImageView *bigImage;
//播放全部按钮
@property (weak, nonatomic) IBOutlet UIButton *playAllBtn;
//音乐分类的id,获取分类音乐使用
@property (nonatomic, copy) NSString *musicClassId;
//音乐播放器
@property (nonatomic, strong) SLJAVPlayer *player;
//进度条
@property (weak, nonatomic) IBOutlet UISlider *progressView;
//淡出按钮
@property (weak, nonatomic) IBOutlet UIButton *danruBtn;
//淡入按钮
@property (weak, nonatomic) IBOutlet UIButton *danchuBtn;
//歌曲名lab
@property (weak, nonatomic) IBOutlet UILabel *musicNameLab;
//音量按钮
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
//总时长lab
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLab;
//开始暂停按钮
@property (weak, nonatomic) IBOutlet UIButton *playOrStopBtn;
//下一曲按钮
@property (weak, nonatomic) IBOutlet UIButton *playNextBtn;
//上一曲按钮
@property (weak, nonatomic) IBOutlet UIButton *playUpBtn;
@property (weak, nonatomic) IBOutlet UIView *progressViewBGview;
//是否正在播放
@property (nonatomic, assign) BOOL isPlaying;
//当前音乐播放的索引
@property (nonatomic, strong) NSIndexPath *musicIndex;
//淡入
@property (nonatomic, assign) BOOL isDanru;
//淡出
@property (nonatomic, assign) BOOL isDanchu;
//音量进度条
@property (nonatomic, strong) UISlider *slider;
//当前音量
@property (nonatomic, assign) float voice;
//进度条上当前时间view
@property (nonatomic, strong) currentTimeView *currentView;
//音量lab
@property (weak, nonatomic) IBOutlet UILabel *voiceLab;

@property (nonatomic, strong) voiceChangeView *voiceChange;//大的音量调整进度条

@property (nonatomic, copy) NSString *collectionName;

@property (nonatomic, assign) BOOL isLocal;

@property (nonatomic, strong) NSMutableArray *totalLocalMusicArr;


@end

@implementation MusicBaseVc
@synthesize toneUnit;
@synthesize mAudioFormat;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isPlaying = NO;
    self.isDanru   = NO;
    self.isDanchu  = NO;
    
    self.isLocal   = NO;
    
    [self.danruBtn setImage:[UIImage imageNamed:@"danru-1"] forState:UIControlStateNormal];
    [self.danchuBtn setImage:[UIImage imageNamed:@"danchu-1"] forState:UIControlStateNormal];
    
    self.musicCalssTab.delegate     = self;
    self.musicCalssTab.dataSource   = self;
    self.musicDetalTable.delegate   = self;
    self.musicDetalTable.dataSource = self;
    
    self.voice = 0.5f;
    
    self.musicIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    
    //添加进度条滑块并设置约束
    self.currentView = [[currentTimeView alloc] initWithFrame:CGRectMake(self.progressView.centerX-self.progressView.frameWidth/2, self.progressView.centerY-40, 50, 30)];
    self.currentView.currentTimeLab.text = @"00:00";
    [self.progressViewBGview addSubview:self.currentView];
    
    [self.currentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.progressView).with.offset(-23);
        make.centerY.equalTo(self.progressView).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(50,30));
    }];
    
    //添加collection
    [self addCollection];

    //添加音乐播放器
    [self addMusicPlayer];
    
    [SLJNotificationTools addaddObserver:self selector:@selector(loginOut) methodName:@"LOGINOUT"];
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];//创建单例对象并且使其设置为活跃状态.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:)   name:AVAudioSessionRouteChangeNotification object:nil];//设置通知
    
    
}

//退出登录的通知方法,关掉播放器
-(void)loginOut{
    self.isPlaying = NO;
    [self.player resetPlayer];
}

#pragma mark - 控件方法 -
//淡入按钮点击
- (IBAction)danru:(UIButton *)sender {
    if (self.isDanru) {
        self.isDanru = NO;
        [sender setImage:[UIImage imageNamed:@"danru-1"] forState:UIControlStateNormal];
    }else{
        self.isDanru = YES;
        [sender setImage:[UIImage imageNamed:@"danru"] forState:UIControlStateNormal];
    }
}
//淡出按钮点击
- (IBAction)danchu:(UIButton *)sender {
    if (self.isDanchu) {
        self.isDanchu = NO;
        [sender setImage:[UIImage imageNamed:@"danchu-1"] forState:UIControlStateNormal];
    }else{
        self.isDanchu = YES;
        [sender setImage:[UIImage imageNamed:@"danchu"] forState:UIControlStateNormal];
    }
}
//音量按钮点击
- (IBAction)changeVoice:(UIButton *)sender {
//    if (!self.slider) {
//        self.slider = [[UISlider alloc] initWithFrame:CGRectMake(self.voiceBtn.centerX-35, self.voiceBtn.centerY-60, 70, 30)];
//        self.slider.transform = CGAffineTransformMakeRotation(-M_PI/2);;
//        [self.slider setThumbImage:[self OriginImage:[UIImage imageNamed:@"jindutiao"] scaleToSize:CGSizeMake(10, 10)] forState:UIControlStateNormal];
//        [self.slider setThumbImage:[self OriginImage:[UIImage imageNamed:@"jindutiao"] scaleToSize:CGSizeMake(10, 10)] forState:UIControlStateHighlighted];
//        [self.progressViewBGview addSubview:self.slider];
//        self.slider.value = self.player.player.volume;
//        self.slider.minimumTrackTintColor = RGBA(251, 166, 84, 1);
//        self.voiceLab.hidden = YES;
//    }else{
//        [self.slider removeFromSuperview];
//        self.slider = nil;
//        self.voiceLab.hidden = NO;
//    }
//    
//    // slider滑动中事件
//    [self.slider addTarget:self action:@selector(SliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    if (!self.voiceChange) {
        self.voiceChange = [[voiceChangeView alloc] initWithFrame:CGRectMake(100, 200, 250, 100)];
        self.voiceChange.voicePro.value = self.player.player.volume;
        [self.view addSubview:self.voiceChange];

        [self.voiceChange mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).with.offset(0);
            make.right.equalTo(self.view).with.offset(0);
            make.top.equalTo(self.view).with.offset(20);
            make.bottom.equalTo(self.view).with.offset(-self.progressViewBGview.frameHeight);
//            make.centerY.equalTo(self.progressView).with.offset(-10);
//            make.size.mas_equalTo(CGSizeMake(250,100));
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
    self.player.player.volume = slider.value;
    self.voice                = slider.value;
    self.voiceLab.text        = [NSString stringWithFormat:@"%.0f",self.player.player.volume*100];
}
//移除方法
-(void)remove{
    self.voiceChange = nil;
}

//开始或者暂停
- (IBAction)playOrStop:(UIButton *)sender {
    if (self.isPlaying) {
        self.isPlaying = NO;
        [sender setImage:[UIImage imageNamed:@"zantingicon"] forState:UIControlStateNormal];
        [self.player.player pause];
    }else{
        if (self.musicName==nil) {
            return;
        }
        self.isPlaying = YES;
        [sender setImage:[UIImage imageNamed:@"kaishiicon"] forState:UIControlStateNormal];
        [self.player.player play];
    }
}
//下一曲
- (IBAction)nextOneMusic:(UIButton *)sender {
    if (self.dataArr.count == 0) {//防止没有音乐数据奔溃
        return;
    }
    if (self.musicIndex.row+1 == self.dataArr.count) {
        self.musicIndex = [NSIndexPath indexPathForRow:0 inSection:0];
        [self tableView:self.musicDetalTable didSelectRowAtIndexPath:self.musicIndex];
    }else{
        self.musicIndex = [NSIndexPath indexPathForRow:self.musicIndex.row+1 inSection:self.musicIndex.section];
        [self tableView:self.musicDetalTable didSelectRowAtIndexPath:self.musicIndex];
    }
}
//上一曲
- (IBAction)upOneMusic:(UIButton *)sender {
    if (self.dataArr.count == 0) {//防止没有音乐数据奔溃
        return;
    }
    if (self.musicIndex.row == 0) {
        self.musicIndex = [NSIndexPath indexPathForRow:0 inSection:0];
        [self tableView:self.musicDetalTable didSelectRowAtIndexPath:self.musicIndex];
    }else{
        self.musicIndex = [NSIndexPath indexPathForRow:self.musicIndex.row-1 inSection:self.musicIndex.section];
        [self tableView:self.musicDetalTable didSelectRowAtIndexPath:self.musicIndex];
    }
}
//返回四大类型按钮点击
- (IBAction)backChooseMusicClass:(UIButton *)sender {
    self.collectionView.hidden = NO;
}
//播放全部按钮点击
- (IBAction)playAllBtnClick:(UIButton *)sender {
    self.musicIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    [self tableView:self.musicDetalTable didSelectRowAtIndexPath:self.musicIndex];
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
    if (self.musicName) {
        [playingInfoDict setObject:self.musicName forKey:MPMediaItemPropertyAlbumTitle];
    }
    // 4设置歌曲的总时长
    if (self.self.currentView.currentTimeLab.text) {
        [playingInfoDict setObject:[NSString stringWithFormat:@"%ld",(NSInteger)self.player.palyItem.duration.value / self.player.palyItem.duration.timescale] forKey:MPMediaItemPropertyPlaybackDuration];
    }
    //音乐信息赋值给获取锁屏中心的nowPlayingInfo属性
    playingInfoCenter.nowPlayingInfo = playingInfoDict;
    
    // 5.开启远程交互，只有开启这个才能进行远程操控
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

//通知方法的实现
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification
{
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
//            tipWithMessage(@"耳机插入");
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:{
//            tipWithMessage(@"耳机拔出，停止播放操作");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.isPlaying = YES;
                [weakSelf playOrStop:self.playOrStopBtn];
                
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
//        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        
//        [alerView show];
//        
//        [alerView performSelector:@selector(dismissWithClickedButtonIndex:animated:) withObject:@[@0, @1] afterDelay:0.9];
//        
//    });
//    
//}

//不管何时,只要有通知中心的出现,在dealloc的方法中都要移除所有观察者.
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}

//音量进度条滑动
- (void)SliderValueChanged:(UISlider *)slider{
    self.player.player.volume = slider.value;
    self.voice                = slider.value;

}

//播放器定时器一秒调用一次方法
- (void)startTime {
    if (self.player.palyItem.duration.timescale != 0) {
        
        self.progressView.value  = CMTimeGetSeconds([self.player.palyItem currentTime]) / (self.player.palyItem.duration.value / self.player.palyItem.duration.timescale);//当前进度
        
        //当前时长进度progress
        NSInteger proMin = (NSInteger)CMTimeGetSeconds([self.player.player currentTime]) / 60;//当前秒
        NSInteger proSec = (NSInteger)CMTimeGetSeconds([self.player.player currentTime]) % 60;//当前分钟
        
        //duration 总时长
        NSInteger durMin = (NSInteger)self.player.palyItem.duration.value / self.player.palyItem.duration.timescale / 60;//总秒
        NSInteger durSec = (NSInteger)self.player.palyItem.duration.value / self.player.palyItem.duration.timescale % 60;//总分钟
        
        NSString *pro    = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
        NSString *pro1   = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
        //更新滑块约束
        [self.currentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.progressView).with.offset(self.progressView.frameWidth*self.progressView.value-23);
            make.centerY.equalTo(self.progressView).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(50,30));
        }];
        self.currentView.currentTimeLab.text = pro;//当前时间赋值
        self.totalTimeLab.text   = pro1;//总时间赋值
        if (![self.currentView.currentTimeLab.text isEqualToString:@"00:00"]) {
            [MBProgressHUD hideHUD];
            
//            [self initHighLowBuffer];
//            [self configAudio];
            
        }
        //音量赋值
        if (self.player.player.volume*100<0) {//防越界
            self.voiceLab.text = @"0";
        }else{
            self.voiceLab.text = [NSString stringWithFormat:@"%.0f",self.player.player.volume*100];
        }
        
        //设置远程时间进度条
        if ([self.currentView.currentTimeLab.text isEqualToString:@"00:00"]) {
            [self setupLockScreenInfo];
        }
        
        
        NSInteger currentSec = (NSInteger)CMTimeGetSeconds([self.player.player currentTime]);
        NSInteger totalSec   = (NSInteger)self.player.palyItem.duration.value / self.player.palyItem.duration.timescale;
        //在音量控制的情况下不执行淡入淡出方法
        if (!self.slider) {
            if (self.isDanchu) {//淡出
                //评判淡出的标准
                if (totalSec - currentSec < 10) {
                    //淡出咯
                    if (self.player.player > 0) {
                        if (self.player.player.volume <= 0){
                            return;
                        }
                        self.player.player.volume = self.player.player.volume -=0.1;
//                        NSLog(@"淡出%f",self.player.player.volume);
                    }
                }
            }
            if (self.isDanru) {//淡入
                if (totalSec - currentSec > 10){
                    //淡入咯
                    if (self.player.player.volume < self.voice) {
                        if (self.player.player.volume >= self.voice){
                            return;
                        }
                        self.player.player.volume = self.player.player.volume +=0.1;
//                        NSLog(@"淡入%f",self.player.player.volume);
                    }
                }
                
            }
        }
    }
}
//添加音乐播放器
-(void)addMusicPlayer{
    [self.progressView setThumbImage:[self OriginImage:[UIImage imageNamed:@"jindutiao"] scaleToSize:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    [self.progressView setThumbImage:[self OriginImage:[UIImage imageNamed:@"jindutiao"] scaleToSize:CGSizeMake(10, 10)] forState:UIControlStateHighlighted];
}

-(SLJAVPlayer *)player{
    if (!_player) {
        //初始化音乐播放器
        _player               = [[SLJAVPlayer alloc] initWithFrame:CGRectMake(20, 120, [UIScreen mainScreen].bounds.size.width-40, 220)];
        _player.delegate      = self;
        
        
    }
    return _player;
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

//获取歌曲类型列表
-(void)addMusicClassList:(NSIndexPath *)index{
    
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *createPath;
    if (index.row == 0) {
        createPath=[NSString stringWithFormat:@"%@/musicData/五脏",cachesPath];
        self.collectionName = @"五脏";
    }
    if (index.row == 1) {
        createPath=[NSString stringWithFormat:@"%@/musicData/情志",cachesPath];
        self.collectionName = @"情志";
    }
    if (index.row == 2) {
        createPath=[NSString stringWithFormat:@"%@/musicData/脑健康",cachesPath];
        self.collectionName = @"脑健康";
    }
    if (index.row == 3) {
        createPath=[NSString stringWithFormat:@"%@/musicData/改善睡眠",cachesPath];
        self.collectionName = @"改善睡眠";
    }

    NSArray *oldMusicarr = [NSArray array];
    oldMusicarr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:createPath error:nil];
    self.listArr = [oldMusicarr mutableCopy];
    if ([self.listArr containsObject:@".DS_Store"]) {
        [self.listArr removeObject:@".DS_Store"];
    }
    
    [self.musicCalssTab reloadData];
    
    if (self.listArr.count>0) {
        self.isLocal = YES;
        self.collectionView.hidden = YES;
        return;
    }
    
    self.isLocal = NO;
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
                                                            
                                                            if (index.row==0) {
                                                                if ([dict[@"name"] isEqualToString:@"情绪心理调节"]) {
                                                                    [arrayM addObject:[musicClassModel musicClassWithDict:dict]];//中转数组存放转成模型的字典
                                                                }
                                                            }
                                                            
                                                            if (index.row==1) {
                                                                if ([dict[@"name"] isEqualToString:@"轻度疼痛"] ||
                                                                    [dict[@"name"] isEqualToString:@"轻微疼痛"] ||
                                                                    [dict[@"name"] isEqualToString:@"中度疼痛"]) {
                                                                    [arrayM addObject:[musicClassModel musicClassWithDict:dict]];//中转数组存放转成模型的字典
                                                                }
                                                            }
                                                            
                                                            if (index.row==2) {
                                                                if ([dict[@"name"] isEqualToString:@"脑神经调节"]) {
                                                                    [arrayM addObject:[musicClassModel musicClassWithDict:dict]];//中转数组存放转成模型的字典
                                                                }
                                                            }
                                                            
                                                            if (index.row==3) {
                                                                if ([dict[@"name"] isEqualToString:@"帮助入眠"] ||
                                                                    [dict[@"name"] isEqualToString:@"深度睡眠"] ||
                                                                    [dict[@"name"] isEqualToString:@"音乐唤醒简短版"] ||
                                                                    [dict[@"name"] isEqualToString:@"唤醒音乐"] ||
                                                                    [dict[@"name"] isEqualToString:@"自然之声"]) {
                                                                    [arrayM addObject:[musicClassModel musicClassWithDict:dict]];//中转数组存放转成模型的字典
                                                                }
                                                            }
   
                                                        }
//                                                        NSLog(@"%@",arrayM);
                                                        self.listArr = arrayM;
                                                        
                                                        if (self.listArr.count == 0) {
                                                            [MBProgressHUD showError:@"没有音频数据"];
                                                            return;
                                                        }
                                                        
                                                        [self.musicCalssTab reloadData];
                                                        
                                                        NSArray *arrimage = @[@"naojiankang-1",@"ganshanshuimian-1",@"naojiankang-1",@"ganshanshuimian-1"];
                                                        self.bigImage.image = [UIImage imageNamed:arrimage[index.row]];
                                                        CATransition *animation = [CATransition animation];
                                                        animation.type = kCATransitionFade;
                                                        animation.duration = 0.4;
                                                        [self.collectionView.layer addAnimation:animation forKey:nil];
                                                        
                                                        self.collectionView.hidden = YES;
                                                        
                                                    }
                                                       fail:^(NSError *error) {
//                                                           NSLog(@"error--%@",error);
                                                           [MBProgressHUD showError:@"请检查网络连接"];
                                                       }];
}

//获取具体类型下的音乐列表
-(void)addMusicData:(NSIndexPath *)index{
    
    NSString *token        = [NSString md5WithString];

    NSDictionary *dict     = @{
                               @"token":token,
                               @"p":@"1",
                               @"num":@"20",
                               @"cate":self.musicClassId,
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
                                                        self.dataArr = arrayM;
                                                        [self.musicDetalTable reloadData];
                                                        
                                                    }
                                                       fail:^(NSError *error) {
//                                                           NSLog(@"error--%@",error);
                                                       }];
}

//添加collection
-(void)addCollection{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置collectionView的滚动方向，需要注意的是如果使用了collectionview的headerview或者footerview的话， 如果设置了水平滚动方向的话，那么就只有宽度起作用了了
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView. backgroundColor = RGBA(248, 248, 248, 1);
    self.collectionView.dataSource       = self;
    self.collectionView.delegate         = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(20);
        make.left.equalTo(self.view).with.offset(-2);
        make.size.mas_equalTo(CGSizeMake(844,748));
    }];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"collectionCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
}

#pragma mark - tableviewdelegate -
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.musicCalssTab) {
        return 80;
    }else{
        return 50;
    }    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.musicCalssTab) {
        return _listArr.count;
    }else{
        return _dataArr.count;
    }
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //二级列表table
    if (tableView==self.musicCalssTab) {
        static NSString *cellIdentifier = @"cell";
        DetailCell *cell       = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

        NSArray *nib1          = [[NSBundle mainBundle]loadNibNamed:@"DetailCell" owner:nil options:nil];
        cell                   = [nib1 lastObject];
        cell.lineImage.hidden  = YES;
        if (self.isLocal) {
            cell.musicnameLab.text = self.listArr[indexPath.row];
        }else{
            musicClassModel *model = self.listArr[indexPath.row];
            cell.musicnameLab.text = model.name;
        }


        if ([cell.musicnameLab.text isEqualToString:self.musicClassName]) {
            cell.musicnameLab.textColor = RGBA(98, 173, 112, 1);
            cell.lineImage.hidden       = NO;
        }
        cell.selectionStyle      = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
        //三级级列表table
        static NSString *cellIdentifier = @"cell";
        MusicCell *cell          = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

        NSArray *nib1            = [[NSBundle mainBundle]loadNibNamed:KCellMusicCell owner:nil options:nil];
        cell                     = [nib1 lastObject];
        if (self.isLocal) {
            cell.MusicLabel.text     = self.dataArr[indexPath.row];
            cell.musicIndexLab.text  = [NSString stringWithFormat:@"%ld",indexPath.row+1];
            cell.shuxianImage.hidden = YES;
            cell.chooseMusicbtn.tag  = indexPath.row;
        }else{
            musicModel *model        = self.dataArr[indexPath.row];
            cell.MusicLabel.text     = model.name;
            cell.musicIndexLab.text  = [NSString stringWithFormat:@"%ld",indexPath.row+1];
            cell.shuxianImage.hidden = YES;
            cell.chooseMusicbtn.tag  = indexPath.row;
        }
        
        cell.delegate            = self;
        
        if ([cell.MusicLabel.text isEqualToString:self.musicName]) {
            cell.MusicLabel.textColor    = RGBA(251, 166, 84, 1);
            cell.musicIndexLab.textColor = RGBA(251, 166, 84, 1);
            cell.shuxianImage.hidden     = NO;
        }
        
        cell.selectionStyle      = UITableViewCellSelectionStyleNone;
        return cell;
    }
    

    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //二级列表table
    if (tableView==self.musicCalssTab) {
        
        if (self.listArr.count==0) {
            return;
        }
        if (self.isLocal) {
            NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            NSString *createPath = [NSString stringWithFormat:@"%@/musicData/%@/%@",cachesPath,self.collectionName,self.listArr[indexPath.row]];
            self.musicClassName = self.listArr[indexPath.row];
            
            NSArray *oldMusicarr = [NSArray array];
            oldMusicarr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:createPath error:nil];
            self.dataArr = [oldMusicarr mutableCopy];
            if ([self.dataArr containsObject:@".DS_Store"]) {
                [self.dataArr removeObject:@".DS_Store"];
            }
            [self.musicDetalTable reloadData];
            [self.musicCalssTab reloadData];
        }else{
            musicClassModel *model = self.listArr[indexPath.row];
            self.musicClassName = model.name;
            //传输歌曲分类的id
            self.musicClassId = model.path;
            //获取具体类型下的音乐列表
            [self addMusicData:indexPath];
            [self.musicCalssTab reloadData];
        }
  
    }else{
        if (self.dataArr.count == 0) {//防止没有音乐数据奔溃
            return;
        }
        //普通状体点击
        [self.player resetPlayer];//重置播放器
        
        if (self.isLocal) {
            [self getLoaclMusic:indexPath];
        }else{
            musicModel *model            = self.dataArr[indexPath.row];
            NSString *musicUrlstr        = model.url;
            self.musicName               = model.name;
            [self.musicDetalTable reloadData];
            self.musicIndex              = indexPath;
            NSURL *netlUrl = [NSURL URLWithString:musicUrlstr];
            [self.player playWithUrlStr:netlUrl PlayerLayer:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-40, 220)];
            
            [self.player startPaly];
            if (self.player.levelTimer) {
                [self.player.levelTimer invalidate];
                self.player.levelTimer       = nil;
            }
            self.player.levelTimer       = [NSTimer scheduledTimerWithTimeInterval: 1
                                                                            target: self
                                                                          selector: @selector(startTime)
                                                                          userInfo: nil repeats: YES];
            self.musicIndex              = indexPath;
        }
        
        
    }
}


#pragma mark - UICollectionViewDataSource -
/** 每组cell的个数*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

/** cell的内容*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    collectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSArray *arrname = @[@"心理陪伴",@"缓解疼痛",@"脑健康",@"改善睡眠"];
    NSArray *arrimage = @[@"xinlipeiban",@"huanjietengtong",@"naojiankang",@"gaishanshuimian"];
    


    for (int i = 0; i < indexPath.row+1; i ++) {
        cell.nameLab.text = arrname[i];
        cell.image.image = [UIImage imageNamed:arrimage[i]];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout -
/** 每个cell的尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(400, 350);
}

/** section的margin*/
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(17, 20, 0, 13);
}

#pragma mark - UICollectionViewDelegate -
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"点击了第 %zd组 第%zd个",indexPath.section, indexPath.row);
    
    
    //添加网络歌曲类别列表
    [self addMusicClassList:indexPath];
    //沙盒没放音乐防止提示

    
    [self.musicCalssTab reloadData];
    //默认选中第一行
//    NSIndexPath * selIndex = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self tableView:self.musicCalssTab didSelectRowAtIndexPath:selIndex];
    
}

#pragma mark - 播放器代理方法 -
-(void)startPlay{
    
    self.musicNameLab.text = self.musicName;
//    NSLog(@"开始播放");
    self.isPlaying = YES;
    [self.playOrStopBtn setImage:[UIImage imageNamed:@"kaishiicon"] forState:UIControlStateNormal];
    
    if (self.isDanru) {
        self.player.player.volume = 0;
    }else{
        self.player.player.volume = self.voice;
    }
    
    [MBProgressHUD showMessage:@"正在缓冲请稍后"];
    
//    [self initHighLowBuffer];
//    [self configAudio];
}


-(void)endPlay{
    
    if (self.musicIndex.row+1 >= self.dataArr.count) {
        self.isPlaying  = NO;
        [self.playOrStopBtn setImage:[UIImage imageNamed:@"zantingicon"] forState:UIControlStateNormal];
        return;
    }else{
        self.musicIndex = [NSIndexPath indexPathForRow:self.musicIndex.row+1 inSection:self.musicIndex.section];
        [self tableView:self.musicDetalTable didSelectRowAtIndexPath:self.musicIndex];
        self.isPlaying  = NO;
        [self.playOrStopBtn setImage:[UIImage imageNamed:@"zantingicon"] forState:UIControlStateNormal];
    }
}

#pragma mark - cell按钮点击时间代理事件,传过来cell的标题 -
-(void)changeMusicName:(NSString *)text button:(CellButton *)btn{
    
}

-(void)choosedMusic:(UIButton *)sender{
    
//    musicModel *model = self.dataArr[sender.tag];
    
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
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    for (int i=0; i<arr.count; i++) {
        NSArray *array = [arr[i] componentsSeparatedByString:@"."];
        [dataArr addObject:array[0]];
    }
    [ICInfomationView initWithTitle:@"请选择添加到的列表" message:@"" cancleButtonTitle:@"取消" OtherButtonsArray:dataArr clickAtIndex:^(NSInteger buttonIndex) {

        if (buttonIndex == 0) {
//            NSLog(@"取消");
        }else{
            //之前的歌单字符串
            NSString *path = [NSString stringWithFormat:@"%@/%@.musiclist",FILEPATH,dataArr[buttonIndex-1]];
            NSData *data = [NSData dataWithContentsOfFile:path];
            NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSString *fileNameChart = path;
            NSFileHandle *logFileChart = [NSFileHandle fileHandleForWritingAtPath:path];
            [logFileChart seekToEndOfFile];
            
            NSArray *array1 = [result componentsSeparatedByString:@"分割线"];
            
            NSString *zhu;
            if (self.isLocal) {
                //新选的歌单字符串
                zhu = [NSString stringWithFormat:@"%@*本地播放的?",self.dataArr[sender.tag]];
            }else{
                musicModel *model            = self.dataArr[sender.tag];
                NSString *musicUrlstr        = model.url;
                //新选的歌单字符串
                zhu = [NSString stringWithFormat:@"%@*%@?",model.name,musicUrlstr];
            }
            
            NSString *musicListStr = [NSString stringWithFormat:@"%@%@分割线%@",array1[0],zhu,array1[1]];
            //把歌单写入本地文件
            [musicListStr writeToFile:fileNameChart atomically:YES encoding:NSUTF8StringEncoding error:nil];

            
//            NSArray *choose = @[@"主音乐列表",@"叠加音乐列表"];
//            [SLJInfomationView initWithTitle:@"请选择主列表或叠加列表" message:@"" cancleButtonTitle:@"取消" OtherButtonsArray:choose clickAtIndex:^(NSInteger buttonIndex) {
//                
//                if (buttonIndex == 0) {
//                    NSLog(@"取消");
//                }else{
//                    NSArray *array1 = [result componentsSeparatedByString:@"分割线"];
//                    if (buttonIndex == 1) {
//                        //新选的歌单字符串
//                        NSString *zhu;
//                        NSString *path = [NSString stringWithFormat:@"%@/%@",self.musicClassId,self.dataArr[sender.tag]];
//                        zhu = [NSString stringWithFormat:@"%@,%@?",self.dataArr[sender.tag],path];
//                        
//                        NSString *musicListStr = [NSString stringWithFormat:@"%@%@分割线%@",array1[0],zhu,array1[1]];
//                        //把歌单写入本地文件
//                        [musicListStr writeToFile:fileNameChart atomically:YES encoding:NSUTF8StringEncoding error:nil];
//                    }else if(buttonIndex == 2){
//                        NSString *zhu;
//                        NSString *path = [NSString stringWithFormat:@"%@/%@",self.musicClassId,self.dataArr[sender.tag]];
//                        zhu = [NSString stringWithFormat:@"%@,%@?",self.dataArr[sender.tag],path];
//                        
//                        NSString *musicListStr = [NSString stringWithFormat:@"%@分割线%@%@",array1[0],array1[1],zhu];
//                        //把歌单写入本地文件
//                        [musicListStr writeToFile:fileNameChart atomically:YES encoding:NSUTF8StringEncoding error:nil];
//                    }
//
//
//
//                    
//                }
//            }];
            
        }
    }];
    
}

//获取本地所有音乐
-(void)getLoaclMusic:(NSIndexPath *)index{
    [self.totalLocalMusicArr removeAllObjects];
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
            if (index.row>=self.dataArr.count) {
                return;
            }
            if ([self.dataArr[index.row] isEqualToString:oldMusicarr[y]]) {
                NSURL *localUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",pathArr[i],oldMusicarr[y]]];
                [self.player playWithUrlStr:localUrl PlayerLayer:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-40, 220)];
                isok = YES;
                self.musicName               = oldMusicarr[y];
                [self.musicDetalTable reloadData];
                self.musicIndex              = index;
                [self.player startPaly];
                if (self.player.levelTimer) {
                    [self.player.levelTimer invalidate];
                    self.player.levelTimer       = nil;
                }
                self.player.levelTimer       = [NSTimer scheduledTimerWithTimeInterval: 1
                                                                                target: self
                                                                              selector: @selector(startTime)
                                                                              userInfo: nil repeats: YES];
                return;
                
            }
        }
    }
}

#pragma mark - 懒加载 -
-(NSMutableArray *)listArr{
    if (!_listArr) {
        _listArr = [[NSMutableArray alloc] init];
    }
    return _listArr;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

-(NSMutableArray *)totalLocalMusicArr{
    if (!_totalLocalMusicArr) {
        _totalLocalMusicArr = [[NSMutableArray alloc] init];
    }
    return _totalLocalMusicArr;
}



static void CheckError(OSStatus error,const char *operaton){
    if (error==noErr) {
        return;
    }
    char errorString[20]={};
    *(UInt32 *)(errorString+1)=CFSwapInt32HostToBig(error);
    if (isprint(errorString[1])&&isprint(errorString[2])&&isprint(errorString[3])&&isprint(errorString[4])) {
        errorString[0]=errorString[5]='\'';
        errorString[6]='\0';
    }else{
        sprintf(errorString, "%d",(int)error);
    }
    fprintf(stderr, "Error:%s (%s)\n",operaton,errorString);
    exit(1);
}
OSStatus RenderTone(
                    void *inRefCon,
                    AudioUnitRenderActionFlags 	*ioActionFlags,
                    const AudioTimeStamp 		*inTimeStamp,
                    UInt32 						inBusNumber,
                    UInt32 						inNumberFrames,
                    AudioBufferList 			*ioData)

{
    
    //    NSLog(@"RenderTone:%ld,%d",ioData->mBuffers[0].mDataByteSize,(unsigned int)inNumberFrames);
    // Get the tone parameters out of the view controller
    MusicBaseVc* THIS = (__bridge MusicBaseVc *)inRefCon;
    
    //收到数据解析
    
    NSUInteger BYTES_LEN=ioData->mBuffers[0].mDataByteSize;//数据收到的大小
    
    
    
    NSData *readData=[[NSData alloc] initWithBytes:ioData->mBuffers[0].mData length:ioData->mBuffers[0].mDataByteSize];//收到的数据
    NSLog(@"%@",readData);
    
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        //Update UI in UI thread here
        
    });
    
    NSUInteger bufferShort[BYTES_LEN/2];
    SInt16 testByte[BYTES_LEN];
    [readData getBytes:&testByte length:BYTES_LEN];
    //将二进制数据转换为有符号的整数
    for(int i=0;i<BYTES_LEN/2;i++)
    {
        bufferShort[i]=((testByte[2*i] & 0xff) | ((testByte[2*i + 1] << 8) ) );
    }
    
    
    
    if(THIS->bSend)//数据发送
    {
        //将需要发送的数据转换为每位的数据数组，判断每位数据0或1从初始化的波形中取数据填充
        NSUInteger dataLen =THIS->_sendData.length;
        int length=inNumberFrames*2*kChannels/2;
        SignedByte bitcodedData[8*BufferSize*dataLen];
        SignedByte dataByte[dataLen];
        SignedByte sendBufferByte[length];
        [THIS->_sendData getBytes:&dataByte length:dataLen];
        
        BOOL tmpSin = true;
        BOOL tmpUp = true;
        int temLen = 0;
        memset(bitcodedData, 0, 8*BufferSize*dataLen);
        
        for (int i = 0; i < dataLen; i++) {
            for (int j = 0; j < 8; j++) {
                int bit = (dataByte[i]>>j) & (0x01 );//逆序二进制//data[i] & (0x80 >> j);// 顺序二进制数
                if (bit != 0) {
                    if (tmpSin) {
                        if (tmpUp) {
                            for(int i=0;i<BufferSize;i++)
                            {
                                bitcodedData[i+temLen]=THIS->_outHighLowBuffer[i];
                            }
                            
                        } else {
                            for(int i=0;i<BufferSize;i++)
                            {
                                bitcodedData[i+temLen]=THIS->_outLowHighBuffer[i];
                            }
                        }
                    } else {
                        if (tmpUp) {
                            for(int i=0;i<BufferSize;i++)
                            {
                                bitcodedData[i+temLen]=THIS->_outLowHighBuffer[i];
                            }
                            tmpUp = false;
                        } else {
                            for(int i=0;i<BufferSize;i++)
                            {
                                bitcodedData[i+temLen]=THIS->_outHighLowBuffer[i];
                            }
                            tmpUp = true;
                        }
                    }
                    tmpSin = true;
                } else {
                    if (tmpSin) {
                        if (tmpUp) {
                            for(int i=0;i<BufferSize;i++)
                            {
                                bitcodedData[i+temLen]=THIS->_outHighHighBuffer[i];
                            }
                            
                        } else {
                            for(int i=0;i<BufferSize;i++)
                            {
                                bitcodedData[i+temLen]=THIS->_outLowLowBuffer[i];
                            }
                        }
                    } else {
                        if (tmpUp) {
                            for(int i=0;i<BufferSize;i++)
                            {
                                bitcodedData[i+temLen]=THIS->_outLowLowBuffer[i];
                            }
                            tmpUp = false;
                        } else {
                            for(int i=0;i<BufferSize;i++)
                            {
                                bitcodedData[i+temLen]=THIS->_outHighHighBuffer[i];
                            }
                            tmpUp = true;
                        }
                    }
                    tmpSin = false;
                }
                temLen +=BufferSize;
            }
        }
        
        for (UInt32 i=0; i < inNumberFrames*2*kChannels/2; i++)
        {
            sendBufferByte[i]=bitcodedData[i+THIS->_sendBufIndex];
            
        }
        THIS->_sendBufIndex+=inNumberFrames*2*kChannels/2;
        // copy data into left channel
        memcpy(ioData->mBuffers[0].mData, sendBufferByte, ioData->mBuffers[0].mDataByteSize);//发送数据
        if(THIS->_sendBufIndex>=8*BufferSize*dataLen)
        {
            THIS->bSend=FALSE;
        }
        
    }
    else
    {
        SInt32 values[inNumberFrames*2*kChannels/2];
        for (int j=0; j<inNumberFrames*2*kChannels/2; j++) {
            values[j]=0;
        }
        // copy data into left channel
        memcpy(ioData->mBuffers[0].mData, values, ioData->mBuffers[0].mDataByteSize);
        
    }
    
    
    return noErr;
}


void ToneInterruptionListener(void *inClientData, UInt32 inInterruptionState)
{
    MusicBaseVc* THIS = (__bridge MusicBaseVc *)inClientData;
    if (inInterruptionState == kAudioSessionEndInterruption) {
        // make sure we are again the active session
        AudioSessionSetActive(true);
        AudioOutputUnitStart(THIS->toneUnit);
    }
    
    if (inInterruptionState == kAudioSessionBeginInterruption) {
        AudioOutputUnitStop(THIS->toneUnit);
    }
    
}
#pragma mark -Audio Session Property Listener

void propListener(	void *                  inClientData,
                  AudioSessionPropertyID	inID,
                  UInt32                  inDataSize,
                  const void *            inData)
{
    MusicBaseVc* THIS = (__bridge MusicBaseVc *)inClientData;
    
    if (inID == kAudioSessionProperty_AudioRouteChange)
    {
        
        // if there was a route change, we need to dispose the current rio unit and create a new one
        CheckError(AudioComponentInstanceDispose(THIS->toneUnit), "couldn't dispose remote i/o unit");
        //Obtain a RemoteIO unit instance---------------------
        AudioComponentDescription acd;
        acd.componentType = kAudioUnitType_Output;
        acd.componentSubType = kAudioUnitSubType_RemoteIO;
        acd.componentFlags = 0;
        acd.componentFlagsMask = 0;
        acd.componentManufacturer = kAudioUnitManufacturer_Apple;
        AudioComponent inputComponent = AudioComponentFindNext(NULL, &acd);
        AudioComponentInstanceNew(inputComponent, &THIS->toneUnit);
        
        //The Remote I/O unit, by default, has output enabled and input disabled
        //Enable input scope of input bus for recording.
        UInt32 enable = 1;
        UInt32 disable=0;
        AudioUnitSetProperty(THIS->toneUnit,
                             kAudioOutputUnitProperty_EnableIO,
                             kAudioUnitScope_Input,
                             kInputBus,
                             &enable,
                             sizeof(enable));
        CheckError(AudioUnitSetProperty(THIS->toneUnit, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Input, 0, &THIS->_inputProc, sizeof(THIS->_inputProc)), "couldn't set remote i/o render callback");
        THIS->mAudioFormat.mSampleRate=AUDIO_SAMPLE_RATE;//采样率（立体声＝8000）
        THIS->mAudioFormat.mFormatID=kAudioFormatLinearPCM;//PCM格式
        THIS->mAudioFormat.mFormatFlags        = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
        THIS->mAudioFormat.mFramesPerPacket    = 1;//每个数据包多少帧
        THIS->mAudioFormat.mChannelsPerFrame   = kChannels/2;//1单声道，2立体声
        THIS->mAudioFormat.mBitsPerChannel     = 16;//语音每采样点占用位数
        THIS->mAudioFormat.mBytesPerFrame      = THIS->mAudioFormat.mBitsPerChannel*THIS->mAudioFormat.mChannelsPerFrame/8;//每帧的bytes数
        THIS->mAudioFormat.mBytesPerPacket     = THIS->mAudioFormat.mBytesPerFrame*THIS->mAudioFormat.mFramesPerPacket;//每个数据包的bytes总数，每帧的bytes数＊每个数据包的帧数
        //NSLog(@"%ld",mAudioFormat.mBytesPerPacket);
        THIS->mAudioFormat.mReserved           = 0;
        
        CheckError(AudioUnitSetProperty(THIS->toneUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, disable, &THIS->mAudioFormat, sizeof(THIS->mAudioFormat)), "couldn't set the remote I/O unit's output client format");
        CheckError(AudioUnitSetProperty(THIS->toneUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, enable, &THIS->mAudioFormat, sizeof(THIS->mAudioFormat)), "couldn't set the remote I/O unit's input client format");
        
        CheckError(AudioUnitInitialize(THIS->toneUnit), "couldn't initialize the remote I/O unit");
        //---------------------
        
        
        UInt32 size = sizeof(THIS->_hwSampleRate);
        CheckError(AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareSampleRate, &size, &THIS->_hwSampleRate), "couldn't get new sample rate");
        
        CheckError(AudioOutputUnitStart(THIS->toneUnit), "couldn't start unit");
        
        // we need to rescale the sonogram view's color thresholds for different input
        CFStringRef newRoute;
        size = sizeof(CFStringRef);
        CheckError(AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &size, &newRoute), "couldn't get new audio route");
        
    }
}






//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view, typically from a nib.
//    _hwSampleRate=AUDIO_SAMPLE_RATE;
//    [self initHighLowBuffer];
//    [self configAudio];
//}

// Initialize our remote i/o unit
- (void)configAudio
{
    // Set our tone rendering function on the unit
    _inputProc.inputProc = RenderTone;
    _inputProc.inputProcRefCon = (__bridge void *)(self);
    
    // Initialize and configure the audio session
    CheckError(AudioSessionInitialize(NULL, NULL, ToneInterruptionListener, (__bridge void *)(self)), "couldn't initialize audio session");
    CheckError(AudioSessionSetActive(true), "couldn't set audio session active\n");
    
    UInt32 audioCategory = kAudioSessionCategory_PlayAndRecord;
    CheckError(AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(audioCategory), &audioCategory), "couldn't set audio category");
    CheckError(AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, propListener, (__bridge void *)(self)), "couldn't set property listener");
    Float32 preferredBufferSize = .005;
    CheckError(AudioSessionSetProperty(kAudioSessionProperty_PreferredHardwareIOBufferDuration, sizeof(preferredBufferSize), &preferredBufferSize), "couldn't set i/o buffer duration");
    
    UInt32 size = sizeof(_hwSampleRate);
    CheckError(AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareSampleRate, &size, &_hwSampleRate), "couldn't get hw sample rate");
    //Obtain a RemoteIO unit instance
    AudioComponentDescription acd;
    acd.componentType = kAudioUnitType_Output;
    acd.componentSubType = kAudioUnitSubType_RemoteIO;
    acd.componentFlags = 0;
    acd.componentFlagsMask = 0;
    acd.componentManufacturer = kAudioUnitManufacturer_Apple;
    AudioComponent inputComponent = AudioComponentFindNext(NULL, &acd);
    AudioComponentInstanceNew(inputComponent, &toneUnit);
    
    //The Remote I/O unit, by default, has output enabled and input disabled
    //Enable input scope of input bus for recording.
    UInt32 enable = 1;
    UInt32 disable=0;
    AudioUnitSetProperty(toneUnit,
                         kAudioOutputUnitProperty_EnableIO,
                         kAudioUnitScope_Input,
                         kInputBus,
                         &enable,
                         sizeof(enable));
    CheckError(AudioUnitSetProperty(toneUnit, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Input, 0, &_inputProc, sizeof(_inputProc)), "couldn't set remote i/o render callback");
    mAudioFormat.mSampleRate=AUDIO_SAMPLE_RATE;//采样率（立体声＝8000）
    mAudioFormat.mFormatID=kAudioFormatLinearPCM;//PCM格式
    mAudioFormat.mFormatFlags        = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    mAudioFormat.mFramesPerPacket    = 1;//每个数据包多少帧
    mAudioFormat.mChannelsPerFrame   = kChannels/2;//1单声道，2立体声
    mAudioFormat.mBitsPerChannel     = 16;//语音每采样点占用位数
    mAudioFormat.mBytesPerFrame      = mAudioFormat.mBitsPerChannel*mAudioFormat.mChannelsPerFrame/8;//每帧的bytes数
    mAudioFormat.mBytesPerPacket     = mAudioFormat.mBytesPerFrame*mAudioFormat.mFramesPerPacket;//每个数据包的bytes总数，每帧的bytes数＊每个数据包的帧数
    mAudioFormat.mReserved           = 0;
    
    //2.设置remote io unit的渲染回调,从输入硬件获得采样传入到回调函数进行渲染,从而获得录音数据解析数据. 向回调函数填数据,从而向输出硬件提供数据进行放音发送数据.
    CheckError(AudioUnitSetProperty(toneUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, disable, &mAudioFormat, sizeof(mAudioFormat)), "couldn't set the remote I/O unit's output client format");
    CheckError(AudioUnitSetProperty(toneUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, enable, &mAudioFormat, sizeof(mAudioFormat)), "couldn't set the remote I/O unit's input client format");
    
    CheckError(AudioUnitInitialize(toneUnit), "couldn't initialize the remote I/O unit");
    //Obtain a RemoteIO unit instance
    UInt32 maxFPSt;
    size = sizeof(maxFPSt);
    CheckError(AudioUnitGetProperty(toneUnit, kAudioUnitProperty_MaximumFramesPerSlice, kAudioUnitScope_Global, 0, &maxFPSt, &size), "couldn't get the remote I/O unit's max frames per slice");
    //Create an audio file for recording
    
    
    CheckError(AudioOutputUnitStart(toneUnit), "couldn't start remote i/o unit");
    size = sizeof(mAudioFormat);
    CheckError(AudioUnitGetProperty(toneUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output,1, &mAudioFormat,&size), "couldn't get the remote I/O unit's output client format");
}

-(void)initHighLowBuffer
{
    for (int i = 0; i < BufferSize/2; i++) {
        // shorts.+
        _outHighHighBuffer[i * 2] = 0xFF;
        _outHighHighBuffer[i * 2 + 1] = 0x5F;
        _outLowLowBuffer[i * 2] = 0x00;
        _outLowLowBuffer[i * 2 + 1] = 0x80;
        if (i < BufferSize / 4) {
            _outHighLowBuffer[i * 2] = 0xFF;
            _outHighLowBuffer[i * 2 + 1] = 0x5F;
            _outLowHighBuffer[i * 2] = 0x00;
            _outLowHighBuffer[i * 2 + 1] =0x80;
        } else {
            _outHighLowBuffer[i * 2] = 0x00;
            _outHighLowBuffer[i * 2+1] = 0x80;
            _outLowHighBuffer[i * 2] = 0xFF;
            _outLowHighBuffer[i * 2+1] = 0x5F;
        }
    }
}










- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
