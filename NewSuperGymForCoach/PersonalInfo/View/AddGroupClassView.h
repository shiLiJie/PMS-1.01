//
//  AddGroupClassView.h
//  NewSuperGymForCoach
//
//  Created by liliang on 15/9/6.
//  Copyright (c) 2015年 HanYouApp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddGroupClassViewBlock)(NSString *className,NSString *classDescription);

@interface AddGroupClassView : UIView

@property (nonatomic, copy) AddGroupClassViewBlock block;

+ (instancetype)addGroupClassView;

@end
