//
//  AddViewController.h
//  MobileMiner
//
//  Created by Elias Limneos on 15/12/2017.
//  Copyright © 2017 Elias Limneos. All rights reserved.
//

#define CONFIGS_KEY @"configurations"
#import <UIKit/UIKit.h>
@interface AddConfigurationViewController  : UITableViewController <UITableViewDelegate, UITableViewDataSource>
-(id)initWithConfiguration:(NSDictionary *)config;
@end
