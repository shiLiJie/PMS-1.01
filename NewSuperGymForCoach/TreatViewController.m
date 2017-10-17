//
//  TreatViewController.m
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 16/3/16.
//  Copyright © 2016年 HanYouApp. All rights reserved.
//

#import "TreatViewController.h"
#import "MineViewController.h"
#import "Tool.h"
#import "DetailCell.h"
#import "musicClassModel.h"
#define IMP_WEAK_SELF(type) __weak type *weak_self=self;


static TreatViewController   *stationSelf = nil;

@interface TreatViewController ()<UITableViewDelegate,UITableViewDataSource,MineViewDelegate>
{
    float begntTIME;
}

@property (weak, nonatomic) IBOutlet UITableView *musicListTable;
@property (nonatomic, strong)UIViewController *currentVC;
@property (nonatomic, strong)UIViewController *lastVC;
@property (strong, nonatomic) NSTimer *timer;

@property (nonatomic, assign)int lastIndex;
@property (nonatomic) BOOL isMusic;


@property (nonatomic, strong) NSArray *listArr;//音乐库名称
@property (nonatomic, strong) NSArray *userArr;//音乐库名称
@property (nonatomic, strong) NSString *musicName;//当前音乐库名称
@property (nonatomic, strong) NSString *userName;//当前音乐库名称
@property (weak, nonatomic) IBOutlet UIButton *customMusicListBtn;

@property (nonatomic, strong) MineViewController *min;

@end

@implementation TreatViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addChildController];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];

}
- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}
//添加自定义歌单
- (IBAction)addNewMusicList:(UIButton *)sender {
    
    [UIView animateWithDuration:2.0 animations:^{
        
        if (self.min.tableWidth.constant == 0) {
            self.min.tableWidth.constant =  self.min.tableView.frame.size.width/2;
        }
    }];
    
    if (self.min.isChooseing) {
        return;
    }
    
    [self.min addNewMusicList];
    
    self.min.isChooseing = YES;
    self.min.isXuanzhong = NO;
    self.min.isXuanting  = NO;
    
    [self.min.tableView reloadData];
}

#pragma mark - 私有方法 -
//添加控制器
-(void)addChildController {
    
    MineViewController *min = [[MineViewController alloc]init];
    min.delegate = self;

    
    
    [self addChildViewController:min];

}

- (void)clickBtn:(UIButton * )btn {
    
    
    int i =  btn.tag - 100;
    
    if (i == self.lastIndex && i != 0) {
        return;
    }
    
    self.currentVC = self.childViewControllers[i];
    self.currentVC.view.frame = CGRectMake(202, 20, (self.view.bounds.size.width-200), self.view.bounds.size.height-40);
    [self.view insertSubview:self.currentVC.view atIndex:i];
    if (self.lastIndex != 0) {
        
        
        self.lastVC = self.childViewControllers[self.lastIndex];
        [self.lastVC.view removeFromSuperview];
    }
    
    self.lastIndex = i;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customMusicListBtn.hidden = YES;
    self.isMusic = YES;
    
    NSString *token        = [NSString md5WithString];
//    NSDictionary *dict1     = @{
//                               @"token":token,
//                               @"uid":@"99"
//                               };
////    http://cloud.musiccare.cn/Api/ZyApi/get_nbbg_lastest_time?uid=99
////    @"http://cloud.musiccare.cn/Api/MusicApi/get_music_cate"
////    @"http://cloud.musiccare.cn/Api/ZyApi/brainwave_alpha_gama_ratio_max?uid=99"
//    
//    //脑波检测时间
//    [[HttpRequest shardWebUtil] postNetworkRequestURLString:@"http://cloud.musiccare.cn/Api/ZyApi/get_nbbg_lastest_time"
//     
//                                                 parameters:dict1
//                                                    success:^(id obj) {
//                                                        
////                                                        NSLog(@"%@",obj);
////
////                                                        //解析数据
////                                                        NSLog(@"%@",obj[0][@"max(time)"]);
////                                                        NSString *time = obj[0][@"max(time)"];
////                                                        NSString *str = [NSString stringFromTimestamp:[time integerValue]];
////                                                        NSLog(@"%@",str);
//                                                    }
//                                                       fail:^(NSError *error) {
//                                                           NSLog(@"error--%@",error);
//                                                       }];
    
//    1480315838
//    2016-11-28 14:50:38
    NSDictionary *dict     = @{
                                @"token":token,
                                @"uid":@"99"
//                                @"time":@"1480315838",
                                };
//    //脑波饼图报告数据
//    [[HttpRequest shardWebUtil] postNetworkRequestURLString:@"http://cloud.musiccare.cn/Api/ZyApi/get_user_nbbg"
//     
//                                                 parameters:dict
//                                                    success:^(id obj) {
//                                                        
//                                                        NSLog(@"%@",obj);
//                                                        
//                                                        
//                                                    }
//                                                       fail:^(NSError *error) {
//                                                           NSLog(@"error--%@",error);
//                                                       }];
//    
//
//    //音乐滴定最大值接口
//    [[HttpRequest shardWebUtil] postNetworkRequestURLString:@"http://cloud.musiccare.cn/Api/ZyApi/brainwave_delta_theta_sum_max?uid=99"
//     
//                                                 parameters:nil
//                                                    success:^(id obj) {
//                                                        
////                                                        NSLog(@"%@",obj);
//                                                        
//                                                        
//                                                            }
//                                                       fail:^(NSError *error) {
//                                                           NSLog(@"error--%@",error);
//                                                       }];
    
    
    
    
    //    NSURLSession *session = [NSURLSession sharedSession];
    //    // 1.创建一个URL ： 请求路径
    //    NSURL *url = [NSURL URLWithString:@"http://cloud.musiccare.cn/Api/ZyApi/get_nbbg_lastest_time"];
    //    // 2.创建一个请求
    //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //    // 设置请求方法
    //    request.HTTPMethod = @"POST";
    //    // 设置请求体 : 请求参数
    //    NSString *param = [NSString stringWithFormat:@"uid=99"];
    //    // NSString --> NSData
    //    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    //    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    //
    //        //解析数据
    //        NSArray *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    //        NSLog(@"%@",dict);
    //
    //        NSLog(@"%@",dict[0]);
    //        NSLog(@"%@",dict[0][@"max(time)"]);
    //    }];
    //    
    //    //7.执行任务
    //    [dataTask resume];

    
    
//        NSString *text = @" question_1=否&question_2=否&question_3=否&question_4=否&question_5=否&question_6=否&question_7=否&question_8=否&question_9=否&question_10=否&question_11=否&question_12=否&question_13=否&question_14=否&question_15=否&question_16=否&question_17=否&question_18=否&question_19=否&question_20=否&question_21=否&question_22=否&question_23=否&question_24=否&question_25=否&question_26=否&question_27=否&question_28=否&question_29=否&question_30=否";
//    
//        NSDictionary *dict1     = @{
//                                   @"token":token,
//                                   @"id":@"99",
//                                   @"time":@"123455",
//                                   @"question_i":text,
//                                   @"Form_type":@"eap"
//                                   };
//    
//        [[HttpRequest shardWebUtil] postNetworkRequestURLString:@"http://cloud.musiccare.cn/Api/NbApi/upload_survey_data"
//    
//                                                     parameters:dict1
//                                                        success:^(id obj) {
//    
//                                                            NSLog(@"%@",obj);
//    
//                                                            }
//                                                           fail:^(NSError *error) {
//                                                               NSLog(@"error--%@",error);
//                                                           }];
    
//    正式代码
    [[HttpRequest shardWebUtil] postNetworkRequestURLString:@"http://cloud.musiccare.cn/Api/MusicApi/get_music_cate"

                                                 parameters:dict
                                                    success:^(id obj) {
                                                        
                                                        
                                                        NSArray *arr = obj;//取出需要的数据数组
                                                        NSMutableArray *arrayM = [NSMutableArray array];//中间中转数组
                                                        for (int i = 0; i < arr.count; i ++) {//遍历数组
                                                            NSDictionary *dict = arr[i];
                                                            [arrayM addObject:[musicClassModel musicClassWithDict:dict]];//中转数组存放转成模型的字典
                                                        }
                                                        self.listArr = arrayM;
                                                        
                                                        [self.musicListTable reloadData];
                                                        
                                                        
                                                    }
                                                       fail:^(NSError *error) {
                                                           NSLog(@"error--%@",error);
                                                       }];
//
    self.musicListTable.delegate = self;
    self.musicListTable.dataSource = self;
    

}
#pragma mark - tableviewdelegate -
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isMusic) {
        return _listArr.count;
    }else{
        return _userArr.count;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *nib1 = [[NSBundle mainBundle]loadNibNamed:@"DetailCell" owner:nil options:nil];
    cell = [nib1 lastObject];
    
    cell.lineImage.hidden = YES;
    
    if (self.isMusic) {
        musicClassModel *model = self.listArr[indexPath.row];
        cell.musicnameLab.text = model.name;
        if ([cell.musicnameLab.text isEqualToString:self.musicName]) {
            cell.musicnameLab.textColor = [UIColor redColor];
            cell.lineImage.hidden = NO;
        }
    }else{
        cell.musicnameLab.text = self.userArr[indexPath.row];
        if ([cell.musicnameLab.text isEqualToString:self.userName]) {
            cell.musicnameLab.textColor = [UIColor redColor];
            cell.lineImage.hidden = NO;
        }
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    musicClassModel *model = self.listArr[indexPath.row];
    self.musicName = model.name;
    self.userName = self.userArr[indexPath.row];
    [self.musicListTable reloadData];
    
    if (!self.min) {
        self.min = [[MineViewController alloc]init];
        self.min.delegate = self;
        self.min.view.frame = CGRectMake(202, 20, (self.view.bounds.size.width-200), self.view.bounds.size.height-20);
        [self.view insertSubview:self.min.view atIndex:0];
    }
    //传输歌曲分类的id
//    self.min.musicClassId = model.mid;
    //获取id下的歌曲/更新歌曲列表内容
    [self.min addMusicData];
    //左侧线显示
    self.customMusicListBtn.hidden = NO;
}

#pragma mark - 右侧详情界面代理方法-
//切换患者
-(void)changePatientBase{
    self.isMusic = NO;
    self.customMusicListBtn.hidden = YES;
    [self.musicListTable reloadData];
}

//切换乐库
-(void)changeMusicBase{
    self.isMusic = YES;
    self.customMusicListBtn.hidden = NO;
    [self.musicListTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
