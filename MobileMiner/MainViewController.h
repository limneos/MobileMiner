//
//  MainViewController.h
//  MobileMiner
//
//  Created by Elias Limneos on 13/12/2017.
//  Copyright © 2017 Elias Limneos. All rights reserved.
//

#include "GrayTableController.h"
#define CONFIGS_KEY @"configurations"

@interface MainViewController : UIViewController
-(void)setConfiguration:(NSDictionary *)conf;
@end
