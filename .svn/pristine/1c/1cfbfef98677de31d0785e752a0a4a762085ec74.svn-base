//
//  BYRegisterController.m
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 16/11/17.
//  Copyright © 2016年 HanYouApp. All rights reserved.
//

NSString *const failureCoder = @"0";
NSString *const succeedCoder = @"1";

#import "BYRegisterController.h"
#import <FMDB.h>
//枚举判断注册类型
typedef enum
{
    //以下是枚举成员
    otherRegist = 1,
    phoneRegist = 2,
    mailRegist = 3
    
}registerType;//枚举名称

@interface BYRegisterController ()<UITextFieldDelegate>
//账号textfield
@property (weak, nonatomic) IBOutlet UITextField *accentTextField;
//密码textfield
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
//验证码textf
@property (weak, nonatomic) IBOutlet UITextField *verifiCodeTextField;
//枚举属性,修改注册类型使用
@property (nonatomic, assign)registerType registertype;
//注册方块的背景图
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
//获取验证码的小图标
@property (weak, nonatomic) IBOutlet UIImageView *verifiImageIcon;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
//右下右侧按钮(默认其他注册按钮)
@property (weak, nonatomic) IBOutlet UIButton *rightDownBtn;
//左下右侧按钮(默认邮箱注册按钮)
@property (weak, nonatomic) IBOutlet UIButton *leftDownBtn;
//获取验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *getVerifiCodeBtn;
//验证码下边的横线
@property (weak, nonatomic) IBOutlet UIImageView *verifiCodeBgLine;
//距离顶部的约束(切换其他注册的时候改变)
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceToTop;
//验证码按钮倒计时定时器
@property (nonatomic, weak) NSTimer *timer;
//机构列表数组
@property (nonatomic, strong) NSArray *orgListArr;

@end

@implementation BYRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置文本框光标颜色
    [[UITextField appearance] setTintColor:[UIColor hexColorWithString:@"B8B8B8"]];
    //设置textfield代理
    self.accentTextField.delegate = self;
    self.passWordTextField.delegate = self;
    self.verifiCodeTextField.delegate = self;
    //启动默认进入手机注册
    self.registertype = phoneRegist;
    //设置编辑textfield的时候右侧出现清空按钮
    self.accentTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.verifiCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //密码输入框
    [self.passWordTextField setSecureTextEntry:YES];
    //网络请求机构列表
//    [self getOrgListArray];
}

//点击方法点击空白收回键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.accentTextField resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
    [self.verifiCodeTextField resignFirstResponder];
    //获取机构列表
//    for (int i =0 ; i<self.orgListArr.count; i++) {
//        OrganizationModel *model = self.orgListArr[i];
//        NSLog(@"%@",model.organizationId);
//        NSLog(@"%@",model.jgqc);
//    }
}

#pragma mark - buttonClick -

//返回登陆界面
- (IBAction)backToLogin:(UIButton *)sender {
    //返回登陆开启回调
    self.registerBlock();
}

//获取验证码
- (IBAction)getVerifiCodeBtnClick:(UIButton *)sender {
    //根据填写的信息获取验证码
    [self getVerifi:self.registertype number:self.accentTextField.text];
}

//点击注册按钮
- (IBAction)registerBtnClick:(UIButton *)sender {
    //判断是否传入空的账号或密码
    if ([self.accentTextField.text isEqualToString:@""] ||
        [self.passWordTextField.text isEqualToString:@""] ) {
        return;
    }
    
    //过滤账号密码格式
    //普通注册
    if (self.registertype == otherRegist) {
        //排除特殊字符
        NSString *acc=self.accentTextField.text;
        NSString *pwd=self.passWordTextField.text;
        //判断账号密码长度
        if (self.accentTextField.text.length > 15) {
            [MBProgressHUD showText:@"账号长度不要大于20位"];
            return;
        }
        if (self.passWordTextField.text.length > 20) {
            [MBProgressHUD showText:@"密码长度不要大于20位"];
            return;
        }
        //再判断格式是否正确
        if ([SLJJudgementString checkPassword:acc]) {
        }else{
            //没有
            [MBProgressHUD showText:@"账号格式不正确"];
            return;
        }
        if ([SLJJudgementString checkPassword:pwd]) {
        }else{
            //没有
            [MBProgressHUD showText:@"密码格式不正确"];
            return;
        }
    }
    //手机注册
    if (self.registertype == phoneRegist) {
        //判断是否传入空的账号或密码
        if ([self.accentTextField.text isEqualToString:@""] ||
            [self.passWordTextField.text isEqualToString:@""] ) {
            return;
        }
        
        if (self.passWordTextField.text.length > 20) {
            [MBProgressHUD showText:@"密码长度不要大于20位"];
            return;
        }
        //排除特殊字符
        NSString *acc=self.accentTextField.text;
        NSString *pwd=self.passWordTextField.text;
        
        //再判断格式是否正确
        if ([SLJJudgementString checkTelNumber:acc]) {
        }else{
            //没有
            [MBProgressHUD showText:@"手机号格式不正确"];
            return;
        }
        if ([SLJJudgementString checkPassword:pwd]) {
        }else{
            //没有
            [MBProgressHUD showText:@"密码格式不正确"];
            return;
        }
    }
    //邮箱注册
    if (self.registertype == mailRegist) {
        //判断是否传入空的账号或密码
        if ([self.accentTextField.text isEqualToString:@""] ||
            [self.passWordTextField.text isEqualToString:@""] ) {
            return;
        }
        
        if (self.passWordTextField.text.length > 20) {
            [MBProgressHUD showText:@"密码长度不要大于20位"];
            return;
        }
        //排除特殊字符
        NSString *acc=self.accentTextField.text;
        NSString *pwd=self.passWordTextField.text;
        
        //再判断格式是否正确
        if ([SLJJudgementString validateEmail:acc]) {
        }else{
            //没有
            [MBProgressHUD showText:@"邮箱格式不正确"];
            return;
        }
        if ([SLJJudgementString checkPassword:pwd]) {
        }else{
            //没有
            [MBProgressHUD showText:@"密码格式不正确"];
            return;
        }
    }
    //禁用按钮
    [self.registBtn setEnabled:NO];
    NSString *token = [NSString md5WithString];
    NSDictionary *dict = @{
                           @"token":token,
                           @"register_name":self.accentTextField.text,
                           @"org_id":@"1",
                           @"password":self.passWordTextField.text,
                           @"re_password":self.passWordTextField.text,
                           @"verify_code":self.verifiCodeTextField.text,
                           @"register_type":[NSString stringWithFormat:@"%u",self.registertype],
                           @"register_form":@"app"
                           };
    //注册账号网络请求
    [[HttpRequest shardWebUtil] postNetworkRequestURLString:@"http://cloud.musiccare.cn/Api/NbApi/nb_register"
                                                 parameters:dict
                                                    success:^(id obj) {
                                                        [self.registBtn setEnabled:YES];
                                                        NSLog(@"%@",obj);
                                                        NSString *msg = [NSString getResponseMsgWithObject:obj];
                                                        NSString *uid = [NSString getResponseUIDWithObject:obj];
                                                        if ([succeedCoder isEqualToString:[NSString stringWithFormat:@"%@",[obj valueForKey:@"code"]]]) {
                                                            [MBProgressHUD showSuccess:@"注册成功"];
                                                            //存用户数据
                                                            UserObj *obj = [UserObj sharedUser];
                                                            obj.ID = uid;
                                                            obj.userID = self.accentTextField.text;
                                                            obj.password = self.passWordTextField.text;
                                                            [UserTool saveTheUserInfo:obj];
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
//                                                                //查询数据条数
//                                                                int i = 0;
//                                                                if ([db open]) {
//                                                                    NSString * sql = @"SELECT * FROM shopCar";
//                                                                    FMResultSet * rs = [db executeQuery:sql];
//                                                                    
//                                                                    while ([rs next]) {
//                                                                        i++;
//                                                                    }
//                                                                    [db close];
//                                                                }
                                                                //插入数据
                                                                if ([db open]) {
                                                                    NSString *insertSql1= [NSString stringWithFormat:@"INSERT INTO shopCar (uid, account, password) VALUES ('%@', '%@', '%@')", uid, self.accentTextField.text, self.passWordTextField.text];
                                                                    BOOL res = [db executeUpdate:insertSql1];
                                                                    
                                                                    if (res) {
                                                                        NSLog(@"数据插入表成功");
                                                                    } else {
                                                                        NSLog(@"数据插入表失败");
                                                                    }
                                                                    [db close];
                                                                }
                                                            }
                                                            //注册成功回调
                                                            self.registerSuccessBlock();
                                                        }else{
                                                            [MBProgressHUD showError:msg];
                                                        }
        
                                                    } fail:^(NSError *error) {
                                                        //失败,提示网络错误
    }];
}

//点击切换邮箱注册(左侧按钮)
- (IBAction)mailRegisterBtnClick:(UIButton *)sender {
    [self resumeVerifiBtn];//恢复获取验证码按钮移除定时器
    //当前为手机注册,
    if (self.registertype == phoneRegist) {
        //设置为邮箱注册
        [self setMailRegister];
        //当前为邮箱注册
    }else if (self.registertype == mailRegist) {
        //设置为手机注册
        [self setPhoneRegister];
        //当前为其他注册
    }else if (self.registertype == otherRegist){
        //设置为邮箱注册
        [self setMailRegister];
    }
}

//切换其他普通按钮注册(右侧按钮)
- (IBAction)otherRegisterBtnclick:(UIButton *)sender {
    [self resumeVerifiBtn];//恢复获取验证码按钮移除定时器
    //当前不是其他注册
    if (self.registertype != otherRegist) {
        //设置为其他注册
        [self setOtherRegister];
    }else{
        //设置为手机注册
        [self setPhoneRegister];
    }
}


#pragma mark - 私有方法 -


//获取机构列表方法
//-(void)getOrgListArray{
//    
//    self.orgListArr = [[NSArray alloc] init];
//    
//    NSString *token = [NSString md5WithString];
//    
//    NSDictionary *dict = @{
//                           @"token":token,
//                           };
//    NSString *url = @"http://cloud.musiccare.cn/Api/NbApi/nb_organization_lists";
//    [[HttpRequest shardWebUtil] postNetworkRequestURLString:url
//                                                 parameters:dict
//                                                    success:^(id obj) {
//                                                        
//                                                        int code;
//                                                        if ([[obj valueForKey:@"code"] isKindOfClass:[NSNumber class]]) {
//                                                            code = [[obj valueForKey:@"code"] intValue];
//                                                        }
//                                                        //状态码1成功
//                                                        if ([succeedCoder isEqualToString:[NSString stringWithFormat:@"%@",[obj valueForKey:@"code"]]]){
//                                                            NSArray *arr = [[obj valueForKey:@"result"] valueForKey:@"org_lists"];
//                                                            NSMutableArray *arrayM = [NSMutableArray array];
//                                                            for (int i = 0; i < arr.count; i ++) {
//                                                                NSDictionary *dict = arr[i];
//                                                                [arrayM addObject:[OrganizationModel OrgInfoWithDict:dict]];
//                                                                
//                                                            }
//                                                            self.orgListArr= arrayM;
//                                                        }else{
//                                                            //block失败
//                                                            [MBProgressHUD showError:@"获取机构列表失败"];
//                                                        }
//                                                        
//                                                    } fail:^(NSError *error) {
//                                                        self.orgListArr = nil;
//                                                        [MBProgressHUD showError:@"获取机构列表失败"];
//                                                    }];
//}


//设置为手机注册
-(void)setPhoneRegister{
    self.registertype = phoneRegist;
    self.bgImage.image = [UIImage imageNamed:@"zhucebg"];
    self.verifiImageIcon.image = [UIImage imageNamed:@"iphone"];
    [self.leftDownBtn setImage:[UIImage imageNamed:@"youxiangzhuce"] forState:UIControlStateNormal];
    [self.rightDownBtn setImage:[UIImage imageNamed:@"qitafangshi"] forState:UIControlStateNormal];
    self.distanceToTop.constant = 95;
    [self.verifiImageIcon setHidden:NO];
    [self.getVerifiCodeBtn setHidden:NO];
    [self.verifiCodeTextField setHidden:NO];
    [self.verifiCodeBgLine setHidden:NO];
    [self clearnTextfieldText];//清空输入框内容
}
//设置为邮箱注册
-(void)setMailRegister{
    self.registertype = mailRegist;
    self.bgImage.image = [UIImage imageNamed:@"youxiangbg"];
    self.verifiImageIcon.image = [UIImage imageNamed:@"youxingicon"];
    [self.leftDownBtn setImage:[UIImage imageNamed:@"shoujizhuce"] forState:UIControlStateNormal];
    [self.rightDownBtn setImage:[UIImage imageNamed:@"qitafangshi"] forState:UIControlStateNormal];
    self.distanceToTop.constant = 95;
    [self.verifiImageIcon setHidden:NO];
    [self.getVerifiCodeBtn setHidden:NO];
    [self.verifiCodeTextField setHidden:NO];
    [self.verifiCodeBgLine setHidden:NO];
    [self clearnTextfieldText];
}
//设置为其他注册
-(void)setOtherRegister{
    self.registertype = otherRegist;
    self.bgImage.image = [UIImage imageNamed:@"qitazhucebg"];
    [self.leftDownBtn setImage:[UIImage imageNamed:@"youxiangzhuce"] forState:UIControlStateNormal];
    [self.rightDownBtn setImage:[UIImage imageNamed:@"shoujizhuce"] forState:UIControlStateNormal];
    self.distanceToTop.constant = 140;
    [self.verifiImageIcon setHidden:YES];
    [self.getVerifiCodeBtn setHidden:YES];
    [self.verifiCodeTextField setHidden:YES];
    [self.verifiCodeBgLine setHidden:YES];
    [self clearnTextfieldText];
}

-(void)clearnTextfieldText{
    self.accentTextField.text = @"";
    self.passWordTextField.text = @"";
    self.verifiCodeTextField.text = @"";
}

/**
 *  通过枚举判断当前的注册类型发送验证码请求
 *
 *  @param type   枚举类型
 *  @param number 手机号码/邮箱号码
 */
-(void)getVerifi:(registerType)type
          number:(NSString *)number{
    switch (type) {
        case phoneRegist://手机
            //判断是否传入不匹配账号
            if ([SLJJudgementString checkTelNumber:self.accentTextField.text]) {
            }else{
                //格式不匹配
                [MBProgressHUD showText:@"手机号格式不正确"];
                return;
            }
            [self postGetVerifiRequest:@"phone" Number:number function:@"nb_phone_verify"];
            break;
        case mailRegist://邮箱
            //判断是否传入不匹配账号
            if ([SLJJudgementString validateEmail:self.accentTextField.text]) {
            }else{
                //没有
                [MBProgressHUD showText:@"邮箱格式不正确"];
                return;
            }
            [self postGetVerifiRequest:@"email" Number:number function:@"nb_email_verify"];
            break;
        case otherRegist://其他注册
            
            break;
            
        default:
            break;
    }
}
/**
 *  发送获取验证码网络请求
 *
 *  @param type     参数类型:手机/邮箱
 *  @param Number   手机号/邮箱号
 *  @param function url参数后边拼接的方法,手机或邮箱
 */
-(void)postGetVerifiRequest:(NSString *)type
                     Number:(NSString *)Number
                   function:(NSString *)function{
    
    NSString *token = [NSString md5WithString];
    NSDictionary *dict = @{
                           @"token":token,
                           type:Number,
                           @"type":@""
                           };
    [[HttpRequest shardWebUtil] postNetworkRequestURLString:[NSString stringWithFormat:@"http://cloud.musiccare.cn/Api/NbApi/%@",function]
                                                 parameters:dict
                                                    success:^(id obj) {
                                                        if ([succeedCoder isEqualToString:[NSString stringWithFormat:@"%@",[obj valueForKey:@"code"]]]) {
                                                            [MBProgressHUD showSuccess:@"发送成功"];
                                                            //发送成功后设置一下按钮
                                                            [self setVerifiBtn];
                                                            //开启定时器
                                                            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(daojishiGCD) userInfo:nil repeats:YES];
                                                        }else{
                                                            [MBProgressHUD showError:@"获取验证码失败"];
                                                        }
                                                    }
                                                       fail:^(NSError *error) {
                                                           [MBProgressHUD showSuccess:@"发送失败"];
                                                           
    }];
}
//获取验证码成功后设置验证码按钮
-(void)setVerifiBtn{
    [self.getVerifiCodeBtn setTitle:@"59" forState:UIControlStateNormal];//倒计时59开始
    [self.getVerifiCodeBtn setBackgroundColor:[UIColor clearColor]];//背景给透明
    self.getVerifiCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];//title字体大小
    self.getVerifiCodeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    [self.getVerifiCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//设置title在一般情况
    [self.getVerifiCodeBtn setBackgroundColor:[UIColor grayColor]];
    [self.getVerifiCodeBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];//背景图去掉
    self.getVerifiCodeBtn.userInteractionEnabled = NO;//禁用按钮
}
//验证码倒计时走完或者切换了其他注册或者注册成功恢复按钮点击ui
-(void)resumeVerifiBtn{
    [self.getVerifiCodeBtn setImage:[UIImage imageNamed:@"huoquyanzhengma"] forState:UIControlStateNormal];//恢复背景图
    self.getVerifiCodeBtn.userInteractionEnabled = YES;//恢复按钮点击
    [self.timer invalidate];//移除定时器
}
//获取验证码成功后的定时器方法
-(void)daojishiGCD{
    
    int time = [self.getVerifiCodeBtn.titleLabel.text intValue];//拿到当前的按钮title
    if (time == 0) {//时间走光
        [self resumeVerifiBtn];//恢复获取验证码按钮移除定时器
        return;
    }
    time--;//开始倒计时 --实现
    [self.getVerifiCodeBtn setTitle:[NSString stringWithFormat:@"%d",time] forState:UIControlStateNormal];//设置title
}


#pragma mark - textfield代理方法 -
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //监听输入框内容
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
