//
//  TTPlayAudio.h
//  TTBar
//
//  Created by tianliwei on 29/4/15.
//  Copyright (c) 2015 tianliwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface TTPlayAudio : NSObject

+ (instancetype)sharedInstance;

- (void)playNativeSystemSoundWithName:(NSString *)resourceName ofType:(NSString *)type;

- (void)playSystemSoundWithName:(NSString *)resourceName ofType:(NSString *)type;

- (void)playAudioWithName:(NSString *)resourceName ofType:(NSString *)type infinite:(BOOL)isInfinite;

- (void)stopAudio;

@end
