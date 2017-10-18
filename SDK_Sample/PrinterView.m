//
//  PrinterView.m
//  SDK_Sample_Rj4040
//
//  Created by BIL on 12/09/03.
//
//

#import "PrinterView.h"

@implementation PrinterView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
	UIBarButtonItem* btn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(pushDone:)];
	self.navigationItem.rightBarButtonItem = btn;
	[btn release];
    
    return self;
}

-(void)dealloc
{
	//	Release BRPtouchPrinter
	[ptn release];
	
	[super dealloc];
}

////////////////////////////////////////////////////////////
//	click on Done
////////////////////////////////////////////////////////////
-(void)pushDone:(id)sender
{
	[self.parentViewController dismissModalViewControllerAnimated:YES];
	
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	self.title = @"Printer List";
    
	[aryListData removeAllObjects];
    
	//	BRPtouchPrinter Class initialize (Release will be done in [dealloc])
	ptn = [[BRPtouchNetwork alloc] init];
	
	//	Set delegate
	ptn.delegate = self;
	
    NSString *	path = [[NSBundle mainBundle] pathForResource:@"PrinterList" ofType:@"plist"];
    if( path )
    {
        NSDictionary *printerDict = [NSDictionary dictionaryWithContentsOfFile:path];
        
        NSArray *printerList;
        printerList = [[NSArray alloc] initWithArray:printerDict.allKeys];
        [ptn setPrinterNames:printerList];
        [printerList release];
    }
	
	//	Start printer search
	[ptn startSearch: 5.0];
    
	//	Create indicator View
	loadingView = [[UIView alloc] initWithFrame:[self.parentViewController.view bounds]];
	[loadingView setBackgroundColor:[UIColor blackColor]];
	[loadingView setAlpha:0.5];
	[self.parentViewController.view addSubview:loadingView];
	indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	indicator.frame = CGRectMake(140.0, 200, 40.0, 40.0);
	[self.parentViewController.view addSubview:indicator];
	
	//	Start indicator animation
	[indicator startAnimating];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

////////////////////////////////////////////////////////////////////////////////////
//
//	BRPtouchNetwork delegate method
//
////////////////////////////////////////////////////////////////////////////////////
-(void)didFinishedSearch:(id)sender
{
	[indicator stopAnimating];          //  stop indicator animation
	[indicator removeFromSuperview];    //  remove indicator view (indicator)
	[loadingView removeFromSuperview];  //  remove indicator view (view)
	
	//  get BRPtouchNetworkInfo Class list
	[aryListData removeAllObjects];
	aryListData = (NSMutableArray*)[ptn getPrinterNetInfo];
	
	// reload TableView
	[tablePrinterList reloadData];
    
	return;
}

////////////////////////////////////////////////////////////////////////////////////
//
//	TableView
//
//
////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////
//	Set section count
////////////////////////////////////////////////////////////
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

////////////////////////////////////////////////////////////
//	Set section title
////////////////////////////////////////////////////////////
-(NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
	if(0 == section){
		return @"Printer";
	}
	return nil;
}

////////////////////////////////////////////////////////////
//	Set cells count
////////////////////////////////////////////////////////////
-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
	return [aryListData count];
}

////////////////////////////////////////////////////////////
//	cell creation
////////////////////////////////////////////////////////////
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	UITableViewCell*	cell;
	
	cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
	if(!cell){
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
		[cell autorelease];
	}
    
	//	Display Device Information
	BRPtouchNetworkInfo* bpni = [aryListData objectAtIndex:indexPath.row];
	cell.textLabel.text = bpni.strModelName;
	cell.detailTextLabel.text = bpni.strIPAddress;
	cell.accessoryType = UITableViewCellAccessoryNone;
	
	return cell;
}

////////////////////////////////////////////////////////////
//	cell selection
////////////////////////////////////////////////////////////
-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	
	//	Cancel selected mode
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	//	check on selected cell
	UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
	cell.accessoryType = UITableViewCellAccessoryCheckmark;
	
    NSUserDefaults *printSetting = [NSUserDefaults standardUserDefaults];

	//	Refer to BRPtouchNetworkInfo
	BRPtouchNetworkInfo* bpni = [aryListData objectAtIndex:[indexPath row]];

	//	Save IP Address
    [printSetting setObject:bpni.strIPAddress forKey:@"ipAddress"];
    [printSetting setObject:bpni.strModelName forKey:@"LastSelectedPrinter"];
    [printSetting synchronize];

	return;
}


/////////////////////////////////////////
// Error handling code
- (void)handleError:(NSNumber *)error
{
    NSLog(@"An error occurred. Error code = %d", [error intValue]);
    // Handle error here
}

@end
