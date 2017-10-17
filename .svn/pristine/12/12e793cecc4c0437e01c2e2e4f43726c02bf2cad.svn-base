//
//  AudioPlayer.h
//  bofangqi
//
//  Created by 凤凰八音 on 17/1/20.
//  Copyright © 2017年 fenghuangbayin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@protocol playDelegate <NSObject>

- (void)startPlay1;
- (void)endPlay1;

@end
//播放器的几种状态
typedef NS_ENUM(NSInteger, PlayState) {
    PlayStateFailed,     // 播放失败
    PlayStateBuffering,  // 缓冲中
    PlayStatePlaying,    // 播放中
    PlayStateStopped,    // 停止播放
    PlayStatePause       // 暂停播放
};



@interface SLJPlayer : UIView
@property (nonatomic, weak  ) id<playDelegate > delegate;
/**  播放时间  */
@property (strong, nonatomic) UILabel       * playCurrentTime;
/** 滑杆 */
@property (nonatomic, strong) UISlider      * videoSlider;
/**  播放器对象  */
@property (strong, nonatomic) AVPlayer      * player;
/**  播放器内容对象  */
@property (strong, nonatomic) AVPlayerItem  * palyItem;
/**  播放器Layer对象  */
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
/**  播放内容的链接  */
@property (strong, nonatomic) NSURL         *playerUrlStr;
/**  记录重置视频原始坐标  */
@property (assign, nonatomic) CGRect        originPlayerFrame;
/**  重新播放按钮  */
@property (strong, nonatomic) UIButton * rePlayButton;
/**  播放按钮  */
@property (strong, nonatomic) UIButton * playButton;
/**  暂停按钮  */
@property (strong, nonatomic) UIButton * pauseButton;
/**  全屏播放按钮  */
@property (strong, nonatomic) UIButton * fullScreenButton;
/**  退出全屏播放  */
@property (strong, nonatomic) UIButton * exitFullScreenButton;
/**  总时间  */
@property (strong, nonatomic) UILabel  * playTotalTime;
/**  记录原始父视图  */
@property (strong, nonatomic) UIView    * originSuperView;
/**  记录原始坐标  */
@property (assign, nonatomic) CGRect    originFrame;
/***  计时器  */
@property (nonatomic, strong) NSTimer   *levelTimer;
/** 播发器的几种状态 */
@property (nonatomic, assign) PlayState playState;

@property (nonatomic, assign) BOOL      isPlaying;

/**
 *  监听音频播放结束
 */
@property(copy, nonatomic)void(^AVPlayEnd)(void);


/**
 *  播放资源
 *
 *  @param url        资源URL
 *  @param layerFrame 设置Frame
 */
-(void)playWithUrlStr:(NSURL *)url PlayerLayer:(CGRect)layerFrame;


/**
 *  开始播放
 */
-(void)startPaly;

/**
 *  停止播放
 */
-(void)stopPlay;


/**
 *  总时间
 */
@property(strong, nonatomic)NSString * totalTime;

/**
 *  获取缓冲时间
 */
@property(assign, nonatomic)CGFloat totalDurationTime;


/**
 *  全屏播放
 */
-(void)fullScreenPlay;

/**
 *  退出全屏播放
 */
-(void)exitFullScreenPlay;

//重置播放器
-(void)resetPlayer;

//为了多曲播放时用的一秒调用一次的计时器
-(void)startTime;


@end
