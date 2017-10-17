//
//  XihaoCell.h
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 2017/6/12.
//  Copyright © 2017年 HanYouApp. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XihaoCellDelegate<NSObject>
//textView代理
-(void)getTextViewOneString:(NSString *)str;
-(void)getTextViewTwoString:(NSString *)str;
//textField代理
-(void)getTextFieldTwoString:(NSString *)str;
-(void)getTextFieldThreeString:(NSString *)str;
-(void)getTextFieldFourString:(NSString *)str;
-(void)getTextFieldFiveString:(NSString *)str;
-(void)getTextFieldSixString:(NSString *)str;
-(void)getTextFieldSevenString:(NSString *)str;
-(void)getTextFieldEightString:(NSString *)str;
-(void)getTextFieldNineString:(NSString *)str;

@end

@interface XihaoCell : UITableViewCell

@property (nonatomic, strong) NSMutableDictionary *dict;
@property (nonatomic, strong) NSMutableArray *arr;

//textView
@property (weak, nonatomic) IBOutlet UITextView *textViewONe;
@property (weak, nonatomic) IBOutlet UITextView *textVIewTwo;
//textField
@property (weak, nonatomic) IBOutlet UITextField *twoText;
@property (weak, nonatomic) IBOutlet UITextField *threeText;
@property (weak, nonatomic) IBOutlet UITextField *fourText;
@property (weak, nonatomic) IBOutlet UITextField *fiveText;
@property (weak, nonatomic) IBOutlet UITextField *sixText;
@property (weak, nonatomic) IBOutlet UITextField *sevenText;
@property (weak, nonatomic) IBOutlet UITextField *eightText;
@property (weak, nonatomic) IBOutlet UITextField *nineText;
//button
@property (weak, nonatomic) IBOutlet UIButton *oneA;
@property (weak, nonatomic) IBOutlet UIButton *oneB;
@property (weak, nonatomic) IBOutlet UIButton *oneC;
@property (weak, nonatomic) IBOutlet UIButton *oneD;
@property (weak, nonatomic) IBOutlet UIButton *oneE;

@property (weak, nonatomic) IBOutlet UIButton *twoA;
@property (weak, nonatomic) IBOutlet UIButton *twoB;
@property (weak, nonatomic) IBOutlet UIButton *twoC;
@property (weak, nonatomic) IBOutlet UIButton *twoD;

@property (weak, nonatomic) IBOutlet UIButton *threeA;
@property (weak, nonatomic) IBOutlet UIButton *threeB;
@property (weak, nonatomic) IBOutlet UIButton *threeC;
@property (weak, nonatomic) IBOutlet UIButton *threeD;
@property (weak, nonatomic) IBOutlet UIButton *threeE;

@property (weak, nonatomic) IBOutlet UIButton *fourA;
@property (weak, nonatomic) IBOutlet UIButton *fourB;
@property (weak, nonatomic) IBOutlet UIButton *fourC;
@property (weak, nonatomic) IBOutlet UIButton *fourD;
@property (weak, nonatomic) IBOutlet UIButton *fourE;
@property (weak, nonatomic) IBOutlet UIButton *fourF;
@property (weak, nonatomic) IBOutlet UIButton *fourG;
@property (weak, nonatomic) IBOutlet UIButton *fourI;
@property (weak, nonatomic) IBOutlet UIButton *fourH;
@property (weak, nonatomic) IBOutlet UIButton *fourJ;
@property (weak, nonatomic) IBOutlet UIButton *fourK;
@property (weak, nonatomic) IBOutlet UIButton *fourL;
@property (weak, nonatomic) IBOutlet UIButton *fourM;
@property (weak, nonatomic) IBOutlet UIButton *fourN;
@property (weak, nonatomic) IBOutlet UIButton *fourO;

@property (weak, nonatomic) IBOutlet UIButton *fiveA;
@property (weak, nonatomic) IBOutlet UIButton *fiveB;
@property (weak, nonatomic) IBOutlet UIButton *fiveC;
@property (weak, nonatomic) IBOutlet UIButton *fiveD;
@property (weak, nonatomic) IBOutlet UIButton *fiveE;
@property (weak, nonatomic) IBOutlet UIButton *fiveF;
@property (weak, nonatomic) IBOutlet UIButton *fiveG;
@property (weak, nonatomic) IBOutlet UIButton *fiveH;

@property (weak, nonatomic) IBOutlet UIButton *sixA;
@property (weak, nonatomic) IBOutlet UIButton *sixB;
@property (weak, nonatomic) IBOutlet UIButton *sixC;
@property (weak, nonatomic) IBOutlet UIButton *sixD;
@property (weak, nonatomic) IBOutlet UIButton *sixE;
@property (weak, nonatomic) IBOutlet UIButton *sixF;
@property (weak, nonatomic) IBOutlet UIButton *sixG;
@property (weak, nonatomic) IBOutlet UIButton *sixH;

@property (weak, nonatomic) IBOutlet UIButton *sevA;
@property (weak, nonatomic) IBOutlet UIButton *sevB;
@property (weak, nonatomic) IBOutlet UIButton *sevC;
@property (weak, nonatomic) IBOutlet UIButton *sevD;
@property (weak, nonatomic) IBOutlet UIButton *sevE;
@property (weak, nonatomic) IBOutlet UIButton *sevF;
@property (weak, nonatomic) IBOutlet UIButton *sevG;
@property (weak, nonatomic) IBOutlet UIButton *sevH;
@property (weak, nonatomic) IBOutlet UIButton *sevI;

@property (weak, nonatomic) IBOutlet UIButton *eigA;
@property (weak, nonatomic) IBOutlet UIButton *eigB;
@property (weak, nonatomic) IBOutlet UIButton *eigC;
@property (weak, nonatomic) IBOutlet UIButton *eigD;
@property (weak, nonatomic) IBOutlet UIButton *eigE;

@property (weak, nonatomic) IBOutlet UIButton *nineA;
@property (weak, nonatomic) IBOutlet UIButton *nineB;
@property (weak, nonatomic) IBOutlet UIButton *nineC;
@property (weak, nonatomic) IBOutlet UIButton *nineD;
@property (weak, nonatomic) IBOutlet UIButton *nineE;
@property (weak, nonatomic) IBOutlet UIButton *nineF;















































@property (nonatomic, weak) id <XihaoCellDelegate> delegate;

@end
