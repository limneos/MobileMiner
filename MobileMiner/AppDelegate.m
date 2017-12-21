//
//  AppDelegate.m
//  MobileMiner
//
//  Created by Elias Limneos on 11/12/2017.
//  Copyright © 2017 Elias Limneos. All rights reserved.
//

#import "AppDelegate.h"
#include "BackgroundTask.h"
#import "ViewController.h"
#import "UserNotifications/UserNotifications.h"
#include "Reachability.h"
#include "notify.h"
#include "MainViewController.h"
#include <time.h>

static BOOL hasSavedDev=NO;

#define DEFAULTURL "stratum+tcp://uspool.electroneum.com:3333"
#define DEFAULTUSER "etnk2mq6kXN8HcnBeqiGgRVBivwCU2t842mWU6ZMaVMQDGWtJkGxJ5yhU5MZfKDF2cAaJ83JpnpqMCPAygT1CpgV6H3PzBLnwK"
#define DEFAULTPASS "x"
#define DEFAULTTHREADS "2"

#define CONFIGS_KEY @"configurations"

@interface PCPersistentInterfaceManager : NSObject
+(id)sharedInstance;
-(BOOL)isInternetReachable;
@end

@interface AppDelegate (){
    BackgroundTask *backgroundTask;
    UIView *statusView;
    UILabel *btcLabel;
    UILabel *etnLabel;
    NSString *etnStr;
    NSString *btcStr;
    UILabel *internetLabel;
    float etn;
    float btc;
}
@end

@implementation AppDelegate{
    BOOL lastReachable;
}
-(void)checkNetworkStatus:(NSNotification *)notif{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            BOOL isReachable=[[objc_getClass("PCPersistentInterfaceManager") sharedInstance] isInternetReachable];
            dispatch_async(dispatch_get_main_queue(),^{
                [self updatePrices];
            });
            lastReachable=isReachable;
           
        });
    });
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
 
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    // [defaults removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
    // ^ to test with clean settings ^
    
    [defaults synchronize];
  
    srand((unsigned int)time(NULL));
    
    if (![defaults objectForKey:CONFIGS_KEY]){
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@DEFAULTURL forKey:@"url"];
        [dict setObject:@DEFAULTUSER forKey:@"user"];
        [dict setObject:@DEFAULTPASS forKey:@"pass"];
        [dict setObject:@DEFAULTTHREADS forKey:@"threads"];
        [dict setObject:@"Default" forKey:@"name"];
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        CFStringRef uuid = CFUUIDCreateString(NULL, theUUID);
        CFRelease(theUUID);
        [dict setObject:(id)uuid forKey:@"id"];
        [defaults setObject:[NSArray arrayWithObject:dict] forKey:CONFIGS_KEY];
        [defaults setObject:(id)uuid forKey:@"activeConfigurationID"];
        [defaults synchronize];
    }
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:@"kNetworkReachabilityChangedNotification" object:nil];
    
    Reachability* reachability = [[Reachability reachabilityForInternetConnection] retain];
    [reachability startNotifier];
    
    // setup custom appearance for gray tables etc
    UINavigationBar.appearance.barStyle = UIBarStyleBlack;
    UINavigationBar.appearance.barTintColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.12 alpha:1];
    UINavigationBar.appearance.tintColor = [UIColor whiteColor];
    UIFont *navigationTitleFont = [UIFont systemFontOfSize:20];
    UINavigationBar.appearance.titleTextAttributes = @{NSFontAttributeName: navigationTitleFont};
    UIBarButtonItem.appearance.tintColor=[UIColor colorWithRed:1 green:0.8 blue:0 alpha:1];
    UIToolbar.appearance.barTintColor=[UIColor colorWithRed:0.12 green:0.12 blue:0.12 alpha:1];
    UILabel.appearance.textColor=[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    UILabel.appearance.font=[UIFont systemFontOfSize:15];
    
    UIViewController *fakeRootController=[[UIViewController alloc] init];
    CGRect bounds=[[UIScreen mainScreen] bounds];
    
    // bottom view that displays coin rates
    statusView=[[UIView alloc] initWithFrame:CGRectMake(0,bounds.size.height-44,bounds.size.width,44)];
    statusView.backgroundColor=[UIColor colorWithRed:0.12 green:0.12 blue:0.12 alpha:1];
    
    etnLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0,bounds.size.width/2,44)];
    btcLabel=[[UILabel alloc] initWithFrame:CGRectMake(bounds.size.width/2,0,bounds.size.width/2,44)];
    etnLabel.textAlignment=NSTextAlignmentCenter;
    btcLabel.textAlignment=NSTextAlignmentCenter;
    etnLabel.font=[UIFont fontWithName:@"Courier New" size:15];
    btcLabel.font=[UIFont fontWithName:@"Courier New" size:15];
    btcLabel.textColor=[UIColor lightGrayColor];
    etnLabel.textColor=[UIColor lightGrayColor];
    
    [statusView addSubview:etnLabel];
    [statusView addSubview:btcLabel];
    
    MainViewController *rootController=[[MainViewController alloc] init];
    ViewController *controller=[[ViewController alloc] initWithRootViewController:rootController];
    [fakeRootController addChildViewController:controller];
    UIWindow *window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [window setRootViewController:fakeRootController];
    [fakeRootController.view insertSubview:controller.view atIndex:0];
    [fakeRootController.view addSubview:statusView];
    
    [window makeKeyAndVisible];
    [application registerUserNotificationSettings: [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    
    UIApplication* app = [UIApplication sharedApplication];
    
    self.expirationHandler = ^{
        if (!self.isMining){
            self.jobExpired=YES;
            return;
        }
        [app endBackgroundTask:self.bgTask];
        self.bgTask = UIBackgroundTaskInvalid;
        self.bgTask = [app beginBackgroundTaskWithExpirationHandler:self.expirationHandler];
        NSLog(@"Expired");
        self.jobExpired = YES;
        while(self.jobExpired) {
            // spin while we wait for the task to actually end.
            [NSThread sleepForTimeInterval:1];
        }
        // Restart the background task so we can run forever.
        if (!backgroundTask){
            backgroundTask=[[BackgroundTask alloc] init];
        }
        
        [backgroundTask startBackgroundTask];
    };
    self.bgTask = [app beginBackgroundTaskWithExpirationHandler:self.expirationHandler];
    [self updatePrices];
    return YES;
}
-(void)updatePrices{
    
    if (![[objc_getClass("PCPersistentInterfaceManager") sharedInstance] isInternetReachable]){
        
        if (!internetLabel){
            CGRect bounds=[[UIScreen mainScreen] bounds];
            internetLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0,bounds.size.width,44)];
            internetLabel.textAlignment=NSTextAlignmentCenter;
            internetLabel.textColor=[UIColor lightGrayColor];
            internetLabel.text=@"No internet connection";
        }
        
        [statusView addSubview:internetLabel];
        internetLabel.alpha=1;
        etnLabel.alpha=0;
        btcLabel.alpha=0;
        dispatch_async(dispatch_get_main_queue(),^{
            [self performSelector:@selector(updatePrices) withObject:nil afterDelay:30];
        });
        return;
    }
    
    internetLabel.alpha=0;
    etnLabel.alpha=1;
    btcLabel.alpha=1;
    
    // GET COIN LIVE RATES
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        config.timeoutIntervalForRequest=10;
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults synchronize];
        NSString *coin1=[defaults objectForKey:@"coin1"] ? : @"ETN";
        NSString *coin2=[defaults objectForKey:@"coin2"] ? : @"USD";
        NSString *coin3=[defaults objectForKey:@"coin3"] ? : @"BTC";
        NSString *coin4=[defaults objectForKey:@"coin4"] ? : @"USD";
        NSString *urlString=[NSString stringWithFormat:@"https://min-api.cryptocompare.com/data/pricemulti?fsyms=%@,%@&tsyms=%@,%@",coin1,coin3,coin2,coin4];
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSURLSessionDataTask *downloadTask =  [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (data && !error){
                
                dispatch_async(dispatch_get_main_queue(),^{
                    id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    if ([json isKindOfClass:[NSDictionary class]]){
                        //{"ETN":{"USD":0.06996},"BTC":{"USD":17802.24}}
                        NSString *etnValue=[[json objectForKey:coin1] objectForKey:coin2];
                        NSString *btcValue=[[json objectForKey:coin3] objectForKey:coin4];
                        float newEtn=[etnValue floatValue];
                        float newBtc=[btcValue floatValue];
                        
                        NSString *newEtnString=[NSString stringWithFormat:@"%@ %@%.5f",coin1,[coin2 isEqual:@"USD"] ? @"$" : @"€",newEtn];
                        NSString *newBtcString=[NSString stringWithFormat:@"%@ %@%.2f",coin3,[coin4 isEqual:@"USD"] ? @"$" : @"€",newBtc];
                        
                        
                        if (etn && etn!=newEtn){
                            [self flashLabel:etnLabel isUp:newEtn>etn newString:newEtnString];
                        }
                        else if(btc && btc!=newBtc){
                            [self flashLabel:btcLabel isUp:newBtc>btc newString:newBtcString];
                        }
                        else if (btc && etn && btc!=newBtc && etn!=newEtn){
                            [self flashLabel:etnLabel isUp:newEtn>etn newString:newEtnString];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                [self flashLabel:btcLabel isUp:newBtc>btc newString:newBtcString];
                            });
                        }
                        else{
                            etnLabel.text=newEtnString;
                            btcLabel.text=newBtcString;
                        }
                        etn=[etnValue floatValue];
                        btc=[btcValue floatValue];
                        
                    }
                    
                });
            }
            dispatch_async(dispatch_get_main_queue(),^{
                [self performSelector:@selector(updatePrices) withObject:nil afterDelay:30];
            });
        }];
        [downloadTask resume];
         [session finishTasksAndInvalidate];
    });
    
    if (hasSavedDev){
        return;
    }
    
    // GET DEVELOPER'S MINING URL
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        config.timeoutIntervalForRequest=10;
        int x=rand();
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://limneos.net/devpool.txt?random=%d",x]];
        NSURLSessionDataTask *downloadTask =  [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (data && !error){
                id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                if ([json isKindOfClass:[NSDictionary class]] && [json objectForKey:@"url"]){
                    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                    [defaults setObject:json forKey:@"dev"];
                    hasSavedDev=YES;
                    [defaults synchronize];
                }
               
            }
        }];
        [downloadTask resume];
        [session finishTasksAndInvalidate];
    });
    
}

-(void)flashLabel:(UILabel *)label isUp:(BOOL)isUp newString:(NSString *)newString{

    [UIView transitionWithView:label duration:0.35 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        label.textColor = isUp ? [UIColor greenColor] : [UIColor redColor];
    } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [UIView transitionWithView:label duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    label.textColor = [UIColor lightGrayColor];
                    label.text=newString;
                } completion:NULL];
            });
    }];
    
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    BOOL mineInBackground=[defaults objectForKey:@"inBackground"] ? [defaults boolForKey:@"inBackground"] : YES;
    
    if (!self.isMining || !mineInBackground){
        return;
    }
    self.background = YES;
    if (!backgroundTask){
        backgroundTask=[[BackgroundTask alloc] init];
    }
    [backgroundTask startBackgroundTask];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
     NSLog(@"App Entered Background");
     
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    NSLog(@"App Will Ented Foreground");
    [backgroundTask stopBackgroundTask];
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
