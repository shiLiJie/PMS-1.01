//
//  MineViewController.m
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 16/3/16.
//  Copyright © 2016年 HanYouApp. All rights reserved.
//

#import "MineViewController.h"
#import "MusicCell.h"
#import "musicModel.h"
#import "SLJAVPlayer.h"
#import "Imitation_AlertView_TextField.h"
#import "UIViewExt.h"
#import "MusicProCell.h"
#import "SLJPlayer.h"

@interface MineViewController ()<playerDelegate,Imitation_AlertView_TextFielddelegate,MusicProCellDelegate>

@property (weak, nonatomic) IBOutlet UIButton *playAllBtn;      //全部播放按钮
@property (weak, nonatomic) IBOutlet UIButton *morePlayBtn;     //多曲播放按钮
@property (weak, nonatomic) IBOutlet UIButton *chooseMusicBtn;  //选择音乐按钮
@property (weak, nonatomic) IBOutlet UIButton *talkBtn;         //演讲按钮
@property (weak, nonatomic) IBOutlet UIButton *nextOneBtn;      //下一曲按钮
@property (weak, nonatomic) IBOutlet UIButton *startOrStopBtn;  //开始/暂停按钮
@property (weak, nonatomic) IBOutlet UIButton *listMusicBtn;    //列表播放按钮
@property (weak, nonatomic) IBOutlet UIButton *xunhuanMusicBtn; //循环播放按钮
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLab;   //当前时间lab
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLab;     //总时长lab
@property (weak, nonatomic) IBOutlet UILabel *musicNameLab;     //音乐名称lab
@property (weak, nonatomic) IBOutlet UISlider *progressView;    //播放进度条slider
@property (weak, nonatomic) IBOutlet UIButton *danruBtn;        //淡入按钮
@property (weak, nonatomic) IBOutlet UIButton *danchuBtn;       //淡出按钮
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;       //创建歌单时取消按钮
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;         //创建歌单时确定按钮
@property (weak, nonatomic) IBOutlet UIButton *addMusicListBtn; //添加音乐到歌单按钮
@property (nonatomic, strong) NSMutableArray *dataArr;          //音乐数据数组
@property (nonatomic, strong) SLJAVPlayer *player;              //音乐播放器
@property (nonatomic, strong) NSIndexPath *musicIndex;          //当前音乐播放的索引
@property (nonatomic, strong) NSString *musicName;              //歌曲名称
@property (nonatomic, assign) BOOL isPlaying;                   //是否正在播放
@property (nonatomic, assign) int chooseIndex;                  //选中歌曲的索引
@property (nonatomic, strong) NSMutableArray *chooseArr;        //选中歌曲数组
@property (nonatomic, strong) NSMutableArray *chooseIndexArr;   //选中歌曲索引数组
@property (nonatomic, strong) NSMutableArray *musicListArr;     //新建歌曲数组

@property (nonatomic, copy)   NSString *fileNameChart;          //新歌单本地文件名
@property (nonatomic, strong) NSFileHandle * logFileChart;      //新歌单文件handle
@property (nonatomic, strong) NSMutableArray *musicListNameArr; //歌单路径名称数组
@property (nonatomic, assign) BOOL isAddMusic;                  //是否正在播放

@property (nonatomic ,copy) NSString *currentTIme;              //当前音乐播放时间
@property (nonatomic, assign) BOOL isDanru;                     //淡入
@property (nonatomic, assign) BOOL isDanchu;                    //淡出
@property (nonatomic, assign) BOOL isDuoqubofang;               //多曲播放

@property (nonatomic ,strong) NSMutableArray *moreMusicDataArr;     //多曲音乐数据数组
@property (nonatomic ,strong) NSMutableArray *moreMusicPlayArr;     //多曲播放器数组
@property (nonatomic, strong) Imitation_AlertView_TextField * textFieldView;//弹框套入的文本框

@end

@implementation MineViewController
//添加音乐到歌单按钮点击
- (IBAction)addMusicToList:(UIButton *)sender {
    //如果没有选中歌曲退出
    if (self.chooseArr.count == 0) {
        return;
    }
    
    self.musicListNameArr = [[NSMutableArray alloc] init];
    NSString *pathDocuments=kDocument;
    NSArray *fileNameList=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathDocuments error:nil];
    NSMutableArray *arr = [fileNameList mutableCopy];
    if ([arr containsObject:@".DS_Store"]) {
        [arr removeObject:@".DS_Store"];
    }
    if ([arr containsObject:@"musicData"]) {
        [arr removeObject:@"musicData"];
    }
    self.musicListNameArr = arr;
    self.isAddMusic = YES;
    [self.tableView reloadData];
    
}
//创建歌单时取消按钮点击
- (IBAction)cancelMusicList:(UIButton *)sender {
    
    self.isChooseing             = NO;
    
    self.cancelBtn.hidden        = YES;
    self.sureBtn.hidden          = YES;
    
    self.playAllBtn.hidden       = NO;
    self.morePlayBtn.hidden      = NO;
    self.chooseMusicBtn.hidden   = NO;
    
    [self.tableViewNew removeFromSuperview];
    
    self.tableWidth.constant     =  0;
    
    [self.musicListArr removeAllObjects];
        
}
//创建歌单时确定按钮点击
- (IBAction)sureMusicLIst:(UIButton *)sender {
    
    
    //如果新歌单有内容,弹出歌单命名弹窗
    if (self.musicListArr.count != 0) {
        [self.textFieldView viewShow];
        [self.view bringSubviewToFront:self.textFieldView];
    }

}

//调取上边方法切换刷新tableview
- (IBAction)LocalBtn:(UIButton *)sender {

    [self changeTable:sender btn:_NearBtn btn1:_PrivateBtn];
    NSLog(@"乐库");
    [self.delegate changeMusicBase];
}
- (IBAction)PrivateBtn:(UIButton *)sender {
    
    [self changeTable:sender btn:_NearBtn btn1:_LocalBtn];
    NSLog(@"患者");
    [self.delegate changePatientBase];
}
- (IBAction)NearBtn:(UIButton *)sender {

    [self changeTable:sender btn:_LocalBtn btn1:_PrivateBtn];
}
//播放全部
- (IBAction)playAll:(UIButton *)sender {
    self.musicIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    [self tableView:self.tableView didSelectRowAtIndexPath:self.musicIndex];
}
//选听
- (IBAction)chooseMusic:(UIButton *)sender {
    
    if (self.isAddMusic) {
        return;
    }
    
    if (!self.isXuanting) {
        self.isXuanting = YES;
        self.isXuanzhong = NO;
        NSLog(@"选听");
        [self.chooseIndexArr removeAllObjects];
        [self.chooseArr removeAllObjects];
        [sender setImage:nil forState:UIControlStateNormal];
        [sender setTitle:@"确认" forState:UIControlStateNormal];
        [self.morePlayBtn setImage:[UIImage imageNamed:@"quxiao"] forState:UIControlStateNormal];
        self.addMusicListBtn.hidden = NO;
        self.playAllBtn.hidden = YES;
        [self.tableView reloadData];
    }else{
        
        if (self.chooseArr.count==0) {
            self.isXuanting = NO;
            self.isXuanzhong = NO;
            [sender setTitle:@"" forState:UIControlStateNormal];
            [sender setImage:[UIImage imageNamed:@"xuantingicon"] forState:UIControlStateNormal];
            [self.morePlayBtn setImage:[UIImage imageNamed:@"duoqubofangicon"] forState:UIControlStateNormal];
            self.addMusicListBtn.hidden = YES;
            self.playAllBtn.hidden = NO;
            [self.tableView reloadData];
            return;
        }
        self.isXuanting = NO;
        self.isXuanzhong = YES;
        NSLog(@"选听确定");
        for (int i=0; i<self.dataArr.count; i++) {
            if ([self.chooseArr containsObject:self.dataArr[i]]) {
                
            }else{
                [self.chooseArr addObject:self.dataArr[i]];
            }
        }
        [sender setTitle:@"" forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"xuantingicon"] forState:UIControlStateNormal];
        [self.morePlayBtn setImage:[UIImage imageNamed:@"duoqubofangicon"] forState:UIControlStateNormal];
        self.addMusicListBtn.hidden = YES;
        self.playAllBtn.hidden = NO;
        [self.tableView reloadData];
        self.musicIndex = [NSIndexPath indexPathForRow:0 inSection:0];
        [self tableView:self.tableView didSelectRowAtIndexPath:self.musicIndex];
    }
    
}
//多曲播放
- (IBAction)morePlay:(UIButton *)sender {
    //取消选听
    if (self.isXuanting) {
        self.isXuanting = NO;
        self.isXuanzhong = NO;
        self.isAddMusic = NO;
        [self.chooseMusicBtn setTitle:@"" forState:UIControlStateNormal];
        [self.chooseMusicBtn setImage:[UIImage imageNamed:@"xuantingicon"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"duoqubofangicon"] forState:UIControlStateNormal];
        self.addMusicListBtn.hidden = YES;
        self.playAllBtn.hidden = NO;
        [self.tableView reloadData];
    }else{
        
        if (self.isDuoqubofang) {
            //关闭多曲播放模式
            self.isDuoqubofang = NO;
            //恢复两侧全部播放和选听按钮的交互事件
            self.playAllBtn.userInteractionEnabled=YES;
            self.playAllBtn.alpha=1;
            self.chooseMusicBtn.userInteractionEnabled=YES;
            self.chooseMusicBtn.alpha=1;
        }else{
            //开启多曲播放模式
            self.isDuoqubofang = YES;
            //禁用两侧全部播放和选听按钮
            self.playAllBtn.userInteractionEnabled=NO;
            self.playAllBtn.alpha=0.4;
            self.chooseMusicBtn.userInteractionEnabled=NO;
            self.chooseMusicBtn.alpha=0.4;
            
        }
    }
}
//演讲
- (IBAction)talk:(UIButton *)sender {
    if (!sender.selected) {
        //静音
        [sender setImage:[UIImage imageNamed:@"jieshuoicon-1"] forState:UIControlStateNormal];
        sender.selected           = YES;
        self.player.player.volume = 0;
    }else{
        //不静音
        [sender setImage:[UIImage imageNamed:@"jieshuoicon"] forState:UIControlStateNormal];
        sender.selected           = NO;
        self.player.player.volume = 1;
    }

}
//下一曲
- (IBAction)nextOneMusic:(UIButton *)sender {
    if (self.musicIndex.row+1 == self.dataArr.count) {
        self.musicIndex = [NSIndexPath indexPathForRow:0 inSection:0];
        [self tableView:self.tableView didSelectRowAtIndexPath:self.musicIndex];
    }else{
        self.musicIndex = [NSIndexPath indexPathForRow:self.musicIndex.row+1 inSection:self.musicIndex.section];
        [self tableView:self.tableView didSelectRowAtIndexPath:self.musicIndex];
    }
}
//开始或暂停
- (IBAction)startOrPause:(UIButton *)sender {
    if (self.isPlaying) {
        self.isPlaying = NO;
        [sender setImage:[UIImage imageNamed:@"zantingicon"] forState:UIControlStateNormal];
        [self.player.player pause];
    }else{
        if (self.musicName==nil) {
            return;
        }
        self.isPlaying = YES;
        [sender setImage:[UIImage imageNamed:@"kaishi"] forState:UIControlStateNormal];
        [self.player.player play];
    }

}

//列表播放
- (IBAction)listMusicPlay:(UIButton *)sender {
    //激活列表播放
    if (self.xunhuanMusicBtn.selected == YES) {
        self.xunhuanMusicBtn.selected = NO;
        [self.xunhuanMusicBtn setImage:[UIImage imageNamed:@"xuanhuan"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"shunxu-1"] forState:UIControlStateNormal];
        sender.selected               = YES;
    }else{
        //激活列表播放
        if (!sender.selected) {
            [sender setImage:[UIImage imageNamed:@"shunxu-1"] forState:UIControlStateNormal];
        sender.selected               = YES;
        }else{
            //关闭列表播放
            [sender setImage:[UIImage imageNamed:@"shunxu"] forState:UIControlStateNormal];
        sender.selected               = NO;
        }
    }
}

//循环播放
- (IBAction)xunhuanPlay:(UIButton *)sender {
    //激活循环播放
    if (self.listMusicBtn.selected == YES) {
        self.listMusicBtn.selected = NO;
        [self.listMusicBtn setImage:[UIImage imageNamed:@"shunxu"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"xuanhuan1"] forState:UIControlStateNormal];
        sender.selected            = YES;
    }else{
        //激活循环播放
        if (!sender.selected) {
            [sender setImage:[UIImage imageNamed:@"xuanhuan1"] forState:UIControlStateNormal];
        sender.selected            = YES;
        }else{
            //关闭循环播放
            [sender setImage:[UIImage imageNamed:@"xuanhuan"] forState:UIControlStateNormal];
        sender.selected            = NO;
        }
    }
}
//淡入
- (IBAction)danru:(UIButton *)sender {
    
    if (self.isDanru) {
        self.isDanru = NO;
        [sender setImage:[UIImage imageNamed:@"danru-1"] forState:UIControlStateNormal];
    }else{
        self.isDanru = YES;
        [sender setImage:[UIImage imageNamed:@"danru"] forState:UIControlStateNormal];
    }
}
//淡出
- (IBAction)danchu:(UIButton *)sender {
    
    if (self.isDanchu) {
        self.isDanchu = NO;
        [sender setImage:[UIImage imageNamed:@"danchu-1"] forState:UIControlStateNormal];
    }else{
        self.isDanchu = YES;
        [sender setImage:[UIImage imageNamed:@"danchu"] forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.LocalBtn.selected    = YES;
    self.isPlaying            = NO;
    self.isXuanting           = NO;
    self.isXuanzhong          = NO;
    self.isChooseing          = NO;
    self.isDuoqubofang        = NO;
    self.chooseIndex          = 0;

    self.cancelBtn.hidden     = YES;
    self.sureBtn.hidden       = YES;
    self.addMusicListBtn.hidden = YES;
    
    
    self.isDanru = YES;
    self.isDanchu = YES;

    self.dataArr              = [[NSMutableArray alloc] init];
    self.chooseArr            = [[NSMutableArray alloc] init];
    self.chooseIndexArr       = [[NSMutableArray alloc] init];
    self.musicListArr         = [[NSMutableArray alloc] init];
    self.moreMusicDataArr     = [[NSMutableArray alloc] init];
    self.moreMusicPlayArr     = [[NSMutableArray alloc] init];
    
//    //加载网络音乐数据
//    [self addMusicData];
    //初始化音乐播放器
    self.player               = [[SLJAVPlayer alloc] initWithFrame:CGRectMake(20, 120, [UIScreen mainScreen].bounds.size.width-40, 220)];
    self.player.delegate      = self;

    // slider开始滑动事件
    [self.progressView addTarget:self action:@selector(SliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    // slider滑动中事件
    [self.progressView addTarget:self action:@selector(SliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    // slider结束滑动事件
    [self.progressView addTarget:self action:@selector(SliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
    [self.progressView setThumbImage:[self OriginImage:[UIImage imageNamed:@"benr"] scaleToSize:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    [self.progressView setThumbImage:[self OriginImage:[UIImage imageNamed:@"benr"] scaleToSize:CGSizeMake(10, 10)] forState:UIControlStateHighlighted];
    
    self.textFieldView = [[Imitation_AlertView_TextField alloc] initWithFatherViewFrameWidth:700 withFrameHeight:750];
    self.textFieldView.title = @"歌单命名";
    [self.view addSubview:self.textFieldView];
    self.textFieldView.textMessage = @"";
    self.textFieldView.delegate = self;
    [self.textFieldView viewHidden];
}

-(UIImage*) OriginImage:(UIImage*)image scaleToSize:(CGSize)size

{
    
    UIGraphicsBeginImageContext(size);//size为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 共有方法 -
//加入新的歌单列表
-(void)addNewMusicList{
    self.tableViewNew            = [[RTDragCellTableView alloc] init];
    self.tableViewNew.frame      = CGRectMake(self.tableView.bounds.origin.x+self.tableView.frame.size.width/2, self.tableView.frame.origin.y, self.tableView.frame.size.width-350, self.tableView.frame.size.height);

    [self.view addSubview:self.tableViewNew];
    [self.tableViewNew addRecognizer];

    self.tableViewNew.delegate   = self;
    self.tableViewNew.dataSource = self;

    self.cancelBtn.hidden        = NO;
    self.sureBtn.hidden          = NO;
    
    self.addMusicListBtn.hidden  = YES;

    self.playAllBtn.hidden       = YES;
    self.morePlayBtn.hidden      = YES;
    self.chooseMusicBtn.hidden   = YES;
    
    self.isXuanting = NO;
    self.isXuanzhong = NO;
    [self.chooseMusicBtn setTitle:@"" forState:UIControlStateNormal];
    [self.chooseMusicBtn setImage:[UIImage imageNamed:@"xuantingicon"] forState:UIControlStateNormal];
    [self.morePlayBtn setImage:[UIImage imageNamed:@"duoqubofangicon"] forState:UIControlStateNormal];
    self.addMusicListBtn.hidden = YES;
}

#pragma mark - 私有方法 -

- (void)SliderTouchBegan:(UISlider *)slider{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if (self.player.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        // 暂停timer
        [self.player.levelTimer setFireDate:[NSDate distantFuture]];
    }
}
- (void)SliderValueChanged:(UISlider *)slider{
    //拖动改变视频播放进度
    if (self.player.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        
        // 暂停
        [self.player.player pause];
        
        CGFloat total           = (CGFloat)self.player.palyItem.duration.value / self.player.palyItem.duration.timescale;
        
        //计算出拖动的当前秒数
        NSInteger dragedSeconds = floorf(total * slider.value);
        
        //转换成CMTime才能给player来控制播放进度
        
        CMTime dragedCMTime     = CMTimeMake(dragedSeconds, 1);
        // 拖拽的时长
        NSInteger proMin        = (NSInteger)CMTimeGetSeconds(dragedCMTime) / 60;//当前秒
        NSInteger proSec        = (NSInteger)CMTimeGetSeconds(dragedCMTime) % 60;//当前分钟
        
        NSString *currentTime   = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
        
        if (total > 0) {
            // 当总时长 > 0时候才能拖动slider
            self.player.playCurrentTime.text  = currentTime;
            
        }else {
            // 此时设置slider值为0
            slider.value = 0;
        }
        
    }else { // player状态加载失败
        // 此时设置slider值为0
        slider.value = 0;
    }
}
- (void)SliderTouchEnded:(UISlider *)slider{
    if (self.player.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        
        // 继续开启timer
        [self.player.levelTimer setFireDate:[NSDate date]];

        // 视频总时间长度
        CGFloat total           = (CGFloat)self.player.palyItem.duration.value / self.player.palyItem.duration.timescale;

        //计算出拖动的当前秒数
        NSInteger dragedSeconds = floorf(total * slider.value);

        [self seekToTime:dragedSeconds completionHandler:nil];

        self.isPlaying = YES;
        [self.startOrStopBtn setImage:[UIImage imageNamed:@"kaishi"] forState:UIControlStateNormal];
    }
}
/**
 *  从xx秒开始播放视频跳转
 *
 *  @param dragedSeconds 视频跳转的秒数
 */
- (void)seekToTime:(NSInteger)dragedSeconds completionHandler:(void (^)(BOOL finished))completionHandler
{
    if (self.player.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        // seekTime:completionHandler:不能精确定位
        // 如果需要精确定位，可以使用seekToTime:toleranceBefore:toleranceAfter:completionHandler:
        // 转换成CMTime才能给player来控制播放进度
        CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
        [self.player.player seekToTime:dragedCMTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            // 视频跳转回调
            if (completionHandler) { completionHandler(finished); }
            
            [self.player.player play];
            //            self.playButton.hidden = YES;
            //            self.pauseButton.hidden = NO;
            if (!self.player.palyItem.isPlaybackLikelyToKeepUp) {
                self.player.playState = PlayerStateBuffering;
            }
        }];
    }
}
-(void)startTime1{
    [self.tableView reloadData];
}

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

        self.currentTimeLab.text = pro;//当前时间赋值
        self.totalTimeLab.text   = pro1;//总时间赋值
        
        
        NSInteger currentSec = (NSInteger)CMTimeGetSeconds([self.player.player currentTime]);
        NSInteger totalSec   = (NSInteger)self.player.palyItem.duration.value / self.player.palyItem.duration.timescale;
        
        if (self.isDanchu) {//淡出
            //评判淡出的标准
            if (totalSec - currentSec < 5) {
                //淡出咯
                if (self.player.player > 0) {
                    if (self.player.player.volume <= 0){
                        return;
                    }
                    self.player.player.volume = self.player.player.volume -=0.2;
                    NSLog(@"淡出%f",self.player.player.volume);
                }
            }
        }
        if (self.isDanru) {//淡入
            if (totalSec - currentSec > 5){
                //淡入咯
                if (self.player.player.volume < 1) {
                    if (self.player.player.volume >= 1){
                        return;
                    }
                    self.player.player.volume = self.player.player.volume +=0.2;
                    NSLog(@"淡入%f",self.player.player.volume);
                }
            }
            
        }
    }
}

//点击按钮刷新不同的tableview
-(void)changeTable:(UIButton *)sender btn:(UIButton *)btn btn1:(UIButton *)btn1
{
    if (sender.selected == YES) {
        [self.tableView reloadData];
        return;
    }
    sender.selected = YES;
    btn.selected = NO;
    btn1.selected = NO;
    [self.tableView reloadData];
}

//给音乐tab添加后台曲目
-(void)addMusicData{
    self.isXuanzhong = NO;
    
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
                                                        
                                                        NSLog(@"%@",obj[@"msg"]);
                                                        
                                                        NSArray *arr = [obj valueForKey:@"data"];//取出需要的数据数组
                                                        NSMutableArray *arrayM = [NSMutableArray array];//中间中转数组
                                                        for (int i = 0; i < arr.count; i ++) {//遍历数组
                                                            NSDictionary *dict = arr[i];
                                                            [arrayM addObject:[musicModel musicListWithDict:dict]];//中转数组存放转成模型的字典
                                                        }
                                                        self.dataArr = arrayM;
                                                        
                                                        [self.tableView reloadData];
                                                        
                                                        
                                                    }
                                                       fail:^(NSError *error) {
                                                           NSLog(@"error--%@",error);
                                                       }];
}

#pragma mark - tableviewdelegate -
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.LocalBtn.selected == NO){
        return self.moreMusicDataArr.count;
    }
    
    if (self.isAddMusic) {
        return self.musicListNameArr.count;
    }
    
    if (tableView==self.tableViewNew) {
        
        return self.musicListArr.count;
        
    }else{
        
        return self.dataArr.count;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    //如果是添加曲目到歌单的cell加载
    if (self.isAddMusic) {
        MusicCell *cell            = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSArray *nib1              = [[NSBundle mainBundle]loadNibNamed:KCellMusicCell owner:nil options:nil];
        cell                       = [nib1 lastObject];
        cell.delegate              = self;
        cell.MusicLabel.text       = self.musicListNameArr[indexPath.row];
        
        cell.musicIndexLab.text    = @"";
        cell.musicIndexLab.hidden  = YES;
        cell.chooseMusicbtn.hidden = YES;
        cell.shoucangBtn.hidden    = YES;
        
        cell.selectionStyle        = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    if (tableView==self.tableViewNew) {
        MusicCell *cell            = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSArray *nib1              = [[NSBundle mainBundle]loadNibNamed:KCellMusicCell owner:nil options:nil];
        cell                       = [nib1 lastObject];
        cell.delegate              = self;
        musicModel *model          = self.musicListArr[indexPath.row];
        cell.MusicLabel.text       = model.name;
        
        cell.musicIndexLab.text    = @"";
        cell.musicIndexLab.hidden  = YES;
        cell.chooseMusicbtn.hidden = YES;
        cell.shoucangBtn.hidden    = YES;
        
        cell.selectionStyle        = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
    
        if (self.LocalBtn.selected == YES){
            
            MusicCell *cell      = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

            NSArray *nib1        = [[NSBundle mainBundle]loadNibNamed:KCellMusicCell owner:nil options:nil];
            cell                 = [nib1 lastObject];
            cell.delegate        = self;
            musicModel *model    = self.dataArr[indexPath.row];
            cell.MusicLabel.text = model.name;
            
            cell.musicIndexLab.text    = @"";
            cell.musicIndexLab.hidden  = YES;
            cell.chooseMusicbtn.hidden = YES;
            cell.shoucangBtn.hidden    = YES;
            //在乐库界面点击选听按钮后刷新tableview
            if (self.isXuanting) {
                cell.chooseMusicbtn.hidden = NO;
                cell.shoucangBtn.hidden    = YES;
            }
            cell.chooseMusicbtn.tag = indexPath.row;
            cell.shoucangBtn.tag    = indexPath.row;

            cell.selectionStyle     = UITableViewCellSelectionStyleNone;
            
            if (self.isXuanzhong) {

                if (self.chooseArr.count!=0) {
                    musicModel *model    = self.chooseArr[indexPath.row];
                    cell.MusicLabel.text = model.name;
                }
                
                if (indexPath.row<self.chooseIndexArr.count) {
                    cell.MusicLabel.textColor = [UIColor redColor];
                }else{
                    cell.MusicLabel.textColor = [UIColor blackColor];
                }
            }
            if ([cell.MusicLabel.text isEqualToString:self.musicName]) {
                cell.MusicLabel.textColor = [UIColor redColor];
                
            }
            
            return cell;
        }else{
            MusicProCell *cell    = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            NSArray *nib1         = [[NSBundle mainBundle]loadNibNamed:@"MusicProCell" owner:nil options:nil];
            cell                  = [nib1 lastObject];
            cell.delegate         = self;
            cell.progressView.tag = indexPath.row;
            cell.startOrStop.tag  = indexPath.row;
            if (self.moreMusicDataArr.count!=0) {

                musicModel *model = self.moreMusicDataArr[indexPath.row];
                SLJPlayer *player = self.moreMusicPlayArr[indexPath.row];
                
                if (player.palyItem.duration.timescale != 0) {
                    cell.progressView.value     = CMTimeGetSeconds([player.palyItem currentTime]) / (player.palyItem.duration.value / player.palyItem.duration.timescale);//当前进度
                    
                    //当前时长进度progress
                    NSInteger proMin = (NSInteger)CMTimeGetSeconds([player.player currentTime]) / 60;//当前秒
                    NSInteger proSec = (NSInteger)CMTimeGetSeconds([player.player currentTime]) % 60;//当前分钟

                    //duration 总时长
                    NSInteger durMin = (NSInteger)player.palyItem.duration.value / player.palyItem.duration.timescale / 60;//总秒
                    NSInteger durSec = (NSInteger)player.palyItem.duration.value / player.palyItem.duration.timescale % 60;//总分钟

                    player.playCurrentTime.text = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
                    player.playTotalTime.text   = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
                    
                }
                
                cell.musicName.text   = model.name;
                cell.currentTime.text = player.playCurrentTime.text;
                cell.totalTime.text   = player.playTotalTime.text;
                
                if (player.isPlaying) {
                    [cell.startOrStop setImage:[UIImage imageNamed:@"kaishi"] forState:UIControlStateNormal];
                }else{
                    [cell.startOrStop setImage:[UIImage imageNamed:@"zantingicon"] forState:UIControlStateNormal];
                }
            }
            
            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==self.tableViewNew) {
        return;
    }
    //添加音乐到歌单时候选择歌单的点击方法
    if (self.isAddMusic) {
        NSArray *arr = @[@"确定"];
        [ICInfomationView initWithTitle:@"添加到此歌单" message:@"" cancleButtonTitle:@"取消" OtherButtonsArray:arr clickAtIndex:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                NSLog(@"取消");
            }else{
                NSLog(@"确定");
                //之前的歌单字符串
                NSString *path = [NSString stringWithFormat:@"%@/%@",FILEPATH,self.musicListNameArr[indexPath.row]];
                self.fileNameChart = path;
                self.logFileChart = [NSFileHandle fileHandleForWritingAtPath:path];
                [self.logFileChart seekToEndOfFile];
                NSData *data = [NSData dataWithContentsOfFile:path];
                NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                //新选的歌单字符串
                NSString *str;
                for (int i = 0; i < self.chooseArr.count; i ++) {
                    musicModel *model = self.chooseArr[i];
                    if (i==0) {
                        str = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",model.mid,model.name,model.url,model.size,model.cate,model.add_time];
                    }else{
                        str = [NSString stringWithFormat:@"%@?%@,%@,%@,%@,%@,%@",str,model.mid,model.name,model.url,model.size,model.cate,model.add_time];
                    }
                }
                NSString *musicListStr = [NSString stringWithFormat:@"%@?%@",result,str];
                //把歌单写入本地文件
                [musicListStr writeToFile:self.fileNameChart atomically:YES encoding:NSUTF8StringEncoding error:nil];
            }
        }];
        return;
    }
    
    if (self.LocalBtn.selected == YES) {
        //选听时候点击
        if (self.isXuanzhong) {
            MusicCell *newCell           = [tableView cellForRowAtIndexPath:indexPath];
            newCell.MusicLabel.textColor = [UIColor redColor];
            [self.player resetPlayer];//重置播放器
            musicModel *model            = self.chooseArr[indexPath.row];
            NSString *musicUrlstr        = model.url;
            self.musicName               = model.name;
            
            NSString *pathDocuments=kDocument;
            NSArray *fileNameList=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/musicData",pathDocuments] error:nil];
            NSMutableArray *arr = [fileNameList mutableCopy];
            if ([arr containsObject:@".DS_Store"]) {
                [arr removeObject:@".DS_Store"];
            }
            if ([arr containsObject:[NSString stringWithFormat:@"%@.mp3",model.mid]]) {
                NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                //歌曲路径
                NSString *str = [NSString stringWithFormat:@"%@/musicData/%@.mp3",path,model.mid];
                NSURL *url1 = [NSURL fileURLWithPath:str];
                [self.player playWithUrlStr:url1 PlayerLayer:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-40, 220)];
            }else{
                
                NSURL *url = [NSURL URLWithString:musicUrlstr];
                [self.player playWithUrlStr:url PlayerLayer:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-40, 220)];
            }
            
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

        }else if(self.isDuoqubofang){
            
            musicModel *model            = self.dataArr[indexPath.row];
            self.musicName               = model.name;
            
            //初始化音乐播放器
        SLJPlayer *player               = [[SLJPlayer alloc] initWithFrame:CGRectMake(20, 120, [UIScreen mainScreen].bounds.size.width-40, 220)];
//            player.delegate      = self;
            [player playWithUrlStr:[NSURL URLWithString:model.url] PlayerLayer:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-40, 220)];
            [player startPaly];
            if (player.levelTimer) {
                [player.levelTimer invalidate];
                player.levelTimer       = nil;
            }
            //开启一秒定时器计时
//            [player startTime];
            player.levelTimer = [NSTimer scheduledTimerWithTimeInterval: 1
                                                                  target: self
                                                                selector: @selector(startTime1)
                                                                userInfo: nil repeats: YES];
            
            [self.moreMusicDataArr addObject:model];
            [self.moreMusicPlayArr addObject:player];

            
        }else{
            //普通状体点击
            MusicCell *newCell           = [tableView cellForRowAtIndexPath:indexPath];
            newCell.MusicLabel.textColor = [UIColor redColor];
            [self.player resetPlayer];//重置播放器
            musicModel *model            = self.dataArr[indexPath.row];
            NSString *musicUrlstr        = model.url;
            self.musicName               = model.name;
            
            NSString *pathDocuments=kDocument;
            NSArray *fileNameList=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/musicData",pathDocuments] error:nil];
            NSMutableArray *arr = [fileNameList mutableCopy];
            if ([arr containsObject:@".DS_Store"]) {
                [arr removeObject:@".DS_Store"];
            }
            if ([arr containsObject:[NSString stringWithFormat:@"%@.mp3",model.mid]]) {
                NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                //歌曲路径
                NSString *str = [NSString stringWithFormat:@"%@/musicData/%@.mp3",path,model.mid];
                NSURL *url1 = [NSURL fileURLWithPath:str];
                [self.player playWithUrlStr:url1 PlayerLayer:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-40, 220)];
            }else{
                
                NSURL *url = [NSURL URLWithString:musicUrlstr];
                [self.player playWithUrlStr:url PlayerLayer:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-40, 220)];
            }

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
            
            if (self.isChooseing) {
                [self.musicListArr addObject:self.dataArr[indexPath.row]];
                
                [self.tableViewNew reloadData];
            }
            
        }

    }else if (self.PrivateBtn.selected == YES){

    }

    [tableView reloadData];
    
}
//通知传值
-(void)notificationpassname:(NSString *)name time:(NSString *)time
{
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:name,NOTIFICATIONKEYNAME,time,NOTIFICATIONKEYTIME, nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:NOTIFICATIONTONGZHI object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}



//左滑删除功能
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.LocalBtn.selected == NO) {
        
        return YES;
        
    }else if (tableView==self.tableViewNew) {
        
        return YES;
        
    }else{
        
        return NO;
    }
    
}
//左滑删除功能
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.musicListArr removeObjectAtIndex:indexPath.row];
    
    [self.tableViewNew reloadData];
}
//左滑删除文字设置
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==self.tableViewNew) {
        
        return 44;
        
    }else{
        
        return 44;
    }
    
}
#pragma mark - 带进度条的cell代理 -
//进度条后边的暂停开始按钮点击代理
-(void)clickStopOrStart:(UIButton *)btn{
    NSInteger i = btn.tag;
    SLJPlayer *player = self.moreMusicPlayArr[i];
    if (player.isPlaying) {
        [player.player pause];
        player.isPlaying = NO;
        [btn setImage:[UIImage imageNamed:@"zantingicon"] forState:UIControlStateNormal];
    }else{
        [player.player play];
        player.isPlaying = YES;
        [btn setImage:[UIImage imageNamed:@"kaishi"] forState:UIControlStateNormal];
    }
    
}

-(void)TouchBeganSlider:(UISlider *)progressView{
    NSInteger i = progressView.tag;
    SLJPlayer *player = self.moreMusicPlayArr[i];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if (player.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        // 暂停timer
        [player.levelTimer setFireDate:[NSDate distantFuture]];
    }
}
-(void)ValueChangedSlider:(UISlider *)progressView{
    NSInteger i = progressView.tag;
    SLJPlayer *player = self.moreMusicPlayArr[i];
    if (player.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        
        // 暂停
        [player.player pause];
        
        CGFloat total           = (CGFloat)player.palyItem.duration.value / player.palyItem.duration.timescale;
        
        //计算出拖动的当前秒数
        NSInteger dragedSeconds = floorf(total * progressView.value);
        
        //转换成CMTime才能给player来控制播放进度
        
        CMTime dragedCMTime     = CMTimeMake(dragedSeconds, 1);
        // 拖拽的时长
        NSInteger proMin        = (NSInteger)CMTimeGetSeconds(dragedCMTime) / 60;//当前秒
        NSInteger proSec        = (NSInteger)CMTimeGetSeconds(dragedCMTime) % 60;//当前分钟
        
        NSString *currentTime   = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
        
        if (total > 0) {
            // 当总时长 > 0时候才能拖动slider
            player.playCurrentTime.text  = currentTime;
            
        }else {
            // 此时设置slider值为0
            progressView.value = 0;
        }
        
    }else { // player状态加载失败
        // 此时设置slider值为0
        progressView.value = 0;
    }
}
-(void)TouchEndedSlider:(UISlider *)progressView{
    NSInteger i = progressView.tag;
    SLJPlayer *player = self.moreMusicPlayArr[i];
    if (player.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        
        // 继续开启timer
        [player.levelTimer setFireDate:[NSDate date]];
        
        // 视频总时间长度
        CGFloat total           = (CGFloat)player.palyItem.duration.value / player.palyItem.duration.timescale;
        
        //计算出拖动的当前秒数
        NSInteger dragedSeconds = floorf(total * progressView.value);
        
        [self seekToTime1:dragedSeconds :progressView completionHandler:nil];
        
//        self.isPlaying = YES;
//        [self.startOrStopBtn setImage:[UIImage imageNamed:@"kaishi"] forState:UIControlStateNormal];
    }
}

/**
 *  从xx秒开始播放视频跳转
 *
 *  @param dragedSeconds 视频跳转的秒数
 */
- (void)seekToTime1:(NSInteger)dragedSeconds :(UISlider *)progressView completionHandler:(void (^)(BOOL finished))completionHandler
{
    NSInteger i = progressView.tag;
    SLJPlayer *player = self.moreMusicPlayArr[i];
    if (player.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        // seekTime:completionHandler:不能精确定位
        // 如果需要精确定位，可以使用seekToTime:toleranceBefore:toleranceAfter:completionHandler:
        // 转换成CMTime才能给player来控制播放进度
        CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
        [player.player seekToTime:dragedCMTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            // 视频跳转回调
            if (completionHandler) { completionHandler(finished); }
            
            [player.player play];

            if (!player.palyItem.isPlaybackLikelyToKeepUp) {
                player.playState = PlayerStateBuffering;
            }
        }];
    }
}

#pragma mark - 拖动tableview代理 -
- (NSArray *)originalArrayDataForTableView:(RTDragCellTableView *)tableView{
    return self.musicListArr;
}

- (void)tableView:(RTDragCellTableView *)tableView newArrayDataForDataSource:(NSArray *)newArray{
    self.musicListArr = [newArray mutableCopy];
}

#pragma mark - cell按钮点击时间代理事件,传过来cell的标题 -
-(void)changeMusicName:(NSString *)text button:(CellButton *)btn{
    
}

-(void)choosedMusic:(UIButton *)sender{
    
    [self.chooseIndexArr addObject:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
    [self.chooseArr addObject:self.dataArr[sender.tag]];
    NSLog(@"%lu",(unsigned long)self.chooseArr.count);
}

-(void)dismissMusic:(UIButton *)sender{
    
    [self.chooseIndexArr removeObject:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
    [self.chooseArr removeObject:self.dataArr[sender.tag]];
    NSLog(@"%lu",(unsigned long)self.chooseArr.count);
}

#pragma mark - 播放器代理方法 -
-(void)startPlay{
    self.musicNameLab.text = self.musicName;
    NSLog(@"开始播放");
    self.isPlaying = YES;
    [self.startOrStopBtn setImage:[UIImage imageNamed:@"kaishi"] forState:UIControlStateNormal];
    
    if (self.isDanru) {
        self.player.player.volume = 0;
    }else{
        self.player.player.volume = 1;
    }
    
}

-(void)endPlay{
    if (self.musicIndex.row+1 == self.dataArr.count) {
        self.isPlaying  = NO;
        [self.startOrStopBtn setImage:[UIImage imageNamed:@"zantingicon"] forState:UIControlStateNormal];
        return;
    }else{
        self.musicIndex = [NSIndexPath indexPathForRow:self.musicIndex.row+1 inSection:self.musicIndex.section];
        [self tableView:self.tableView didSelectRowAtIndexPath:self.musicIndex];
        self.isPlaying  = NO;
        [self.startOrStopBtn setImage:[UIImage imageNamed:@"zantingicon"] forState:UIControlStateNormal];
    }
   NSLog(@"结束播放");
}

#pragma mark - 弹窗textview点击确定的代理方法 -
//确定按钮点击
-(void)at_textViewDidEndEditing:(UITextView *)at_textView{
    

    
    NSString *createPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    self.fileNameChart = [NSString stringWithFormat:@"%@/%@.musiclist", createPath,at_textView.text];
    //检查是否存在
    if(![[NSFileManager defaultManager] fileExistsAtPath:self.fileNameChart])
        [[NSFileManager defaultManager] createFileAtPath:self.fileNameChart contents:nil attributes:nil];
    self.logFileChart = [NSFileHandle fileHandleForWritingAtPath:self.fileNameChart];
    [self.logFileChart seekToEndOfFile];
    

    NSString *str;
    for (int i = 0; i < self.musicListArr.count; i ++) {
        musicModel *model = self.musicListArr[i];
        if (i==0) {
            str = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",model.mid,model.name,model.url,model.size,model.cate,model.add_time];
        }else{
            str = [NSString stringWithFormat:@"%@?%@,%@,%@,%@,%@,%@",str,model.mid,model.name,model.url,model.size,model.cate,model.add_time];
        }
        
    }
    //把歌单写入本地文件
    [str writeToFile:self.fileNameChart atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    [self.musicListArr removeAllObjects];
    //创建歌单完毕后恢复之前歌曲列表
    self.isChooseing             = NO;
    self.cancelBtn.hidden        = YES;
    self.sureBtn.hidden          = YES;
    self.playAllBtn.hidden       = NO;
    self.morePlayBtn.hidden      = NO;
    self.chooseMusicBtn.hidden   = NO;
    
    [self.tableViewNew removeFromSuperview];
    
    self.tableWidth.constant     =  0;
}
//取消按钮点击
- (void)at_textViewCancel{
    
//    [self.musicListArr removeAllObjects];
}

@end
