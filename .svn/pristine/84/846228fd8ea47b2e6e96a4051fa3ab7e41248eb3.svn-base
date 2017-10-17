//
//  XihaoVc.m
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 2017/6/12.
//  Copyright © 2017年 HanYouApp. All rights reserved.
//

#import "XihaoVc.h"
#import "XihaoCell.h"
#import "FMDB.h"
#import "UserObj.h"
#import "UserTool.h"

@interface XihaoVc ()<UITableViewDataSource,UITableViewDelegate,XihaoCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *xihaoTable;
@property (nonatomic, strong) NSMutableArray *cellArr;

@property (nonatomic, strong) XihaoCell *cell;

@property (nonatomic, assign) int count;

@end

@implementation XihaoVc

-(NSMutableArray *)cellArr{
    if (!_cellArr) {
        [_cellArr removeAllObjects];
        NSArray *tmp1 = [[NSBundle mainBundle] loadNibNamed:@"XihaoCell" owner:nil options:nil];
        _cellArr = [[NSMutableArray alloc] initWithArray:tmp1];
    }
    return _cellArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.count = 0;
    
    self.xihaoTable.delegate = self;
    self.xihaoTable.dataSource = self;
    
    [SLJNotificationTools addaddObserver:self selector:@selector(reciveData:) methodName:@"RECIVEDATA666"];
}
- (IBAction)sureBtnClick:(UIButton *)sender {
    [SLJNotificationTools postNotification:nil methodName:@"PASSDATA666"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//提交后得到选择的答案字典
-(void)reciveData:(NSNotification *)no{
    self.count ++;
    if (self.count == 1) {
        
        
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
            BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS XiHaoForm (uid TEXT NOT NULL, time TEXT NOT NULL, score TEXT NOT NULL);"];
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
            NSString *insertSql1= [NSString stringWithFormat:@"INSERT INTO XiHaoForm (uid, time, score) VALUES ('%@', '%@','%@')", obj.ID, DateTime, no.object];
            BOOL res = [db executeUpdate:insertSql1];
            
            if (res) {
                NSLog(@"数据插入表成功");
            } else {
                NSLog(@"数据插入表失败");
            }
            [db close];
        }
        
        
    }else{
        return;
    }
    
}

#pragma mark - tableviewdelegate -

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        return 150;
    }
    if (indexPath.row == 4) {
        return 110;
    }
    if (indexPath.row == 5) {
        return 110;
    }
    if (indexPath.row == 6) {
        return 110;
    }
    if (indexPath.row == 8) {
        return 110;
    }

    if (indexPath.row == 9) {
        return 230;
    }
    return 75;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell1";
    self.cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (self.cell == nil) {
        self.cell = [self.cellArr objectAtIndex:indexPath.row];
    }
    self.cell.delegate = self;
    
    self.cell.selectionStyle   = UITableViewCellSelectionStyleNone;
    return self.cell;
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
