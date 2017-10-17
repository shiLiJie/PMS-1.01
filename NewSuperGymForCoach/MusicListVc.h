//
//  MusicListVc.h
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 16/3/28.
//  Copyright © 2016年 HanYouApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicListVc : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) NSArray *musicarray;

+ (instancetype )shareSonglist;


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;


@end
