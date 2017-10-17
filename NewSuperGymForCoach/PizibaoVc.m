//
//  PizibaoVc.m
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 2017/6/7.
//  Copyright © 2017年 HanYouApp. All rights reserved.
//

#import "PizibaoVc.h"
#import "PizibaoCell.h"
#import "PizibaoCell2.h"
#import "FMDB.h"
#import "UserObj.h"
#import "UserTool.h"

@interface PizibaoVc ()<UITableViewDataSource,UITableViewDelegate,PizibaoCellDelegate,PizibaoCellDelegate2>

@property (weak, nonatomic) IBOutlet UITableView *PizibaoTab;
@property (nonatomic, strong) NSMutableArray *cellArr;
@property (nonatomic, strong) NSArray *questionArr;

@property (nonatomic, strong) NSMutableDictionary *twoDic;
@end

@implementation PizibaoVc

-(NSMutableArray *)cellArr{
    if (!_cellArr) {
        [_cellArr removeAllObjects];
        NSArray *tmp1 = [[NSBundle mainBundle] loadNibNamed:@"PizibaoCell" owner:nil options:nil];
        _cellArr = [[NSMutableArray alloc] initWithArray:tmp1];
    }
    return _cellArr;
}

- (IBAction)sureBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self getSocre];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.PizibaoTab.delegate = self;
    self.PizibaoTab.dataSource = self;
    
    self.twoDic = [[NSMutableDictionary alloc] init];
    
    self.questionArr = @[@"a. 入睡困难(30分钟内不能入睡)",@"b. 夜间易醒或早醒",@"c. 夜间去厕所",@"d. 呼吸不畅 ",@"e. 咳嗽或鼾声高",@"f. 感觉冷",@"g. 感觉热",@"h. 做恶梦",@"i. 疼痛不适",@"j. 其它影响睡眠的事情"];
}

#pragma mark - tableviewdelegate -
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"下面一些问题是关于您最近1个月的睡眠情况，请选择回填写最符合您近1个月实际情况的答案。请回答下列问题：";
    }
    else if (section == 1){
        return @"对下列问题请选择1个最适合您的答案。";
    }else{
        return @"如有，请说明：";
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    else if (section == 1){
        return 10;
    }else{
        return 4;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell1";
    PizibaoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    
    static NSString *identifier1 = @"Cell11";
    PizibaoCell2 *cell1 = [tableView dequeueReusableCellWithIdentifier:identifier1];
    

    //三级级列表table
    if (indexPath.section == 0) {
        if (cell == nil) {
            
            cell = [self.cellArr objectAtIndex:indexPath.row];
            cell.delegate = self;
        }
    }
    if (indexPath.section == 1) {
        if (cell1 == nil) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"PizibaoCell2" owner:nil options:nil];
            cell1 = [nib lastObject];
            cell1.delegate = self;
            cell1.oneBtn.tag   = indexPath.row;
            cell1.towBtn.tag   = indexPath.row;
            cell1.threeBtn.tag = indexPath.row;
            cell1.fourBtn.tag  = indexPath.row;
            cell1.questionLab.text = self.questionArr[indexPath.row];
            
            //记录第二组选择的状态
            NSString *index = [NSString stringWithFormat:@"%d",indexPath.row+1];
            if (self.twoDic != nil) {
                NSArray *arr = [self.twoDic allKeys];
                for (int i = 0; i <arr.count; i++) {
                    if ([index isEqualToString:arr[i]]) {
                        NSString *value = [self.twoDic valueForKey:index];
                        if ([value isEqualToString:@"1"]) {
                            cell1.oneBtn.selected = YES;
                        }
                        if ([value isEqualToString:@"2"]) {
                            cell1.towBtn.selected = YES;
                        }
                        if ([value isEqualToString:@"3"]) {
                            cell1.threeBtn.selected = YES;
                        }
                        if ([value isEqualToString:@"4"]) {
                            cell1.fourBtn.selected = YES;
                        }
                    }
                }
            }
        }
        return cell1;
    }
    if (indexPath.section == 2) {
        if (cell == nil) {
            cell = [self.cellArr objectAtIndex:indexPath.row+15];
            cell.delegate = self;
        }
        
    }
    cell.selectionStyle   = UITableViewCellSelectionStyleNone;
    
    return cell;
}

//第一组代理
-(void)editText1:(UITextField *)textfield str:(NSString *)str{
    [self.twoDic setValue:str forKey:@"01"];
}
-(void)editText2:(UITextField *)textfield str:(NSString *)str{
    [self.twoDic setValue:str forKey:@"02"];
}
-(void)editText3:(UITextField *)textfield str:(NSString *)str{
    [self.twoDic setValue:str forKey:@"03"];
}
-(void)editText4:(UITextField *)textfield str:(NSString *)str{
    [self.twoDic setValue:str forKey:@"04"];
}


//第二组代理
-(void)chooseone2:(UIButton *)btn{
    NSLog(@"%d题--1分",btn.tag+1);
    [self.twoDic setValue:@"1" forKey:[NSString stringWithFormat:@"%d",btn.tag+1]];
}
-(void)choosetwo2:(UIButton *)btn{
    NSLog(@"%d题--2分",btn.tag+1);
    [self.twoDic setValue:@"2" forKey:[NSString stringWithFormat:@"%d",btn.tag+1]];
}
-(void)choosethree2:(UIButton *)btn{
    NSLog(@"%d题--3分",btn.tag+1);
    [self.twoDic setValue:@"3" forKey:[NSString stringWithFormat:@"%d",btn.tag+1]];
}
-(void)choosefour2:(UIButton *)btn{
    NSLog(@"%d题--4分",btn.tag+1);
    [self.twoDic setValue:@"4" forKey:[NSString stringWithFormat:@"%d",btn.tag+1]];
    
}
//第三组代理
-(void)chooseOne1:(UIButton *)btn{
    [self.twoDic setValue:@"1" forKey:@"11"];}
-(void)chooseOne2:(UIButton *)btn{
    [self.twoDic setValue:@"2" forKey:@"11"];}
-(void)chooseOne3:(UIButton *)btn{
    [self.twoDic setValue:@"3" forKey:@"11"];}
-(void)chooseOne4:(UIButton *)btn{
    [self.twoDic setValue:@"4" forKey:@"11"];}

-(void)chooseTwo1:(UIButton *)btn{
    [self.twoDic setValue:@"1" forKey:@"12"];}
-(void)chooseTwo2:(UIButton *)btn{
    [self.twoDic setValue:@"2" forKey:@"12"];}
-(void)chooseTwo3:(UIButton *)btn{
    [self.twoDic setValue:@"3" forKey:@"12"];}
-(void)chooseTwo4:(UIButton *)btn{
    [self.twoDic setValue:@"4" forKey:@"12"];}

-(void)chooseThree1:(UIButton *)btn{
    [self.twoDic setValue:@"1" forKey:@"13"];}
-(void)chooseThree2:(UIButton *)btn{
    [self.twoDic setValue:@"2" forKey:@"13"];}
-(void)chooseThree3:(UIButton *)btn{
    [self.twoDic setValue:@"3" forKey:@"13"];}
-(void)chooseThree4:(UIButton *)btn{
    [self.twoDic setValue:@"4" forKey:@"13"];}

-(void)chooseFour1:(UIButton *)btn{
    [self.twoDic setValue:@"1" forKey:@"14"];}
-(void)chooseFour2:(UIButton *)btn{
    [self.twoDic setValue:@"2" forKey:@"14"];}
-(void)chooseFour3:(UIButton *)btn{
    [self.twoDic setValue:@"3" forKey:@"14"];}
-(void)chooseFour4:(UIButton *)btn{
    [self.twoDic setValue:@"4" forKey:@"14"];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getSocre{
    
    NSArray *allKeys = [self.twoDic allKeys];
    //睡眠质量
    int a = 0;
    //入睡时间
    int b = 0;
    //睡眠时间
    int c = 0;
    //睡眠效率
    int d = 0;
    //睡眠障碍
    int e = 0;
    //催眠药物
    int f = 0;
    //日间功能障碍
    int g = 0;
    
    
    int bbb = 0;
    int bbbb = 0;
    int cc = 0;
    int dd = 0;
    int ddd = 0;
    int eb = 0;
    int ec = 0;
    int ed = 0;
    int ee = 0;
    int ef = 0;
    int eg = 0;
    int eh = 0;
    int ei = 0;
    int ej = 0;
    int gg = 0;
    int ggg = 0;
    
    
    for (int i = 0; i<allKeys.count; i++) {
        //不用动
        if ([allKeys[i] isEqualToString:@"11"]) {
            NSString *obj = [self.twoDic objectForKey:allKeys[i]];
            if ([obj isEqualToString:@"1"] || [obj isEqualToString:@"2"]) {
                a = 1;
            }
            if ([obj isEqualToString:@"3"]) {
                a = 2;
            }
            if ([obj isEqualToString:@"4"]) {
                a = 3;
            }
        }
        
        
        if ([allKeys[i] isEqualToString:@"02"]) {
            NSString *obj = [self.twoDic objectForKey:allKeys[i]];
            int bb = [obj intValue];
            if (bb<=15) {
                bbb = 0;
            }
            if (16<=bb && bb<=30) {
                bbb = 1;
            }
            if (31<=bb && bb<=60) {
                bbb = 2;
            }
            if (bb>60) {
                bbb = 3;
            }
            
        }

        if ([allKeys[i] isEqualToString:@"1"]) {
            NSString *obj = [self.twoDic objectForKey:allKeys[i]];
            if ([obj isEqualToString:@"1"]) {
                bbbb = 0;
            }
            if ([obj isEqualToString:@"2"]) {
                bbbb = 1;
            }
            if ([obj isEqualToString:@"3"]) {
                bbbb = 2;
            }
            if ([obj isEqualToString:@"4"]) {
                bbbb = 3;
            }
        }
        
        
        
        if ([allKeys[i] isEqualToString:@"04"]) {
            NSString *obj = [self.twoDic objectForKey:allKeys[i]];
            cc = [obj intValue];
            if (cc>=7) {
                c = 0;
            }
            if (cc == 6) {
                c = 1;
            }
            if (cc == 5) {
                c = 2;
            }
            if (cc < 5) {
                c = 3;
            }
            
        }
        

        if ([allKeys[i] isEqualToString:@"01"]) {
            NSString *obj = [self.twoDic objectForKey:allKeys[i]];
            dd = [obj intValue];
        }
        if ([allKeys[i] isEqualToString:@"03"]) {
            NSString *obj = [self.twoDic objectForKey:allKeys[i]];
            ddd = [obj intValue];
        }

        
        
        
        if ([allKeys[i] isEqualToString:@"2"]) {
            NSString *obj = [self.twoDic objectForKey:allKeys[i]];
            if ([obj isEqualToString:@"1"]) {
                eb = 0;
            }
            if ([obj isEqualToString:@"2"]) {
                eb = 1;
            }
            if ([obj isEqualToString:@"3"]) {
                eb = 2;
            }
            if ([obj isEqualToString:@"4"]) {
                eb = 3;
            }
        }

        if ([allKeys[i] isEqualToString:@"3"]) {
            NSString *obj = [self.twoDic objectForKey:allKeys[i]];
            if ([obj isEqualToString:@"1"]) {
                ec = 0;
            }
            if ([obj isEqualToString:@"2"]) {
                ec = 1;
            }
            if ([obj isEqualToString:@"3"]) {
                ec = 2;
            }
            if ([obj isEqualToString:@"4"]) {
                ec = 3;
            }
        }

        if ([allKeys[i] isEqualToString:@"4"]) {
            NSString *obj = [self.twoDic objectForKey:allKeys[i]];
            if ([obj isEqualToString:@"1"]) {
                ed = 0;
            }
            if ([obj isEqualToString:@"2"]) {
                ed = 1;
            }
            if ([obj isEqualToString:@"3"]) {
                ed = 2;
            }
            if ([obj isEqualToString:@"4"]) {
                ed = 3;
            }
        }

        if ([allKeys[i] isEqualToString:@"5"]) {
            NSString *obj = [self.twoDic objectForKey:allKeys[i]];
            if ([obj isEqualToString:@"1"]) {
                ee = 0;
            }
            if ([obj isEqualToString:@"2"]) {
                ee = 1;
            }
            if ([obj isEqualToString:@"3"]) {
                ee = 2;
            }
            if ([obj isEqualToString:@"4"]) {
                ee = 3;
            }
        }

        if ([allKeys[i] isEqualToString:@"6"]) {
            NSString *obj = [self.twoDic objectForKey:allKeys[i]];
            if ([obj isEqualToString:@"1"]) {
                ef = 0;
            }
            if ([obj isEqualToString:@"2"]) {
                ef = 1;
            }
            if ([obj isEqualToString:@"3"]) {
                ef = 2;
            }
            if ([obj isEqualToString:@"4"]) {
                ef = 3;
            }
        }

        if ([allKeys[i] isEqualToString:@"7"]) {
            NSString *obj = [self.twoDic objectForKey:allKeys[i]];
            if ([obj isEqualToString:@"1"]) {
                eg = 0;
            }
            if ([obj isEqualToString:@"2"]) {
                eg = 1;
            }
            if ([obj isEqualToString:@"3"]) {
                eg = 2;
            }
            if ([obj isEqualToString:@"4"]) {
                eg = 3;
            }
        }

        if ([allKeys[i] isEqualToString:@"8"]) {
            NSString *obj = [self.twoDic objectForKey:allKeys[i]];
            if ([obj isEqualToString:@"1"]) {
                eh = 0;
            }
            if ([obj isEqualToString:@"2"]) {
                eh = 1;
            }
            if ([obj isEqualToString:@"3"]) {
                eh = 2;
            }
            if ([obj isEqualToString:@"4"]) {
                eh = 3;
            }
        }

        if ([allKeys[i] isEqualToString:@"9"]) {
            NSString *obj = [self.twoDic objectForKey:allKeys[i]];
            if ([obj isEqualToString:@"1"]) {
                ei = 0;
            }
            if ([obj isEqualToString:@"2"]) {
                ei = 1;
            }
            if ([obj isEqualToString:@"3"]) {
                ei = 2;
            }
            if ([obj isEqualToString:@"4"]) {
                ei = 3;
            }
        }

        if ([allKeys[i] isEqualToString:@"10"]) {
            NSString *obj = [self.twoDic objectForKey:allKeys[i]];
            if ([obj isEqualToString:@"1"]) {
                ej = 0;
            }
            if ([obj isEqualToString:@"2"]) {
                ej = 1;
            }
            if ([obj isEqualToString:@"3"]) {
                ej = 2;
            }
            if ([obj isEqualToString:@"4"]) {
                ej = 3;
            }
        }
        
        
        
        //不用动
        if ([allKeys[i] isEqualToString:@"11"]) {
            NSString *obj = [self.twoDic objectForKey:allKeys[i]];
            if ([obj isEqualToString:@"1"] || [obj isEqualToString:@"2"]) {
                f = 1;
            }
            if ([obj isEqualToString:@"3"]) {
                f = 2;
            }
            if ([obj isEqualToString:@"4"]) {
                f = 3;
            }
        }
        

        if ([allKeys[i] isEqualToString:@"12"]) {
            NSString *obj = [self.twoDic objectForKey:allKeys[i]];
            if ([obj isEqualToString:@"1"] || [obj isEqualToString:@"2"]) {
                gg = 1;
            }
            if ([obj isEqualToString:@"3"]) {
                gg = 2;
            }
            if ([obj isEqualToString:@"4"]) {
                gg = 3;
            }
        }
        
        if ([allKeys[i] isEqualToString:@"13"]) {
            NSString *obj = [self.twoDic objectForKey:allKeys[i]];
            if ([obj isEqualToString:@"1"] || [obj isEqualToString:@"2"]) {
                ggg = 1;
            }
            if ([obj isEqualToString:@"3"]) {
                ggg = 2;
            }
            if ([obj isEqualToString:@"4"]) {
                ggg = 3;
            }
        }
    }
    
    if (bbb + bbbb == 0) {
        b=0;
    }
    if (bbb + bbbb == 1 || bbb + bbbb == 2) {
        b=1;
    }
    if (bbb + bbbb == 3 || bbb + bbbb == 4) {
        b=2;
    }
    if (bbb + bbbb == 5 || bbb + bbbb == 6) {
        b=3;
    }
    
    
    int  dddd = 12-dd+ddd;
    float ddddd = cc *100 / dddd;
    if (ddddd>85) {
        d = 0;
    }
    if (ddddd>75 && ddddd<84) {
        d = 1;
    }
    if (ddddd>65 && ddddd<74) {
        d = 2;
    }
    if (ddddd<65) {
        d = 3;
    }
    
    
    int eee = eb+ec+ed+ee+ef+eg+eh+ei+ej;
    if (eee==0) {
        e = 0;
    }
    if (eee>=1 && eee<=9) {
        e = 1;
    }
    if (eee>=10 && eee<=18) {
        e = 2;
    }
    if (eee>=19 && eee<=27) {
        e = 3;
    }
    
    
    int gggg = gg + ggg;
    if (gggg == 0) {
        g = 0;
    }
    if (gggg == 1 || gggg == 2) {
        g = 1;
    }
    if (gggg == 3 || gggg == 4) {
        g = 2;
    }
    if (gggg == 5 || gggg == 6) {
        g = 3;
    }
    
    NSString *mas;
    int total = a+b+c+d+e+f+g;
    if (total>=0 && total<=5) {
        mas = @"睡眠质量很好";
    }
    if (total>=6 && total<=10) {
        mas = @"睡眠质量还行";
    }
    if (total>=11 && total<=15) {
        mas = @"睡眠质量一般";
    }
    if (total>=16 && total<=21) {
        mas = @"睡眠质量很差";
    }
    
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
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS PiZiBao (uid TEXT NOT NULL, time TEXT NOT NULL, reuslt TEXT NOT NULL);"];
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
        NSString *insertSql1= [NSString stringWithFormat:@"INSERT INTO PiZiBao (uid, time, reuslt) VALUES ('%@', '%@','%@')", obj.ID, DateTime, mas];
        BOOL res = [db executeUpdate:insertSql1];
        
        if (res) {
            NSLog(@"数据插入表成功");
        } else {
            NSLog(@"数据插入表失败");
        }
        [db close];
    }
    
    NSArray *arr = @[mas];
    [ICInfomationView initWithTitle:@"检测结果" message:@"" cancleButtonTitle:@"取消" OtherButtonsArray:arr clickAtIndex:^(NSInteger buttonIndex) {
        nil;
    }];

}



@end
