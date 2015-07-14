//
//  TTViewController.m
//  TTQRCodeScanner
//
//  Created by Administrator on 07/14/2015.
//  Copyright (c) 2015 Administrator. All rights reserved.
//

#import "TTViewController.h"
#import "TTScanViewController.h"

@interface TTViewController ()

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end

@implementation TTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    TTScanViewController *scanVC = segue.destinationViewController;
    scanVC.delegate = self;
    self.resultLabel.text = @"";
}

- (void)ttViewControllerDidScanned:(NSString *)result{
    self.resultLabel.text = result;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
