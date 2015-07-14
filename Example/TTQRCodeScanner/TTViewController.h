//
//  TTViewController.h
//  TTQRCodeScanner
//
//  Created by Administrator on 07/14/2015.
//  Copyright (c) 2015 Administrator. All rights reserved.
//

@import UIKit;

@protocol TTViewControllerDelegate <NSObject>

- (void)ttViewControllerDidScanned:(NSString *)result;

@end

@interface TTViewController : UIViewController <TTViewControllerDelegate>

@end
