//
//  Imitation_AlertView_TextField.m
//  模拟TextFiled
//
//  Created by GaoFei on 16/7/6.
//  Copyright © 2016年 GaoFei. All rights reserved.
//

#define kViewHeight(a) a.frame.size.height
#define kViewWidth(a) a.frame.size.width

#define kDurationTime 0.35

#import "Imitation_AlertView_TextField.h"

@interface Imitation_AlertView_TextField ()<UITextViewDelegate>{
    
    UITextView * textView;
    UIButton * okBtn;
    UIButton * cancleBtn;
    UILabel * nameLabel;
}

@property (nonatomic,strong) UIView * alertView;
@property (nonatomic,assign) CGFloat width;//屏幕的宽度
@property (nonatomic,assign) CGFloat height;//屏幕的高度

@end

@implementation Imitation_AlertView_TextField

/**
 初始化视图：传入其父视图的大小
 */
-(instancetype)initWithFatherViewFrameWidth:(CGFloat)width withFrameHeight:(CGFloat)height{

    self = [super initWithFrame:CGRectMake(0, 0, width, height)];
    
    if(self){
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        
        self.width = width;
        self.height = height;
        
        [self loadAlertView];
    }
    
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [super touchesBegan:touches withEvent:event];
    
    [self endEditing:YES];
    
    [UIView animateWithDuration:kDurationTime animations:^{
        self.alertView.transform = CGAffineTransformIdentity;
    }];
}

-(void)setTitle:(NSString *)title{

    _title = title;
    
    if(self.title == nil){
        
        nameLabel.text = @"填写日报";
    }else{
        
        nameLabel.text = self.title;
    }
}

-(void)setTextMessage:(NSString *)textMessage{

    _textMessage = textMessage;
    
    if (_textMessage == nil) {
        
        textView.text = @"请输入内容";
    }else{
    
        textView.text = _textMessage;
    }
}

//创建UIAlertView
-(void)loadAlertView{
    
    if (self.alertView == nil) {
        
        
        self.alertView = [[UIView alloc] initWithFrame:CGRectMake((700-300)/2, 225, 300, 180)];
        self.alertView.layer.cornerRadius = 8;
//        self.alertView.center = self.center;
        self.alertView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.alertView];
        
        //分界线
        UIView *fenjiexian1 = [[UIView alloc] initWithFrame:CGRectMake(0, kViewHeight(self.alertView)-32-5, kViewWidth(self.alertView), 1)];
        fenjiexian1.backgroundColor = [UIColor lightGrayColor];
        [self.alertView addSubview:fenjiexian1];
        
        
        //创建按钮
        UIView * btnBgView = [[UIView alloc] initWithFrame:CGRectMake(4, kViewHeight(self.alertView)-32-4,kViewWidth(self.alertView)-4*2, 32)];
        btnBgView.backgroundColor = [UIColor lightGrayColor];
        [self.alertView addSubview:btnBgView];
        
        //创建两个btn按钮
        cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kViewWidth(btnBgView)/2, kViewHeight(btnBgView))];
        cancleBtn.backgroundColor = [UIColor whiteColor];
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancleBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [cancleBtn addTarget:self action:@selector(cancleBtn) forControlEvents:UIControlEventTouchUpInside];
        [btnBgView addSubview:cancleBtn];
        
        okBtn = [[UIButton alloc] initWithFrame:CGRectMake(kViewWidth(cancleBtn)+1, 0, kViewWidth(btnBgView)/2-1, kViewHeight(btnBgView))];
        okBtn.backgroundColor = [UIColor whiteColor];
        [okBtn setTitle:@"确定" forState:UIControlStateNormal];
        [okBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [okBtn addTarget:self action:@selector(okBtn) forControlEvents:UIControlEventTouchUpInside];
        [btnBgView addSubview:okBtn];
        
        okBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14];

//        btnBgView.layer.cornerRadius = 8;
//        cancleBtn.layer.cornerRadius = 8;
//        ok.layer.cornerRadius = 8;

        
        //创建标题
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, kViewWidth(self.alertView)-10*2, 32)];
                nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.alertView addSubview:nameLabel];
//        nameLabel.backgroundColor = [UIColor greenColor];
        
        CGFloat height = kViewHeight(self.alertView) - kViewHeight(nameLabel) - kViewHeight(btnBgView)-4-4-4-4-4;
        
        //创建textView
        textView = [[UITextView alloc] initWithFrame:CGRectMake(10, kViewHeight(nameLabel)+4+4, kViewWidth(nameLabel), height)];
//        textView.backgroundColor = [UIColor yellowColor];
        textView.delegate = self;
        textView.layer.borderWidth = 0.5;
        textView.font = [UIFont systemFontOfSize:14];
        textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        [self.alertView addSubview:textView];
        
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    [UIView animateWithDuration:kDurationTime animations:^{
        
        self.alertView.transform = CGAffineTransformMakeTranslation(0, -100);
    }];
    
    return YES;
}

-(void)cancleBtn{
    
    [self viewHidden];
    
    [self.delegate at_textViewCancel];
}

-(void)okBtn{
    
    
    if ([textView.text isEqualToString:@""]) {
        return;
    }
    [self viewHidden];
    
    [self.delegate at_textViewDidEndEditing:textView];
    
//    NSString * text = textView.text;
//    
//    if (text.length == 0) {
//        
//        _sendText(@"暂无内容");
//    }else{
//    
//        _sendText(text);
//    }
}

//-(void)textViewDidEndEditing:(SendTextViewText)block{
//
//    _sendText = block;
//}

/**
 
 隐藏
 
 */
-(void)viewHidden{

    
    [UIView animateWithDuration:kDurationTime animations:^{
        [textView endEditing:YES];
        self.alertView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

/**
 
 显示
 
 */
-(void)viewShow{

    self.hidden = NO;
    
    [UIView animateWithDuration:kDurationTime animations:^{
        
        self.alertView.transform = CGAffineTransformMakeTranslation(0, -60);
        [textView becomeFirstResponder];
    }];
    
}


/**
 调用方法返回数据
 */
-(NSString *)sendTextView{

    NSString * text = textView.text;

    if (text.length == 0) {

        return (@"暂无内容");
    }else{

        return text;
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
