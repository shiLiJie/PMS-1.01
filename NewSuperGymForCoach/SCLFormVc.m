//
//  SCLFormVc.m
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 2017/6/5.
//  Copyright © 2017年 HanYouApp. All rights reserved.
//

#import "SCLFormVc.h"
#import "SCLFormModel.h"
#import "SCLCell.h"
#import "FMDB.h"
#import "UserObj.h"
#import "UserTool.h"

@interface SCLFormVc ()<UITableViewDelegate,UITableViewDataSource,SCLCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *sclTab;
@property (nonatomic, strong) SCLFormModel *model;

@property (nonatomic, strong) NSMutableArray *chooseArr;
@property (nonatomic, strong) NSMutableArray *scoreArr;
@property (nonatomic, strong) NSMutableDictionary *dict;
@end

@implementation SCLFormVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sclTab.delegate = self;
    self.sclTab.dataSource = self;
    
    self.model = [[SCLFormModel alloc] init];
}
//确定按钮
- (IBAction)commit:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self getScore];
}

#pragma mark - tableviewdelegate -
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.model SclQ].count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //三级级列表table
    static NSString *cellIdentifier = @"cell";
    SCLCell *cell         = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    NSArray *nib1         = [[NSBundle mainBundle]loadNibNamed:@"SCLCell" owner:nil options:nil];
    cell                  = [nib1 lastObject];
    cell.qusetionLab.text = [NSString stringWithFormat:@"%d.%@",indexPath.row+1,[self.model SclQ][indexPath.row]];
    cell.chooseOne.tag    = indexPath.row+1;
    cell.chooseTwo.tag    = indexPath.row+1;
    cell.chooseThree.tag  = indexPath.row+1;
    cell.chooseFour.tag   = indexPath.row+1;
    cell.chooseFive.tag   = indexPath.row+1;
    cell.delegate         = self;

    cell.selectionStyle   = UITableViewCellSelectionStyleNone;
    
    //记录第二组选择的状态
    NSString *index = [NSString stringWithFormat:@"%d",indexPath.row+1];
    if (self.dict != nil) {
        NSArray *arr = [self.dict allKeys];
        for (int i = 0; i <arr.count; i++) {
            if ([index isEqualToString:arr[i]]) {
                NSString *value = [self.dict valueForKey:index];
                if ([value isEqualToString:@"1"]) {
                    cell.chooseOne.selected = YES;
                }
                if ([value isEqualToString:@"2"]) {
                    cell.chooseTwo.selected = YES;
                }
                if ([value isEqualToString:@"3"]) {
                    cell.chooseThree.selected = YES;
                }
                if ([value isEqualToString:@"4"]) {
                    cell.chooseFour.selected = YES;
                }
                if ([value isEqualToString:@"5"]) {
                    cell.chooseFive.selected = YES;
                }
            }
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - cell代理 -
-(void)chooseOne:(UIButton *)btn{
    
    [self.dict setValue:@"1" forKey:[NSString stringWithFormat:@"%d",btn.tag]];
}
-(void)chooseTwo:(UIButton *)btn{
    
    [self.dict setValue:@"2" forKey:[NSString stringWithFormat:@"%d",btn.tag]];
}
-(void)chooseThree:(UIButton *)btn{
    
    [self.dict setValue:@"3" forKey:[NSString stringWithFormat:@"%d",btn.tag]];
}
-(void)chooseFour:(UIButton *)btn{
    
    [self.dict setValue:@"4" forKey:[NSString stringWithFormat:@"%d",btn.tag]];
}
-(void)chooseFive:(UIButton *)btn{
    
    [self.dict setValue:@"5" forKey:[NSString stringWithFormat:@"%d",btn.tag]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 私有方法 -
-(void)getScore{
    
    NSArray * allkeys = [self.dict allKeys];
    for (int i = 0; i < allkeys.count; i++)
    {
        NSInteger key = [[allkeys objectAtIndex:i] integerValue];
        if (key == 1 || key == 4 || key == 12 || key == 27 || key == 40 || key == 42 || key== 48 || key == 49 || key == 52 || key == 53 || key == 56 || key == 58 ) {
            NSString *obj  = [self.dict objectForKey:[NSString stringWithFormat:@"%d",key]];
            [self.model.f1 addObject:obj];
        }
        if (key == 3 || key == 9 || key == 10 || key == 28 || key == 38 || key == 45 || key == 46 || key == 51 || key == 55 || key == 65) {
            NSString *obj  = [self.dict objectForKey:[NSString stringWithFormat:@"%d",key]];
            [self.model.f2 addObject:obj];
        }
        if (key == 6 || key == 21 || key == 34 || key == 36 || key == 37 || key == 41 || key == 61 || key == 69 || key == 73) {
            NSString *obj  = [self.dict objectForKey:[NSString stringWithFormat:@"%d",key]];
            [self.model.f3 addObject:obj];
        }
        if (key == 5 || key == 14 || key == 15 || key == 20 || key == 22 || key == 26 || key == 29 || key == 30 || key == 31 || key == 32 || key == 54 || key == 72 || key == 79) {
            NSString *obj  = [self.dict objectForKey:[NSString stringWithFormat:@"%d",key]];
            [self.model.f4 addObject:obj];
        }
        if (key == 2 || key == 17 || key == 23 || key == 33 || key == 39 || key == 57 || key == 72 || key == 78 || key == 80 || key == 86) {
            NSString *obj  = [self.dict objectForKey:[NSString stringWithFormat:@"%d",key]];
            [self.model.f5 addObject:obj];
        }
        if (key == 11 || key == 24 || key == 63 || key == 67 || key == 74 || key == 81) {
            NSString *obj  = [self.dict objectForKey:[NSString stringWithFormat:@"%d",key]];
            [self.model.f6 addObject:obj];
        }
        if (key == 12 || key == 25 || key == 47 || key == 50 || key == 70 || key == 75 || key == 82) {
            NSString *obj  = [self.dict objectForKey:[NSString stringWithFormat:@"%d",key]];
            [self.model.f7 addObject:obj];
        }
        if (key == 8 || key == 18 || key == 43 || key == 68 || key == 76 || key == 83) {
            NSString *obj  = [self.dict objectForKey:[NSString stringWithFormat:@"%d",key]];
            [self.model.f8 addObject:obj];
        }
        if (key == 7 || key == 16 || key == 35 || key == 62 || key == 77 || key == 84 || key == 85 || key == 77 || key == 78 || key == 90) {
            NSString *obj  = [self.dict objectForKey:[NSString stringWithFormat:@"%d",key]];
            [self.model.f9 addObject:obj];
        }
        if (key == 19 || key == 44 || key == 59 || key == 60 || key == 64 || key == 66 || key == 89) {
            NSString *obj  = [self.dict objectForKey:[NSString stringWithFormat:@"%d",key]];
            [self.model.f10 addObject:obj];
        }
    }
    int f1 = 0;
    int f2 = 0;
    int f3 = 0;
    int f4 = 0;
    int f5 = 0;
    int f6 = 0;
    int f7 = 0;
    int f8 = 0;
    int f9 = 0;
    int f10 = 0;
    
    for (int i=0; i<self.model.f1.count; i++) {
        int score = [self.model.f1[i] intValue];
        f1 += score;
    }
    for (int i=0; i<self.model.f2.count; i++) {
        int score = [self.model.f2[i] intValue];
        f2 += score;
    }
    for (int i=0; i<self.model.f3.count; i++) {
        int score = [self.model.f3[i] intValue];
        f3 += score;
    }
    for (int i=0; i<self.model.f4.count; i++) {
        int score = [self.model.f4[i] intValue];
        f4 += score;
    }
    for (int i=0; i<self.model.f5.count; i++) {
        int score = [self.model.f5[i] intValue];
        f5 += score;
    }
    for (int i=0; i<self.model.f6.count; i++) {
        int score = [self.model.f6[i] intValue];
        f6 += score;
    }
    for (int i=0; i<self.model.f7.count; i++) {
        int score = [self.model.f7[i] intValue];
        f7 += score;
    }
    for (int i=0; i<self.model.f8.count; i++) {
        int score = [self.model.f8[i] intValue];
        f8 += score;
    }
    for (int i=0; i<self.model.f9.count; i++) {
        int score = [self.model.f9[i] intValue];
        f9 += score;
    }
    for (int i=0; i<self.model.f10.count; i++) {
        int score = [self.model.f10[i] intValue];
        f10 += score;
    }
    //总分
    int total = f1 +f2 +f3 +f4 +f5 +f6 +f7 +f8 +f9 +f10;
    //阳性项目数
    int yangCount = 0;
    int yangTotal = 0;
    for (int i = 0; i < allkeys.count; i++)
    {
        NSString *obj = [self.dict objectForKey:allkeys[i]];
        if (![obj isEqualToString:@"1"]) {
            yangTotal += [obj intValue];
            yangCount ++;
        }
    }
    if (allkeys.count == 0) {
        return;
    }
    //阳性症状均分
    int yangPingjun = yangTotal/yangCount;
    //因子分
    float one   = f1/12.0;
    float two   = f2/10.0;
    float three = f3/9.0;
    float four  = f4/13.0;
    float five  = f5/10.0;
    float six   = f6/6.0;
    float sev   = f7/7.0;
    float eig   = f8/6.0;
    float nine  = f9/10.0;
    float ten   = f10/7.0;
    
    NSString *zongfen = [NSString stringWithFormat:@"总分: %d",total];
    NSString *yangxingshu = [NSString stringWithFormat:@"阳性数: %d",yangCount];
    NSString *yangping = [NSString stringWithFormat:@"阳性症状均分: %d",yangPingjun];
    
    
    
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
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS SCLForm (uid TEXT NOT NULL, time TEXT NOT NULL, zongfen TEXT NOT NULL,yangxingshu TEXT NOT NULL,junfen TEXT NOT NULL);"];
        if (result) {
            NSLog(@"成功创表");
        } else {
            NSLog(@"创表失败");
        }
        [db close];
    }
    //插入数据
    UserObj *obj = [UserTool readTheUserModle];
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *DateTime = [formatter stringFromDate:date];
    
    if ([db open]) {
        NSString *insertSql1= [NSString stringWithFormat:@"INSERT INTO SCLForm (uid, time, zongfen,yangxingshu,junfen) VALUES ('%@', '%@','%@', '%@','%@')", obj.ID, DateTime, zongfen,yangxingshu,yangping];
        BOOL res = [db executeUpdate:insertSql1];
        
        if (res) {
            NSLog(@"数据插入表成功");
        } else {
            NSLog(@"数据插入表失败");
        }
        [db close];
    }
    
    
    NSArray *arr = @[zongfen,yangxingshu,yangping];
    [ICInfomationView initWithTitle:@"检测结果" message:@"" cancleButtonTitle:@"取消" OtherButtonsArray:arr clickAtIndex:^(NSInteger buttonIndex) {
        nil;
    }];
}


-(NSMutableArray *)chooseArr{
    if (!_chooseArr) {
        _chooseArr = [[NSMutableArray alloc] init];
    }
    return _chooseArr;
}
-(NSMutableArray *)scoreArr{
    if (!_scoreArr) {
        _scoreArr = [[NSMutableArray alloc] init];
    }
    return _scoreArr;
}
-(NSMutableDictionary *)dict{
    if (!_dict) {
        _dict = [[NSMutableDictionary alloc] init];
    }
    return _dict;
}

@end
