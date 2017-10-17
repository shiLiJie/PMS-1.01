//
//  NavigationController.m
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 2017/4/10.
//  Copyright © 2017年 HanYouApp. All rights reserved.
//

#import "NavigationController.h"
#import "DetailViewController.h"

@interface NavigationController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *navigationTable;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation NavigationController

-(void)viewWillAppear:(BOOL)animated{
    
    self.dataArr = [[NSMutableArray alloc] init];
    
    self.navigationTable.delegate = self;
    self.navigationTable.dataSource = self;
    
    NSString *pathDocuments=kDocument;
    NSArray *fileNameList=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathDocuments error:nil];
    NSMutableArray *arr = [fileNameList mutableCopy];
    if ([arr containsObject:@".DS_Store"]) {
        [arr removeObject:@".DS_Store"];
    }
    if ([arr containsObject:@"musicData"]) {
        [arr removeObject:@"musicData"];
    }
    self.dataArr = arr;
    
    [self.navigationTable reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArr = [[NSMutableArray alloc] init];
    
    self.navigationTable.delegate = self;
    self.navigationTable.dataSource = self;
    
    NSString *pathDocuments=kDocument;
    NSArray *fileNameList=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathDocuments error:nil];
    NSMutableArray *arr = [fileNameList mutableCopy];
    if ([arr containsObject:@".DS_Store"]) {
        [arr removeObject:@".DS_Store"];
    }
    self.dataArr = arr;
    
    
}

#pragma mark - tableviewdelegate -
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [NSString stringWithFormat:@"%d",indexPath.row];
    
    [SLJNotificationTools postNotification:str methodName:@"MUSICLISTINDEX"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
