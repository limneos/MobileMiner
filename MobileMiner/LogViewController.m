//
//  LogViewController.m
//  MobileMiner
//
//  Created by Elias Limneos on 13/12/2017.
//  Copyright © 2017 Elias Limneos. All rights reserved.
//


#define CONFIGS_KEY @"configurations"

#include "LogViewController.h"
#include <objc/runtime.h>
#include "notify.h"
#include <AudioToolbox/AudioToolbox.h>
#include "AppDelegate.h"

@interface LogViewController ()
@property (nonatomic, retain) NSMutableString *textInBackground;
@end

static BOOL workioDone=NO;
static BOOL stratumDone=NO;
static int threadsDone=0;
static int threads=2;


static void stateCallback(CFNotificationCenterRef center, void *observer, CFNotificationName name, const void *object, CFDictionaryRef userInfo){
    
    // Receive notification that threads exited
    
    char *thread=(char *)object;
    if (!strcmp(thread,"workio")){
        workioDone=YES;
    }
    if (!strcmp(thread,"stratum")){
        stratumDone=YES;
    }
    if (strstr(thread,"thread")){
        threadsDone+=1;
    }
    
    // All important threads are stopped, update UI
    
    if (stratumDone && threadsDone==threads){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MiningStateDidChangeNotification" object:(LogViewController *)observer userInfo:@{@"state":@(0)}];
        dispatch_async(dispatch_get_main_queue(),^{
            [[(LogViewController *)observer valueForKey:@"miningButton"] setEnabled:YES];
            [[(LogViewController *)observer valueForKey:@"miningButton"] setSelected:NO];
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] setIsMining:NO];
        });
    }
    
}

@implementation LogViewController{
  
    UITextView *textView;
    NSOperationQueue* queue;
    int lockstateToken;
    UIButton *miningButton;
    BOOL hasView;
    NSUserDefaults *defaults;
    
}
-(id)title{
    return @"Miner Log";
}
-(id)init{
    
    if (self=[super init]){
        
        self.textInBackground=NULL;
        miningButton=[[UIButton buttonWithType:UIButtonTypeCustom] retain];
        miningButton.alpha=0;
        [miningButton setTitle:@"Start" forState:UIControlStateNormal];
        [miningButton setTitle:@"Stop" forState:UIControlStateSelected];
        [miningButton setTitle:@"Stopping" forState:UIControlStateDisabled];
        [miningButton addTarget:self action:@selector(toggleMining:) forControlEvents:UIControlEventTouchUpInside];
        hasView=NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didResume)  name:UIApplicationDidBecomeActiveNotification object:NULL];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessage:) name:@"LOG_MESSAGE" object:NULL];
        CFNotificationCenterAddObserver(CFNotificationCenterGetLocalCenter(),(const void *)self, &stateCallback, CFSTR("thread.exit"),NULL,0);
        textView=[[UITextView alloc] initWithFrame:CGRectMake(0,20,self.view.frame.size.width,self.view.frame.size.height-120)];
        textView.editable=NO;
        textView.backgroundColor=[UIColor clearColor];
        textView.textColor=[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
        textView.font=[UIFont fontWithName:@"Courier" size:12];
        defaults=[NSUserDefaults standardUserDefaults];
        [defaults synchronize];
        //self.tabBarItem.image
    }
    return self;
}
- (void)updateColors{
    
    textView.scrollEnabled = NO;
    NSRange selectedRange = textView.selectedRange;
    NSString *text = textView.text;
    text=[text stringByReplacingOccurrencesOfString:@"] thread" withString:@"] Thread"];
    
   
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1] range:NSMakeRange(0, text.length)];
    NSError *error = nil;
    
    NSRegularExpression *regex;
    NSArray *matches;
    
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\d+\\D\\d\\d\\sH" options:0 error:&error];
    matches = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    for (NSTextCheckingResult *match in matches) {
        NSRange matchRange = [match rangeAtIndex:0];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:NSMakeRange(matchRange.location,matchRange.length-2)];
    }
    
    
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\d+\\D\\d\\d\\sH\\/s\\sat" options:0 error:&error];
    matches = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    for (NSTextCheckingResult *match in matches) {
        NSRange matchRange = [match rangeAtIndex:0];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(matchRange.location,matchRange.length-7)];
    }
    
    regex = [NSRegularExpression regularExpressionWithPattern:@"Accepted:" options:0 error:&error];
    matches = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    for (NSTextCheckingResult *match in matches) {
        NSRange matchRange = [match rangeAtIndex:0];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(matchRange.location,matchRange.length-1)];
    }
    regex = [NSRegularExpression regularExpressionWithPattern:@"Rejected:" options:0 error:&error];
    matches = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    for (NSTextCheckingResult *match in matches) {
        NSRange matchRange = [match rangeAtIndex:0];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(matchRange.location,matchRange.length-1)];
    }
   
    regex = [NSRegularExpression regularExpressionWithPattern:@"Hash rate:" options:0 error:&error];
    matches = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    for (NSTextCheckingResult *match in matches) {
        NSRange matchRange = [match rangeAtIndex:0];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.2 green:0.7 blue:1 alpha:1] range:NSMakeRange(matchRange.location,matchRange.length-1)];
    }
    
    textView.attributedText = attributedString;
    textView.selectedRange = selectedRange;
    textView.scrollEnabled = YES;
    [attributedString release];
    
}
-(void)newMessage:(id)notification{
    
    char *message=(char *)[notification object];
    
    
    static const char mon_name[][4] = {
        "Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    };
    char result[26];
    
    time_t rawtime;
    struct tm * timeptr;
    
    time ( &rawtime );
    timeptr = localtime ( &rawtime );
    
    
    sprintf(result, "[%d-%.3s-%d %.2d:%.2d:%.2d]",
            1900 + timeptr->tm_year,
            mon_name[timeptr->tm_mon],
            timeptr->tm_mday, timeptr->tm_hour,
            timeptr->tm_min, timeptr->tm_sec);
    NSString *messageWithDate=[NSString stringWithFormat:@"%s %s\n",result,message];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PARSED_MESSAGE" object:[NSString stringWithFormat:@"%s",message]];
    dispatch_async(dispatch_get_main_queue(),^{
        
        
        if ((strstr(message,"ccepted") || strstr(message,"at diff")) && [[UIApplication sharedApplication] applicationState]==2){
            BOOL allowsNotifications=[defaults objectForKey:@"allowNotifications"] ? [defaults boolForKey:@"allowNotifications"] : YES;
            if (allowsNotifications){
                
                UILocalNotification* localNotification = [[UILocalNotification alloc] init];
                localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0.5];
                localNotification.timeZone = [NSTimeZone systemTimeZone];
                localNotification.repeatInterval = 0;
                //localNotification.soundName = @"dtmf-7.caf"; //UILocalNotificationDefaultSoundName;
                localNotification.alertBody = [NSString stringWithUTF8String:message];
                [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                [localNotification release];
            }
        }
        
       
        if ([[UIApplication sharedApplication] applicationState]!=UIApplicationStateBackground && hasView){
            [self updateTextViewWithNewText:messageWithDate];
        }
        else{
            if (!self.textInBackground){
                self.textInBackground=[[NSMutableString alloc] init];
            }
            [self.textInBackground appendString:messageWithDate];
            
        }
        
    });
}
-(void)didResume{
    if (self.textInBackground){
        dispatch_async(dispatch_get_main_queue(),^{
            [self updateTextViewWithNewText:self.textInBackground];
            [self.textInBackground release];
            self.textInBackground=NULL;
        });
        
    }
}
-(void)updateTextViewWithNewText:(NSString *)messageWithDate{
    
    textView.text=textView.text ? [textView.text stringByAppendingString:messageWithDate] : [@"Miner Loaded\n" stringByAppendingString:messageWithDate];
    [self updateColors];
    [UIView setAnimationsEnabled:NO];
    [textView scrollRangeToVisible:NSMakeRange([textView.text length], 0)];
    [UIView setAnimationsEnabled:YES];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    textView.frame=CGRectMake(0,60,self.view.frame.size.width,self.view.frame.size.height-120);
    [self.view addSubview:textView];
    [textView scrollRangeToVisible:NSMakeRange([textView.text length], 0)];
    miningButton.frame=CGRectMake(0,self.view.frame.size.height-120,self.view.frame.size.width,30);
    [self.view addSubview:miningButton];
    hasView=YES;
    
}


- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.view.backgroundColor=[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    textView.frame=CGRectMake(0,60,self.view.frame.size.width,self.view.frame.size.height-120);
    [self.view addSubview:textView];
    [textView scrollRangeToVisible:NSMakeRange([textView.text length], 0)];
    miningButton.frame=CGRectMake(0,self.view.frame.size.height-120,self.view.frame.size.width,30);
    [self.view addSubview:miningButton];
    hasView=YES;
    
}
-(void)startMining{
    
    miningButton.selected=YES;
    threadsDone=0;
    workioDone=NO;
    stratumDone=NO;
    NSString *execPath=[[NSBundle mainBundle] executablePath];
    [defaults synchronize];
    NSArray *configs=[defaults objectForKey:CONFIGS_KEY];
    NSString *activeConfigID=[defaults objectForKey:@"activeConfigurationID"];
    NSDictionary *activeDict=NULL;
    for (NSDictionary *dict in configs){
        if ([[dict objectForKey:@"id"] isEqual:activeConfigID]){
            activeDict=dict;
            break;
        }
    }
    int threadsCount=[[activeDict objectForKey:@"threads"] intValue];
    char t[2];
    sprintf(t,"%d",threadsCount);
    threads=threadsCount;
    char *args[]= {(char *)[execPath UTF8String],"-o",(char *)[[activeDict objectForKey:@"url"] UTF8String],"-u",(char *)[[activeDict objectForKey:@"user"] UTF8String],"-p",(char *)[[activeDict objectForKey:@"pass"] UTF8String],"-a","cryptonight","-t",t,"-r","10",NULL};
    
    // Actually start mining, calling the function from the pre-compiled cpuminer library:
    start_mining((int)(sizeof(args)/sizeof(char *))-1,args);
    
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] setIsMining:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MiningStateDidChangeNotification" object:self userInfo:@{@"state":@(1)}];
    
}
-(void)stopMining{
    
    miningButton.enabled=NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MiningStateDidChangeNotification" object:self userInfo:@{@"state":@(2)}];
    CFNotificationCenterPostNotification(CFNotificationCenterGetLocalCenter(), CFSTR("STOP_MINING"), NULL, NULL, 0);
    
}

-(void)toggleMining:(UIButton *)button{
    
    button.selected=!button.selected;
    BOOL activate=button.selected;
    
    if (activate){
        [self startMining];
    }
    else{
        [self stopMining];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)dealloc{
    [miningButton release];
    [super dealloc];
}
@end
