//
//  HYSettingSplitViewController.m
//  SuperGymForCoach
//
//  Created by hanyou on 7/23/15.
//  Copyright (c) 2015 HanYouApp. All rights reserved.
//

#import "HYSettingSplitViewController.h"
#import "HYSettingViewController.h"
#import "HYSettingDetailViewController.h"


@interface HYSettingSplitViewController ()<HYSettingVCDelegate>
@end

@implementation HYSettingSplitViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        HYSettingViewController *masterVC = [[HYSettingViewController alloc] init];
        masterVC.delegate = self;
        HYSettingDetailViewController *detailVC = [HYSettingDetailViewController new];
        
        detailVC.view.backgroundColor = [UIColor redColor];
        HYNav *nv = [[HYNav alloc] initWithRootViewController:detailVC];
        self.viewControllers = @[masterVC, nv];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)settingVC:(HYSettingViewController *)settingVC totle:(NSString *)title {
    HYSettingDetailViewController *detailVC = self.viewControllers.lastObject;
    detailVC.navigationController.navigationBar.barTintColor = [UIColor blackColor];

    kDebug(@"%@", title);
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
