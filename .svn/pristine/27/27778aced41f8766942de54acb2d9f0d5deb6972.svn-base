//
//  AudioPlayer.h
//  bofangqi
//
//  Created by 凤凰八音 on 17/1/20.
//  Copyright © 2017年 fenghuangbayin. All rights reserved.
//

#import "SLJPlayer.h"



@interface SLJPlayer()



@end

@implementation SLJPlayer
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        [self addSubview:self.playButton];
        [self addSubview:self.pauseButton];
        [self addSubview:self.fullScreenButton];
        [self addSubview:self.exitFullScreenButton];
        
        
        [self addSubview:self.playCurrentTime];
        [self addSubview:self.playTotalTime];
        [self addSubview:self.videoSlider];
        [self addSubview:self.rePlayButton];
        
        [self setNormalFrame];
        
    }
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter addObserver:self selector:@selector(progressSliderTouchBegan:) name:@"TOUCHBEGAN" object:nil];
    [notiCenter addObserver:self selector:@selector(progressSliderValueChanged:) name:@"TOUCHCHANGE" object:nil];
    [notiCenter addObserver:self selector:@selector(progressSliderTouchEnded:) name:@"TOUCHENDED" object:nil];
    
    return self;
}



/**
 *  播放资源
 *
 *  @param url        资源URL
 *  @param layerFrame 设置Frame
 */
-(void)playWithUrlStr:(NSURL *)url PlayerLayer:(CGRect)layerFrame{
    _originPlayerFrame = layerFrame;
    _playerUrlStr = url;
    //    NSURL * audioUrl  = [NSURL fileURLWithPath:url];              //本地用fileurlwithpath
    //    NSURL * audioUrl  = [NSURL URLWithString:url];                  //网络用urlwithstring
    _palyItem = [[AVPlayerItem alloc]initWithURL:url];
    _player = [[AVPlayer alloc]initWithPlayerItem:_palyItem];
    _playerLayer=[AVPlayerLayer playerLayerWithPlayer:_player];
    // 此处为默认视频填充模式
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _playerLayer.frame=layerFrame;
    //    [self.layer insertSublayer:_playerLayer below:self.playButton.layer];
}



#pragma mark--------------  事件响应方法 ----------------------------
/**
 *  停止播放
 */
-(void)stopPlay{
    self.playButton.hidden = NO;
    self.pauseButton.hidden = YES;
    self.isPlaying = NO;
    [_player pause];
    if (self.levelTimer) {
        [self.levelTimer invalidate];
        self.levelTimer = nil;
        [self.levelTimer setFireDate:[NSDate distantFuture]];
    }
}


/**
 *  开始播放
 */
-(void)startPaly{
    self.playButton.hidden = YES;
    self.rePlayButton.hidden = YES;
    self.pauseButton.hidden = NO;
    
    [_player play];
    self.isPlaying = YES;
    //监听播放状态（AVPlayerStatusReadyToPlay时代表视频已经可以播放了）
    [_palyItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监听缓冲状态
    [_palyItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    
    //监听播放结束
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:_palyItem];
    
    //开始计时
    if (self.levelTimer) {
        //        [self.levelTimer invalidate];
        //        self.levelTimer = nil;
        [self.levelTimer setFireDate:[NSDate date]];
    }
    
//        self.levelTimer = [NSTimer scheduledTimerWithTimeInterval: 1
//                                                           target: self
//                                                         selector: @selector(startTime)
//                                                         userInfo: nil repeats: YES];
}

-(void)startTime{
    //开始计时
    if (self.levelTimer) {
        //        [self.levelTimer invalidate];
        //        self.levelTimer = nil;
        [self.levelTimer setFireDate:[NSDate date]];
    }
    
    self.levelTimer = [NSTimer scheduledTimerWithTimeInterval: 1
                                                       target: self
                                                     selector: @selector(oneSecDo)
                                                     userInfo: nil repeats: YES];
}

-(void)oneSecDo{
        if (_palyItem.duration.timescale != 0) {
            self.videoSlider.value     = CMTimeGetSeconds([_palyItem currentTime]) / (_palyItem.duration.value / _palyItem.duration.timescale);//当前进度
    
            //当前时长进度progress
            NSInteger proMin                       = (NSInteger)CMTimeGetSeconds([_player currentTime]) / 60;//当前秒
            NSInteger proSec                       = (NSInteger)CMTimeGetSeconds([_player currentTime]) % 60;//当前分钟
    
            //duration 总时长
            NSInteger durMin                       = (NSInteger)_palyItem.duration.value / _palyItem.duration.timescale / 60;//总秒
            NSInteger durSec                       = (NSInteger)_palyItem.duration.value / _palyItem.duration.timescale % 60;//总分钟
    
            self.playCurrentTime.text = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
            self.playTotalTime.text   = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
    
        }
}

///**
// *  开始录音计时
// */
//- (void)startTime {
//    if (_palyItem.duration.timescale != 0) {
//        self.videoSlider.value     = CMTimeGetSeconds([_palyItem currentTime]) / (_palyItem.duration.value / _palyItem.duration.timescale);//当前进度
//
//        //当前时长进度progress
//        NSInteger proMin                       = (NSInteger)CMTimeGetSeconds([_player currentTime]) / 60;//当前秒
//        NSInteger proSec                       = (NSInteger)CMTimeGetSeconds([_player currentTime]) % 60;//当前分钟
//
//        //duration 总时长
//        NSInteger durMin                       = (NSInteger)_palyItem.duration.value / _palyItem.duration.timescale / 60;//总秒
//        NSInteger durSec                       = (NSInteger)_palyItem.duration.value / _palyItem.duration.timescale % 60;//总分钟
//
//        self.playCurrentTime.text = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
//        self.playTotalTime.text   = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
//
//    }
//}


/**
 *  全屏播放
 */
-(void)fullScreenPlay{
    self.originSuperView = self.superview;
    self.originFrame = self.frame;
    self.fullScreenButton.hidden = YES;
    self.exitFullScreenButton.hidden = NO;
    
    self.originFrame = self.frame;
    CGFloat height = [[UIScreen mainScreen] bounds].size.width;
    CGFloat width = [[UIScreen mainScreen] bounds].size.height;
    CGRect frame = CGRectMake((height - width) / 2, (width - height) / 2, width, height);;
    [UIView animateWithDuration:0.3f animations:^{
        self.frame = frame;
        _playerLayer.frame=CGRectMake(0, 0, width, height);
        [self setTransform:CGAffineTransformMakeRotation(M_PI_2)];
    } completion:^(BOOL finished) {
        
        //ViewController * VC = (ViewController *)[self getViewController:self];
        //[VC.view insertSubview:self aboveSubview:VC.bgView];
        //[[UIApplication sharedApplication].keyWindow insertSubview:self belowSubview:self];
    }];
}



/**
 *  退出全屏播放
 */
-(void)exitFullScreenPlay{
    self.fullScreenButton.hidden = NO;
    self.exitFullScreenButton.hidden = YES;
    [self.originSuperView insertSubview:self belowSubview:self];
    [UIView animateWithDuration:0.3f animations:^{
        [self setTransform:CGAffineTransformIdentity];
        self.frame = self.originFrame;
        _playerLayer.frame=CGRectMake(0, 0, self.originFrame.size.width, self.originFrame.size.height);
    } completion:^(BOOL finished) {
        
        //[[self getViewController:self].view addSubview:self];
    }];
}


#pragma mark - slider事件

/**
 *  slider开始滑动事件
 *
 *  @param slider UISlider
 */
- (void)progressSliderTouchBegan:(UISlider *)slider
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        // 暂停timer
        [self.levelTimer setFireDate:[NSDate distantFuture]];
    }
}


/**
 *  slider滑动中事件
 *
 *  @param slider UISlider
 */
- (void)progressSliderValueChanged:(UISlider *)slider
{
    //拖动改变视频播放进度
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        
        // 暂停
        [_player pause];
        
        CGFloat total           = (CGFloat)_palyItem.duration.value / _palyItem.duration.timescale;
        
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
            self.playCurrentTime.text  = currentTime;
            
        }else {
            // 此时设置slider值为0
            slider.value = 0;
        }
        
    }else { // player状态加载失败
        // 此时设置slider值为0
        slider.value = 0;
    }
}

/**
 *  slider结束滑动事件
 *
 *  @param slider UISlider
 */
- (void)progressSliderTouchEnded:(UISlider *)slider
{
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        
        // 继续开启timer
        [self.levelTimer setFireDate:[NSDate date]];
        
        // 视频总时间长度
        CGFloat total           = (CGFloat)_palyItem.duration.value / _palyItem.duration.timescale;
        
        //计算出拖动的当前秒数
        NSInteger dragedSeconds = floorf(total * slider.value);
        
        [self seekToTime:dragedSeconds completionHandler:nil];
    }
}

/**
 *  从xx秒开始播放视频跳转
 *
 *  @param dragedSeconds 视频跳转的秒数
 */
- (void)seekToTime:(NSInteger)dragedSeconds completionHandler:(void (^)(BOOL finished))completionHandler
{
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        // seekTime:completionHandler:不能精确定位
        // 如果需要精确定位，可以使用seekToTime:toleranceBefore:toleranceAfter:completionHandler:
        // 转换成CMTime才能给player来控制播放进度
        CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
        [self.player seekToTime:dragedCMTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            // 视频跳转回调
            if (completionHandler) { completionHandler(finished); }
            
            [_player play];
            self.playButton.hidden = YES;
            self.pauseButton.hidden = NO;
            if (!_palyItem.isPlaybackLikelyToKeepUp) {
                self.playState = PlayStateBuffering;
            }
        }];
    }
}


#pragma mark--------------  代理方法 ----------------------------
//监听播放状态和缓冲状态
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            _playState = PlayStatePlaying;
            [self.delegate startPlay1];
            
            //CMTime duration = _palyItem.duration;// 获取视频总长度
            CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;// 转换成秒
            _totalTime = [self convertTime:totalSecond];// 转换成播放时间
            //[self monitoringPlayback:_palyItem];// 监听播放状态
            
        } else if ([playerItem status] == AVPlayerStatusFailed) {
            _playState = PlayStateFailed;
        }
        
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
        //        NSLog(@"Time Interval:%f",timeInterval);
        CMTime duration = _palyItem.duration;
        _totalDurationTime = CMTimeGetSeconds(duration);
        NSLog(@"%f",timeInterval/_totalDurationTime);
    }
}



#pragma mark--------------  私有方法 ----------------------------

//监听播放结束
-(void)playerItemDidReachEnd{
    NSLog(@"播放结束");
    self.isPlaying = NO;
    [self.delegate endPlay1];
    //    [self resetPlayer];
}


//重置播放器
-(void)resetPlayer{
    self.rePlayButton.hidden = NO;
    [self stopPlay];
    
    self.playCurrentTime.text = @"00:00";
    self.playTotalTime.text = @"00:00";
    self.videoSlider.value = 0;
    
    [[NSNotificationCenter defaultCenter] removeObserver:_player];
    [_palyItem removeObserver:self forKeyPath:@"status"];
    [_palyItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    _palyItem = nil;
    [self playWithUrlStr:_playerUrlStr PlayerLayer:_originPlayerFrame];
}




//获取父控制器
-(UIViewController *)getViewController:(UIView *)curView {
    for (UIView* next = [curView superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


//计算缓冲时间
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}


//时间转换
- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}




#pragma mark-----------------  适配区 ----------------------------

/** 正常播放  */
-(void)setNormalFrame{
    //    [self.rePlayButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.center.mas_equalTo(self);
    //        make.size.mas_equalTo(CGSizeMake(40, 60));
    //    }];
    //
    //
    //    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(self).offset(5);
    //        make.bottom.mas_equalTo(self).offset(-5);
    //        make.size.mas_equalTo(CGSizeMake(18, 20));
    //    }];
    //
    //    [self.pauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(self).offset(5);
    //        make.bottom.mas_equalTo(self).offset(-5);
    //        make.size.mas_equalTo(CGSizeMake(18, 20));
    //    }];
    //
    //    [self.fullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.mas_equalTo(self).offset(-5);
    //        make.bottom.mas_equalTo(self).offset(-5);
    //        make.size.mas_equalTo(CGSizeMake(18, 20));
    //    }];
    //
    //    [self.exitFullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.mas_equalTo(self).offset(-5);
    //        make.bottom.mas_equalTo(self).offset(-5);
    //        make.size.mas_equalTo(CGSizeMake(18, 20));
    //    }];
    //
    //
    //    [self.playCurrentTime mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(self.playButton.mas_right).offset(5);
    //        make.bottom.mas_equalTo(self).offset(-6);
    //        make.width.mas_greaterThanOrEqualTo(16);
    //        make.height.mas_equalTo(16);
    //    }];
    //
    //    [self.playTotalTime mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.mas_equalTo(self.fullScreenButton.mas_left).offset(-5);
    //        make.bottom.mas_equalTo(self).offset(-6);
    //        make.width.mas_greaterThanOrEqualTo(16);
    //        make.height.mas_equalTo(16);
    //    }];
    //
    //    [self.videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(self.playCurrentTime.mas_right).offset(2);
    //        make.right.mas_equalTo(self.playTotalTime.mas_left).offset(-2);
    //        make.bottom.mas_equalTo(self).offset(-11.5);
    //        make.height.mas_equalTo(5);
    //    }];
}



#pragma mark--------------  get/set区 ----------------------------

-(UIButton *)rePlayButton{
    if (!_rePlayButton) {
        _rePlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rePlayButton setImage:[UIImage imageNamed:@"ZFPlayer_repeat_video"] forState:UIControlStateNormal];
        //_playButton.backgroundColor = [UIColor redColor];
        [_rePlayButton addTarget:self action:@selector(startPaly) forControlEvents:UIControlEventTouchUpInside];
        _rePlayButton.hidden = YES;
    }
    return _rePlayButton;
}

-(UIButton *)playButton{
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"ZFPlayer_play"] forState:UIControlStateNormal];
        //_playButton.backgroundColor = [UIColor redColor];
        [_playButton addTarget:self action:@selector(startPaly) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

-(UIButton *)pauseButton{
    if (!_pauseButton) {
        _pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pauseButton setImage:[UIImage imageNamed:@"ZFPlayer_pause"] forState:UIControlStateNormal];
        //_pauseButton.backgroundColor = [UIColor redColor];
        [_pauseButton addTarget:self action:@selector(stopPlay) forControlEvents:UIControlEventTouchUpInside];
        _pauseButton.hidden = YES;
    }
    return _pauseButton;
}




-(UIButton *)fullScreenButton{
    if (!_fullScreenButton) {
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenButton setImage:[UIImage imageNamed:@"ZFPlayer_fullscreen"] forState:UIControlStateNormal];
        [_fullScreenButton addTarget:self action:@selector(fullScreenPlay) forControlEvents:UIControlEventTouchUpInside];
        //_fullScreenButton.backgroundColor = [UIColor redColor];
    }
    return _fullScreenButton;
}

-(UIButton *)exitFullScreenButton{
    if (!_exitFullScreenButton) {
        _exitFullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exitFullScreenButton setImage:[UIImage imageNamed:@"ZFPlayer_shrinkscreen"] forState:UIControlStateNormal];
        [_exitFullScreenButton addTarget:self action:@selector(exitFullScreenPlay) forControlEvents:UIControlEventTouchUpInside];
        
        _exitFullScreenButton.hidden = YES;
        //_exitFullScreenButton.backgroundColor = [UIColor redColor];
    }
    return _exitFullScreenButton;
}



-(UILabel *)playCurrentTime{
    if (!_playCurrentTime) {
        _playCurrentTime = [[UILabel alloc] init];
        _playCurrentTime.textColor = [UIColor blackColor];
        _playCurrentTime.text = @"00:00";
        
        //_playCurrentTime.backgroundColor = [UIColor redColor];
    }
    return _playCurrentTime;
}

-(UILabel *)playTotalTime{
    if (!_playTotalTime) {
        _playTotalTime = [[UILabel alloc] init];
        _playTotalTime.textColor = [UIColor blackColor];
        _playTotalTime.text = @"00:00";
        
        //_playTotalTime.backgroundColor = [UIColor redColor];
    }
    return _playTotalTime;
}


- (UISlider *)videoSlider
{
    if (!_videoSlider) {
        _videoSlider                       = [[UISlider alloc] init];
        // 设置slider
        [_videoSlider setThumbImage:[UIImage imageNamed:@"ZFPlayer_slider"] forState:UIControlStateNormal];
        _videoSlider.maximumValue          = 1;
        _videoSlider.minimumTrackTintColor = [UIColor whiteColor];
        _videoSlider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
        
        // slider开始滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        // slider滑动中事件
        [_videoSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        // slider结束滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
    }
    return _videoSlider;
}


@end
