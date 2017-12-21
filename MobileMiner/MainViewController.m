//
//  SetupViewController.m
//  MobileMiner
//
//  Created by Elias Limneos on 14/12/2017.
//  Copyright © 2017 Elias Limneos. All rights reserved.
//

#include "CustomCell.h"
#include "AddConfigurationViewController.h"
#include "LogViewController.h"
#include "AppDelegate.h"
#include "ManageConfigurationController.h"
#include "LicenseViewController.h"
#include <objc/runtime.h>

#define CONFIG_KEY @"configurations"

@interface PCPersistentInterfaceManager : NSObject
+(id)sharedInstance;
-(BOOL)isInternetReachable;
@end

@interface DisclaimerViewController : UIViewController
@end

@interface InfoLabel : UILabel
@end

@interface CurrencyController : GrayTableController
@end

@interface SettingsNavigationController : UINavigationController
@end

@interface MainViewController: UIViewController
@end

@interface SettingsController : GrayTableController
@end


@implementation InfoLabel
-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]){
        self.textAlignment=NSTextAlignmentLeft;
        self.textColor=UIColor.whiteColor;
        self.font=[UIFont fontWithName:@"Courier New" size:14];
        
    }
    return self;
}
@end


@implementation DisclaimerViewController
-(id)title{
    return @"Disclaimer";
}
-(void)viewDidLoad{
    
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1];
    UITextView *textView=[[UITextView alloc] initWithFrame:CGRectMake(0,60,self.view.frame.size.width,self.view.frame.size.height-60)];
    textView.backgroundColor=[UIColor clearColor];
    textView.textColor=[UIColor whiteColor];
    textView.editable=NO;
    NSString *licensePath=[[NSBundle mainBundle] pathForResource:@"Disclaimer" ofType:@"txt"];
    textView.text=[NSString stringWithContentsOfFile:licensePath encoding:NSUTF8StringEncoding error:NULL];
    [self.view addSubview:textView];
    
}
@end

@interface DonationsViewController : UIViewController
@end

@implementation DonationsViewController{
    
    InfoLabel *donateLabel;
    InfoLabel *etnTitle;
    InfoLabel *xmrTitle;
    InfoLabel *btcTitle;
    InfoLabel *etnAddress;
    InfoLabel *xmrAddress;
    InfoLabel *btcAddress;
    InfoLabel *copyrightLabel;
    UILabel *label;
    UIView *copied;
    
}
-(void)viewDidLoad{
    
    self.view.backgroundColor=[UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1];
    UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissMe:)];
    self.navigationItem.rightBarButtonItem=right;
    [right release];
    
    donateLabel=[[InfoLabel alloc] initWithFrame:CGRectMake(20,80,self.view.frame.size.width-40,70)];
    donateLabel.textAlignment=NSTextAlignmentCenter;
    donateLabel.numberOfLines=3;
    donateLabel.font=[UIFont systemFontOfSize:18];
    donateLabel.text=@"You can donate anything you wish for the job done on iOS devices to the following addresses:";
    [self.view addSubview:donateLabel];
    
    etnTitle=[[InfoLabel alloc] initWithFrame:CGRectMake(20,150+20,self.view.frame.size.width-40,30)];
    etnTitle.textAlignment=NSTextAlignmentLeft;
    etnTitle.font=[UIFont systemFontOfSize:15];
    etnTitle.text=@"Electroneum (ETN):";
    [self.view addSubview:etnTitle];
    
    etnAddress=[[InfoLabel alloc] initWithFrame:CGRectMake(20,180+20,self.view.frame.size.width-40,70)];
    etnAddress.textAlignment=NSTextAlignmentLeft;
    etnAddress.backgroundColor=[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1];
    etnAddress.font=[UIFont fontWithName:@"Courier New" size:15];
    etnAddress.numberOfLines=3;
    etnAddress.userInteractionEnabled=YES;
    etnAddress.text=@"etnk2mq6kXN8HcnBeqiGgRVBivwCU2t842mWU6ZMaVMQDGWtJkGxJ5yhU5MZfKDF2cAaJ83JpnpqMCPAygT1CpgV6H3PzBLnwK";
    [self.view addSubview:etnAddress];
 
    
    xmrTitle=[[InfoLabel alloc] initWithFrame:CGRectMake(20,255+20,self.view.frame.size.width-40,30)];
    xmrTitle.textAlignment=NSTextAlignmentLeft;
    xmrTitle.font=[UIFont systemFontOfSize:15];
    xmrTitle.text=@"Monero (XMR):";
    [self.view addSubview:xmrTitle];
    
    xmrAddress=[[InfoLabel alloc] initWithFrame:CGRectMake(20,285+20,self.view.frame.size.width-40,70)];
    xmrAddress.textAlignment=NSTextAlignmentLeft;
    xmrAddress.backgroundColor=[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1];
    xmrAddress.font=[UIFont fontWithName:@"Courier New" size:15];
    xmrAddress.numberOfLines=3;
    xmrAddress.userInteractionEnabled=YES;
    xmrAddress.text=@"43gCzqEcBGjekvGebWxnymRcduiCsrUDDXqyoarLgFcr57Pp6jTwHaPebD3e8vQsfgSmx5xGbECP165YikELq8VP3GhyUCK";
    [self.view addSubview:xmrAddress];
    
    btcTitle=[[InfoLabel alloc] initWithFrame:CGRectMake(20,360+20,self.view.frame.size.width-40,30)];
    btcTitle.textAlignment=NSTextAlignmentLeft;
    btcTitle.font=[UIFont systemFontOfSize:15];
    btcTitle.text=@"Bitcoin (BTC):";
    [self.view addSubview:btcTitle];
    
    btcAddress=[[InfoLabel alloc] initWithFrame:CGRectMake(20,390+20,self.view.frame.size.width-40,30)];
    btcAddress.textAlignment=NSTextAlignmentLeft;
    btcAddress.backgroundColor=[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1];
    btcAddress.font=[UIFont fontWithName:@"Courier New" size:15];
    btcAddress.numberOfLines=3;
    btcAddress.userInteractionEnabled=YES;
    btcAddress.text=@"1AKcSN1psy1uYKgWwuPtM4P6Mf6xt7rbs3";
    [self.view addSubview:btcAddress];
    
    UITapGestureRecognizer *longer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(copyLabelText:)];
    [etnAddress addGestureRecognizer:longer];
    [longer release];
    
    
    UITapGestureRecognizer *longer2=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(copyLabelText:)];
    [xmrAddress addGestureRecognizer:longer2];
    [longer2 release];
    
    
    UITapGestureRecognizer *longer3=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(copyLabelText:)];
    [btcAddress addGestureRecognizer:longer3];
    [longer3 release];
    
    
    copyrightLabel=[[InfoLabel alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-60,self.view.frame.size.width,20)];
    copyrightLabel.textAlignment=NSTextAlignmentCenter;
    copyrightLabel.font=[UIFont systemFontOfSize:15];
    copyrightLabel.textColor=[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    copyrightLabel.text=@"Copyright © 2017 Elias Limneos";
    [self.view addSubview:copyrightLabel];
    
}
-(id)title{
    return @"Donate";
}
-(void)dismissMe:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        [[self navigationController] release];
        [self release];
    }];
}
-(void)dealloc{
    
    [donateLabel release];
    [etnAddress release];
    [xmrAddress release];
    [btcAddress release];
    [etnTitle release];
    [xmrTitle release];
    [btcTitle release];
    [label release];
    [copied release];
    [copyrightLabel release];
    [super dealloc];
    
}
-(void)copyLabelText:(UILongPressGestureRecognizer *)sender{
    
    if (sender.state==UIGestureRecognizerStateEnded){
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        [pb setString:((UILabel *)sender.view).text];
        if (!copied){
            copied=[[UIView alloc] initWithFrame:CGRectMake(0,-60,self.view.frame.size.width,60)];
            copied.backgroundColor=[UIColor colorWithRed:1 green:0.8 blue:0 alpha:1];
            copied.layer.cornerRadius=15;
            copied.layer.masksToBounds=YES;
            label=[[UILabel alloc] initWithFrame:CGRectMake(0,10,self.view.frame.size.width,40)];
            label.textAlignment=NSTextAlignmentCenter;
            label.text=@"Copied!";
            label.font=[UIFont boldSystemFontOfSize:27];
            label.textColor=[UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1];
            [copied addSubview:label];
        }
        
        copied.frame=CGRectMake(0,-60,self.view.frame.size.width,60);
        [self.view.window addSubview:copied];
        [UIView animateWithDuration:0.28 animations:^{
            
            copied.frame=CGRectMake(0,0,self.view.frame.size.width,60);
            
        } completion:^(BOOL completed){
            
            [UIView animateWithDuration:0.18 delay:1 options:0 animations:^{
                copied.frame=CGRectMake(0,-60,self.view.frame.size.width,60);
            } completion:^(BOOL completed){
                
                [copied removeFromSuperview];
            }];
            
        }];
    }
}
@end

float cpu_percentage( unsigned int cpu_usage_delay );
int getloadavg (double loadavg[], int nelem);

@interface CurrencyListController : GrayTableController
@property (nonatomic, retain) CustomCell *infoCell;
@property (nonatomic, retain) NSString *key;
@end

@implementation CurrencyListController{
    NSUserDefaults *defaults;
}
-(id)initWithCell:(CustomCell *)acell{
    if (self=[super init]){
        self.infoCell=acell;
        defaults=[[NSUserDefaults standardUserDefaults] retain];
        [defaults synchronize];
        if ([[self.infoCell reuseIdentifier] rangeOfString:@"0-1"].location!=NSNotFound){
            self.key=@"coin1";
        }
        if ([[self.infoCell reuseIdentifier] rangeOfString:@"0-2"].location!=NSNotFound){
            self.key=@"coin2";
        }
        if ([[self.infoCell reuseIdentifier] rangeOfString:@"0-5"].location!=NSNotFound){
            self.key=@"coin3";
        }
        if ([[self.infoCell reuseIdentifier] rangeOfString:@"0-6"].location!=NSNotFound){
            self.key=@"coin4";
        }
        if (![defaults objectForKey:self.key]){
             if ([[self.infoCell reuseIdentifier] rangeOfString:@"0-2"].location!=NSNotFound || [[self.infoCell reuseIdentifier] rangeOfString:@"0-6"].location!=NSNotFound){
                 [defaults setObject:@"USD" forKey:self.key];
             }
            else if ([[self.infoCell reuseIdentifier] rangeOfString:@"0-1"].location!=NSNotFound ){
                [defaults setObject:@"ETN" forKey:self.key];
            }
            else{
                [defaults setObject:@"BTC" forKey:self.key];
            }
            
        }
    }
    return self;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomCell *cell=(CustomCell *)[tableView cellForRowAtIndexPath:indexPath];
    [defaults setObject:cell.textLabel.text forKey:self.key];
    [defaults synchronize];
    cell.accessoryType=UITableViewCellAccessoryCheckmark;
    for (int i=0; i<[self tableView:tableView numberOfRowsInSection:indexPath.section]; i++){
        CustomCell *innerCell=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
        if (![innerCell isEqual:cell]){
            innerCell.accessoryType=UITableViewCellAccessoryNone;
        }
    }
    self.infoCell.detailTextLabel.text=cell.textLabel.text;
    GrayTableController *controller=(GrayTableController *)[[self navigationController] popViewControllerAnimated:YES];
    [[controller tableView] reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[self.infoCell reuseIdentifier] rangeOfString:@"0-1"].location!=NSNotFound || [[self.infoCell reuseIdentifier] rangeOfString:@"0-5"].location!=NSNotFound){
        return 5;
    }
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomCell *cell=(CustomCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([[self.infoCell reuseIdentifier] rangeOfString:@"0-1"].location!=NSNotFound || [[self.infoCell reuseIdentifier] rangeOfString:@"0-5"].location!=NSNotFound){
        switch(indexPath.row){
            case 0:
                cell.textLabel.text=@"ETN";
                cell.detailTextLabel.text=@"Electroneum";
                break;
            case 1:
                cell.textLabel.text=@"XMR";
                cell.detailTextLabel.text=@"Monero";
                break;
            case 2:
                cell.textLabel.text=@"BTC";
                cell.detailTextLabel.text=@"Bitcoin";
                break;
            case 3:
                cell.textLabel.text=@"ETH";
                cell.detailTextLabel.text=@"Etherium";
                break;
            case 4:
                cell.textLabel.text=@"LTC";
                cell.detailTextLabel.text=@"Litecoin";
                break;
        }
    }
    else{
        switch(indexPath.row){
            case 0:
                cell.textLabel.text=@"USD";
                cell.detailTextLabel.text=@"US Dollars";
                break;
            case 1:
                cell.textLabel.text=@"EUR";
                cell.detailTextLabel.text=@"Euros";
                break;
        }
    }
    cell.hasSeparator=YES;
    cell.accessoryType=[[defaults objectForKey:self.key] isEqual:cell.textLabel.text] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}
-(id)title{
    return @"Choose Coin";
}
-(void)dealloc{
    [defaults release];
    [super dealloc];
}
@end









@implementation CurrencyController
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}
-(id)title{
    return @"Live Rates";
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0 || indexPath.row==3 || indexPath.row==4){
        return 35;
    }
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    if (indexPath.row==1  ||indexPath.row==2 ||indexPath.row==5 ||indexPath.row==6){
        CurrencyListController *listController=[[CurrencyListController alloc] initWithCell:[tableView cellForRowAtIndexPath:indexPath]];
        [[self navigationController] pushViewController:listController animated:YES];
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomCell *cell=(CustomCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    
    if (indexPath.row==0){
        cell.textLabel.text=@"Bottom Left Label";
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    if (indexPath.row==3){
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    if (indexPath.row==4){
        cell.textLabel.text=@"Bottom Right Label";
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    if (indexPath.row==1){
        cell.textLabel.text=@"From";
        cell.detailTextLabel.text=[defaults objectForKey:@"coin1"] ? : @"ETN";
        cell.hasSeparator=YES;
    }
    if (indexPath.row==2){
        cell.textLabel.text=@"To";
        cell.detailTextLabel.text=[defaults objectForKey:@"coin2"] ? : @"USD";
        cell.hasSeparator=YES;
    }
    
    if (indexPath.row==5){
        cell.textLabel.text=@"From";
        cell.detailTextLabel.text=[defaults objectForKey:@"coin3"] ? : @"BTC";
        cell.hasSeparator=YES;
    }
    if (indexPath.row==6){
        cell.textLabel.text=@"To";
        cell.detailTextLabel.text=[defaults objectForKey:@"coin4"] ? : @"USD";
        cell.hasSeparator=YES;
    }
    
    return (CustomCell *)cell;
}
@end

@implementation SettingsNavigationController
@end


@implementation SettingsController
{
    id viewController;
    NSUserDefaults *defaults;
    ManageConfigurationController *readOnlyConfigurationController;
    ManageConfigurationController *configurationController;
    LicenseViewController *licenseController;
    DisclaimerViewController *disclaimerController;
    CurrencyController *currencyController;
}
-(id)initFromViewController:(id)inViewController{
    if (self=[super init]){
        viewController=inViewController;
        defaults=[[NSUserDefaults standardUserDefaults] retain];
        [defaults synchronize];
    }
    return self;
}
-(void)viewDidLoad{
    
    [super viewDidLoad];
    UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissMe:)];
    self.navigationItem.rightBarButtonItem=right;
    [right release];
    self.tableView.separatorColor=[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
    UIBlurEffect *blurEffect=[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.tableView.separatorEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    
}

-(void)dismissMe:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        [[self navigationController] release];
        [self release];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(id)title{
    return @"Settings";
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==2 || indexPath.row==5 || indexPath.row==7){
        return 40;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row==0){
        if (!readOnlyConfigurationController){
            readOnlyConfigurationController=[[ManageConfigurationController alloc] initReadOnly];
        }
        [[self navigationController] pushViewController:readOnlyConfigurationController animated:YES];
    }
    if (indexPath.row==1){
        if (!configurationController){
            configurationController=[[ManageConfigurationController alloc] init];
        }
        [[self navigationController] pushViewController:configurationController animated:YES];
    }
    if (indexPath.row==6){
        if (!currencyController){
            currencyController=[[CurrencyController alloc] init];
        }
        [[self navigationController] pushViewController:currencyController animated:YES];
    }
    if (indexPath.row==8){
        if (!licenseController){
            licenseController=[[LicenseViewController alloc] init];
        }
        [[self navigationController] pushViewController:licenseController animated:YES];
    }
    if (indexPath.row==9){
        if (!disclaimerController){
            disclaimerController=[[DisclaimerViewController alloc] init];
        }
        [[self navigationController] pushViewController:disclaimerController animated:YES];
    }
}
-(unsigned long)configurationsCount{
    return [[defaults objectForKey:CONFIG_KEY] count];
}
-(id)activeConfigurationName{
    NSString *activeID=[defaults objectForKey:@"activeConfigurationID"];
    for (NSDictionary *dict in [defaults objectForKey:CONFIGS_KEY]){
        if ([[dict objectForKey:@"id"] isEqual:activeID] ){
            return [dict objectForKey:@"name"];
        }
    }
    return NULL;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomCell *cell=(CustomCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row==0){
        cell.textLabel.text=@"Active Configuration";
        cell.detailTextLabel.text=[self activeConfigurationName] ?: @"!Not found!";
        cell.hasSeparator=YES;
    }
    
    else if (indexPath.row==1){
        cell.textLabel.text=@"Edit Configurations";
        cell.detailTextLabel.text= [self configurationsCount] == 1 ? @"1 Configuration"  : [NSString stringWithFormat: @"%lu Configurations", [self configurationsCount] ];
        cell.hasSeparator=YES;
    }
    else if (indexPath.row==2 || indexPath.row==5 || indexPath.row==7 ) {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
    else if (indexPath.row==3){
        cell.textLabel.text=@"Keep Alive in Background";
        cell.detailTextLabel.text=@"Force-keep running in background";
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        switchView.onTintColor=[UIColor colorWithRed:1 green:0.8 blue:0 alpha:1];
        cell.accessoryView = switchView;
        BOOL isOn = [defaults objectForKey:@"inBackground"] ?  [defaults boolForKey:@"inBackground"] : YES;
        [switchView setOn:isOn animated:NO];
        [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        [switchView release];
        cell.hasSeparator=YES;
    }
    else if (indexPath.row==4){
        cell.textLabel.text=@"Allow Notifications";
        cell.detailTextLabel.text=@"Status updates while backgrounded";
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        switchView.onTintColor=[UIColor colorWithRed:1 green:0.8 blue:0 alpha:1];
        cell.accessoryView = switchView;
        cell.hasSeparator=YES;
        
        BOOL isOn = [defaults objectForKey:@"sendNotifications"] ?  [defaults boolForKey:@"sendNotifications"] : YES;
        [switchView setOn:isOn animated:NO];
        [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        [switchView release];
    }
    else if (indexPath.row==6){
        cell.textLabel.text=@"Live Currency Rates";
        cell.detailTextLabel.text=@"Setup currencies to monitor";
        cell.hasSeparator=YES;
        //cell.detailTextLabel.text= [self configurationsCount] == 1 ? @"1 Configuration"  : [NSString stringWithFormat: @"%lu Configurations", [self configurationsCount] ];
    }
    
    else if (indexPath.row==8){
        cell.textLabel.text=@"License";
        cell.hasSeparator=YES;
        //cell.detailTextLabel.text= [self configurationsCount] == 1 ? @"1 Configuration"  : [NSString stringWithFormat: @"%lu Configurations", [self configurationsCount] ];
    }
    else if (indexPath.row==9){
        cell.textLabel.text=@"Disclaimer";
        cell.hasSeparator=YES;
        //cell.detailTextLabel.text= [self configurationsCount] == 1 ? @"1 Configuration"  : [NSString stringWithFormat: @"%lu Configurations", [self configurationsCount] ];
    }
    return (UITableViewCell*)cell;
    
}
-(int)rowForSwitchControl:(UISwitch *)sender{
    
    for (int i=0; i<[[self tableView] numberOfRowsInSection:0]; i++){
        UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if ([cell.accessoryView isEqual:sender]){
            return i;
        }
    }
    return -1;
}
-(void)switchChanged:(UISwitch *)sender{
    //NSLog(@"SWITCH CHANGED %@",sender);
    //NSLog(@"INDEXPATH %@",[self.tableView indexPathForCell:(UITableViewCell *)sender.superview]);
    if ([self rowForSwitchControl:sender]==4){
        [defaults setBool:sender.on forKey:@"inBackground"];
        [defaults synchronize];
    }
    if ([self rowForSwitchControl:sender]==4){
        [defaults setBool:sender.on forKey:@"sendNotifications"];
        [defaults synchronize];
    }
    
}

-(void)dealloc{
    [defaults release];
    [super dealloc];
}
@end

 

@implementation MainViewController{
   
    UIView *activeView;
    InfoLabel *nameLabel;
    InfoLabel *nameValue;
    InfoLabel *urlLabel;
    InfoLabel *urlValue;
    InfoLabel *userLabel;
    InfoLabel *userValue;
    InfoLabel *passLabel;
    InfoLabel *passValue;
    InfoLabel *threadsLabel;
    InfoLabel *threadsValue;
    InfoLabel *confLabel;
    InfoLabel *infoLabel;
    UIButton *mineButton;
    LogViewController *mineController;
    InfoLabel *statusLabel;
    InfoLabel *hashesLabel;
    InfoLabel *totalsLabel;
    InfoLabel *diffLabel;
    InfoLabel *hashesValue;
    InfoLabel *totalsValue;
    InfoLabel *uptimeValue;
    InfoLabel *diffValue;
    UIButton *streamButton;
    UIView *statusView;
    int state;
    NSTimeInterval startup;
    int secondsPassed;
    UIView *copied;
    UILabel *detailedLogLabel;
    
    NSDictionary *activeConfig;
}
-(id)init{
    if (self=[super init]){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(miningStateDidChange:) name:@"MiningStateDidChangeNotification" object:NULL];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessage:) name:@"PARSED_MESSAGE" object:NULL];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectivityChanged:) name:@"kNetworkReachabilityChangedNotification" object:NULL];
        
    }
    return self;
    
}
-(void)copyLabelText:(UILongPressGestureRecognizer *)sender{
    
    if (sender.state==UIGestureRecognizerStateBegan){
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        [pb setString:((UILabel *)sender.view).text];
        if (!copied){
            copied=[[UIView alloc] initWithFrame:CGRectMake(0,-60,self.view.frame.size.width,60)];
            copied.backgroundColor=[UIColor colorWithRed:1 green:0.8 blue:0 alpha:1];
            copied.layer.cornerRadius=15;
            copied.layer.masksToBounds=YES;
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0,10,self.view.frame.size.width,40)];
            label.textAlignment=NSTextAlignmentCenter;
            label.text=@"Copied!";
            label.font=[UIFont boldSystemFontOfSize:27];
            label.textColor=[UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1];
            [copied addSubview:label];
        }
        
        copied.frame=CGRectMake(0,-60,self.view.frame.size.width,60);
        [self.view.window addSubview:copied];
        [UIView animateWithDuration:0.28 animations:^{
        
            copied.frame=CGRectMake(0,0,self.view.frame.size.width,60);
            
        } completion:^(BOOL completed){
            
            [UIView animateWithDuration:0.18 delay:1 options:0 animations:^{
                 copied.frame=CGRectMake(0,-60,self.view.frame.size.width,60);
             } completion:^(BOOL completed){
                 
                 [copied removeFromSuperview];
             }];
            
        }];
    }
}
-(void)setConfiguration:(NSDictionary *)configuration{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    activeConfig=configuration;
    [defaults setObject:[configuration objectForKey:@"id"] forKey:@"activeConfigurationID"];
    [defaults synchronize];
    [self.view insertSubview:[self activeView] atIndex:0];
    
    
}
-(id)title{
    return @"MobileMiner";
}
-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1];
   
}
-(void)openDonations:(id)sender{
    UINavigationController *navi=[[UINavigationController alloc] initWithRootViewController:[[DonationsViewController alloc] init]];
    [self presentViewController:navi animated:YES completion:NULL];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
 
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *dictID=[defaults objectForKey:@"activeConfigurationID"];
    for (NSDictionary *dict in [defaults objectForKey:CONFIGS_KEY]){
        if ([[dict objectForKey:@"id"] isEqual:dictID]){
            [self setConfiguration:dict];
            break;
        }
    }
    
    if (!mineButton){
        UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gear"] style:UIBarButtonItemStylePlain target:self action:@selector(openSettings:)];
        self.navigationItem.rightBarButtonItem=right;
        self.navigationItem.rightBarButtonItem.tintColor=[UIColor colorWithRed:1 green:0.8 blue:0 alpha:1];
        [right release];
        
        UIBarButtonItem *left=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"love"] style:UIBarButtonItemStylePlain target:self action:@selector(openDonations:)];
        self.navigationItem.leftBarButtonItem=left;
        self.navigationItem.leftBarButtonItem.tintColor=[UIColor colorWithRed:1 green:0.8 blue:0 alpha:1];
        [left release];
       
        mineButton=[[UIButton buttonWithType:UIButtonTypeCustom] retain];
        BOOL isReachable=[[objc_getClass("PCPersistentInterfaceManager") sharedInstance] isInternetReachable];
        
        [mineButton setTitle:@"Start Mining!" forState:UIControlStateNormal];
        [mineButton setTitle:@"Stop Mining" forState:UIControlStateSelected];
        [mineButton setTitle:@"Stop Mining" forState:(UIControlState)5];
        [mineButton setTitle:isReachable ? @"Stopping..." : @"Cannot Mine" forState:UIControlStateDisabled];
        mineButton.enabled=isReachable || state==1;
        mineButton.titleLabel.font=[UIFont boldSystemFontOfSize:30];
        mineButton.tintAdjustmentMode=UIViewTintAdjustmentModeNormal;
        
        [mineButton setBackgroundImage:[UIImage imageNamed:@"buttonbg"] forState:UIControlStateNormal];
        [mineButton setBackgroundImage:[UIImage imageNamed:@"buttonbg-selected"] forState:UIControlStateSelected];
        [mineButton setBackgroundImage:[UIImage imageNamed:@"buttonbg-selected"] forState:UIControlStateDisabled];
        [mineButton setBackgroundImage:[UIImage imageNamed:@"buttonbg-selected"] forState:(UIControlState)5];

        [mineButton setTitleColor:[UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1] forState:UIControlStateNormal];
        [mineButton setTitleColor:[UIColor colorWithRed:1 green:0.8 blue:0 alpha:1] forState:UIControlStateSelected];
        [mineButton setTitleColor:[UIColor colorWithRed:1 green:0.8 blue:0 alpha:0.5] forState:(UIControlState)5];
        
        [mineButton setTitleColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.7] forState:UIControlStateDisabled];
        
        [mineButton addTarget:self action:@selector(toggleMining:) forControlEvents:UIControlEventTouchUpInside];
        mineButton.frame=CGRectMake(self.view.frame.size.width/2-210/2,self.view.frame.size.height-140,210,40);
        
        infoLabel=[[InfoLabel alloc] initWithFrame:CGRectMake(0,mineButton.frame.origin.y-45,self.view.frame.size.width,30)];
        infoLabel.textColor=[UIColor whiteColor];
        infoLabel.font=[UIFont systemFontOfSize:22];
        infoLabel.textAlignment=NSTextAlignmentCenter;
        infoLabel.adjustsFontSizeToFitWidth=YES;
        infoLabel.text= isReachable ? @"Ready to Start" : @"Please connect to the Internet";
        
        [self.view addSubview:mineButton];
        [self.view addSubview:infoLabel];
        
        statusView=[[UIView alloc] initWithFrame:CGRectZero];
        
        statusView.frame=CGRectMake(20,self.view.frame.size.height/2-200/2,self.view.frame.size.width-40,200);
        statusView.clipsToBounds=YES;
        
        hashesLabel=[[InfoLabel alloc] initWithFrame:CGRectMake(0,40,self.view.frame.size.width,40)];
        totalsLabel=[[InfoLabel alloc] initWithFrame:CGRectMake(0,85,self.view.frame.size.width,40)];
        diffLabel=[[InfoLabel alloc] initWithFrame:CGRectMake(0,130,self.view.frame.size.width,40)];
        statusLabel=[[InfoLabel alloc] initWithFrame:CGRectMake(0,230,self.view.frame.size.width-40,70)];
        statusLabel.numberOfLines=0;
        
        hashesValue=[[InfoLabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-200-40,40,200,40)];
        totalsValue=[[InfoLabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-200-40,85,200,40)];
        diffValue=[[InfoLabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-200-40,130,200,40)];
        uptimeValue=[[InfoLabel alloc] initWithFrame:CGRectMake(0,175,200,40)];
        
        hashesValue.font=[UIFont boldSystemFontOfSize:22];
        totalsValue.font=[UIFont systemFontOfSize:18];
        diffValue.font=[UIFont systemFontOfSize:18];
        diffValue.textColor=[UIColor colorWithRed:15.f/255.f green:83.f/255.f blue:1 alpha:1];
        uptimeValue.font=[UIFont fontWithName:@"Courier New" size:15];
        hashesValue.textColor=[UIColor colorWithRed:0.1 green:0.7 blue:0 alpha:1];
        totalsValue.textColor=[UIColor colorWithRed:151.f/255.f green:197.f/255.f blue:236.f/255.f alpha:1];
        
        hashesValue.textAlignment=NSTextAlignmentRight;
        totalsValue.textAlignment=NSTextAlignmentRight;
        diffValue.textAlignment=NSTextAlignmentRight;
        
        
        streamButton=[[UIButton buttonWithType:UIButtonTypeCustom] retain];
        streamButton.titleLabel.textColor=[UIColor whiteColor];
        streamButton.titleLabel.font=[UIFont systemFontOfSize:15];
        streamButton.titleLabel.textAlignment=NSTextAlignmentRight;
        [streamButton setTitle:@"Hide Stream" forState:UIControlStateNormal];
        [streamButton setTitle:@"Show Stream" forState:UIControlStateSelected];
        [streamButton addTarget:self action:@selector(toggleStream:) forControlEvents:UIControlEventTouchUpInside];
        streamButton.frame=CGRectMake(self.view.frame.size.width-100-35,173,100,40);
        [statusView addSubview:streamButton];
        
        totalsValue.text=@"-";
        hashesValue.text=@"-";
        diffLabel.text=@"Pool Diff:";
        
        hashesLabel.font=[UIFont systemFontOfSize:22];
        totalsLabel.font=[UIFont systemFontOfSize:18];
        diffLabel.font=[UIFont systemFontOfSize:18];
        statusLabel.font=[UIFont fontWithName:@"Courier New" size:13];
        
        hashesLabel.text=@"Hash Rate:";
        totalsLabel.text=@"Accepted:";
       
        statusLabel.text=@"";
        
        [statusView addSubview:hashesLabel];
        [statusView addSubview:totalsLabel];
        [statusView addSubview:diffLabel];
        [statusView addSubview:statusLabel];
        
        [statusView addSubview:hashesValue];
        [statusView addSubview:totalsValue];
        [statusView addSubview:diffValue];
        [statusView addSubview:uptimeValue];
        
        [self.view addSubview:statusView];
        
        detailedLogLabel=[[InfoLabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-100-20,self.view.frame.size.height-80,100,30)];
        detailedLogLabel.textColor=[UIColor whiteColor];
        detailedLogLabel.font=[UIFont systemFontOfSize:15];
        detailedLogLabel.text=@"Log ->";
        detailedLogLabel.alpha=0;
        detailedLogLabel.textAlignment=NSTextAlignmentRight;
        [self.view addSubview:detailedLogLabel];
        detailedLogLabel.userInteractionEnabled=YES;
        [detailedLogLabel sizeToFit];
        detailedLogLabel.frame=CGRectMake(self.view.frame.size.width-detailedLogLabel.frame.size.width-20,self.view.frame.size.height-80,detailedLogLabel.frame.size.width,detailedLogLabel.frame.size.height);
        UITapGestureRecognizer *detailTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDetails:)];
        [detailedLogLabel addGestureRecognizer:detailTap];
        [detailTap release];
        
        statusView.frame=CGRectMake(self.view.frame.size.width/2,self.view.frame.size.height/2,0.0,0.0);
        
    }
    
}
-(void)toggleStream:(UIButton *)button{
    button.selected=!button.selected;
    BOOL showStream=!button.selected;
    statusLabel.alpha=showStream;
}
-(void)showDetails:(id)sender{
    if (!mineController){
        mineController=[[LogViewController alloc] init];
    }
    [[self navigationController] pushViewController:mineController animated:YES];
}
-(void)openSettings:(id)sender{
    SettingsController *ct=[[SettingsController alloc] initFromViewController:self];
    SettingsNavigationController *navi=[[SettingsNavigationController alloc] initWithRootViewController:ct];
    [self presentViewController:navi animated:YES completion:NULL];
}
-(void)connectivityChanged:(NSNotification*)notification{
    
    bool connected=[[objc_getClass("PCPersistentInterfaceManager") sharedInstance] isInternetReachable];
    dispatch_async(dispatch_get_main_queue(),^{
        
        mineButton.enabled=connected || state==1;
        [mineButton setTitle:connected ? @"Stopping..." : @"Cannot Mine" forState:UIControlStateDisabled];
        infoLabel.text=connected ? (state==0 ? @"Ready to Start" : (state==1 ? @"" : @"Waiting for processes to stop...")) : @"Please connect to the Internet";
    });
    
}
-(UIView *)activeView{
    
    if (!activeView){
        
        activeView=[[UIView alloc] initWithFrame:CGRectMake(0,110,self.view.frame.size.width,320)];
        
        confLabel=[[InfoLabel alloc] initWithFrame:CGRectMake(0,-30,self.view.frame.size.width,20)];
        confLabel.font=[UIFont boldSystemFontOfSize:17];
        confLabel.textColor=[UIColor colorWithRed:1 green:0.8 blue:0 alpha:1];
        confLabel.textAlignment=NSTextAlignmentCenter;
        confLabel.text=@"Active Mining Configuration:";
       
        nameLabel=[[InfoLabel alloc] initWithFrame:CGRectMake(20,0,80,30)];
        nameLabel.font=[UIFont boldSystemFontOfSize:15];
        nameValue=[[InfoLabel alloc] initWithFrame:CGRectMake(20,nameLabel.frame.origin.y+26,activeView.frame.size.width-40,17)];
        
        nameValue.backgroundColor=[UIColor colorWithRed:0.23 green:0.23 blue:0.23 alpha:0.7];
        nameValue.layer.borderColor=[[UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:0.6] CGColor];
        nameValue.layer.borderWidth=0.5;
        
        
        urlLabel=[[InfoLabel alloc] initWithFrame:CGRectMake(20,nameValue.frame.origin.y+nameValue.frame.size.height+7,80,30)];
        urlLabel.font=[UIFont boldSystemFontOfSize:15];
        NSString *urlValueStr=[activeConfig objectForKey:@"url"];
        urlValue=[[InfoLabel alloc] initWithFrame:CGRectMake(20,urlLabel.frame.origin.y+26,self.view.frame.size.width-40,(ceil((float)((float)urlValueStr.length/(float)30)))*16)];
        urlValue.numberOfLines=0;
        UILongPressGestureRecognizer *longer=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(copyLabelText:)];
        [urlValue addGestureRecognizer:longer];
        [longer release];
        
        urlValue.lineBreakMode=NSLineBreakByCharWrapping;
        urlValue.backgroundColor=[UIColor colorWithRed:0.23 green:0.23 blue:0.23 alpha:0.7];
        urlValue.layer.borderColor=[[UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:0.6] CGColor];
        urlValue.layer.borderWidth=0.5;
        userLabel=[[InfoLabel alloc] initWithFrame:CGRectMake(20,urlValue.frame.origin.y+urlValue.frame.size.height+7,80,30)];
        userLabel.font=[UIFont boldSystemFontOfSize:15];
        NSString *userValString=[activeConfig objectForKey:@"user"];
        int numberOfUserLines=ceil(userValString.length/30);
        if (numberOfUserLines<1){
            numberOfUserLines=1;
        }
        userValue=[[InfoLabel alloc] initWithFrame:CGRectMake(20,userLabel.frame.origin.y+userLabel.frame.size.height,activeView.frame.size.width-40,(numberOfUserLines)*16)];
        userValue.numberOfLines=0;
        userValue.lineBreakMode=NSLineBreakByWordWrapping;
        
        userValue.backgroundColor=[UIColor colorWithRed:0.23 green:0.23 blue:0.23 alpha:0.7];
        userValue.layer.borderColor=[[UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:0.6] CGColor];
        userValue.layer.borderWidth=0.5;
        urlValue.userInteractionEnabled=YES;
        userValue.userInteractionEnabled=YES;
        UILongPressGestureRecognizer *longer2=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(copyLabelText:)];
        [userValue addGestureRecognizer:longer2];
        [longer2 release];
        
        
        passLabel=[[InfoLabel alloc] initWithFrame:CGRectMake(20,userValue.frame.origin.y+userValue.frame.size.height+7,80,30)];
        passLabel.font=[UIFont boldSystemFontOfSize:15];
        passValue=[[InfoLabel alloc] initWithFrame:CGRectMake(20,passLabel.frame.origin.y+26,activeView.frame.size.width-40,17)];
        
        passValue.backgroundColor=[UIColor colorWithRed:0.23 green:0.23 blue:0.23 alpha:0.7];
        passValue.layer.borderColor=[[UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:0.6] CGColor];
        passValue.layer.borderWidth=0.5;
        
        threadsLabel=[[InfoLabel alloc] initWithFrame:CGRectMake(20,passValue.frame.origin.y+passValue.frame.size.height+7,80,30)];
        threadsLabel.font=[UIFont boldSystemFontOfSize:15];
        threadsValue=[[InfoLabel alloc] initWithFrame:CGRectMake(20,threadsLabel.frame.origin.y+26,activeView.frame.size.width-40,17)];
        threadsValue.backgroundColor=[UIColor colorWithRed:0.23 green:0.23 blue:0.23 alpha:0.7];
        threadsValue.layer.borderColor=[[UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:0.6] CGColor];
        threadsValue.layer.borderWidth=0.5;
        
        nameLabel.text=@"Name:";
        urlLabel.text=@"Pool URL:";
        userLabel.text=@"User:";
        passLabel.text=@"Pass:";
        threadsLabel.text=@"Threads:";
        
        [activeView addSubview:confLabel];
        [activeView addSubview:nameLabel];
        [activeView addSubview:nameValue];
        
        [activeView addSubview:urlLabel];
        [activeView addSubview:urlValue];
        [activeView addSubview:userLabel];
        [activeView addSubview:userValue];
        [activeView addSubview:passLabel];
        [activeView addSubview:passValue];
        [activeView addSubview:threadsLabel];
        [activeView addSubview:threadsValue];
        
       
    }
    
    nameValue.frame=CGRectMake(20,nameLabel.frame.origin.y+26,activeView.frame.size.width-40,17);
    urlLabel.frame=CGRectMake(20,nameValue.frame.origin.y+nameValue.frame.size.height+7,80,30);
    
    NSString *urlValueStr=[activeConfig objectForKey:@"url"];
    urlValue.frame=CGRectMake(20,urlLabel.frame.origin.y+26,self.view.frame.size.width-40,(ceil((float)((float)urlValueStr.length/(float)30)))*16);
    
    NSString *userValString=[activeConfig objectForKey:@"user"];
    int numberOfUserLines=ceil(userValString.length/30);
    if (numberOfUserLines<1){
        numberOfUserLines=1;
    }
    
    userLabel.frame=CGRectMake(20,urlValue.frame.origin.y+urlValue.frame.size.height+7,80,30);
    userValue.frame=CGRectMake(20,userLabel.frame.origin.y+userLabel.frame.size.height,activeView.frame.size.width-40,(numberOfUserLines)*16);
    passLabel.frame=CGRectMake(20,userValue.frame.origin.y+userValue.frame.size.height+7,80,30);
    
    nameValue.text=[activeConfig objectForKey:@"name"];
    urlValue.text=[activeConfig objectForKey:@"url"];
    userValue.text=[activeConfig objectForKey:@"user"];
    passValue.text=[activeConfig objectForKey:@"pass"];
    threadsValue.text=[activeConfig objectForKey:@"threads"];
    passValue.frame=CGRectMake(20,passLabel.frame.origin.y+26,activeView.frame.size.width-40,17);
    threadsLabel.frame=CGRectMake(20,passValue.frame.origin.y+passValue.frame.size.height+7,80,30);
    threadsValue.frame=CGRectMake(20,threadsLabel.frame.origin.y+26,activeView.frame.size.width-40,17);
    
    
    if (state!=0){
        nameLabel.alpha=0;
        nameValue.alpha=0;
        confLabel.alpha=0;
        passLabel.alpha=0;
        passValue.alpha=0;
        threadsLabel.alpha=0;
        threadsValue.alpha=0;
        CGRect frame=activeView.frame;
        frame.origin.y=20;
        activeView.frame=frame;
    }
    return activeView;
}

- (NSString *)timeFormatted:(int)totalSeconds{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}
-(void)updateUptime{
   
    if (state!=0){
        
        dispatch_async(dispatch_get_main_queue(),^{
            uptimeValue.text=[NSString stringWithFormat:@"%@",[self timeFormatted:CFAbsoluteTimeGetCurrent()-startup]];
        });
        secondsPassed++;
        if (secondsPassed>30){
            secondsPassed=0;
            CFNotificationCenterPostNotification(CFNotificationCenterGetLocalCenter(),CFSTR("HASHRATE"),NULL,NULL,0);
        }
        [self performSelector:@selector(updateUptime) withObject:nil afterDelay:1];
    }
}
-(void)miningStateDidChange:(NSNotification *)notification{
    
    //NSLog(@"MINING STATE DID CHAGE %@",notification);
    state=[[[notification userInfo] objectForKey:@"state"] intValue];
    dispatch_async(dispatch_get_main_queue(),^{
    if (state==1){
        secondsPassed=0;
        startup=CFAbsoluteTimeGetCurrent();
        [self updateUptime];
        mineButton.enabled=YES;
        mineButton.selected=YES;
        //mineButton.tintColor=[UIColor colorWithRed:0.1 green:0.7 blue:0.1 alpha:1];
        statusView.frame=CGRectMake(self.view.frame.size.width/2-200/2+100,self.view.frame.size.height/2,0.1,0.1);
        statusView.backgroundColor=[UIColor clearColor];
        UIBlurEffect *blurEffect=[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *v=[[UIVisualEffectView alloc] initWithEffect:blurEffect];
        v.alpha=0.9;
        [statusView addSubview:v];
        v.frame=[[UIScreen mainScreen] bounds];
        
        [UIView animateWithDuration:0.54 animations:^{
            nameLabel.alpha=0;
            nameValue.alpha=0;
            confLabel.alpha=0;
            passLabel.alpha=0;
            passValue.alpha=0;
            threadsLabel.alpha=0;
            threadsValue.alpha=0;
            CGRect frame=activeView.frame;
            frame.origin.y=20;
            activeView.frame=frame;
            
        } completion:^(BOOL ok){
            [UIView animateWithDuration:0.33 animations:^{
                
            v.alpha=0.8;
            statusView.frame=CGRectMake(20,self.view.frame.size.height/2-200/2+100,self.view.frame.size.width-40,2);
            } completion:^(BOOL completed){
                [UIView animateWithDuration:0.24 animations:^{
                    v.alpha=0.0;
                    statusView.frame=CGRectMake(20,self.view.frame.size.height/2-200/2-10,self.view.frame.size.width-40,270);
                } completion:^(BOOL comple){
                    [v removeFromSuperview];
                    [v release];
                  
                }];
            }];
            detailedLogLabel.alpha=1;
            infoLabel.text=@"";
        }];
        
    }
    else if (state==2){
        mineButton.selected=NO;
        mineButton.enabled=NO;
        infoLabel.text=@"Waiting for processes to stop...";
        
    }
    else{
        mineButton.enabled=YES;
        mineButton.selected=NO;
        statusView.frame=CGRectMake(20,self.view.frame.size.height/2-200/2-10,self.view.frame.size.width-40,270);
        [UIView animateWithDuration:0.54 animations:^{
            nameLabel.alpha=1;
            nameValue.alpha=1;
            confLabel.alpha=1;
            passLabel.alpha=1;
            passValue.alpha=1;
            threadsLabel.alpha=1;
            threadsValue.alpha=1;
            CGRect frame=activeView.frame;
            frame.origin.y=110;
            activeView.frame=frame;
            statusView.frame=CGRectMake(self.view.frame.size.width/2,self.view.frame.size.height/2,0.0,0.0);
        } completion:^(BOOL ok){
            totalsValue.text=@"-";
            hashesValue.text=@"-";
            diffLabel.text=@"Pool diff:";
            detailedLogLabel.alpha=0;
            infoLabel.text=@"Ready to Start";
        }];
        
    }
    });
}
-(void)toggleMining:(UIButton *)button{
    
    if (!mineController){
        mineController=[[LogViewController alloc] init];
    }
    
    BOOL isMining=[(AppDelegate*)[[UIApplication sharedApplication] delegate] isMining];
    if (!isMining){
        [mineController startMining];
    }
    else{
        [mineController stopMining];
    }
}
-(void)newMessage:(id)notification{

    dispatch_async(dispatch_get_main_queue(),^{

        
        NSString *text=[[notification object] stringByReplacingOccurrencesOfString:@"%%" withString:@"%%%"];
        
        if ([text rangeOfString:@"Hash rate:"].location!=NSNotFound){
            NSString *hashRate=[text stringByReplacingOccurrencesOfString:@"Hash rate: " withString:@""];
            hashesValue.text=hashRate;
            secondsPassed=0;
         
        }
        if ([text rangeOfString:@"at diff"].location!=NSNotFound){
            
            NSString *diff=[text substringFromIndex:[text rangeOfString:@"at diff"].location+@"at diff ".length];
            diff=[diff stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            diffValue.text=diff;
            
        }
        if ([text rangeOfString:@"set diff to"].location!=NSNotFound){
            
            NSString *diff=[text substringFromIndex:[text rangeOfString:@"set diff to"].location+@"set diff to ".length];
            diff=[diff stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            diffValue.text=diff;
            
        }
        

        if ([text rangeOfString:@"Accepted:"].location!=NSNotFound && [text rangeOfString:@")"].location!=NSNotFound){
            NSString *totalsText=[text substringWithRange:NSMakeRange(9, [text rangeOfString:@")"].location-8)];
            totalsValue.text=totalsText;
            if ([text rangeOfString:@","].location!=NSNotFound && [text rangeOfString:@"/s"].location!=NSNotFound){
                NSString *hashRate=[text substringWithRange:NSMakeRange([text rangeOfString:@","].location+1, [text rangeOfString:@"/s"].location+2-[text rangeOfString:@","].location)];
                hashesValue.text=hashRate;
                secondsPassed=0;
            }
        }
        text=[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([text length]){
            statusLabel.text=text;
            [statusLabel sizeToFit];
            CGRect frame=statusLabel.frame;
            frame.size.width=self.view.frame.size.width-40;
            statusLabel.frame=frame;
        }
    
    });
}
@end
