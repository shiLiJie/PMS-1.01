//
//  musicModel.m
//  musicEvaluation
//
//  Created by 凤凰八音 on 2017/3/3.
//  Copyright © 2017年 com.lingxian01. All rights reserved.
//

#import "musicModel.h"

@implementation musicModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.mid        = dict[@"id"];
        self.name       = dict[@"name"];
        self.url        = dict[@"url"];
        self.size       = dict[@"size"];
        self.cate       = dict[@"cate"];
        self.add_time   = dict[@"add_time"];
        self.cate1      = dict[@"cate1"];
    }
    return self;
}

+ (instancetype)musicListWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
