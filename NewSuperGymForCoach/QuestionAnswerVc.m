//
//  QuestionAnswerVc.m
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 2017/5/23.
//  Copyright © 2017年 HanYouApp. All rights reserved.
//

#import "QuestionAnswerVc.h"

#import "SCLFormVc.h"
#import "YaliFormVc.h"
#import "PizibaoVc.h"
#import "XihaoVc.h"

@interface QuestionAnswerVc ()


@end

@implementation QuestionAnswerVc

- (IBAction)zhegnzhuangziping:(UIButton *)sender {
    
    SCLFormVc *scl = [[SCLFormVc alloc] init];
    [self presentViewController:scl animated:YES completion:nil];
    
//    WebVIewVc *web = [[WebVIewVc alloc] init];
//    [self presentViewController:web animated:YES completion:nil];
//    
//    NSURL *url = [NSURL URLWithString:@"http://cloud.musiccare.cn/survey/scl90.html"];
//    NSURLRequest *quest = [NSURLRequest requestWithURL:url];
//    [web.web loadRequest:quest];

}

- (IBAction)EAPziping:(UIButton *)sender {
    
    YaliFormVc *yali = [[YaliFormVc alloc] init];
    [self presentViewController:yali animated:YES completion:nil];
    
//    WebVIewVc *web = [[WebVIewVc alloc] init];
//    [self presentViewController:web animated:YES completion:nil];
//    
//    NSURL *url = [NSURL URLWithString:@"http://cloud.musiccare.cn/survey/eap.html"];
//    NSURLRequest *quest = [NSURLRequest requestWithURL:url];
//    [web.web loadRequest:quest];
}

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (IBAction)pushQusetionList:(UIButton *)sender {
    
    PizibaoVc *pizibao = [[PizibaoVc alloc] init];
    [self presentViewController:pizibao animated:YES completion:nil];
    
//    WebVIewVc *web = [[WebVIewVc alloc] init];
//    [self presentViewController:web animated:YES completion:nil];
//    
//    NSURL *url = [NSURL URLWithString:@"http://cloud.musiccare.cn/survey/psqi.html"];
//    NSURLRequest *quest = [NSURLRequest requestWithURL:url];
//    [web.web loadRequest:quest];
}

- (IBAction)xihaoList:(UIButton *)sender {
    
    XihaoVc *xihao = [[XihaoVc alloc] init];
    [self presentViewController:xihao animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
