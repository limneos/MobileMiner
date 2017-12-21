//
//  BackgroundTask.m
//  MobileMiner
//
//  Created by Elias Limneos on 14/12/2017.
//  Copyright © 2017 Elias Limneos. All rights reserved.
//
//  Credits - Original Source : https://github.com/yarodevuci/backgroundTask
//
//

#include "BackgroundTask.h"
#import <AVFoundation/AVFoundation.h>

@interface BackgroundTask ()
@property (nonatomic, retain) AVAudioPlayer* player;
@end

@implementation BackgroundTask

-(void)startBackgroundTask {
    self.player=nil;
    //NSLog(@"BACKGROUND TASK STARTED");
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(interuptedAudio:) name: AVAudioSessionInterruptionNotification object: [AVAudioSession sharedInstance]];
    [self playAudio];
}
    
-(void) stopBackgroundTask{
    //NSLog(@"BACKGROUND TASK STOPPED");
    [[NSNotificationCenter defaultCenter] removeObserver:self name: AVAudioSessionInterruptionNotification object:nil];
    [self.player stop];
}
    
-(void) interuptedAudio:(NSNotification*)notification{
    
    //NSLog(@"INTERRRUPTED AUDIO %@",notification);
    if ([notification.name isEqual:AVAudioSessionInterruptionNotification] && notification.userInfo != nil ){
        NSDictionary *info = [notification userInfo];
        int intValue = [[info objectForKey:AVAudioSessionInterruptionTypeKey] intValue];
        if (intValue == 1) {
            [self playAudio];
        }
    }
}
    
-(void) playAudio{
    
    [self.player release];
    
    NSString *path = [[NSBundle mainBundle] pathForResource: @"empty" ofType: @"wav"];
    NSURL *alertSound = [NSURL fileURLWithPath:path];
    [AVAudioSession.sharedInstance setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:NULL];
    NSError *error=NULL;
    [[AVAudioSession sharedInstance] setActive:YES withOptions:0 error:&error];
    if (error){
        NSLog(@"ERROR activating session %@",[error description]);
    }
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:alertSound error:&error];
    if (error){
        NSLog(@"ERROR initializing audioplayer %@",[error description]);
    }
    //self.player.numberOfLoops = -1;
    self.player.numberOfLoops = 1;
    self.player.volume = 0.01;
    [self.player prepareToPlay];
    [self.player play];
    
    [self performSelector:@selector(playAudio) withObject:nil afterDelay:2];

}
@end
