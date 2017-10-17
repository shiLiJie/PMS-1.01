//
//  LoginViewController.h
//  PCIMEEGPlayer
//
//  Created by 凤凰八音 on 16/1/7.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  声明block
 *
 *  @param result  登陆状态码 1:yes 0:no
 *  @param message 返回信息msg
 */
typedef void (^BYLoginHandler)(BOOL result, NSString *message);

@interface LoginViewController : UIViewController


/** 登录按钮点击回调 **/
@property (nonatomic, copy) BYLoginHandler loginBlock;

+ (instancetype)loginControllerWithBlock:(BYLoginHandler)loginBlock;

@end
