
//  LoginViewController.m
//  PCIMEEGPlayer
//
//  Created by 凤凰八音 on 16/1/7.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import "LoginViewController.h"

#import "BYRegisterController.h"
#import "UserManageVc.h"
#import "FMDB.h"

//返回码的枚举,避免魔法数字
typedef enum
{
    //以下是枚举成员
    failRequset = 0,
    successRequest = 1,
    
}returnCode;//枚举名称

@interface LoginViewController (){
    // 下载句柄
    NSURLSessionDownloadTask *_downloadTask;
}
@property (weak, nonatomic) IBOutlet UITextField *accountField1;//账号field
@property (weak, nonatomic) IBOutlet UITextField *passwordField1;//密码field

@property (weak, nonatomic) IBOutlet UIButton *loginButton;//登录btn
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;//取消btn
@property (weak, nonatomic) IBOutlet UIButton *registerButton;//去注册btn
@property (nonatomic, strong) NSMutableArray *oldDataListArr;//获取数据列表数组

@property (nonatomic, assign) int downLoadIndex;//当前下载的索引

@end

@implementation LoginViewController
//取消
- (IBAction)cancelButton:(id)sender {
    
    [self.view removeFromSuperview];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.loginButton setupCornerRadius:5];
    //设置文本框光标颜色
    [[UITextField appearance] setTintColor:[UIColor hexColorWithString:@"B8B8B8"]];
    //设置编辑textfield的时候右侧出现清空按钮
    self.accountField1.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordField1.clearButtonMode = UITextFieldViewModeWhileEditing;
    //密码输入框
    [self.passwordField1 setSecureTextEntry:YES];
    //获取历史数据列表请求
//    [self getOlddataList];

}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.accountField1 resignFirstResponder];
    [self.passwordField1 resignFirstResponder];
    //先上传再下载,不然会把本地的再上传一遍
    //上传本地数据到云端
//    [self upLoadOldData];
    //下载云端数据
//    [self downLoadOldData];
}







//获取本地数据列表
-(NSArray *)getLocalDataList{
    NSArray *arr = [NSArray array];
    //获取主路径
    
    NSString *createPath=[NSString stringWithFormat:@"%@/user/%@",FILEPATH,[UserTool readTheUserModle].ID];
    //检查是否存在
    if(![[NSFileManager defaultManager] fileExistsAtPath:createPath]){
        //不存在
        [[NSFileManager defaultManager] createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    }else{
        //存在
        arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:createPath error:nil];
        
        return arr;
    }
    return arr;
}



#pragma mark -
#pragma mark - Public Methods
+ (instancetype)loginControllerWithBlock:(BYLoginHandler)loginBlock {
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    loginVC.loginBlock = loginBlock;
    return loginVC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - Private Methods
//点击登陆按钮
- (IBAction)loginButton:(UIButton *)sender {    
    //加密token
    NSString *token = [NSString md5WithString];
    //参数字典
    NSDictionary *dict = @{
                           @"token":token,
                           @"login_name":self.accountField1.text,
                           @"password":self.passwordField1.text
                           };
    [[HttpRequest shardWebUtil] postNetworkRequestURLString:@"http://cloud.musiccare.cn/Api/NbApi/nb_login"
                                                 parameters:dict
                                                    success:^(id obj) {
                                                        NSString *msg = [NSString getResponseMsgWithObject:obj];
                                                        int code;
                                                        if ([[obj valueForKey:@"code"] isKindOfClass:[NSNumber class]]) {
                                                            code = [[obj valueForKey:@"code"] intValue];
                                                        }
                                                        //状态码1成功
                                                        if (code == successRequest) {
                                                            
                                                            //存一下成功的账号信息
                                                            NSString *uid = [NSString getResponseUIDWithObject:obj];
                                                            UserObj *obj = [UserObj sharedUser];
                                                            obj.ID = uid;
                                                            obj.userID = self.accountField1.text;
                                                            obj.password = self.passwordField1.text;
                                                            [UserTool saveTheUserInfo:obj];
                                                            
                                                            //block成功
                                                            self.loginBlock(YES,msg);
                                                            
                                                            // 1.获得数据库文件的路径
                                                            NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                                                            NSString *filename = [doc stringByAppendingPathComponent:@"operDB.sqlite"];
                                                            
                                                            // 2.得到数据库
                                                            FMDatabase *db = [FMDatabase databaseWithPath:filename];
                                                            
                                                            // 3.打开数据库
                                                            if ([db open]) {
                                                                NSLog(@"打开operDB成功");
                                                            }else {
                                                                NSLog(@"打开operDB失败");
                                                            }
                                                            
                                                            // 4.创表
                                                            if ([db open]) {
                                                                BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS shopCar (uid TEXT NOT NULL, account TEXT NOT NULL, password TEXT NOT NULL);"];
                                                                if (result) {
                                                                    NSLog(@"成功创表");
                                                                } else {
                                                                    NSLog(@"创表失败");
                                                                }
                                                                [db close];
                                                            }
                                                            //查询数据条数
                                                            BOOL isCUnzai = NO;
                                                            if ([db open]) {
                                                                NSString * sql = @"SELECT * FROM shopCar";
                                                                FMResultSet * rs = [db executeQuery:sql];
                                                                
                                                                while ([rs next]) {
                                                                    NSString * userId = [rs stringForColumn:@"uid"];
                                                                    NSString * account = [rs stringForColumn:@"account"];
                                                                    NSString * password = [rs stringForColumn:@"password"];
                                                                    
                                                                    if ([account isEqualToString:self.accountField1.text] && [password isEqualToString:self.passwordField1.text]) {
                                                                        isCUnzai = YES;
                                                                        return;
                                                                    }else{
                                                                        
                                                                    }
                                                                }
                                                                [db close];
                                                            }
                                                            
                                                            if (isCUnzai) {
                                                                return;
                                                            }else{
                                                                //插入数据
                                                                if ([db open]) {
                                                                    NSString *insertSql1= [NSString stringWithFormat:@"INSERT INTO shopCar (uid, account, password) VALUES ('%@', '%@', '%@')", uid, self.accountField1.text, self.passwordField1.text];
                                                                    BOOL res = [db executeUpdate:insertSql1];
                                                                    
                                                                    if (res) {
                                                                        NSLog(@"数据插入表成功");
                                                                    } else {
                                                                        NSLog(@"数据插入表失败");
                                                                    }
                                                                    [db close];
                                                                }
                                                            }
                                                            
                                                            
                                                            
                                                            
                                                            
                                                        }
                                                        //状态码0失败
                                                        if (code == failRequset) {
                                                            //block失败
                                                            self.loginBlock(NO,msg);
                                                        }
    }
                                                       fail:^(NSError *error) {
                                                           self.loginBlock(NO,@"请检查网络");
                                                           // 1.获得数据库文件的路径
                                                           NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                                                           NSString *filename = [doc stringByAppendingPathComponent:@"operDB.sqlite"];
                                                           
                                                           // 2.得到数据库
                                                           FMDatabase *db = [FMDatabase databaseWithPath:filename];
                                                           
                                                           // 3.打开数据库
                                                           if ([db open]) {
                                                               NSLog(@"打开operDB成功");
                                                           }else {
                                                               NSLog(@"打开operDB失败");
                                                           }
                                                           
                                                           // 4.创表
                                                           if ([db open]) {
                                                               BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS shopCar (uid TEXT NOT NULL, account TEXT NOT NULL, password TEXT NOT NULL);"];
                                                               if (result) {
                                                                   NSLog(@"成功创表");
                                                               } else {
                                                                   NSLog(@"创表失败");
                                                               }
                                                               [db close];
                                                           }
                                                           //查询数据条数
                                                           BOOL isCUnzai = NO;
                                                           if ([db open]) {
                                                               NSString * sql = @"SELECT * FROM shopCar";
                                                               FMResultSet * rs = [db executeQuery:sql];
                                                               
                                                               while ([rs next]) {
                                                                   NSString * userId = [rs stringForColumn:@"uid"];
                                                                   NSString * account = [rs stringForColumn:@"account"];
                                                                   NSString * password = [rs stringForColumn:@"password"];
                                                                   
                                                                   if ([account isEqualToString:self.accountField1.text] && [password isEqualToString:self.passwordField1.text]) {
                                                                       isCUnzai = YES;
                                                                       UserObj *obj = [UserObj sharedUser];
                                                                       obj.ID = userId;
                                                                       obj.userID = self.accountField1.text;
                                                                       obj.password = self.passwordField1.text;
                                                                       [UserTool saveTheUserInfo:obj];
                                                                       //block成功
                                                                       self.loginBlock(YES,@"本地登陆成功");
                                                                       return;
                                                                   }else{
                                                                       
                                                                   }
                                                               }
                                                               [db close];
                                                           }
                                                           
                                                           if (isCUnzai) {

                                                           }
                                                           
                                                           
    }];
}


- (IBAction)registerButton:(UIButton *)sender {
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"CHANGEROOTVCREGIST" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}



@end
