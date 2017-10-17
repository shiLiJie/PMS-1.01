//
//  UserDetailVcViewController.m
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 2017/5/27.
//  Copyright © 2017年 HanYouApp. All rights reserved.
//

#define DeviceHeight            [[UIScreen mainScreen] bounds].size.height
#define DeviceWidth             [[UIScreen mainScreen] bounds].size.width
#define Key_DistrictSelectProvince          @"DistrictSelectProvince"
#define Key_DistrictSelectProvinceCode      @"DistrictSelectProvinceCode"
#define Key_DistrictSelectProvinceSubCode   @"DistrictSelectProvinceSubCode"
#define Key_DistrictSelectProvinceSub       @"DistrictSelectProvinceSub"
#define Key_DistrictSelectCityCode          @"DistrictSelectCityCode"
#define Key_DistrictSelectCity              @"DistrictSelectCity"


#import "UserDetailVcViewController.h"
#import "UserDetailCell.h"
#import <ActionSheetDatePicker.h>
#import "GPDateView.h"
#import "ValuePickerView.h"

@interface UserDetailVcViewController ()<UITableViewDelegate,UITableViewDataSource,UserDettailDelegate>

@property (weak, nonatomic) IBOutlet UITableView *UserDetailTab;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *fenyeLab;

@property (nonatomic, strong) UserDetailCell *accountcell;
@property (nonatomic, strong) NSMutableArray * zhanghuArr;

@property (nonatomic, copy)  NSString *year;//年龄
@property (nonatomic, copy)  NSString *city;//城市
@property (nonatomic, copy)  NSString *sex;//性别
@property (nonatomic, copy)  NSString *job;//职业
@property (nonatomic, copy)  NSString *xingming;//姓名
@property (nonatomic, copy)  NSString *lianxifangshi;//联系方式
@property (nonatomic, copy)  NSString *one;//onetextView
@property (nonatomic, copy)  NSString *two;//twoTextView

@property (nonatomic, copy) NSString *dataString;//数据字符串

@end

@implementation UserDetailVcViewController

-(NSMutableArray *)zhanghuArr
{
    if (!_zhanghuArr) {
        [_zhanghuArr removeAllObjects];
        NSArray *tmp1 = [[NSBundle mainBundle] loadNibNamed:@"UserDetailCell" owner:nil options:nil];
        _zhanghuArr = [[NSMutableArray alloc] initWithArray:tmp1];
    }
    return _zhanghuArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    self.detailView.layer.cornerRadius = 9;
    
    self.detailView.layer.masksToBounds = YES;
    
    self.dataString = @"1";
    
    [self getData];//拿本地数据
    
    self.UserDetailTab.delegate = self;
    self.UserDetailTab.dataSource = self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<9) {
        return 50;
    }else{
        return 200;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.zhanghuArr.count;;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"Cell1";
    UserDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    
    if (cell == nil) {
        
        cell = [_zhanghuArr objectAtIndex:indexPath.row];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.zhiliaoshi.text = @"张明禄";
        cell.zhiliaochangsuo.text = @"凤凰八音音乐治疗室";
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
        NSString *DateTime = [formatter stringFromDate:date];
        cell.riqi.text = DateTime;
        
        [self preserveData:[self getherStr]];//先写本地数据
        [self getData];//拿本地数据
        
        if ([self.dataString isEqualToString:@"1"]) {

            cell.nianling.text   = self.year;
            cell.chushengdi.text = self.city;
            cell.zhiye.text      = self.job;
            cell.xingbie.text    = self.sex;
        }else{
            NSArray *array = [self.dataString componentsSeparatedByString:@","];

            cell.xingming.text      = [array[0] isEqualToString:@"(null)"] ? @"": array[0];
            cell.lianxifangshi.text = [array[1] isEqualToString:@"(null)"] ? @"": array[1];
            cell.xingbie.text       = [array[2] isEqualToString:@"(null)"] ? @"": array[2];
            cell.nianling.text      = [array[3] isEqualToString:@"(null)"] ? @"": array[3];
            cell.zhiye.text         = [array[4] isEqualToString:@"(null)"] ? @"": array[4];
            cell.chushengdi.text    = [array[5] isEqualToString:@"(null)"] ? @"": array[5];
            cell.oneTextView.text   = [array[6] isEqualToString:@"(null)"] ? @"": array[6];
            cell.twoTextView.text   = [array[7] isEqualToString:@"(null)"] ? @"": array[7];
        }
        
        
        
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //年龄
    if (indexPath.row == 6) {
        NSString *birth = [NSString stringWithFormat:@"%zd-01-01", [self yearOfDate:[NSDate date]]];
        NSDate *birthday = [NSDate dateFromString:birth
                                       withFormat:@"yyyy-MM-dd"];
        [ActionSheetDatePicker showPickerWithTitle:kLocal(@"生日")
                                    datePickerMode:UIDatePickerModeDate
                                      selectedDate:birthday
                                       minimumDate:[NSDate dateFromString:@"1900-01-01"]
                                       maximumDate:[NSDate date]
                                         doneBlock:^(ActionSheetDatePicker *picker, NSDate *selectedDate, id origin) {
                                             
                                             
                                             NSDateFormatter *df = [[NSDateFormatter alloc] init];
                                             [df setDateFormat:@"yyyy-MM-dd"];
                                             NSString *currentDateString = [df stringFromDate:selectedDate];
                                             NSArray *arr = [currentDateString componentsSeparatedByString:@"-"];
                                             NSString *year = [NSString stringWithFormat:@"%d",2017-[arr[0] integerValue]];
                                             
                                             self.year = [NSString stringWithFormat:@"%@ 岁",year];
                                             //存数据
                                             [self preserveData:[self getherStr]];
                                             [self.UserDetailTab reloadData];
                                             
                                             
                                             
                                             
                                             
                                             
                                         } cancelBlock:^(ActionSheetDatePicker *picker) {
                                             //
                                         } origin:tableView];
    }
    //出生地
    if (indexPath.row == 8) {
        GPDateView * dateView = [[GPDateView alloc] initWithFrame:CGRectMake(10, DeviceHeight-320, 340, 250) Data:nil];
        
        [dateView showPickerView];
        
        dateView.ActionDistrictViewSelectBlock = ^(NSString *desStr,NSDictionary *selectDistrictDict){
            
            self.city = [NSString stringWithFormat:@"%@-%@-%@",[selectDistrictDict objectForKey:Key_DistrictSelectProvince],[selectDistrictDict objectForKey:Key_DistrictSelectCity],[selectDistrictDict objectForKey:Key_DistrictSelectProvinceSub]];
            //存数据
            [self preserveData:[self getherStr]];
            [self.UserDetailTab reloadData];
            
        };
    }
    //性别
    if (indexPath.row == 5) {
        ValuePickerView *pickerView = [[ValuePickerView alloc] init];
        pickerView.dataSource =@[@"男",@"女"];
        pickerView.pickerTitle = @"性别";
        
        pickerView.valueDidSelect = ^(NSString *value){
            NSArray * stateArr = [value componentsSeparatedByString:@"/"];
            
            self.sex = stateArr[0];
            //存数据
            [self preserveData:[self getherStr]];
            [self.UserDetailTab reloadData];
            
        };
        
        [pickerView show];
    }
    //职业
    if (indexPath.row == 7) {
        ValuePickerView *pickerView = [[ValuePickerView alloc] init];
        pickerView.dataSource =@[@"农牧渔林业", @"采矿业", @"交通运输业", @"餐饮旅游业", @"建筑工程", @"制造加工维修业", @"出版广告业",@"医疗卫生保健",@"娱乐业",@"文教机构",@"一般买卖（批发零售业)",@"服务业",@"公检法等检察机关",@"军人",@"IT行业",@"运动员",@"宗教机构",@"家政服务业"];
        pickerView.pickerTitle = @"职业";
        
        pickerView.valueDidSelect = ^(NSString *value){
            NSArray * stateArr = [value componentsSeparatedByString:@"/"];
            
            self.job = stateArr[0];
            //存数据
            [self preserveData:[self getherStr]];
            [self.UserDetailTab reloadData];

        };
        
        [pickerView show];
    }
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat bottomOffset = scrollView.contentSize.height - contentOffsetY;
    if (bottomOffset <= height)
    {
        //在最底部
        self.fenyeLab.text = @"2/2";
    }
    else
    {
        self.fenyeLab.text = @"1/2";
    }
}



- (NSInteger)yearOfDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    dateComps = [calendar components:NSYearCalendarUnit fromDate:date];
    return dateComps.year;
}

#pragma mark - cell代理方法传值 -
- (void)trainName:(NSString *)str{
    self.xingming = str;
    //存数据
    [self preserveData:[self getherStr]];
    [self.UserDetailTab reloadData];
}

- (void)trainPhoneNum:(NSString *)str{

    self.lianxifangshi = str;
    //存数据
    [self preserveData:[self getherStr]];
    [self.UserDetailTab reloadData];
}

- (void)trainONe:(NSString *)str{
    self.one = str;
    //存数据
    [self preserveData:[self getherStr]];
    [self.UserDetailTab reloadData];
}
- (void)trainTwo:(NSString *)str{
    self.two = str;
    //存数据
    [self preserveData:[self getherStr]];
    [self.UserDetailTab reloadData];
    
}

-(void)preserveData:(NSString *) str{
    //获取主路径
    NSString *pathDocuments=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *createPath=[NSString stringWithFormat:@"%@/user/%@",pathDocuments,[UserTool readTheUserModle].ID];
    //检查是否存在
    if(![[NSFileManager defaultManager] fileExistsAtPath:createPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    };
    //主路径拼接命名
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.txt", createPath,[UserTool readTheUserModle].ID];
    //检查是否存在
    if(![[NSFileManager defaultManager] fileExistsAtPath:fileName])
        [[NSFileManager defaultManager] createFileAtPath:fileName contents:nil attributes:nil];
    NSFileHandle *logFile = [NSFileHandle fileHandleForWritingAtPath:fileName];
    [logFile seekToEndOfFile];
    
    [str writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}

-(NSString *)getherStr{
    NSString *str = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@",self.xingming,self.lianxifangshi,self.sex,self.year,self.job,self.city,self.one,self.two];
    
    return str;
}

-(void)getData{
    
    //获取主路径
    NSString *pathDocuments=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *createPath=[NSString stringWithFormat:@"%@/user/%@",pathDocuments,[UserTool readTheUserModle].ID];
    
    //主路径拼接命名
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.txt", createPath,[UserTool readTheUserModle].ID];
    //检查是否存在
    if(![[NSFileManager defaultManager] fileExistsAtPath:fileName]){
        return;
    };
    
    NSData *data = [NSData dataWithContentsOfFile:fileName];
    NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    self.dataString = result;
    
    NSArray *array = [self.dataString componentsSeparatedByString:@","];
    
    self.xingming      = array[0];
    self.lianxifangshi = array[1];
    self.sex           = array[2];
    self.year          = array[3];
    self.job           = array[4];
    self.city          = array[5];
    self.one           = array[6];
    self.two           = array[7];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
