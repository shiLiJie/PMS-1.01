//
//  AddGroupClassView.m
//  NewSuperGymForCoach
//
//  Created by liliang on 15/9/6.
//  Copyright (c) 2015年 HanYouApp. All rights reserved.
//

#import "AddGroupClassView.h"
#import "UITextView+Placeholder.h"

@interface AddGroupClassView ()

@property (weak, nonatomic) IBOutlet UITextField *classNameField;
@property (weak, nonatomic) IBOutlet UITextView *classIntroduceTextView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation AddGroupClassView

+ (instancetype)addGroupClassView {
    AddGroupClassView *view = [[NSBundle mainBundle] loadNibNamed:@"AddGroupClassView" owner:nil options:nil].firstObject;
    
    return view;
}

- (void)awakeFromNib {
    self.classIntroduceTextView.placeholder = @"课程简单介绍";
    self.bgView.layer.cornerRadius = 5.0f;
    self.bgView.layer.borderWidth = 1.0f;
    self.bgView.layer.borderColor = [UIColor gym_lineColor].CGColor;
    self.classIntroduceTextView.placeholderLabel.font = [UIFont systemFontOfSize:17];
}

- (void)dealloc {
    NSLog(@"%@ dealloced",self);
}

- (IBAction)createGroupClass:(id)sender {
    NSString *groupClassNameStr = self.classNameField.text;
    NSString *classIntroduceStr = self.classIntroduceTextView.text;
    if (groupClassNameStr <= 0) {
        UIAlertView *alv = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入团体课程名称" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alv show];
    }
    else if (classIntroduceStr <= 0) {
        UIAlertView *alv = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入课程介绍" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alv show];
    }
    else {
        AddGroupClassViewBlock theBlock = self.block;
        if (theBlock) {
            theBlock(groupClassNameStr, classIntroduceStr);
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
