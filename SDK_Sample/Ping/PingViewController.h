//
//  PingViewController.h
//  SDK_Sample
//
//  Created by Sha Peng on 10/22/14.
//
//

#import <UIKit/UIKit.h>
#import "PingOperation.h"
#import "PingModule.h"

@interface PingViewController : UIViewController <PingLogDelegate>

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil idAddress:(NSString *)ipAddress;

@property(nonatomic, retain) NSString *ipAddress;
@end
