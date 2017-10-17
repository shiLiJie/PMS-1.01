//
//  HttpRequest.m
//  网络请求1116Demo
//
//  Created by 凤凰八音 on 16/10/25.
//  Copyright © 2016年 凤凰八音. All rights reserved.
//

#import "HttpRequest.h"
#import <AFHTTPSessionManager.h>
#import "musicModel.h"
/**
 *  存放 网络请求的线程
 */
static NSMutableArray *sg_requestTasks;

@interface HttpRequest (){
    // 下载句柄
    NSURLSessionDownloadTask *downloadTask;
}

@property (nonatomic, strong) NSMutableArray *musicDataArr;//音乐数组
@property (nonatomic, strong) NSMutableArray *oldmusicDataArr;//音乐数组
@property (nonatomic, assign) int downLoadIndex;//当前下载的索引


@end


@implementation HttpRequest
-(void)haha{
    self.netState = NETStateError;
}

static HttpRequest * webUtil = nil;

+ (HttpRequest *) shardWebUtil
{
    @synchronized([HttpRequest class])
    {
        if (!webUtil) {
            webUtil = [[[self class] alloc] init];
            
            
        }
        return webUtil;
    }
    return nil;
}

#pragma mark 检测网路状态
+ (void)netWorkStatus{
    
    /**
     *  AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     *  AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     *  AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G
     *  AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络Wifi
     */
    // 如果要检测网络状态的变化, 必须要用检测管理器的单例startMoitoring
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if(status == AFNetworkReachabilityStatusNotReachable){
            NSLog(@"断网了");
            
            return ;
        }
        if(status == AFNetworkReachabilityStatusReachableViaWiFi){
            NSLog(@"wifi");
            
            //网络连接良好,开始悄悄准备下载后台曲目
            HttpRequest *re = [[HttpRequest alloc] init];
            
            //获取后台音乐列表
            [re getAllMusic];

            return ;
        }
        if(status == AFNetworkReachabilityStatusReachableViaWWAN){
            NSLog(@"4G");
            
            return ;
        }
    }];
    
}

#pragma mark - AFnetworking manager getter

- (AFHTTPSessionManager *)createAFHTTPSessionManager
{
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求参数的类型:HTTP (AFJSONRequestSerializer,AFHTTPRequestSerializer)
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //设置请求的超时时间
    manager.requestSerializer.timeoutInterval = 30.f;
    //设置服务器返回结果的类型:JSON (AFJSONResponseSerializer,AFHTTPResponseSerializer)
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    return manager;
}

/**
 *JSON方式获取数据 GET
 *urlStr:获取数据的url地址
 *
 */
- (void)getNetworkRequestURLString:(NSString *) urlString  andParas:(id) params andTransferGottenData:(transferValue) transfer
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManager];

    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        transfer(responseObject,nil);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        transfer(nil,error);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

/**
 *JSON方式获取数据 POST
 *urlStr:获取数据的url地址
 *
 */
-(void)postNetworkRequestURLString:(NSString *) urlString  andParas:(id) params andTransferGottenData:(transferValue) transfer
{

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManager];
   
    [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         transfer(responseObject,nil);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         transfer(nil,error);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

/**
 *JSON方式获取数据 GET
 *url_path:获取数据的url地址
 *有返回值 类型
 */
- (PPURLSessionTask *)getNetworkRequestURLString:(NSString *)url_path parameters:(id)parameters success:(void (^)(id obj))success fail:(void (^)(NSError *error))fail
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManager];
    
    PPURLSessionTask *session=nil;
    
    session = [manager GET:url_path parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    
    if (session) {
        [[self allTasks] addObject:session];
    }
    return session;
}

/**
 *JSON方式获取数据 POST
 *url_path:获取数据的url地址
 *有返回值 类型
 */
- (PPURLSessionTask *)postNetworkRequestURLString:(NSString *)url_path parameters:(id)parameters success:(void (^)(id obj))success fail:(void (^)(NSError *error))fail
{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManager];
    
     PPURLSessionTask *session=nil;
    
    session = [manager POST:url_path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    
    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
}

- (NSMutableArray *)allTasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sg_requestTasks == nil) {
            sg_requestTasks = [[NSMutableArray alloc] init];
        }
    });
    
    return sg_requestTasks;
}

- (void)cancelRequestWithURL:(NSString *)url {
    
    if (url == nil) {
        return;
    }
    
    @synchronized(self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(PPURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[PPURLSessionTask class]]
                && [task.currentRequest.URL.absoluteString hasSuffix:url]) {
                [task cancel];
                [[self allTasks] removeObject:task];
                return;
            }
        }];
    };
}

- (void)cancelAllRequest {
    @synchronized(self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(PPURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[PPURLSessionTask class]]) {
                [task cancel];
            }
        }];
        
        [[self allTasks] removeAllObjects];
    };
}

/**
 *  上传图片
 *
 *  @param url        请求url
 *  @param image      要上传的文件流
 *  @param completion 文件上传成功的回调
 *  @param errorBlock 文件上传失败的回调
 *
 *  @return 请求体
 */
- (PPURLSessionTask *)uploadImageWithUrl:(NSString *)url
                              WithParams:(NSDictionary*)params
                                   image:(NSData *)imageData
                                filename:(NSString *)name
                                mimeType:(NSString *)mimetype
                              completion:(requestSuccessBlock)completion
                              errorBlock:(requestFailureBlock)errorBlock
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManager];
     PPURLSessionTask *operation = [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         formatter.dateFormat = @"yyyyMMddHHmmss";
         NSString *str = [formatter stringFromDate:[NSDate date]];
         NSString *fileName = [NSString stringWithFormat:@"%@.png",str];
         
         // 上传图片，以文件流的格式
         [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:mimetype];
     } progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         completion(responseObject);
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         errorBlock(error);
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
     }];
    return operation;
}

/**
 *  上传音视频文件
 *
 *  @param url        请求url
 *  @param image      要上传的文件流
 *  @param completion 文件上传成功的回调
 *  @param errorBlock 文件上传失败的回调
 *
 *  @return 请求体
 */
- (PPURLSessionTask *)uploadVedioWithUrl:(NSString *)url
                              WithParams:(NSDictionary*)params
                                   image:(NSData *)vedioData
                                filename:(NSString *)name
                                mimeType:(NSString *)mimetype
                              completion:(requestSuccessBlock)completion
                              errorBlock:(requestFailureBlock)errorBlock
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManager];
    
    PPURLSessionTask *operation = [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.mp4",str];
        [formData appendPartWithFileData:vedioData name:name fileName:fileName mimeType:mimetype];

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorBlock(error);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    
    return operation;
}


/**
 *  上传txt文件
 *
 *  @param url        请求url
 *  @param image      要上传的文件流
 *  @param completion 文件上传成功的回调
 *  @param errorBlock 文件上传失败的回调
 *
 *  @return 请求体
 */
- (PPURLSessionTask *)uploadTextWithUrl:(NSString *)url
                              WithParams:(NSDictionary*)params
                                   image:(NSData *)txtData
                                filename:(NSString *)name
                                mimeType:(NSString *)mimetype
                                fileName:(NSString *)fileName
                              completion:(requestSuccessBlock)completion
                              errorBlock:(requestFailureBlock)errorBlock
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManager];
    
    PPURLSessionTask *operation = [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        [formData appendPartWithFileData:txtData name:name fileName:fileName mimeType:mimetype];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorBlock(error);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    
    
    return operation;
}


//下载音乐方法,传入后台地址和保存的名称
- (void)downMusicWithUrl:(NSString *)url
                fileName:(NSString *)fileName
                    path:(NSString *)path{
    
    //远程地址
    NSURL *URL = [NSURL URLWithString:url];
    //默认配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //AFN3.0+基于封住URLSession的句柄
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    //下载Task操作
    downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        // 给Progress添加监听 KVO
//        NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        // 回到主队列刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{

        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *createPath=[NSString stringWithFormat:@"%@/musicData/%@",cachesPath,path];

        //检查是否存在
        if(![[NSFileManager defaultManager] fileExistsAtPath:createPath]){
            //不存在
            [[NSFileManager defaultManager] createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString *path = [createPath stringByAppendingPathComponent:fileName];
        
        return [NSURL fileURLWithPath:path];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        //在下载完成回调中下载下一个,(防越界)
        if (self.downLoadIndex>=self.musicDataArr.count) {

            return;
        }else{
            //下载下一个
            musicModel *model = self.musicDataArr[self.downLoadIndex];
            NSString *path;
            if ([model.cate isEqualToString:@"情绪心理调节"]) {
                path = [NSString stringWithFormat:@"五脏/%@",model.cate];
            }
            if ([model.cate isEqualToString:@"轻度疼痛"] || [model.cate isEqualToString:@"轻微疼痛"] || [model.cate isEqualToString:@"中度疼痛"]) {
                path = [NSString stringWithFormat:@"情志/%@",model.cate];
            }
            if ([model.cate isEqualToString:@"脑神经调节"]) {
                path = [NSString stringWithFormat:@"脑健康/%@",model.cate];
            }
            if ([model.cate isEqualToString:@"帮助入眠"] || [model.cate isEqualToString:@"深度睡眠"] || [model.cate isEqualToString:@"音乐唤醒简短版"]  || [model.cate isEqualToString:@"唤醒音乐"]  || [model.cate isEqualToString:@"自然之声"]) {
                path = [NSString stringWithFormat:@"改善睡眠/%@",model.cate];
            }
            if ([model.cate isEqualToString:@"叠加"]) {
                path = [NSString stringWithFormat:@"叠加/%@",model.cate];
            }
            [self downMusicWithUrl:model.url
                          fileName:model.name
                              path:path];
            self.downLoadIndex++;
        }
        
    }];
    
    [downloadTask resume];
}

-(void)getAllMusic{
    NSString *token = [NSString md5WithString];
    NSDictionary *dict     = @{
                               @"token":token,
                               @"p":@"",
                               @"num":@"1000"
                               
                               };
    [[HttpRequest shardWebUtil] postNetworkRequestURLString:@"http://cloud.musiccare.cn/Api/MusicApi/get_all_music"
     
                                                 parameters:dict
                                                    success:^(id obj) {
                                                        
                                                        
                                                        NSArray *arr = [obj valueForKey:@"data"];//取出需要的数据数组
                                                        NSMutableArray *arrayM = [NSMutableArray array];//中间中转数组
                                                        for (int i = 0; i < arr.count; i ++) {//遍历数组
                                                            NSDictionary *dict = arr[i];
                                                            [arrayM addObject:[musicModel musicListWithDict:dict]];//中转数组存放转成模型的字典
                                                        }
                                                        
                                                        self.musicDataArr = arrayM;
                                                        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
                                                        NSString *createPath=[NSString stringWithFormat:@"%@/musicData/五脏/情绪心理调节",cachesPath];
                                                        
                                                        NSString *createPath2=[NSString stringWithFormat:@"%@/musicData/情志/轻度疼痛",cachesPath];
                                                        NSString *createPath21=[NSString stringWithFormat:@"%@/musicData/情志/轻微疼痛",cachesPath];
                                                        NSString *createPath22=[NSString stringWithFormat:@"%@/musicData/情志/中度疼痛",cachesPath];
                                                        
                                                        NSString *createPath3=[NSString stringWithFormat:@"%@/musicData/脑健康/脑神经调节",cachesPath];
                                                        
                                                        NSString *createPath4=[NSString stringWithFormat:@"%@/musicData/改善睡眠/帮助入眠",cachesPath];
                                                        NSString *createPath41=[NSString stringWithFormat:@"%@/musicData/改善睡眠/深度睡眠",cachesPath];
                                                        NSString *createPath42=[NSString stringWithFormat:@"%@/musicData/改善睡眠/音乐唤醒简短版",cachesPath];
                                                        NSString *createPath43=[NSString stringWithFormat:@"%@/musicData/改善睡眠/唤醒音乐",cachesPath];
                                                        NSString *createPath44=[NSString stringWithFormat:@"%@/musicData/改善睡眠/自然之声",cachesPath];
                                                        NSString *createPath5=[NSString stringWithFormat:@"%@/musicData/叠加/叠加",cachesPath];
                                                        
                                                        NSMutableArray *pathArr = [[NSMutableArray alloc] init];
                                                        [pathArr addObject:createPath];
                                                        
                                                        [pathArr addObject:createPath2];
                                                        [pathArr addObject:createPath21];
                                                        [pathArr addObject:createPath22];
                                                        [pathArr addObject:createPath3];
                                                        
                                                        [pathArr addObject:createPath4];
                                                        [pathArr addObject:createPath41];
                                                        [pathArr addObject:createPath42];
                                                        [pathArr addObject:createPath43];
                                                        [pathArr addObject:createPath44];
                                                        [pathArr addObject:createPath5];
                                                        
                                                        for (int i = 0; i<pathArr.count; i++) {
                                                            //检查是否存在
                                                            if(![[NSFileManager defaultManager] fileExistsAtPath:pathArr[i]]){
                                                                //不存在
//                                                                [[NSFileManager defaultManager] createDirectoryAtPath:pathArr[i] withIntermediateDirectories:YES attributes:nil error:nil];
                                                            }
                                                            NSArray *oldMusicarr = [NSArray array];
                                                            oldMusicarr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathArr[i] error:nil];
                                                            
                                                            for (int i=0; i<oldMusicarr.count; i++) {
                                                                [self.oldmusicDataArr addObject:oldMusicarr[i]];
                                                            }
                                                        }
                                                        
//                                                        [self downLoadMusicData];
                                                        
                                                    }
                                                       fail:^(NSError *error) {
                                                           NSLog(@"error--%@",error);
                                                       }];
}

-(void)downLoadMusicData{
    for (int i=0; i<self.musicDataArr.count; i++) {
        musicModel *model = self.musicDataArr[i];
        //本地包含后台url
        if ([self.oldmusicDataArr containsObject:model.name]) {
            //不需要下载,从模型数组中移除
            [self.musicDataArr removeObject:self.musicDataArr[i]];
            i--;
        }else{
            //本地没有后台的url
            //数组包含了需要下载的txt
            if ([self.oldmusicDataArr containsObject:model.name]) {
                //不需要下载,从模型数组中移除
                [self.musicDataArr removeObject:self.musicDataArr[i]];
                i--;
            }else{
                //数组不包含txt,加入到数组中,临时记录判断用
                [self.oldmusicDataArr addObject:model.name];
            }
        }
    }
    
    //先判断用不用从云端下载
    if (self.musicDataArr.count>0) {
        //先下载第0个
        self.downLoadIndex = 0;
        musicModel *model = self.musicDataArr[self.downLoadIndex];
        
        NSString *path;
        if ([model.cate isEqualToString:@"情绪心理调节"]) {
            path = [NSString stringWithFormat:@"五脏/%@",model.cate];
        }
        if ([model.cate isEqualToString:@"轻度疼痛"] || [model.cate isEqualToString:@"轻微疼痛"] || [model.cate isEqualToString:@"中度疼痛"]) {
            path = [NSString stringWithFormat:@"情志/%@",model.cate];
        }
        if ([model.cate isEqualToString:@"脑神经调节"]) {
            path = [NSString stringWithFormat:@"脑健康/%@",model.cate];
        }
        if ([model.cate isEqualToString:@"帮助入眠"] || [model.cate isEqualToString:@"深度睡眠"] || [model.cate isEqualToString:@"音乐唤醒简短版"]  || [model.cate isEqualToString:@"唤醒音乐"]  || [model.cate isEqualToString:@"自然之声"]) {
            path = [NSString stringWithFormat:@"改善睡眠/%@",model.cate];
        }
        if ([model.cate isEqualToString:@"叠加"]) {
            path = [NSString stringWithFormat:@"叠加/%@",model.cate];
        }
        
        [self downMusicWithUrl:model.url
                      fileName:model.name
                          path:path];
        
        self.downLoadIndex++;
    }
}


-(NSMutableArray *)musicDataArr{
    if (!_musicDataArr) {
        _musicDataArr = [[NSMutableArray alloc] init];
    }
    return _musicDataArr;
}

-(NSMutableArray *)oldmusicDataArr{
    if (!_oldmusicDataArr) {
        _oldmusicDataArr = [[NSMutableArray alloc] init];
    }
    return _oldmusicDataArr;
}


@end
