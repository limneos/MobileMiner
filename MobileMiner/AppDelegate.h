//
//  AppDelegate.h
//  MobileMiner
//
//  Created by Elias Limneos on 11/12/2017.
//  Copyright © 2017 Elias Limneos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) UIBackgroundTaskIdentifier bgTask;
@property (assign, nonatomic) BOOL background;
@property (assign, nonatomic) BOOL sentNotification;
@property (strong, nonatomic) dispatch_block_t expirationHandler;
@property (assign, nonatomic) BOOL jobExpired;
@property (strong, nonatomic) NSUserDefaults* userDefaults;
@property (assign) BOOL isMining;

@end

