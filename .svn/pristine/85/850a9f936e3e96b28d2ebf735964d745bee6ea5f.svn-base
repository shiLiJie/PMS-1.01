//
//  UserDetailCell.h
//  NewSuperGymForCoach
//
//  Created by slj on 2017/5/26.
//  Copyright © 2017年 HanYouApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserDettailDelegate <NSObject>
- (void)trainPhoneNum:(NSString *)str;
- (void)trainName:(NSString *)str;

- (void)trainONe:(NSString *)str;
- (void)trainTwo:(NSString *)str;
@end

@interface UserDetailCell : UITableViewCell<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *zhiliaochangsuo;
@property (weak, nonatomic) IBOutlet UILabel *zhiliaoshi;
@property (weak, nonatomic) IBOutlet UILabel *riqi;
@property (weak, nonatomic) IBOutlet UITextField *xingming;
@property (weak, nonatomic) IBOutlet UITextField *lianxifangshi;
@property (weak, nonatomic) IBOutlet UILabel *xingbie;
@property (weak, nonatomic) IBOutlet UILabel *nianling;
@property (weak, nonatomic) IBOutlet UILabel *zhiye;
@property (weak, nonatomic) IBOutlet UILabel *chushengdi;

@property (weak, nonatomic) IBOutlet UITextView *oneTextView;
@property (weak, nonatomic) IBOutlet UITextView *twoTextView;
@property(nonatomic, weak) id<UserDettailDelegate> delegate;

@end
