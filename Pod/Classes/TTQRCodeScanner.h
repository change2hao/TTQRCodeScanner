//
//  TTBar.h
//  TTBar
//
//  Created by tianliwei on 29/4/15.
//  Copyright (c) 2015 tianliwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

typedef void (^CompletionHandler)(NSString *scanResult);

typedef NS_ENUM(NSUInteger, ScanCodeType) {
    ScanCodeTypeQR,
    ScanCodeTypeBar,
    ScanCodeTypeAll
};

@interface TTQRCodeScanner : NSObject<AVCaptureMetadataOutputObjectsDelegate>

/**
 *  the method use system AVFoundation.framework and simplify the workflow for scan QR code or bar code in iOS7+
 *
 *  @param codeType          scan codetype,like QR code etc.
 *  @param view              super view of scan preview
 *  @param interestRect      valid scan region in preview
 *  @param maskImage         valid scan region mask, usually like a transparent bolder rectangle
 *  @param scanerLine        a line scaning up and down in interestRect
 *  @param scanerInterval    timeInterval per moving 1px distance
 *  @param alertRing         the ring name, when the result show up it begin beep
 *  @param completionHandler show the scan result
 */

- (void)scanWithCodeType:(ScanCodeType)codeType inView:(UIView *)view interestRect:(CGRect)interestRect interestMaskImage:(UIImage *)maskImage scanerLine:(UIImage *)scanerLine scanerInterval:(NSTimeInterval)scanerInterval alertRing:(NSString *)alertRing completionHandler:(CompletionHandler)completionHandler;

/**
 *  the same as above except for lack of alertRing
 */
- (void)scanWithCodeType:(ScanCodeType)codeType inView:(UIView *)view interestRect:(CGRect)interestRect interestMaskImage:(UIImage *)maskImage scanerLine:(UIImage *)scanerLine scanerInterval:(NSTimeInterval)scanerInterval completionHandler:(CompletionHandler)completionHandler;

- (void)stopScan;
@end
