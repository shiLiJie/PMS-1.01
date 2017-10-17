//
//  musicClassModel.m
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 2017/4/14.
//  Copyright © 2017年 HanYouApp. All rights reserved.
//

#import "musicClassModel.h"

@implementation musicClassModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.name        = dict[@"name"];
        self.path       = dict[@"id"];
    }
    return self;
}

+ (instancetype)musicClassWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
