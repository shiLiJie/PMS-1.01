//
//  DetailViewController.m
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 2017/4/10.
//  Copyright © 2017年 HanYouApp. All rights reserved.
//

#import "DetailViewController.h"
#import "musicModel.h"
#import "SLJAVPlayer.h"
#import "RTDragCellTableView.h"
#import "musicListCell.h"

@interface DetailViewController ()<UITableViewDelegate,UITableViewDataSource,playerDelegate,RTDragCellTableViewDataSource,RTDragCellTableViewDelegate,musicListDelegate>{
    // 下载句柄
    NSURLSessionDownloadTask *_downloadTask;
}

//@property (weak, nonatomic) IBOutlet RTDragCellTableView *detailTable;

@property (nonatomic, strong) NSMutableArray      *firstdataArr;//之前中转数组
@property (nonatomic, strong) NSMutableArray      *secDataArr;  //实际用到数组
@property (nonatomic, strong) SLJAVPlayer         *player;      //音乐播放器
@property (nonatomic, strong) NSIndexPath         *musicIndex;  //当前音乐播放的索引
@property (nonatomic, strong) NSString            *musicName;   //歌曲名称
@property (nonatomic, strong) RTDragCellTableView *detailTable; //歌曲名称
@property (nonatomic, assign) BOOL                isPlaying;    //是否正在播放

@property (nonatomic, strong) NSFileHandle        * logFileChart;  //新歌单文件handle
@property (nonatomic, copy)   NSString            *fileNameChart;  //新歌单本地文件名
@property (nonatomic, assign) NSInteger           setionIndex;     //当前所在的歌单索引
@property (nonatomic, assign) NSInteger           currentSetion;   //当前播放的歌单索引

@property (nonatomic, strong) musicListCell       *cell;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加歌单列表tab
    self.detailTable = [[RTDragCellTableView alloc] init];
    self.detailTable.frame = CGRectMake(self.view.bounds.origin.x, self.view.frame.origin.y+20, self.view.frame.size.width, self.view.frame.size.height+150);
    [self.view addSubview:self.detailTable];
    //给tab添加拖拽手势
    [self.detailTable addRecognizer];
    //设置代理
    self.detailTable.delegate = self;
    self.detailTable.dataSource = self;
    //初始化数据数组
    self.firstdataArr = [[NSMutableArray alloc] init];
    self.secDataArr = [[NSMutableArray alloc] init];
    //添加点击列表标题刷新列表的通知
    [SLJNotificationTools addaddObserver:self selector:@selector(changeMusicList:) methodName:@"MUSICLISTINDEX"];
    //初始化音乐播放器
    self.player = [[SLJAVPlayer alloc] initWithFrame:CGRectMake(20, 120, [UIScreen mainScreen].bounds.size.width-40, 220)];
    self.player.delegate = self;
    
    self.isPlaying = NO;
}

#pragma mark - 通知方法 -
-(void)changeMusicList:(NSNotification *) dict{
    
    [self.firstdataArr removeAllObjects];
    [self.secDataArr removeAllObjects];
    //当前所在的歌单索引
    self.setionIndex = [dict.object integerValue];
    
    NSString *pathDocuments=kDocument;
    NSArray *fileNameList=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathDocuments error:nil];
    NSMutableArray *arr = [fileNameList mutableCopy];
    if ([arr containsObject:@".DS_Store"]) {
        [arr removeObject:@".DS_Store"];
    }
    //打开文件的路径
    NSString *path = [NSString stringWithFormat:@"%@/%@",FILEPATH,arr[[dict.object integerValue]]];
    self.fileNameChart = path;
    self.logFileChart = [NSFileHandle fileHandleForWritingAtPath:path];
    [self.logFileChart seekToEndOfFile];
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.firstdataArr = [[result componentsSeparatedByString:@"?"] mutableCopy];
    

    for (int i = 0; i < self.firstdataArr.count; i++) {
        NSArray *data = [self.firstdataArr[i] componentsSeparatedByString:@","];
        musicModel *model = [[musicModel alloc] init];
        model.mid = data[0];
        model.name = data[1];
        model.url = data[2];
        model.size = data[3];
        model.cate = data[4];
        model.add_time = data[5];
        
        [self.secDataArr addObject:model];
    }
    
    [self.detailTable reloadData];
    
}

#pragma mark - 私有方法 -
-(void)downLoadEEGOldDataWithUrl:(NSString *)url
                    downLoadPath:(NSString *)downLoadPath{
    
    NSURL *URL = [NSURL URLWithString:url];
    //默认配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //AFN3.0+基于封住URLSession的句柄
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    //下载Task操作
    _downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        // 给Progress添加监听 KVO
        NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        // 回到主队列刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            // 设置进度条的百分比
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        return [NSURL fileURLWithPath:downLoadPath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //设置下载完成操作
        NSString *imgFilePath = [filePath path];// 将NSURL转成NSString
        NSLog(@"%@",[NSString fileSHA1:imgFilePath]);

    }];
    
    [_downloadTask resume];
}

#pragma mark - tableviewdelegate -
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.secDataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    self.cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSArray *nib1                   = [[NSBundle mainBundle]loadNibNamed:@"musicListCell" owner:nil options:nil];
    self.cell                       = [nib1 lastObject];
    self.cell.selectionStyle        = UITableViewCellSelectionStyleNone;
    self.cell.delegate              = self;
    
    musicModel *model                = self.secDataArr[indexPath.row];
    self.cell.musicNameLab.text      = model.name;
    self.cell.musicNameLab.textColor = [UIColor blackColor];
    self.cell.starOrPauseBtn.hidden  = YES;
    
    NSInteger a = indexPath.row;
    NSInteger b = self.musicIndex.row;
    
    //判断歌曲是否显示红色要判断一下当前组是否是播放的组
    if (self.currentSetion == self.setionIndex) {
        if (a == b) {
            self.cell.musicNameLab.textColor  = [UIColor redColor];
            self.cell.starOrPauseBtn.hidden  = NO;
            
        }
    }
   
    return self.cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    musicModel *model     = self.secDataArr[indexPath.row];
    NSString *musicUrlstr = model.url;

    NSInteger a = indexPath.row;
    NSInteger b = self.musicIndex.row;
    
    if (self.musicName == model.name) {
        if (self.currentSetion == self.setionIndex) {
            if (a == b) {
                if (self.isPlaying) {
                    self.isPlaying = NO;
                    [self.player.player pause];
                    [self.cell.starOrPauseBtn setImage:[UIImage imageNamed:@"zantingicon"] forState:UIControlStateNormal];
                    [SLJNotificationTools postNotification:nil methodName:@"BOFANGZANTING"];
                    
                }else{
                    self.isPlaying = YES;
                    [self.player.player play];
                    [self.cell.starOrPauseBtn setImage:[UIImage imageNamed:@"kaishi"] forState:UIControlStateNormal];
                    [SLJNotificationTools postNotification:nil methodName:@"BOFANGKAISHI"];
                }
                return;
            }
        }
    }

    //给当前播放的歌曲的歌单索引赋值
    self.currentSetion = self.setionIndex;
    //重置播放器
    [self.player resetPlayer];

    self.musicName               = model.name;
    
    NSString *pathDocuments=kDocument;
    NSArray *fileNameList=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/musicData",pathDocuments] error:nil];
    NSMutableArray *arr = [fileNameList mutableCopy];
    if ([arr containsObject:@".DS_Store"]) {
        [arr removeObject:@".DS_Store"];
    }
    if ([arr containsObject:[NSString stringWithFormat:@"%@.mp3",model.mid]]) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        //歌曲路径
        NSString *str = [NSString stringWithFormat:@"%@/musicData/%@.mp3",path,model.mid];

        
//        NSData *data = [NSData dataWithContentsOfFile:str];
//        //源文件转过来的str
//        NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
//        NSString *add = @"fenghuangbayin";
//        
//        //加工过的str
//        NSString *re = [NSString stringWithFormat:@"%@%@",add,result];
//        NSData *dataa = [re dataUsingEncoding:NSUTF8StringEncoding];
//        
//        NSString *textpath = [NSString stringWithFormat:@"%@/ver.mp3",path];
//        NSFileManager *file = [[NSFileManager alloc] init];
//        [file createFileAtPath:textpath contents:dataa attributes:nil];
//        NSData *data1 = [NSData dataWithContentsOfFile:textpath];
//
//        NSString *result1 = [[NSString alloc] initWithData:data1  encoding:NSUTF8StringEncoding];
        
        
        
        NSURL *url = [NSURL fileURLWithPath:str];
        [self.player playWithUrlStr:url PlayerLayer:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-40, 220)];
    }else{
        
        NSURL *url = [NSURL URLWithString:musicUrlstr];
        [self.player playWithUrlStr:url PlayerLayer:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-40, 220)];
        
        //创建存储歌曲文件的路径
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *musicPath = [NSString stringWithFormat:@"%@/musicData",FILEPATH];
        if(![fileManager fileExistsAtPath:musicPath]){
            [fileManager createDirectoryAtPath:musicPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        //下载歌曲到本地路径
        [self downLoadEEGOldDataWithUrl:model.url downLoadPath:[NSString stringWithFormat:@"%@/%@.mp3",musicPath,model.mid]];
    }
    
    [self.player startPaly];
    if (self.player.levelTimer) {       
        [self.player.levelTimer invalidate];
        self.player.levelTimer       = nil;
    }
//    self.player.levelTimer       = [NSTimer scheduledTimerWithTimeInterval: 1
//                                                                    target: self
//                                                                  selector: @selector(startTime)
//                                                                  userInfo: nil repeats: YES];
    self.musicIndex              = indexPath;
    
    [tableView reloadData];

}

//左滑删除功能
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
        
    return YES;
}
//左滑删除功能
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.secDataArr removeObjectAtIndex:indexPath.row];
    
    NSString *str;
    for (int i = 0; i < self.secDataArr.count; i ++) {
        musicModel *model = self.secDataArr[i];
        if (i==0) {
            str = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",model.mid,model.name,model.url,model.size,model.cate,model.add_time];
        }else{
            str = [NSString stringWithFormat:@"%@?%@,%@,%@,%@,%@,%@",str,model.mid,model.name,model.url,model.size,model.cate,model.add_time];
        }
        
    }
    //把歌单写入本地文件
    [str writeToFile:self.fileNameChart atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    [tableView reloadData];
}
//左滑删除文字设置
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark - 拖动tableview代理 -
- (NSArray *)originalArrayDataForTableView:(RTDragCellTableView *)tableView{
    
    return self.secDataArr;
}

- (void)tableView:(RTDragCellTableView *)tableView newArrayDataForDataSource:(NSArray *)newArray{
    self.secDataArr = [newArray mutableCopy];
    
    NSString *str;
    for (int i = 0; i < self.secDataArr.count; i ++) {
        musicModel *model = self.secDataArr[i];
        if (i==0) {
            str = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",model.mid,model.name,model.url,model.size,model.cate,model.add_time];
        }else{
            str = [NSString stringWithFormat:@"%@?%@,%@,%@,%@,%@,%@",str,model.mid,model.name,model.url,model.size,model.cate,model.add_time];
        }
    }
    //把歌单写入本地文件
    [str writeToFile:self.fileNameChart atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

#pragma mark - 播放器代理方法 -
-(void)startPlay{
    self.isPlaying = YES;
    NSLog(@"开始播放");

}

-(void)endPlay{
    
    self.isPlaying = NO;
    if (self.musicIndex.row+1 == self.secDataArr.count) {
        
        return;
    }else{
        self.musicIndex = [NSIndexPath indexPathForRow:self.musicIndex.row+1 inSection:self.musicIndex.section];
        [self tableView:self.detailTable didSelectRowAtIndexPath:self.musicIndex];
    }
    NSLog(@"结束播放");
}

#pragma mark - 播放列表上的按钮点击代理 -
-(void)clickStartOrStopbutton:(UIButton *)btn{
    
    if (self.isPlaying) {
        [btn setImage:[UIImage imageNamed:@"zantingicon"] forState:UIControlStateNormal];
    }else{
        [btn setImage:[UIImage imageNamed:@"kaishi"] forState:UIControlStateNormal];
    }
    
    [self tableView:self.detailTable didSelectRowAtIndexPath:self.musicIndex];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
