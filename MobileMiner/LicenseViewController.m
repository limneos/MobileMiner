//
//  LicenseViewController.m
//  MobileMiner
//
//  Created by Elias Limneos on 13/12/2017.
//  Copyright © 2017 Elias Limneos. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "LicenseViewController.h"

@implementation LicenseViewController
-(id)title{
    return @"License";
}
-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1];
    UITextView *textView=[[UITextView alloc] initWithFrame:CGRectMake(0,60,self.view.frame.size.width,self.view.frame.size.height-60)];
    textView.backgroundColor=[UIColor clearColor];
    textView.textColor=[UIColor whiteColor];
    textView.editable=NO;
    NSString *licensePath=[[NSBundle mainBundle] pathForResource:@"License" ofType:@"txt"];
    textView.text=[NSString stringWithContentsOfFile:licensePath encoding:NSUTF8StringEncoding error:NULL];
    [self.view addSubview:textView];
    
}
@end
