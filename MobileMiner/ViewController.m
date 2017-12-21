//
//  ViewController.m
//  MobileMiner
//
//  Created by Elias Limneos on 21/12/2017.
//  Copyright © 2017 Elias Limneos. All rights reserved.
//

#import "ViewController.h"

int start_mining(int argc,char *argv[]);

@interface ViewController ()

@end

@implementation ViewController{
    
    UITextView *textView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateText:) name:@"message" object:NULL];
    textView=[[UITextView alloc] initWithFrame:self.view.frame];
    textView.textColor=[UIColor blackColor];
    textView.text=@"";
    [self.view addSubview:textView];
    
}
-(void)updateText:(NSNotification *)notification{
    char *inText=(char *)[notification object];
    dispatch_async(dispatch_get_main_queue(),^{
        textView.text=[textView.text stringByAppendingString:[NSString stringWithUTF8String:inText]];
        [textView scrollRangeToVisible:NSMakeRange(0,[[textView text] length])];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
