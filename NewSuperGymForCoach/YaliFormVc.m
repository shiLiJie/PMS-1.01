//
//  YaliFormVc.m
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 2017/6/6.
//  Copyright © 2017年 HanYouApp. All rights reserved.
//

#import "YaliFormVc.h"
#import "YaliCell.h"
#import "YaliFormModel.h"
#import "FMDB.h"
#import "UserObj.h"
#import "UserTool.h"

@interface YaliFormVc ()<UITableViewDelegate,UITableViewDataSource,YaliCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *quseTab;
@property (nonatomic, strong) YaliFormModel *YaliModel;
@property (nonatomic, strong) NSMutableDictionary *dict;

@end

@implementation YaliFormVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.quseTab.delegate = self;
    self.quseTab.dataSource = self;
    
    self.YaliModel = [[YaliFormModel alloc] init];
}
- (IBAction)sureBtn:(UIButton *)sender {
    
    [self getSocre];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - tableviewdelegate -
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.YaliModel YaliQ].count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //三级级列表table
    static NSString *cellIdentifier = @"cell";
    YaliCell *cell         = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *nib1         = [[NSBundle mainBundle]loadNibNamed:@"YaliCell" owner:nil options:nil];
    cell                  = [nib1 lastObject];
    cell.questionLab.text = [NSString stringWithFormat:@"%d.%@",indexPath.row+1,[self.YaliModel YaliQ][indexPath.row]];
    cell.SureBtn.tag    = indexPath.row+1;

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
                    cell.SureBtn.selected = YES;
                }
            }
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)choose:(UIButton *)btn{
    
    [self.dict setValue:@"1" forKey:[NSString stringWithFormat:@"%d",btn.tag]];
    
}
-(void)dischoose:(UIButton *)btn{
    [self.dict removeObjectForKey:[NSString stringWithFormat:@"%d",btn.tag]];
}

-(NSMutableDictionary *)dict{
    if (!_dict) {
        _dict = [[NSMutableDictionary alloc] init];
    }
    return _dict;
}

-(void)getSocre{
    
    int total = 0;
    NSArray * allkeys = [self.dict allKeys];
    for (int i = 0; i < allkeys.count; i++)
    {
        NSString * key = [allkeys objectAtIndex:i];
        
        int obj  = [[self.dict objectForKey:key] intValue];
        total += obj;
    }
    NSString *tot = [NSString stringWithFormat:@"本次得分: %d",total];
    NSArray *arr = @[tot];
    [ICInfomationView initWithTitle:@"检测结果" message:@"" cancleButtonTitle:@"取消" OtherButtonsArray:arr clickAtIndex:^(NSInteger buttonIndex) {
        nil;
    }];
    
    
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
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS YaLiForm (uid TEXT NOT NULL, time TEXT NOT NULL, socre TEXT NOT NULL);"];
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
        NSString *insertSql1= [NSString stringWithFormat:@"INSERT INTO YaLiForm (uid, time, socre) VALUES ('%@', '%@','%@')", obj.ID, DateTime, tot];
        BOOL res = [db executeUpdate:insertSql1];
        
        if (res) {
            NSLog(@"数据插入表成功");
        } else {
            NSLog(@"数据插入表失败");
        }
        [db close];
    }
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
