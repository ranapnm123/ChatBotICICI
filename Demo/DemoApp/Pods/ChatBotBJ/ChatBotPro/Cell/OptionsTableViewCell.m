//
//  OptionsTableViewCell.m
//  ChatBot
//
//  Created by PULP on 23/07/18.
//  Copyright © 2018 Ashish Kr Singh. All rights reserved.
//

#import "OptionsTableViewCell.h"

@implementation OptionsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(NSArray *)dataArray{
    CGFloat yAxis = 5.0;
    for (NSString *titleStr in dataArray){
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeSystem];
        [btn setBackgroundColor:[UIColor whiteColor]];
        UIFont *font = [UIFont systemFontOfSize:15];
        [btn.titleLabel setFont:font];
        CGSize stringsize = [titleStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
        [btn setTitleColor:[UIColor colorWithRed:22/255.0 green:188/255.0 blue:206/255.0 alpha:1] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, yAxis, stringsize.width+20, 30);
        [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:titleStr forState:UIControlStateNormal];
        CGPoint point = btn.center;
        point.x = self.containerView.center.x;
        btn.center = point;
        
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 15;
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        btn.layer.borderWidth = 1.0;
        // drop shadow
        btn.layer.shadowRadius  = 2.0f;
        btn.layer.shadowColor   = [UIColor lightGrayColor].CGColor;
        btn.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
        btn.layer.shadowOpacity = 0.3f;
        btn.layer.masksToBounds = NO;
        
        UIBezierPath *shadowPath      = [UIBezierPath bezierPathWithRoundedRect:btn.bounds cornerRadius:15];
        btn.layer.shadowPath    = shadowPath.CGPath;
        
        [self.containerView addSubview:btn];
        yAxis = yAxis+btn.frame.size.height+10;
    }

}

-(void)buttonClicked:(UIButton *)sender{
    sender.backgroundColor = UIColor.blueColor;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:sender.titleLabel.text,@"text",sender.titleLabel.text,@"data", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"collectionCellButtonActionNotification" object:dict];
}
@end
