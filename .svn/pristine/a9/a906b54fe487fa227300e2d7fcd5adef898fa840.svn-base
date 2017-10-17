//
//  AudioPlayer.h
//  bofangqi
//
//  Created by 凤凰八音 on 17/1/20.
//  Copyright © 2017年 fenghuangbayin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@protocol playerDelegate <NSObject>

- (void)startPlay;
- (void)endPlay;

@end
//播放器的几种状态
typedef NS_ENUM(NSInteger, PlayerState) {
    PlayerStateFailed,     // 播放失败
    PlayerStateBuffering,  // 缓冲中
    PlayerStatePlaying,    // 播放中
    PlayerStateStopped,    // 停止播放
    PlayerStatePause       // 暂停播放
};



@interface SLJAVPlayer : UIView
@property (nonatomic, weak  ) id<playerDelegate> delegate;
/**  播放时间  */
@property (strong, nonatomic) UILabel        * playCurrentTime;

/** 滑杆 */
@property (nonatomic, strong) UISlider       * videoSlider;
/**  播放器对象  */
@property (strong, nonatomic) AVPlayer       * player;
/**  播放器内容对象  */
@property (strong, nonatomic) AVPlayerItem   * palyItem;
/**  播放器Layer对象  */
@property (strong, nonatomic) AVPlayerLayer  *playerLayer;
/**  播放内容的链接  */
@property (strong, nonatomic) NSURL       *playerUrlStr;
/**  记录重置视频原始坐标  */
@property (assign, nonatomic) CGRect         originPlayerFrame;



/**  重新播放按钮  */
@property (strong, nonatomic) UIButton       * rePlayButton;
/**  播放按钮  */
@property (strong, nonatomic) UIButton       * playButton;
/**  暂停按钮  */
@property (strong, nonatomic) UIButton       * pauseButton;
/**  全屏播放按钮  */
@property (strong, nonatomic) UIButton       * fullScreenButton;
/**  退出全屏播放  */
@property (strong, nonatomic) UIButton       * exitFullScreenButton;



/**  总时间  */
@property (strong, nonatomic) UILabel        * playTotalTime;




/**  记录原始父视图  */
@property (strong, nonatomic) UIView         * originSuperView;
/**  记录原始坐标  */
@property (assign, nonatomic) CGRect         originFrame;
/***  计时器  */
@property (nonatomic, strong) NSTimer        *levelTimer;

/** 播发器的几种状态 */
@property (nonatomic, assign) PlayerState       playState;



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


@end
