//
//  LogViewController.h
//  MobileMiner
//
//  Created by Elias Limneos on 13/12/2017.
//  Copyright © 2017 Elias Limneos. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <dlfcn.h>

int start_mining(int argc,char *argv[]);

@interface LogViewController : UIViewController
-(void)startMining;
-(void)stopMining;
@end



