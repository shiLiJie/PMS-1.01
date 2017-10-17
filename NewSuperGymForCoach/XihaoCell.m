//
//  XihaoCell.m
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 2017/6/12.
//  Copyright © 2017年 HanYouApp. All rights reserved.
//

#import "XihaoCell.h"
@interface XihaoCell()<UITextViewDelegate,UITextFieldDelegate>



@end

@implementation XihaoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [SLJNotificationTools addaddObserver:self selector:@selector(passData) methodName:@"PASSDATA666"];
    
    self.dict = [[NSMutableDictionary alloc] init];
    self.arr = [[NSMutableArray alloc] init];
    
    self.textViewONe.layer.borderColor = UIColor.grayColor.CGColor;
    self.textViewONe.layer.borderWidth = 1;
    self.textViewONe.layer.cornerRadius = 6;
    self.textViewONe.layer.masksToBounds = YES;
    
    self.textVIewTwo.layer.borderColor = UIColor.grayColor.CGColor;
    self.textVIewTwo.layer.borderWidth = 1;
    self.textVIewTwo.layer.cornerRadius = 6;
    self.textVIewTwo.layer.masksToBounds = YES;
    
    self.textVIewTwo.delegate = self;
    self.textViewONe.delegate = self;
    
    self.twoText.delegate = self;
    self.threeText.delegate = self;
    self.fourText.delegate = self;
    self.fiveText.delegate = self;
    self.sixText.delegate = self;
    self.sevenText.delegate = self;
    self.eightText.delegate = self;
    self.nineText.delegate = self;
    
    [self addAction];
    
}

-(void)passData{
    [SLJNotificationTools postNotification:self.dict methodName:@"RECIVEDATA666"];
}

-(void)addAction{
    [self.oneA addTarget:self action:@selector(clickOneA) forControlEvents:UIControlEventAllEvents];
    [self.oneB addTarget:self action:@selector(clickOneB) forControlEvents:UIControlEventAllEvents];
    [self.oneC addTarget:self action:@selector(clickOneC) forControlEvents:UIControlEventAllEvents];
    [self.oneD addTarget:self action:@selector(clickOneD) forControlEvents:UIControlEventAllEvents];
    [self.oneE addTarget:self action:@selector(clickOneE) forControlEvents:UIControlEventAllEvents];
    
    [self.twoA addTarget:self action:@selector(clickTwoA) forControlEvents:UIControlEventAllEvents];
    [self.twoB addTarget:self action:@selector(clickTwoB) forControlEvents:UIControlEventAllEvents];
    [self.twoC addTarget:self action:@selector(clickTwoC) forControlEvents:UIControlEventAllEvents];
    
    [self.threeA addTarget:self action:@selector(clickThreeA) forControlEvents:UIControlEventAllEvents];
    [self.threeB addTarget:self action:@selector(clickThreeB) forControlEvents:UIControlEventAllEvents];
    [self.threeC addTarget:self action:@selector(clickThreeC) forControlEvents:UIControlEventAllEvents];
    [self.threeD addTarget:self action:@selector(clickThreeD) forControlEvents:UIControlEventAllEvents];
    [self.threeE addTarget:self action:@selector(clickThreeE) forControlEvents:UIControlEventAllEvents];
    
    [self.fourA addTarget:self action:@selector(clickFourA) forControlEvents:UIControlEventAllEvents];
    [self.fourB addTarget:self action:@selector(clickFourB) forControlEvents:UIControlEventAllEvents];
    [self.fourC addTarget:self action:@selector(clickFourC) forControlEvents:UIControlEventAllEvents];
    [self.fourD addTarget:self action:@selector(clickFourD) forControlEvents:UIControlEventAllEvents];
    [self.fourE addTarget:self action:@selector(clickFourE) forControlEvents:UIControlEventAllEvents];
    [self.fourF addTarget:self action:@selector(clickFourF) forControlEvents:UIControlEventAllEvents];
    [self.fourG addTarget:self action:@selector(clickFourG) forControlEvents:UIControlEventAllEvents];
    [self.fourH addTarget:self action:@selector(clickFourH) forControlEvents:UIControlEventAllEvents];
    [self.fourI addTarget:self action:@selector(clickFourI) forControlEvents:UIControlEventAllEvents];
    [self.fourJ addTarget:self action:@selector(clickFourJ) forControlEvents:UIControlEventAllEvents];
    [self.fourK addTarget:self action:@selector(clickFourK) forControlEvents:UIControlEventAllEvents];
    [self.fourL addTarget:self action:@selector(clickFourL) forControlEvents:UIControlEventAllEvents];
    [self.fourM addTarget:self action:@selector(clickFourM) forControlEvents:UIControlEventAllEvents];
    [self.fourN addTarget:self action:@selector(clickFourN) forControlEvents:UIControlEventAllEvents];
    [self.fourO addTarget:self action:@selector(clickFourO) forControlEvents:UIControlEventAllEvents];
    
    [self.fiveA addTarget:self action:@selector(clickFiveA) forControlEvents:UIControlEventAllEvents];
    [self.fiveB addTarget:self action:@selector(clickFiveB) forControlEvents:UIControlEventAllEvents];
    [self.fiveC addTarget:self action:@selector(clickFiveC) forControlEvents:UIControlEventAllEvents];
    [self.fiveD addTarget:self action:@selector(clickFiveD) forControlEvents:UIControlEventAllEvents];
    [self.fiveE addTarget:self action:@selector(clickFiveE) forControlEvents:UIControlEventAllEvents];
    [self.fiveF addTarget:self action:@selector(clickFiveF) forControlEvents:UIControlEventAllEvents];
    [self.fiveG addTarget:self action:@selector(clickFiveG) forControlEvents:UIControlEventAllEvents];
    [self.fiveH addTarget:self action:@selector(clickFiveH) forControlEvents:UIControlEventAllEvents];
    
    [self.sixA addTarget:self action:@selector(clickSixA) forControlEvents:UIControlEventAllEvents];
    [self.sixB addTarget:self action:@selector(clickSixB) forControlEvents:UIControlEventAllEvents];
    [self.sixC addTarget:self action:@selector(clickSixC) forControlEvents:UIControlEventAllEvents];
    [self.sixD addTarget:self action:@selector(clickSixD) forControlEvents:UIControlEventAllEvents];
    [self.sixE addTarget:self action:@selector(clickSixE) forControlEvents:UIControlEventAllEvents];
    [self.sixF addTarget:self action:@selector(clickSixF) forControlEvents:UIControlEventAllEvents];
    [self.sixG addTarget:self action:@selector(clickSixG) forControlEvents:UIControlEventAllEvents];
    [self.sixH addTarget:self action:@selector(clickSixH) forControlEvents:UIControlEventAllEvents];
    
    [self.sevA addTarget:self action:@selector(clickSevA) forControlEvents:UIControlEventAllEvents];
    [self.sevB addTarget:self action:@selector(clickSevB) forControlEvents:UIControlEventAllEvents];
    [self.sevC addTarget:self action:@selector(clickSevC) forControlEvents:UIControlEventAllEvents];
    [self.sevD addTarget:self action:@selector(clickSevD) forControlEvents:UIControlEventAllEvents];
    [self.sevE addTarget:self action:@selector(clickSevE) forControlEvents:UIControlEventAllEvents];
    [self.sevF addTarget:self action:@selector(clickSevF) forControlEvents:UIControlEventAllEvents];
    [self.sevG addTarget:self action:@selector(clickSevG) forControlEvents:UIControlEventAllEvents];
    [self.sevH addTarget:self action:@selector(clickSevH) forControlEvents:UIControlEventAllEvents];
    [self.sevI addTarget:self action:@selector(clickSevI) forControlEvents:UIControlEventAllEvents];
    
    [self.eigA addTarget:self action:@selector(clickEigA) forControlEvents:UIControlEventAllEvents];
    [self.eigB addTarget:self action:@selector(clickEigB) forControlEvents:UIControlEventAllEvents];
    [self.eigC addTarget:self action:@selector(clickEigC) forControlEvents:UIControlEventAllEvents];
    [self.eigD addTarget:self action:@selector(clickEigD) forControlEvents:UIControlEventAllEvents];
    [self.eigE addTarget:self action:@selector(clickEigE) forControlEvents:UIControlEventAllEvents];
    
    [self.nineA addTarget:self action:@selector(clickNineA) forControlEvents:UIControlEventAllEvents];
    [self.nineB addTarget:self action:@selector(clickNineB) forControlEvents:UIControlEventAllEvents];
    [self.nineC addTarget:self action:@selector(clickNineC) forControlEvents:UIControlEventAllEvents];
    [self.nineD addTarget:self action:@selector(clickNineD) forControlEvents:UIControlEventAllEvents];
    [self.nineE addTarget:self action:@selector(clickNineE) forControlEvents:UIControlEventAllEvents];
    [self.nineF addTarget:self action:@selector(clickNineF) forControlEvents:UIControlEventAllEvents];

    
}

//textView代理
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView == self.textViewONe) {
//        [self.delegate getTextViewOneString:textView.text];
        [self.dict setValue:textView.text forKey:@"10.1"];
    }
    
    if (textView == self.textVIewTwo) {
//        [self.delegate getTextViewTwoString:textView.text];
        [self.dict setValue:textView.text forKey:@"10.2"];
    }
}
//textField代理
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.twoText) {
//        [self.delegate getTextFieldTwoString:textField.text];
        [self.dict setValue:textField.text forKey:@"2"];
    }
    if (textField == self.threeText) {
//        [self.delegate getTextFieldThreeString:textField.text];
        [self.dict setValue:textField.text forKey:@"3"];
    }
    if (textField == self.fourText) {
//        [self.delegate getTextFieldFourString:textField.text];
        [self.dict setValue:textField.text forKey:@"4"];
    }
    if (textField == self.fiveText) {
//        [self.delegate getTextFieldFiveString:textField.text];
        [self.dict setValue:textField.text forKey:@"5"];
    }
    if (textField == self.sixText) {
//        [self.delegate getTextFieldSixString:textField.text];
        [self.dict setValue:textField.text forKey:@"6"];
    }
    if (textField == self.sevenText) {
//        [self.delegate getTextFieldSevenString:textField.text];
        [self.dict setValue:textField.text forKey:@"7"];
    }
    if (textField == self.eightText) {
//        [self.delegate getTextFieldEightString:textField.text];
        [self.dict setValue:textField.text forKey:@"8"];
    }
    if (textField == self.nineText) {
//        [self.delegate getTextFieldNineString:textField.text];
        [self.dict setValue:textField.text forKey:@"9"];
    }
}

//按钮点击方法加代理
-(void)clickOneA{
    [self.dict setValue:@"A" forKey:@"1"];
    self.oneA.selected = YES;
    self.oneE.selected = NO;
    self.oneD.selected = NO;
    self.oneC.selected = NO;
    self.oneB.selected = NO;
}
-(void)clickOneB{
    [self.dict setValue:@"B" forKey:@"1"];
    self.oneA.selected = NO;
    self.oneE.selected = NO;
    self.oneD.selected = NO;
    self.oneC.selected = NO;
    self.oneB.selected = YES;
}
-(void)clickOneC{
    [self.dict setValue:@"C" forKey:@"1"];
    self.oneA.selected = NO;
    self.oneE.selected = NO;
    self.oneD.selected = NO;
    self.oneC.selected = YES;
    self.oneB.selected = NO;
}
-(void)clickOneD{
    [self.dict setValue:@"D" forKey:@"1"];
    self.oneA.selected = NO;
    self.oneE.selected = NO;
    self.oneD.selected = YES;
    self.oneC.selected = NO;
    self.oneB.selected = NO;
}
-(void)clickOneE{
    [self.dict setValue:@"E" forKey:@"1"];
    self.oneA.selected = NO;
    self.oneE.selected = YES;
    self.oneD.selected = NO;
    self.oneC.selected = NO;
    self.oneB.selected = NO;
}



-(void)clickTwoA{
    [self.dict setValue:@"A" forKey:@"2"];
    self.twoA.selected = YES;
    self.twoB.selected = NO;
    self.twoC.selected = NO;
}
-(void)clickTwoB{
    [self.dict setValue:@"B" forKey:@"2"];
    self.twoA.selected = NO;
    self.twoB.selected = YES;
    self.twoC.selected = NO;
}
-(void)clickTwoC{
    [self.dict setValue:@"C" forKey:@"2"];
    self.twoA.selected = NO;
    self.twoB.selected = NO;
    self.twoC.selected = YES;
}


-(void)clickThreeA{
    [self.dict setValue:@"A" forKey:@"3"];
    self.threeA.selected = YES;
    self.threeB.selected = NO;
    self.threeC.selected = NO;
    self.threeD.selected = NO;
    self.threeE.selected = NO;
}
-(void)clickThreeB{
    [self.dict setValue:@"B" forKey:@"3"];
    self.threeA.selected = NO;
    self.threeB.selected = YES;
    self.threeC.selected = NO;
    self.threeD.selected = NO;
    self.threeE.selected = NO;
}
-(void)clickThreeC{
    [self.dict setValue:@"C" forKey:@"3"];
    self.threeA.selected = NO;
    self.threeB.selected = NO;
    self.threeC.selected = YES;
    self.threeD.selected = NO;
    self.threeE.selected = NO;
}
-(void)clickThreeD{
    [self.dict setValue:@"D" forKey:@"3"];
    self.threeA.selected = NO;
    self.threeB.selected = NO;
    self.threeC.selected = NO;
    self.threeD.selected = YES;
    self.threeE.selected = NO;
}
-(void)clickThreeE{
    [self.dict setValue:@"E" forKey:@"3"];
    self.threeA.selected = NO;
    self.threeB.selected = NO;
    self.threeC.selected = NO;
    self.threeD.selected = NO;
    self.threeE.selected = YES;
}

-(void)clickFourA{
    if (self.fourA.selected == YES) {
        self.fourA.selected = NO;
        [self.arr removeObject:@"A"];
    }else{
        self.fourA.selected = YES;
        [self.arr addObject:@"A"];
    }
//    self.fourB.selected = NO;
//    self.fourC.selected = NO;
//    self.fourD.selected = NO;
//    self.fourE.selected = NO;
//    self.fourF.selected = NO;
//    self.fourG.selected = NO;
//    self.fourH.selected = NO;
//    self.fourI.selected = NO;
//    self.fourJ.selected = NO;
//    self.fourK.selected = NO;
//    self.fourL.selected = NO;
//    self.fourM.selected = NO;
//    self.fourN.selected = NO;
//    self.fourO.selected = NO;
}
-(void)clickFourB{
    
    if (self.fourB.selected == YES) {
        self.fourB.selected = NO;
        [self.arr removeObject:@"B"];
        [self.dict setObject:self.arr forKey:@"4"];
    }else{
        self.fourB.selected = YES;
        [self.arr addObject:@"B"];
        [self.dict setObject:self.arr forKey:@"4"];
    }
}
-(void)clickFourC{

    if (self.fourC.selected == YES) {
        self.fourC.selected = NO;
        [self.arr removeObject:@"C"];
        [self.dict setObject:self.arr forKey:@"4"];
    }else{
        self.fourC.selected = YES;
        [self.arr addObject:@"C"];
        [self.dict setObject:self.arr forKey:@"4"];
    }
}
-(void)clickFourD{

    if (self.fourD.selected == YES) {
        self.fourD.selected = NO;
        [self.arr removeObject:@"D"];
        [self.dict setObject:self.arr forKey:@"4"];
    }else{
        self.fourD.selected = YES;
        [self.arr addObject:@"D"];
        [self.dict setObject:self.arr forKey:@"4"];
    }
}
-(void)clickFourE{

    if (self.fourE.selected == YES) {
        self.fourE.selected = NO;
        [self.arr removeObject:@"E"];
        [self.dict setObject:self.arr forKey:@"4"];
    }else{
        self.fourE.selected = YES;
        [self.arr addObject:@"E"];
        [self.dict setObject:self.arr forKey:@"4"];
    }
}
-(void)clickFourF{

    if (self.fourF.selected == YES) {
        self.fourF.selected = NO;
        [self.arr removeObject:@"F"];
        [self.dict setObject:self.arr forKey:@"4"];
    }else{
        self.fourF.selected = YES;
        [self.arr addObject:@"F"];
        [self.dict setObject:self.arr forKey:@"4"];
    }
}
-(void)clickFourG{

    if (self.fourG.selected == YES) {
        self.fourG.selected = NO;
        [self.arr removeObject:@"G"];
        [self.dict setObject:self.arr forKey:@"4"];
    }else{
        self.fourG.selected = YES;
        [self.arr addObject:@"G"];
        [self.dict setObject:self.arr forKey:@"4"];
    }
}
-(void)clickFourH{

    if (self.fourH.selected == YES) {
        self.fourH.selected = NO;
        [self.arr removeObject:@"H"];
        [self.dict setObject:self.arr forKey:@"4"];
    }else{
        self.fourH.selected = YES;
        [self.arr addObject:@"H"];
        [self.dict setObject:self.arr forKey:@"4"];
    }
}
-(void)clickFourI{

    if (self.fourI.selected == YES) {
        self.fourI.selected = NO;
        [self.arr removeObject:@"I"];
        [self.dict setObject:self.arr forKey:@"4"];
    }else{
        self.fourI.selected = YES;
        [self.arr addObject:@"I"];
        [self.dict setObject:self.arr forKey:@"4"];
    }
}
-(void)clickFourJ{

    if (self.fourJ.selected == YES) {
        self.fourJ.selected = NO;
        [self.arr removeObject:@"J"];
        [self.dict setObject:self.arr forKey:@"4"];
    }else{
        self.fourJ.selected = YES;
        [self.arr addObject:@"J"];
        [self.dict setObject:self.arr forKey:@"4"];
    }
}
-(void)clickFourK{

    if (self.fourK.selected == YES) {
        self.fourK.selected = NO;
        [self.arr removeObject:@"K"];
        [self.dict setObject:self.arr forKey:@"4"];
    }else{
        self.fourK.selected = YES;
        [self.arr addObject:@"K"];
        [self.dict setObject:self.arr forKey:@"4"];
    }
}
-(void)clickFourL{

    if (self.fourL.selected == YES) {
        self.fourL.selected = NO;
        [self.arr removeObject:@"L"];
        [self.dict setObject:self.arr forKey:@"4"];
    }else{
        self.fourL.selected = YES;
        [self.arr addObject:@"L"];
        [self.dict setObject:self.arr forKey:@"4"];
    }
}
-(void)clickFourM{

    if (self.fourM.selected == YES) {
        self.fourM.selected = NO;
        [self.arr removeObject:@"M"];
        [self.dict setObject:self.arr forKey:@"4"];
    }else{
        self.fourM.selected = YES;
        [self.arr addObject:@"M"];
        [self.dict setObject:self.arr forKey:@"4"];
    }
}
-(void)clickFourN{

    if (self.fourN.selected == YES) {
        self.fourN.selected = NO;
        [self.arr removeObject:@"N"];
        [self.dict setObject:self.arr forKey:@"4"];
    }else{
        self.fourN.selected = YES;
        [self.arr addObject:@"N"];
        [self.dict setObject:self.arr forKey:@"4"];
    }
}
-(void)clickFourO{

    if (self.fourO.selected == YES) {
        self.fourO.selected = NO;
        [self.arr removeObject:@"O"];
        [self.dict setObject:self.arr forKey:@"4"];
    }else{
        self.fourO.selected = YES;
        [self.arr addObject:@"O"];
        [self.dict setObject:self.arr forKey:@"4"];
    }
}

-(void)clickFiveA{
    [self.dict setObject:@"A" forKey:@"5"];
    self.fiveA.selected = YES;
    self.fiveB.selected = NO;
    self.fiveC.selected = NO;
    self.fiveD.selected = NO;
    self.fiveE.selected = NO;
    self.fiveF.selected = NO;
    self.fiveG.selected = NO;
    self.fiveH.selected = NO;}
-(void)clickFiveB{
    [self.dict setObject:@"B" forKey:@"5"];
    self.fiveA.selected = NO;
    self.fiveB.selected = YES;
    self.fiveC.selected = NO;
    self.fiveD.selected = NO;
    self.fiveE.selected = NO;
    self.fiveF.selected = NO;
    self.fiveG.selected = NO;
    self.fiveH.selected = NO;}
-(void)clickFiveC{
    [self.dict setObject:@"C" forKey:@"5"];
    self.fiveA.selected = NO;
    self.fiveB.selected = NO;
    self.fiveC.selected = YES;
    self.fiveD.selected = NO;
    self.fiveE.selected = NO;
    self.fiveF.selected = NO;
    self.fiveG.selected = NO;
    self.fiveH.selected = NO;}
-(void)clickFiveD{
    [self.dict setObject:@"D" forKey:@"5"];
    self.fiveA.selected = NO;
    self.fiveB.selected = NO;
    self.fiveC.selected = NO;
    self.fiveD.selected = YES;
    self.fiveE.selected = NO;
    self.fiveF.selected = NO;
    self.fiveG.selected = NO;
    self.fiveH.selected = NO;}
-(void)clickFiveE{
    [self.dict setObject:@"E" forKey:@"5"];
    self.fiveA.selected = NO;
    self.fiveB.selected = NO;
    self.fiveC.selected = NO;
    self.fiveD.selected = NO;
    self.fiveE.selected = YES;
    self.fiveF.selected = NO;
    self.fiveG.selected = NO;
    self.fiveH.selected = NO;}
-(void)clickFiveF{
    [self.dict setObject:@"F" forKey:@"5"];
    self.fiveA.selected = NO;
    self.fiveB.selected = NO;
    self.fiveC.selected = NO;
    self.fiveD.selected = NO;
    self.fiveE.selected = NO;
    self.fiveF.selected = YES;
    self.fiveG.selected = NO;
    self.fiveH.selected = NO;}
-(void)clickFiveG{
    [self.dict setObject:@"G" forKey:@"5"];
    self.fiveA.selected = NO;
    self.fiveB.selected = NO;
    self.fiveC.selected = NO;
    self.fiveD.selected = NO;
    self.fiveE.selected = NO;
    self.fiveF.selected = NO;
    self.fiveG.selected = YES;
    self.fiveH.selected = NO;}
-(void)clickFiveH{
    [self.dict setObject:@"H" forKey:@"5"];
    self.fiveA.selected = NO;
    self.fiveB.selected = NO;
    self.fiveC.selected = NO;
    self.fiveD.selected = NO;
    self.fiveE.selected = NO;
    self.fiveF.selected = NO;
    self.fiveG.selected = NO;
    self.fiveH.selected = YES;}

-(void)clickSixA{
    [self.dict setObject:@"A" forKey:@"6"];
    self.sixA.selected = YES;
    self.sixB.selected = NO;
    self.sixC.selected = NO;
    self.sixD.selected = NO;
    self.sixE.selected = NO;
    self.sixF.selected = NO;
    self.sixG.selected = NO;
    self.sixH.selected = NO;}
-(void)clickSixB{
    [self.dict setObject:@"B" forKey:@"6"];
    self.sixA.selected = NO;
    self.sixB.selected = YES;
    self.sixC.selected = NO;
    self.sixD.selected = NO;
    self.sixE.selected = NO;
    self.sixF.selected = NO;
    self.sixG.selected = NO;
    self.sixH.selected = NO;}
-(void)clickSixC{
    [self.dict setObject:@"C" forKey:@"6"];
    self.sixA.selected = NO;
    self.sixB.selected = NO;
    self.sixC.selected = YES;
    self.sixD.selected = NO;
    self.sixE.selected = NO;
    self.sixF.selected = NO;
    self.sixG.selected = NO;
    self.sixH.selected = NO;}
-(void)clickSixD{
    [self.dict setObject:@"D" forKey:@"6"];
    self.sixA.selected = NO;
    self.sixB.selected = NO;
    self.sixC.selected = NO;
    self.sixD.selected = YES;
    self.sixE.selected = NO;
    self.sixF.selected = NO;
    self.sixG.selected = NO;
    self.sixH.selected = NO;}
-(void)clickSixE{
    [self.dict setObject:@"E" forKey:@"6"];
    self.sixA.selected = NO;
    self.sixB.selected = NO;
    self.sixC.selected = NO;
    self.sixD.selected = NO;
    self.sixE.selected = YES;
    self.sixF.selected = NO;
    self.sixG.selected = NO;
    self.sixH.selected = NO;}
-(void)clickSixF{
    [self.dict setObject:@"F" forKey:@"6"];
    self.sixA.selected = NO;
    self.sixB.selected = NO;
    self.sixC.selected = NO;
    self.sixD.selected = NO;
    self.sixE.selected = NO;
    self.sixF.selected = YES;
    self.sixG.selected = NO;
    self.sixH.selected = NO;}
-(void)clickSixG{
    [self.dict setObject:@"G" forKey:@"6"];
    self.sixA.selected = NO;
    self.sixB.selected = NO;
    self.sixC.selected = NO;
    self.sixD.selected = NO;
    self.sixE.selected = NO;
    self.sixF.selected = NO;
    self.sixG.selected = YES;
    self.sixH.selected = NO;}
-(void)clickSixH{
    [self.dict setObject:@"H" forKey:@"6"];
    self.sixA.selected = NO;
    self.sixB.selected = NO;
    self.sixC.selected = NO;
    self.sixD.selected = NO;
    self.sixE.selected = NO;
    self.sixF.selected = NO;
    self.sixG.selected = NO;
    self.sixH.selected = YES;}

-(void)clickSevA{
    [self.dict setObject:@"A" forKey:@"7"];
    self.sevA.selected = YES;
    self.sevB.selected = NO;
    self.sevC.selected = NO;
    self.sevD.selected = NO;
    self.sevE.selected = NO;
    self.sevF.selected = NO;
    self.sevG.selected = NO;
    self.sevH.selected = NO;
    self.sevI.selected = NO;}

-(void)clickSevB{
    [self.dict setObject:@"B" forKey:@"7"];
    self.sevA.selected = NO;
    self.sevB.selected = YES;
    self.sevC.selected = NO;
    self.sevD.selected = NO;
    self.sevE.selected = NO;
    self.sevF.selected = NO;
    self.sevG.selected = NO;
    self.sevH.selected = NO;
    self.sevI.selected = NO;}
-(void)clickSevC{
    [self.dict setObject:@"C" forKey:@"7"];
    self.sevA.selected = NO;
    self.sevB.selected = NO;
    self.sevC.selected = YES;
    self.sevD.selected = NO;
    self.sevE.selected = NO;
    self.sevF.selected = NO;
    self.sevG.selected = NO;
    self.sevH.selected = NO;
    self.sevI.selected = NO;}
-(void)clickSevD{
    [self.dict setObject:@"D" forKey:@"7"];
    self.sevA.selected = NO;
    self.sevB.selected = NO;
    self.sevC.selected = NO;
    self.sevD.selected = YES;
    self.sevE.selected = NO;
    self.sevF.selected = NO;
    self.sevG.selected = NO;
    self.sevH.selected = NO;
    self.sevI.selected = NO;}
-(void)clickSevE{
    [self.dict setObject:@"E" forKey:@"7"];
    self.sevA.selected = NO;
    self.sevB.selected = NO;
    self.sevC.selected = NO;
    self.sevD.selected = NO;
    self.sevE.selected = YES;
    self.sevF.selected = NO;
    self.sevG.selected = NO;
    self.sevH.selected = NO;
    self.sevI.selected = NO;}
-(void)clickSevF{
    [self.dict setObject:@"F" forKey:@"7"];
    self.sevA.selected = NO;
    self.sevB.selected = NO;
    self.sevC.selected = NO;
    self.sevD.selected = NO;
    self.sevE.selected = NO;
    self.sevF.selected = YES;
    self.sevG.selected = NO;
    self.sevH.selected = NO;
    self.sevI.selected = NO;}
-(void)clickSevG{
    [self.dict setObject:@"G" forKey:@"7"];
    self.sevA.selected = NO;
    self.sevB.selected = NO;
    self.sevC.selected = NO;
    self.sevD.selected = NO;
    self.sevE.selected = NO;
    self.sevF.selected = NO;
    self.sevG.selected = YES;
    self.sevH.selected = NO;
    self.sevI.selected = NO;}
-(void)clickSevH{
    [self.dict setObject:@"H" forKey:@"7"];
    self.sevA.selected = NO;
    self.sevB.selected = NO;
    self.sevC.selected = NO;
    self.sevD.selected = NO;
    self.sevE.selected = NO;
    self.sevF.selected = NO;
    self.sevG.selected = NO;
    self.sevH.selected = YES;
    self.sevI.selected = NO;}
-(void)clickSevI{
    [self.dict setObject:@"I" forKey:@"7"];
    self.sevA.selected = NO;
    self.sevB.selected = NO;
    self.sevC.selected = NO;
    self.sevD.selected = NO;
    self.sevE.selected = NO;
    self.sevF.selected = NO;
    self.sevG.selected = NO;
    self.sevH.selected = NO;
    self.sevI.selected = YES;}

-(void)clickEigA{
    [self.dict setObject:@"A" forKey:@"8"];
    self.eigA.selected = YES;
    self.eigB.selected = NO;
    self.eigC.selected = NO;
    self.eigD.selected = NO;
    self.eigE.selected = NO;}
-(void)clickEigB{
    [self.dict setObject:@"B" forKey:@"8"];
    self.eigA.selected = NO;
    self.eigB.selected = YES;
    self.eigC.selected = NO;
    self.eigD.selected = NO;
    self.eigE.selected = NO;}
-(void)clickEigC{
    [self.dict setObject:@"C" forKey:@"8"];
    self.eigA.selected = NO;
    self.eigB.selected = NO;
    self.eigC.selected = YES;
    self.eigD.selected = NO;
    self.eigE.selected = NO;}
-(void)clickEigD{
    [self.dict setObject:@"D" forKey:@"8"];
    self.eigA.selected = NO;
    self.eigB.selected = NO;
    self.eigC.selected = NO;
    self.eigD.selected = YES;
    self.eigE.selected = NO;}
-(void)clickEigE{
    [self.dict setObject:@"E" forKey:@"8"];
    self.eigA.selected = NO;
    self.eigB.selected = NO;
    self.eigC.selected = NO;
    self.eigD.selected = NO;
    self.eigE.selected = YES;}

-(void)clickNineA{
    [self.dict setObject:@"A" forKey:@"9"];
    self.nineA.selected = YES;
    self.nineB.selected = NO;
    self.nineC.selected = NO;
    self.nineD.selected = NO;
    self.nineE.selected = NO;
    self.nineF.selected = NO;}
-(void)clickNineB{
    [self.dict setObject:@"B" forKey:@"9"];
    self.nineA.selected = NO;
    self.nineB.selected = YES;
    self.nineC.selected = NO;
    self.nineD.selected = NO;
    self.nineE.selected = NO;
    self.nineF.selected = NO;}
-(void)clickNineC{
    [self.dict setObject:@"C" forKey:@"9"];
    self.nineA.selected = NO;
    self.nineB.selected = NO;
    self.nineC.selected = YES;
    self.nineD.selected = NO;
    self.nineE.selected = NO;
    self.nineF.selected = NO;}
-(void)clickNineD{
    [self.dict setObject:@"D" forKey:@"9"];
    self.nineA.selected = NO;
    self.nineB.selected = NO;
    self.nineC.selected = NO;
    self.nineD.selected = YES;
    self.nineE.selected = NO;
    self.nineF.selected = NO;}
-(void)clickNineE{
    [self.dict setObject:@"E" forKey:@"9"];
    self.nineA.selected = NO;
    self.nineB.selected = NO;
    self.nineC.selected = NO;
    self.nineD.selected = NO;
    self.nineE.selected = YES;
    self.nineF.selected = NO;}
-(void)clickNineF{
    [self.dict setObject:@"F" forKey:@"9"];
    self.nineA.selected = NO;
    self.nineB.selected = NO;
    self.nineC.selected = NO;
    self.nineD.selected = NO;
    self.nineE.selected = NO;
    self.nineF.selected = YES;}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
