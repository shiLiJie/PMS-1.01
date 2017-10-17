//
//  Imitation_AlertView_TextField.h
//  模拟TextFiled
//
//  Created by GaoFei on 16/7/6.
//  Copyright © 2016年 GaoFei. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^SendTextViewText)(NSString * textStr);

@protocol Imitation_AlertView_TextFielddelegate <NSObject>

@optional
- (void)at_textViewDidEndEditing:(UITextView *)at_textView;
- (void)at_textViewCancel;

@end

@interface Imitation_AlertView_TextField : UIView

/**
 代理
 */
@property (nonatomic,weak) id<Imitation_AlertView_TextFielddelegate> delegate;

/**
 初始化视图：传入其父视图的大小
 */
-(instancetype)initWithFatherViewFrameWidth:(CGFloat)width withFrameHeight:(CGFloat)height;

/**
 
 隐藏
 
 */
-(void)viewHidden;

/**
 
 显示
 
 */
-(void)viewShow;

/**
 调用方法返回数据
 */
-(NSString *)sendTextView;

#pragma mark ----------// 属性 \\-----------
/**
 标题
 */
@property (nonatomic,copy) NSString * title;

/**
 block
 */
//-(void)textViewDidEndEditing:(SendTextViewText)block;
//@property (nonatomic,copy) SendTextViewText sendText;


/**
 textView 的消息
 */
@property (nonatomic,copy) NSString * textMessage;

@end
