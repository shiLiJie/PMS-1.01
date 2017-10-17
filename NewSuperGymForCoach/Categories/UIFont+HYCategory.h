//
//  UIFont+HYCategory.h
//  SuperGym
//
//  Created by liliang on 15/6/8.
//  Copyright (c) 2015年 yclzone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (HYCategory)

/**
 *  超能健身房超大字体，应用如导航栏标题等
 *
 *  @return 大小为20的系统字体
 */
+ (UIFont *)gym_navSizeFont;

/**
 *  超能健身房标题字体，应用如标题字体及按钮文字等
 *
 *  @return 大小为16的系统字体
 */
+ (UIFont *)gym_titleSizeFont;

/**
 *  超能健身房副标题字体，应用如副标题或某些特殊正文字体
 *
 *  @return 大小为15的系统字体
 */
+ (UIFont *)gym_subtitleSizeFont;

/**
 *  超能健身房正文字体
 *
 *  @return 大小为14的系统字体
 */
+ (UIFont *)gym_textSizeFont;

/**
 *  超能健身房辅助性字体，应用如底部菜单文字、时间、提示性文字等
 *
 *  @return 大小为13的系统字体
 */
+ (UIFont *)gym_auxiliaryLargerSizeFont;

/**
 *  超能健身房辅助型字体，应用如特殊时间点缀的字体大小
 *
 *  @return 大小为12的系统字体
 */
+ (UIFont *)gym_auxiliarySmallerSizeFont;

@end
