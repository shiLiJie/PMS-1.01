//
//  TAGPlayerTheta.h
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 16/8/11.
//  Copyright © 2016年 HanYouApp. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

//typedef NS_ENUM(NSUInteger, TAGPlayerStatus) {
//    TAGPlayerStatus_Old,
//    TAGPlayerStatus_Next,
//};

@protocol PlayEvent <NSObject>

- (void)backTouchEvent:(NSNumber * )status;

@end

@interface TAGPlayerTheta : NSObject
@property (nonatomic, assign) NSInteger tagName;

@property (nonatomic, strong) AVAudioPlayer* musicPlayer;

@property (nonatomic, strong) UIButton *play_Button;

@property (nonatomic, strong) UILabel *currentTime;
@property (nonatomic, copy) NSString *totalTime;

//@property (nonatomic, strong) PlayEvent ktouchEvent;

@property (nonatomic, assign) id <PlayEvent> deleagete;
//进度背景view
@property (nonatomic, strong) UIView *progressBG;
//进度view
@property (nonatomic, strong) UIView *progressView;
//进度滑块
@property (nonatomic, strong) UIImageView *slider;

+ (instancetype )shareTAGPlayer;

- (void)PlayerName:(NSURL *)playerUrl;

- (void )playOrPause:(id)sender;

- (void)stopSong;

-(void)show;

-(void)removeCurrentTime;

@property (nonatomic, assign) BOOL  isStopPlay;
@end
