//
//  CustomCell.m
//  MobileMiner
//
//  Created by Elias Limneos on 16/12/2017.
//  Copyright © 2017 Elias Limneos. All rights reserved.
//

#include "CustomCell.h"

@implementation CustomCell{
    UIView *customSeparatorView;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
   
    if (self=[super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]){
    
        UITableViewCell.appearance.backgroundColor=[UIColor clearColor];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectedBackgroundView=[UIView new];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        customSeparatorView=NULL;
        
    }
    return self;
}
-(UILabel *)textLabel{
    
    UILabel *label=[super textLabel];
    CGRect frame=label.frame;
    label.frame=CGRectMake(frame.origin.x,frame.origin.y,self.contentView.frame.size.width-(frame.origin.x*2)-10,frame.size.height);
    return label;
    
}
-(UILabel *)detailTextLabel{
    
    UILabel *label=[super detailTextLabel];
    CGRect frame=label.frame;
    frame.origin.y=self.textLabel.frame.origin.y+self.textLabel.frame.size.height+7;
    frame.size.width=self.contentView.frame.size.width-(frame.origin.x*2)-10;
    label.frame=frame;
    label.font=[UIFont systemFontOfSize:15];
    label.textColor=[[UIColor whiteColor] colorWithAlphaComponent:0.65];
    return label;
    
}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    if (self.hasSeparator){
        if (!customSeparatorView){
            customSeparatorView=[[UIView alloc] initWithFrame:CGRectZero];
        }
        customSeparatorView.frame=CGRectMake(20,self.contentView.frame.size.height-0.5,self.frame.size.width-20,1);
        customSeparatorView.backgroundColor=[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.6];
        [self addSubview:customSeparatorView];
    }
    
    CGRect frame=self.textLabel.frame;
    self.textLabel.frame=CGRectMake(frame.origin.x,frame.origin.y,self.contentView.frame.size.width-(frame.origin.x*2)-10,frame.size.height);
    self.textLabel.textColor=[UIColor whiteColor];
    self.textLabel.font=[UIFont systemFontOfSize:20];
    
    frame=self.detailTextLabel.frame;
    frame.origin.y=self.textLabel.frame.origin.y+self.textLabel.frame.size.height+7;
    frame.size.width=self.contentView.frame.size.width-(frame.origin.x*2)-10;
    self.detailTextLabel.frame=frame;
    self.detailTextLabel.font=[UIFont systemFontOfSize:15];
    self.detailTextLabel.textColor=[[UIColor whiteColor] colorWithAlphaComponent:0.65];
    
}
-(void)dealloc{
    
    [customSeparatorView release];
    [super dealloc];
    
}
@end
 
