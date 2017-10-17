//
//  publiCattribute.h
//  SuperGym
//
//  Created by csj on 15/6/11.
//  Copyright (c) 2015年 yclzone. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    netWorkIsOk,
    netWorkIsNoWork
}kInternetState;

@interface publiCattribute : NSObject

@property (nonatomic, copy) NSString                *userName;//用户名
@property (nonatomic, copy) NSString                *userId;//用户ID

//网络状态
@property (nonatomic) kInternetState                internetState;

+ (publiCattribute *)sharedModel;

@end
