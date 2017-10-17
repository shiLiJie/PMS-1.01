//
//  voiceChangeView.h
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 2017/6/19.
//  Copyright © 2017年 BaYinApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol voiceChangeViewDelegate <NSObject>

-(void)changeMusicVoeic:(UISlider *)slider;
-(void)remove;

@end

@interface voiceChangeView : UIView

@property (weak, nonatomic) IBOutlet UISlider *voicePro;
@property (weak, nonatomic) IBOutlet UIImageView *toumingBg;

@property (nonatomic, weak) id <voiceChangeViewDelegate> delegate;


@end
