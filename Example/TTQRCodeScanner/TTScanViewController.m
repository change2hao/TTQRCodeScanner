//
//  TTScanViewController.m
//  TTQRCodeScaner
//
//  Created by tianliwei on 7/14/15.
//  Copyright (c) 2015 Administrator. All rights reserved.
//

#import "TTScanViewController.h"
#import "TTQRCodeScanner.h"
#define UI_SCREEN_WIDTH   [[UIScreen mainScreen] bounds].size.width
@interface TTScanViewController ()

@end

@implementation TTScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TTQRCodeScanner *scanner = [[TTQRCodeScanner alloc]init];
    [scanner scanWithCodeType:ScanCodeTypeQR inView:self.view interestRect:CGRectMake(UI_SCREEN_WIDTH/4, UI_SCREEN_WIDTH/4, UI_SCREEN_WIDTH/2, UI_SCREEN_WIDTH/2) interestMaskImage:[UIImage imageNamed:@"background"] scanerLine:[UIImage imageNamed:@"line"] scanerInterval:0.03 completionHandler:^(NSString *scanResult) {
        [scanner stopScan];
        [self dismissViewControllerAnimated:YES completion:^{
            [self.delegate ttViewControllerDidScanned:scanResult];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
