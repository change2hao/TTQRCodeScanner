//
//  TTBar.m
//  TTBar
//
//  Created by tianliwei on 29/4/15.
//  Copyright (c) 2015 tianliwei. All rights reserved.
//

#import "TTQRCodeScanner.h"
#import "TTPlayAudio.h"

@interface TTQRCodeScanner (){
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureSession *_session;
    AVCaptureVideoPreviewLayer *_preview;
    NSTimer *_timer;
    CompletionHandler _completionHandler;
    CGRect _interestRect;
    NSString *_alertRing;
    UIImageView *_scanerLineView;
    UIImageView *_interestMaskView;
    UIView *_view;
    NSUInteger _num;
    BOOL _isScanning;
    BOOL _isBottom;
}
@end

@implementation TTQRCodeScanner

- (void)scanWithCodeType:(ScanCodeType)codeType inView:(UIView *)view interestRect:(CGRect)interestRect interestMaskImage:(UIImage *)maskImage scanerLine:(UIImage *)scanerLine scanerInterval:(NSTimeInterval)scanerInterval alertRing:(NSString *)alertRing completionHandler:(CompletionHandler)completionHandler{
    
    _alertRing = alertRing;
    _interestRect = interestRect;
    _completionHandler = completionHandler;
    _view = view;
    _isScanning = YES;
    
    [self setInterestMask:maskImage];
    
    [self setScanerLine:scanerLine];
    
    [self startTimerWithInterval:scanerInterval];
    
    [self setCaptureSession];
    
    [self setMetadataOutputWithScanCodeType:codeType];
    
    [self setPreview];
    
    [self setInterestRectInPreview];
    
    [self setFocusAndExposure];
    
    // Start
    [_session startRunning];
}

- (void)scanWithCodeType:(ScanCodeType)codeType inView:(UIView *)view interestRect:(CGRect)interestRect interestMaskImage:(UIImage *)maskImage scanerLine:(UIImage *)scanerLine scanerInterval:(NSTimeInterval)scanerInterval completionHandler:(CompletionHandler)completionHandler{
    [self scanWithCodeType:codeType inView:view interestRect:interestRect interestMaskImage:maskImage scanerLine:scanerLine scanerInterval:scanerInterval alertRing:nil completionHandler:completionHandler];
}

- (void)startTimerWithInterval:(NSTimeInterval)timerInterval{
    _timer = [NSTimer scheduledTimerWithTimeInterval:timerInterval target:self selector:@selector(scanAnimation) userInfo:nil repeats:YES];
}

- (void)setInterestMask:(UIImage *)maskImage{
    if (!_interestMaskView) {
        _interestMaskView = [[UIImageView alloc]initWithImage:maskImage];
    }
    _interestMaskView.frame = _interestRect;
    [_view addSubview:_interestMaskView];
}

- (void)setScanerLine:(UIImage *)scanerLine{
    if (!_scanerLineView) {
        _scanerLineView = [[UIImageView alloc]initWithImage:scanerLine];
    }
    [_scanerLineView sizeToFit];
    _scanerLineView.frame = CGRectMake(_interestRect.origin.x, _interestRect.origin.y, _interestRect.size.width, _scanerLineView.bounds.size.height);
    [_view addSubview:_scanerLineView];
}

- (void)setCaptureSession{
    
    // Device
    if (!_device) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    // Input
    if (!_input) {
        _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
    }
    
    // Output
    if (!_output) {
        _output = [[AVCaptureMetadataOutput alloc]init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    }
    
    // Session
    if (!_session) {
        _session = [[AVCaptureSession alloc]init];
        [_session setSessionPreset:AVCaptureSessionPreset1920x1080];
    }
    
    if ([_session canAddInput:_input])
    {
        [_session addInput:_input];
        
    }
    
    if ([_session canAddOutput:_output])
    {
        [_session addOutput:_output];
    }
}

- (void)setPreview{
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.frame = _view.bounds;
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [_view.layer insertSublayer:_preview atIndex:0];
}

- (void)setInterestRectInPreview{
    _output.rectOfInterest = [_preview metadataOutputRectOfInterestForRect:_interestRect];
}

- (void)setFocusAndExposure{
    
    NSAssert(_preview, @"_preview must not be nil");
    
    CGPoint scanCenter = CGPointMake(CGRectGetMidX(_interestRect), CGRectGetMidY(_interestRect));
    CGPoint focusPoint = [_preview captureDevicePointOfInterestForPoint:scanCenter];
    
    NSError *error;
    
    if ([_device lockForConfiguration:&error])
    {
        if ([_device isFocusPointOfInterestSupported])
        {
            [_device setFocusPointOfInterest:focusPoint];
        }
        
        if ([_device isExposurePointOfInterestSupported])
        {
            [_device setExposurePointOfInterest:focusPoint];
        }
        
        [_device unlockForConfiguration];
    }
    else
    {
        NSLog(@"Cannot lock cam device, %@", [error localizedDescription]);
    }
}

- (void)setMetadataOutputWithScanCodeType:(ScanCodeType)codeType{
    
    NSAssert(_output, @"_output must not be nil");
    
    switch (codeType) {
        case ScanCodeTypeQR:
            _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
            break;
        case ScanCodeTypeBar:
            _output.metadataObjectTypes = @[AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode39Mod43Code];
            break;
        case ScanCodeTypeAll:
            _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode39Mod43Code];
            break;
        default:
            break;
    }
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    _isScanning = NO;
    
    NSString *stringValue;
    
    if ([metadataObjects count] > 0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    if (_alertRing) {
        [[TTPlayAudio sharedInstance] playAudioWithName:_alertRing ofType:nil infinite:NO];
    }
    [_session stopRunning];
    [_timer invalidate];
    
    _completionHandler(stringValue);
    
}


-(void)scanAnimation
{
    if (_isBottom == NO) {
        _num ++;
        _scanerLineView.frame = CGRectMake(_interestRect.origin.x, _interestRect.origin.y+_num, _interestRect.size.width, _scanerLineView.bounds.size.height);
        if (_num == _interestRect.size.height-_scanerLineView.bounds.size.height) {
            _isBottom = YES;
        }
    }
    else {
        _num --;
        _scanerLineView.frame = CGRectMake(_interestRect.origin.x, _interestRect.origin.y+_num, _interestRect.size.width, _scanerLineView.bounds.size.height);
        if (_num == 0) {
            _isBottom = NO;
        }
    }
    
}

- (void)stopScan{
    if (_isScanning == YES) {
        _num = 0;
        _isBottom = NO;
        [_preview removeFromSuperlayer];
        [_interestMaskView removeFromSuperview];
        [_scanerLineView removeFromSuperview];
        [_session removeInput:_input];
        [_session removeOutput:_output];
        [_session stopRunning];
        [_timer invalidate];
    }
    
}
@end
