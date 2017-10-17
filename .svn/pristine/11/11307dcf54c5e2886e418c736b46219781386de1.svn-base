//
//  BLECtl.h
//  BLECtl
//
//  Created by cnmobi_hubin on 14-3-25.
//  Copyright (c) 2014年 user_hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


// 项目中必须导入基库 <CoreBluetooth/CoreBluetooth.h>

@protocol BLECtlDelegate <NSObject>

@optional
- (void)bleCtlDidBeginConnect:(CBPeripheral *)aPeripheral;            // 开始连接时
- (void)bleCtlDidDisconnectPeripheral:(CBPeripheral *)aPeripheral;    // 断开连接时
- (void)bleCtlDidConnectPeripheral:(CBPeripheral *)aPeripheral;       // 连接成功时
- (void)bleCtlDidFailToConnectPeripheral:(CBPeripheral *)aPeripheral; // 连接失败时

- (void)bleCtlDidReceivedData:(NSDictionary *)dictionary; // 当接收到蓝牙数据时会告诉代理

@end


@interface BLECtl : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (assign, nonatomic) id <BLECtlDelegate> delegate;        // 代理
@property (retain, nonatomic) CBCentralManager *manager;           // 中心管理者
@property (strong, nonatomic) CBPeripheral     *currentPeripheral; // 当前连接着的设备
@property (strong, nonatomic) NSString *SendDataToBlueString;      // 格式规定: NSString *test = @"FE030100AA1901B0";
//  最后一位B0: bytes[7] = bytes[1]^bytes[2]^bytes[3]^bytes[4]^bytes[5]^bytes[6];

+ (BLECtl *)instance;      // 实例化
- (void)setCentralManager; // 在实例化之后必须执行此方法以激活 系统的中心管理者

- (void)scan; // 调用此方法时将开始搜索
- (void)stop; // 调用此方法时将停止搜索

@end
