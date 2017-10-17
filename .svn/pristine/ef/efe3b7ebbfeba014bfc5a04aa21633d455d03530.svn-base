//
//  MusicListVc.m
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 16/3/28.
//  Copyright © 2016年 HanYouApp. All rights reserved.
//

#import "MusicListVc.h"

static MusicListVc *stataicSelf = nil;


@interface MusicListVc ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation MusicListVc

+ (instancetype )shareSonglist{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stataicSelf = [[MusicListVc alloc] initWithNibName:@"MusicListVc" bundle:nil];

    });
    return stataicSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    self.musicarray = [[NSArray alloc]init];
}


#pragma mark - tableview delegate

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.musicarray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = self.musicarray[indexPath.row];

    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
