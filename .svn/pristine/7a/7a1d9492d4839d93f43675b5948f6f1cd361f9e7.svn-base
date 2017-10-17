//
//  MusicCell.m
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 16/3/16.
//  Copyright © 2016年 HanYouApp. All rights reserved.
//

#import "MusicCell.h"
#import "CellButton.h"

@implementation MusicCell

//加入患者列表按钮
- (IBAction)ShouCang:(CellButton *)sender {
    
//    if (sender.selected == NO) {
//        sender.selected = YES;
//        NSLog(@"加入患者列表");
//    }else{
//        sender.selected = NO;
//    }
//    
//    [self.delegate changeMusicName:self.MusicLabel.text button:sender];
}
//选择音乐按钮
- (IBAction)chooseMusic:(UIButton *)sender {
    
//    if (!self.chooseMusicbtn.selected) {
//        self.chooseMusicbtn.selected = YES;
//        [sender setImage:[UIImage imageNamed:@"xuanzhonghou"] forState:UIControlStateNormal];
        NSLog(@"选中了音乐");
        [self.delegate choosedMusic:(UIButton *)sender];
    
//    }else{
//        self.chooseMusicbtn.selected = NO;
//        [sender setImage:[UIImage imageNamed:@"weixuankuang"] forState:UIControlStateNormal];
//        NSLog(@"取消了选中音乐");
//        [self.delegate dismissMusic:(UIButton *)sender];
//    }
}


- (void)awakeFromNib {
    // Initialization code
    
//    self.chooseMusicbtn.selected = NO;
//    self.shoucangBtn.selected = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
