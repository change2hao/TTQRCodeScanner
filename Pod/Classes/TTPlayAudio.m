//
//  TTPlayAudio.m
//  TTBar
//
//  Created by tianliwei on 29/4/15.
//  Copyright (c) 2015 tianliwei. All rights reserved.
//

#import "TTPlayAudio.h"

@interface TTPlayAudio (){
    SystemSoundID soundID;
    AVAudioPlayer *player;
}

@end

@implementation TTPlayAudio

+ (instancetype)sharedInstance{
    static TTPlayAudio *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TTPlayAudio alloc]init];
    });
    return sharedInstance;
}

- (void)playNativeSystemSoundWithName:(NSString *)resourceName ofType:(NSString *)type{
    NSString *path = [[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] pathForResource:resourceName ofType:type];
    NSURL *pathUrl = [NSURL fileURLWithPath:path];
    [self playSystemResourceUrl:pathUrl];
}

- (void)playSystemSoundWithName:(NSString *)filename ofType:(NSString *)type{
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:filename withExtension:type];
    [self playSystemResourceUrl:fileURL];
}

- (void)playAudioWithName:(NSString *)resourceName ofType:(NSString *)type infinite:(BOOL)isInfinite{
    NSString *path = [[NSBundle mainBundle] pathForResource:resourceName ofType:type];
    NSError *error = nil;
    if (!player) {
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
        if (!error) {
            player.numberOfLoops = (isInfinite == YES ? -1 : 1); // infinite loop
            [player play];
        } else {
            NSLog(@"Audio player init error: %@", error.localizedDescription);
        }
    }
}

- (void)stopAudio
{
    if ([player isPlaying]) {
        [player stop];
    }
}

- (void)playSystemResourceUrl:(NSURL *)resourceUrl{
    if (resourceUrl) {
        SystemSoundID theSoundID;
        OSStatus error =  AudioServicesCreateSystemSoundID((__bridge CFURLRef)resourceUrl, &theSoundID);
        if (error == kAudioServicesNoError) {
            soundID = theSoundID;
        }else {
            NSLog(@"Failed to create sound ");
        }
        AudioServicesPlaySystemSound(soundID);
    }
}

@end
