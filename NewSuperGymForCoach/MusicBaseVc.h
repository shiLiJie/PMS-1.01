//
//  MusicBaseVc.h
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 2017/5/23.
//  Copyright © 2017年 HanYouApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicBaseVc : UIViewController
@property (nonatomic, assign)  AudioComponentInstance toneUnit;
@property (nonatomic, assign)  AudioStreamBasicDescription mAudioFormat;
@property (nonatomic, strong)  NSMutableData  *recevData;
@end
