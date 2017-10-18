//
//  PingViewController.m
//  SDK_Sample
//
//  Created by Sha Peng on 10/22/14.
//
//

#import "PingViewController.h"
#import "PingOperation.h"


@interface PingViewController ()
@property (assign, nonatomic) IBOutlet UITextField *pingAddress;
@property (retain, nonatomic) IBOutlet UITextView *pingLogTextView;

@property (strong, nonatomic) NSString *fullLog;
@property (nonatomic,assign) BOOL isTouching;
@end


@implementation PingViewController{
	PingOperation *              pinger;
}
@synthesize ipAddress;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil idAddress:(NSString *)inIPAddress
{
	self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	ipAddress = inIPAddress;
	
	return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.fullLog = @"";
	self.isTouching = NO;
	self.pingAddress.text = ipAddress;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)stopPinging:(id)sender {
	[pinger stopRunningPing];
}

- (IBAction)ping:(id)sender {
	
	
	pinger = [[PingOperation alloc] init];
	[pinger setDelegate:self];
	
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_async(queue, ^{
		[pinger runWithHostName:self.pingAddress.text];
	});
	
}

- (IBAction)closePingView:(id)sender {
	[self stopPinging:self];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)outputToScreenWithLog:(NSString *)log
{
	NSLog(@"outputToScreenWithLog:[%@] isTouching[%d]",log,self.isTouching);
	
	self.fullLog = [log stringByAppendingString:self.fullLog];
	
	if (self.isTouching == NO) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.pingLogTextView setText:self.fullLog];
		});
	}
	
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
	[_pingLogTextView release];
	[super dealloc];
}
- (void)viewDidUnload {
	[self setPingLogTextView:nil];
	[super viewDidUnload];
}
@end
