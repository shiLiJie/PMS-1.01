//
//  AppDelegate.m
//  NewSuperGymForCoach
//
//  Created by liliang on 15/8/18.
//  Copyright (c) 2015年 HanYouApp. All rights reserved.
//

#import "AppDelegate.h"
#import "NGTabBarController.h"

#import "UserManageVc.h"
#import "QuestionAnswerVc.h"
#import "MusicBaseVc.h"
#import "HealingMusicVc.h"

#import "TreatViewController.h"
#import "NavigationController.h"
#import "DetailViewController.h"

#import "UserObj.h"
#import "UserTool.h"
#import "LoginViewController.h"
#import "BYRegisterController.h"
#import "UserGuoupVc.h"


#define TheUserFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"user.data"]

//返回码的枚举,避免魔法数字
typedef enum
{
    //以下是枚举成员
    failRequset = 0,
    successRequest = 1,
    
}returnCode;//枚举名称

@interface AppDelegate ()<NGTabBarControllerDelegate>{
    // 下载句柄
    NSURLSessionDownloadTask *_downloadTask;
}
/** tabBarVC */
@property (nonatomic, strong    ) NGTabBarController *tabBarVC;



@property (nonatomic, copy) NSString *str;

@end

@implementation AppDelegate

#pragma mark - Life Cycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initRegistForRootVc) name:@"CHANGEROOTVCREGIST" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(qiehuanbaogao:) name:NOTIFICATIONHUIFUBAOGAO object:nil];
    
    [self changeRootViewController];
//    //进入程序
//    NGTabBarController *tabBarVC = [self generateTabBarVC];
//    self.tabBarVC = tabBarVC;
//    self.window.rootViewController = self.tabBarVC;
//    [self.window makeKeyAndVisible];
    
   
    application.statusBarStyle = UIStatusBarStyleLightContent;

    
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback
                                           error: &setCategoryErr];
    [[AVAudioSession sharedInstance] setActive: YES
                                         error: &activationErr];
    //创建网络类上传移动设备的信息
    BYHttpRequest *request = [[BYHttpRequest alloc] init];
    [request postPhoneMessageToCloud];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    [NSThread sleepForTimeInterval:1.5];
    
    
    
    return YES;
}


-(void)creatNgtabbar{
    //进入程序
    NGTabBarController *tabBarVC = [self generateTabBarVC];
    self.tabBarVC = tabBarVC;
    //添加退出登陆按钮
//    UIButton *cancelBtn = [[UIButton alloc] init];
//    [cancelBtn setImage:[UIImage imageNamed:@"tuichudenglu"] forState:UIControlStateNormal];
//    [cancelBtn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
//    [cancelBtn setFrame:CGRectMake(30, kScreen_Height-100, 117, 50)];
//    [self.tabBarVC.view addSubview:cancelBtn];
    
    //版本号
    UILabel *verLab = [[UILabel alloc] init];
    [verLab setFrame:CGRectMake(10, kScreen_Height-50, 150, 50)];
    verLab.textColor = RGBA(200, 230, 200, 1);
    verLab.font = [UIFont systemFontOfSize:12];
    verLab.textAlignment = NSTextAlignmentCenter;
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    verLab.text = app_Version;
    
    [self.tabBarVC.view addSubview:verLab];
    self.window.rootViewController = self.tabBarVC;
    [self.window makeKeyAndVisible];
    //从网络获取一下用户信息
    [self getUserInfo];

}

//点击退出登陆按钮
-(void)loginOut{
    [ICInfomationView initWithTitle:@"注销"
                            message:@"是否确定注销？"
                  cancleButtonTitle:@"取消"
                  OtherButtonsArray:@[@"确定"]
                       clickAtIndex:^(NSInteger buttonIndex) {
                           if (buttonIndex == 1) {
                               //清楚用户的数据缓存
                               NSFileManager* fileManager=[NSFileManager defaultManager];
                               NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                               //文件名
                               NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"user.data"];
                               BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
                               if (!blHave) {
                                   return ;
                               }else {
                                   BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
                                   if (blDele) {
                                       NSLog(@"成功移除");
                                       [SLJNotificationTools postNotification:nil methodName:@"LOGINOUT"];
                                   }else {
                                   }
                               }
                               //掐换回跟控制器重新加载程序
//                               AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                               [self changeRootViewController];
                           }
                       }];
}

-(void)qiehuanbaogao:(NSNotification *)dict
{
    self.str = dict.userInfo[@"b"];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    UIDevice *device = [UIDevice currentDevice];
    BOOL backgroundSupported = NO;
    if ([device respondsToSelector:@selector(isMultitaskingSupported)]) {
        backgroundSupported = YES;
    }
    
    __block UIBackgroundTaskIdentifier bgTaskId = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:bgTaskId];
        bgTaskId = UIBackgroundTaskInvalid;
    }];
    
    if (backgroundSupported) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //
        });
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Public Methods

-(void)chaninde1
{
    self.tabBarVC.selectedIndex = 1;
}
-(void)chaninde2
{
    self.tabBarVC.selectedIndex = 2;
    
}
-(void)chaninde3
{
    self.tabBarVC.selectedIndex = 3;
}
-(void)chaninde4
{
    self.tabBarVC.selectedIndex = 4;
    
}


#pragma mark - Private Methods

//加载程序判断是否有用户缓存
- (void)changeRootViewController {
    
    [HttpRequest netWorkStatus];
    
    self.tabBarVC = nil;
    
    //读取沙盒路径下的用户缓存
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSArray * tempFileList = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:FILEPATH error:nil]];
    //判断存在用户文件
    if ([tempFileList containsObject:@"user.data"]) {
        //存在,先进行登陆请求,还要再次判断用户是否登陆成功
        UserObj *user = [UserTool readTheUserModle];
        //防止账号空导致参数错误崩溃
        if (user.userID!=nil) {
            NSString *token = [NSString md5WithString];
            
            NSDictionary *dict = @{
                                   @"token":token,
                                   @"login_name":user.userID,
                                   @"password":user.password
                                   };
            [[HttpRequest shardWebUtil] postNetworkRequestURLString:@"http://cloud.musiccare.cn/Api/NbApi/nb_login" parameters:dict success:^(id obj) {
                int code;
                if ([[obj valueForKey:@"code"] isKindOfClass:[NSNumber class]]) {
                    code = [[obj valueForKey:@"code"] intValue];
                }
                if (code == successRequest) {
//                    //进入程序
//                    NGTabBarController *tabBarVC = [self generateTabBarVC];
//                    self.tabBarVC = tabBarVC;
//                    //添加退出登陆按钮
//                    UIButton *cancelBtn = [[UIButton alloc] init];
//                    [cancelBtn setImage:[UIImage imageNamed:@"tuichudenglu"] forState:UIControlStateNormal];
//                    [cancelBtn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
//                    [cancelBtn setFrame:CGRectMake(30, kScreen_Height-100, 117, 50)];
//                    [self.tabBarVC.view addSubview:cancelBtn];
//                    self.window.rootViewController = self.tabBarVC;
//                    [self.window makeKeyAndVisible];
//                    //从网络获取一下用户信息
//                    [self getUserInfo];
                    
                    UserManageVc *user = [[UserManageVc alloc] init];
                    self.window.rootViewController = user;
                    [self.window makeKeyAndVisible];
                    [self getUserInfo];
                    
                    
                }
                if (code == failRequset) {
                    //弹出登录
//                    [self initLoginVcForRootVc];
//                    [MBProgressHUD showText:@"登陆失败"];
                    UserManageVc *user = [[UserManageVc alloc] init];
                    self.window.rootViewController = user;
                    [self.window makeKeyAndVisible];
                }
                
            } fail:^(NSError *error) {
                //弹出登录
//                [self initLoginVcForRootVc];
//                [MBProgressHUD showText:@"登陆失败"];
                UserManageVc *user = [[UserManageVc alloc] init];
                self.window.rootViewController = user;
                [self.window makeKeyAndVisible];
            }];
        }
    
    }else{
        //不存在.弹出登录
        [self initLoginVcForRootVc];
        UserObj *obj = [UserObj sharedUser];
        obj.ID = @"418";
        obj.userID = @"bayin2017";
        obj.password = @"fenghuangbayin";
        [UserTool saveTheUserInfo:obj];
        UserManageVc *user = [[UserManageVc alloc] init];
        self.window.rootViewController = user;
        [self.window makeKeyAndVisible];
    }
}

//创建一个登陆控制器为跟控制器
-(void)initLoginVcForRootVc{
    
    LoginViewController *loginVC = [LoginViewController loginControllerWithBlock:^(BOOL result, NSString *message) {
        //判断回调是否成功成功就加载主界面,不成功不做相应
        if (result) {
//            NGTabBarController *tabBarVC = [self generateTabBarVC];
//            self.tabBarVC = tabBarVC;
            //添加退出登陆按钮
            UIButton *cancelBtn = [[UIButton alloc] init];
            [cancelBtn setImage:[UIImage imageNamed:@"tuichudenglu"] forState:UIControlStateNormal];
            [cancelBtn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
            [cancelBtn setFrame:CGRectMake(30, kScreen_Height-100, 117, 50)];
            [self.tabBarVC.view addSubview:cancelBtn];
            self.window.rootViewController = self.tabBarVC;
            [self.window makeKeyAndVisible];
//            //从网络获取一下用户信息
//            [self getUserInfo];
            UserManageVc *user = [[UserManageVc alloc] init];
            self.window.rootViewController = user;
            [self.window makeKeyAndVisible];
            [self getUserInfo];
            

        }else{
            //回调后展示登陆状态信息
//            [MBProgressHUD showError:message];
        }
    }];
    self.window.rootViewController = loginVC;
    [self.window makeKeyAndVisible];
}

//创建一个注册控制器为根控制器
-(void)initRegistForRootVc{
    BYRegisterController *registVc = [[BYRegisterController alloc] init];
    registVc.registerBlock = ^(){
        
        [self initLoginVcForRootVc];
    };
    registVc.registerSuccessBlock = ^(){
        //进入程序
//        NGTabBarController *tabBarVC = [self generateTabBarVC];
//        self.tabBarVC = tabBarVC;
//        //添加退出登陆按钮
//        UIButton *cancelBtn = [[UIButton alloc] init];
//        [cancelBtn setImage:[UIImage imageNamed:@"tuichudenglu"] forState:UIControlStateNormal];
//        [cancelBtn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
//        [cancelBtn setFrame:CGRectMake(30, kScreen_Height-100, 117, 50)];
//        [self.tabBarVC.view addSubview:cancelBtn];
//        self.window.rootViewController = self.tabBarVC;
//        [self.window makeKeyAndVisible];
//        //从网络获取一下用户信息
//        [self getUserInfo];
        UserManageVc *user = [[UserManageVc alloc] init];
        self.window.rootViewController = user;
        [self.window makeKeyAndVisible];
        [self getUserInfo];
    };
    self.window.rootViewController = registVc;
    [self.window makeKeyAndVisible];
}

//从网络获取一下用户信息
-(void)getUserInfo{
    //从网络获取一下用户信息
    UserObj *user = [UserTool readTheUserModle];
    BYHttpRequest *re = [[BYHttpRequest alloc] init];
    [re userInfoRequestWithUid:user.ID];
}


//创建tab跟控制器
- (NGTabBarController *)generateTabBarVC {
    /** 占位 */
    UISplitViewController *vc0 = [[UISplitViewController alloc] init];
    vc0.view.backgroundColor = [UIColor redColor];
    vc0.viewControllers = @[[[UITableViewController alloc] init],
                            [[UITableViewController alloc] init],
                            ];
    vc0.ng_tabBarItem = [NGTabBarItem itemWithTitle:nil image:[UIImage imageNamed:@"logowangzhi"] simage:[UIImage imageNamed:@"honghuguanli"]];
    vc0.ng_tabBarItem.title = nil;
    vc0.ng_tabBarItem.selectedTitleColor = nil;
    vc0.ng_tabBarItem.selectedImageTintColor = [UIColor clearColor];
    
    /** 用户 */
    UserGuoupVc *user = [[UserGuoupVc alloc]init];
    user.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"" image:[UIImage imageNamed:@"yonghuguanli-1"] simage:[UIImage imageNamed:@"yonghuguanli"]];
    
    
    /** 答题 */
    QuestionAnswerVc *qusetion = [[QuestionAnswerVc alloc] init];
    qusetion.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"" image:[UIImage imageNamed:@"wenjuandati-1"] simage:[UIImage imageNamed:@"wenjuandiaocha"]];
    
    /** 曲库 */
    MusicBaseVc *musicBase = [[MusicBaseVc alloc]init];
    musicBase.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"" image:[UIImage imageNamed:@"yinyuekuqu-1"] simage:[UIImage imageNamed:@"yinyuekuqu"]];

    /** 治疗 */
    HealingMusicVc *healingMusic = [[HealingMusicVc alloc]init];
    healingMusic.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"" image:[UIImage imageNamed:@"yinyuezhiliao-1"] simage:[UIImage imageNamed:@"yinyuezhiliao"]];
//    UISplitViewController *splitViewController = [[UISplitViewController alloc] init];
//    NavigationController *nav = [[NavigationController alloc] init];
//    DetailViewController *detail = [[DetailViewController alloc] init];
//    splitViewController.viewControllers = @[nav, detail];
//    splitViewController.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"歌单" image:[UIImage imageNamed:@"kongzhiicon-1"]];
    
    NSArray *viewController = @[vc0, user,qusetion,musicBase,healingMusic ];

    
    NGTabBarController *tabBarController = [[NGTabBarController alloc] initWithDelegate:self];
    tabBarController.delegate = self;
    
    tabBarController.viewControllers = viewController;
    tabBarController.selectedIndex = 1;
    tabBarController.tabBarPosition = NGTabBarPositionLeft;
    tabBarController.tabBar.layoutStrategy = NGTabBarLayoutStrategyStrungTogether;
   
    return tabBarController;
}


- (void)showCoachInfoVC {
    self.tabBarVC.selectedIndex = 4;
}


#pragma mark - NGTabBarControllerDelegate
- (BOOL)tabBarController:(NGTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index {
    
    NSLog(@"%@", tabBarController.viewControllers);

    if (index == 0) {
        return NO;
    }else if (index == 4){
        NSString *str = @"1";
        NSNotification *notification =[NSNotification notificationWithName:NOTIFICATIONQIEHUANBAOGAO object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        if ([self.str isEqualToString:str]) {
            
            NSNotification *notification =[NSNotification notificationWithName:NOTIFICATIONTINGZHIDENGLU object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            return NO;
        }else if ([[UserObj sharedUser].userID isEqualToString:@"0"]){
            return NO;
        }
        return YES;
    }else if (index == 2){
        NSString *str = @"1";
        NSNotification *notification =[NSNotification notificationWithName:NOTIFICATIONQIEHUANBAOGAO object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        if ([self.str isEqualToString:str]) {
            
            NSNotification *notification =[NSNotification notificationWithName:NOTIFICATIONTINGZHIDENGLU object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            return NO;
        }else if ([[UserObj sharedUser].userID isEqualToString:@"0"]){
            return NO;
        }
        return YES;
    }else if (index == 3){
        NSString *str = @"1";
        NSNotification *notification =[NSNotification notificationWithName:NOTIFICATIONQIEHUANBAOGAO object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        if ([self.str isEqualToString:str]) {
            
            NSNotification *notification =[NSNotification notificationWithName:NOTIFICATIONTINGZHIDENGLU object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            return NO;
        }else if ([[UserObj sharedUser].userID isEqualToString:@"0"]){
            return NO;
        }
        return YES;
    }
    return YES;
}

- (CGSize)tabBarController:(NGTabBarController *)tabBarController
sizeOfItemForViewController:(UIViewController *)viewController
                   atIndex:(NSUInteger)index
                  position:(NGTabBarPosition)position {
    if (NGTabBarIsVertical(position)) {
        if (index == 0) {
            return CGSizeMake(180, 120.0f);
        }
        return CGSizeMake(180, 75.f);
    } else {
        return CGSizeMake(60.f, 49.f);
    }
}

- (void)tabBarController:(NGTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index {
    
//    if (tabBarController.viewControllers.count == index+1) {
//        HYSettingViewController *setVC = viewController.childViewControllers.firstObject;
//        [setVC reloadData];
//    }
}

#pragma mark - 推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

}



@end
