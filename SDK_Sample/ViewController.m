//
//  ViewController.m
//  SDK_Sample_RJ4040
//
//  Created by BIL on 12/08/01.
//  Copyright (c) 2012 Brother Industries, Ltd. All rights reserved.
//

#import "ViewController.h"
#import "OptionView.h"
#import "Utilities.h"
#import "Reachability.h"
#import "PingViewController.h"

@implementation ViewController

@synthesize imgPickerCtrller;
@synthesize option;
@synthesize ipInput;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

////////////////////////////////////////////////////////////////////
//
//	ViewDidLoad
//
////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (printerList == nil) {
        printerList = [[NSArray alloc] initWithArray:[self getPrinterList]];
    }
    [self initStoredSettings];
	
	// initialize UIImagePickerController(save time for the first initialization)
	[[[UIImagePickerController alloc] init] autorelease];
    
    if(self.option == nil){
        NSString *optionViewName = [self optionViewForPrinter:selectPrinterButton.currentTitle];
        OptionView *newOption = [[[OptionView alloc] initWithNibName:optionViewName bundle:nil]autorelease];
        newOption.printerName = selectPrinterButton.currentTitle;
        self.option = newOption;
    }
    self.ipInput.delegate = self;
    self.ipInput.returnKeyType = UIReturnKeyDone;
    NSUserDefaults *printSetting = [NSUserDefaults standardUserDefaults];
    NSString *ip = [printSetting stringForKey:@"ipAddress"];
    if(ip) self.ipInput.text = ip;

	printKind = DocumentKindToPrintImage;
}

- (NSString *)optionViewForPrinter:(NSString *)printerName
{
    NSString *optionView;
    
    if ( !([printerName rangeOfString:@"PT-"].location == NSNotFound) ) {
        optionView = @"OptionView_PT";
    }
    else if( !([printerName rangeOfString:@"QL-"].location == NSNotFound) ){
        optionView = @"OptionView_QL";
    }
    else if (!([printerName rangeOfString:@"PJ-"].location == NSNotFound) ){
        optionView = @"OptionView_PJ";
    }
    else if (!([printerName rangeOfString:@"TD-"].location == NSNotFound) ){
        optionView = @"OptionView_TD";
    }
    else if (!([printerName rangeOfString:@"RJ-"].location == NSNotFound) ){
        optionView = @"OptionView_RJ";
    }
    else{
        optionView = @"Not Supported";
    }
    
    return optionView;
}

- (void)initStoredSettings
{
    NSUserDefaults *userSettings = [NSUserDefaults standardUserDefaults];
    NSString *selectedPrinterName = [userSettings stringForKey:@"LastSelectedPrinter"];
    if (selectedPrinterName) {
        selectedPrinterIndex = [printerList indexOfObject:selectedPrinterName];
		if (![selectedPrinterName isEqualToString:@"Brother PJ-673"]) {
			if (printKind == DocumentKindToPrintPDF) {
				printKind = DocumentKindToPrintImage;
				imgView.image = nil;
			}
		}
    }
    else{
        selectedPrinterIndex = 0;
    }
    [selectPrinterButton setTitle:[printerList objectAtIndex:selectedPrinterIndex] forState:UIControlStateNormal];
}

- (NSArray *)getPrinterList
{
    NSArray *list;
    
    NSString *	path = [[NSBundle mainBundle] pathForResource:@"PrinterList" ofType:@"plist"];
    if( path )
    {
        NSDictionary *printerDict = [NSDictionary dictionaryWithContentsOfFile:path];
        
        list = [[[NSArray alloc] initWithArray:printerDict.allKeys] autorelease];
    }
    else{
        NSLog(@"Path is not existed !");
        return nil;
    }
    
    return list;
}

////////////////////////////////////////////////////////////////////
//
//	ViewDidUnload
//
////////////////////////////////////////////////////////////////////
- (void)viewDidUnload
{
    [selectPrinterButton release];
    selectPrinterButton = nil;
	[selectPDF release];
	selectPDF = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	[selectPDF setHidden:![selectPrinterButton.currentTitle isEqualToString:@"Brother PJ-673"]];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults *printSetting = [NSUserDefaults standardUserDefaults];
    NSString *ip = [printSetting stringForKey:@"ipAddress"];
    if(ip) self.ipInput.text = ip;
    [super viewDidAppear:animated];
    
    [self initStoredSettings];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

////////////////////////////////////////////////////////////////////
//
//	Device rotate
//
////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	} else {
	    return YES;
	}
}

////////////////////////////////////////////////////////////////////
//
//	Push [Select a image]
//
////////////////////////////////////////////////////////////////////
- (IBAction)selectImage:(id)sender{
	
	// Do any additional setup after loading the view, typically from a nib.
	if(imgPickerCtrller == nil){
		UIImagePickerController *aImgPickerCtrl = [[[UIImagePickerController alloc] init] autorelease];
		imgPickerCtrller = aImgPickerCtrl;
		
		imgPickerCtrller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		imgPickerCtrller.allowsEditing = NO;
		imgPickerCtrller.delegate = self;
	}
	
	[self presentViewController:self.imgPickerCtrller animated:YES completion:nil];
}

////////////////////////////////////////////////////////////////////
//
//	Push [Option]
//
////////////////////////////////////////////////////////////////////
- (IBAction)printOption:(id)sender{
    
    // Switch Option View
    NSString *optionViewName = [self optionViewForPrinter:selectPrinterButton.currentTitle];
    OptionView *newOption = [[[OptionView alloc] initWithNibName:optionViewName bundle:nil]autorelease];
    newOption.printerName = selectPrinterButton.currentTitle;
    
    self.option = newOption;
    
    [self presentViewController:self.option animated:YES completion:nil];
}

////////////////////////////////////////////////////////////////////
//
//	Image Picker ( iOS default control )
//
////////////////////////////////////////////////////////////////////
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	imgView.image = [info valueForKey:UIImagePickerControllerOriginalImage];
	if (imgView.image) {
		printKind = DocumentKindToPrintImage;
	}
    [picker dismissModalViewControllerAnimated:YES];
	imgPickerCtrller = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[picker dismissModalViewControllerAnimated:YES];
	imgPickerCtrller = nil;
}

////////////////////////////////////////////////////////////////////
//
//	Push Return Key on Text Field
//
////////////////////////////////////////////////////////////////////
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	// the user pressed the "Done" button, so dismiss the keyboard
    NSUserDefaults *printSetting = [NSUserDefaults standardUserDefaults];
    [printSetting setObject:self.ipInput.text forKey:@"ipAddress"];
    [printSetting synchronize];
	[textField resignFirstResponder];
	return YES;
}

////////////////////////////////////////////////////////////////////
//
//	Push [Print]
//
////////////////////////////////////////////////////////////////////
- (IBAction)printImage:(id)sender
{
	BRPtouchPrintInfo*	printInfo;
    BOOL	isCarbon;
	BOOL	isDashPrint;
	int		feedMode;
	NSString*		strPaperTmp;
    int copies;
	UIButton *printButton = (UIButton *)sender;
	NSString *printButtonTitle = [printButton titleForState:UIControlStateNormal];
	
	//	Create BRPtouchPrintInfo
	printInfo = [[BRPtouchPrintInfo alloc] init];

	//	Initialize by Printer Name
    NSString *printerName = [NSString stringWithString:selectPrinterButton.currentTitle];
    BRPtouchPrinter	*ptp = [[BRPtouchPrinter alloc] initWithPrinterName:printerName];
    
	//	Load Paramator from UserDefault
    NSUserDefaults *printSetting = [NSUserDefaults standardUserDefaults];
	strPaperTmp = [printSetting stringForKey:@"paperName"];
	if (0 != [strPaperTmp length]) {
		printInfo.strPaperName      = [printSetting stringForKey:@"paperName"];
		
		if (![supportedPaperSizeForPrinter(printerName) containsObject:printInfo.strPaperName]) {
			printInfo.strPaperName = @"Custom";
		}
		
		NSInteger density			= [printSetting integerForKey:@"density"];
		if (!isAvailableDensity(selectPrinterButton.currentTitle, density)) {
			density = 0;
			NSUserDefaults *printSetting = [NSUserDefaults standardUserDefaults];
			[printSetting setInteger: density forKey:@"density"];
		}
		
		printInfo.nDensity          = density;
		printInfo.nPrintMode        = [printSetting integerForKey:@"printMode"];
		printInfo.nOrientation      = [printSetting integerForKey:@"orientation"];
		printInfo.nHalftone         = [printSetting integerForKey:@"halftone"];
		printInfo.nHorizontalAlign  = [printSetting integerForKey:@"horizontalAlign"];
		printInfo.nVerticalAlign    = [printSetting integerForKey:@"verticalAlign"];
		printInfo.nPaperAlign       = [printSetting integerForKey:@"paperAlign"];
        
        if (isFuncAvailable(kFuncAutoCut, printerName)) {
            printInfo.nAutoCutFlag      = [printSetting integerForKey:@"AutoCut"];
        }
        
        if (isFuncAvailable(kFuncChainPrint, printerName) ||
            isFuncAvailable(kFuncSpecialTape, printerName) ||
            isFuncAvailable(kFuncHalfCut, printerName)) {
            printInfo.nExMode = [printSetting integerForKey:@"ExMode"];
        }
        
        if (isFuncAvailable(kFuncCopies, printerName)) {
            copies = [printSetting integerForKey:@"Copies"];
        }
        else{
            copies = 0;
        }
        
        if (isFuncAvailable(kFuncCarbonPrint, printerName)) {
            isCarbon = [printSetting boolForKey:@"isCarbon"];
        }
        
        if (isFuncAvailable(kFuncDashPrint, printerName)) {
            isDashPrint = [printSetting boolForKey:@"isDashPrint"];
        }
        
        if (isFuncAvailable(kFuncFeedMode, printerName)) {
            feedMode = [printSetting integerForKey:@"feedMode"];
        }
        
	}
	else{
        if ([printerName isEqualToString:@"Brother PJ-673"]) {
            printInfo.strPaperName = @"A4_CutSheet";
        }
        else{
            printInfo.strPaperName = @"RD 102mm";
        }
		printInfo.nPrintMode = PRINT_FIT;
		printInfo.nDensity = 0;
		printInfo.nOrientation = ORI_PORTRATE;
		printInfo.nHalftone = HALFTONE_ERRDIF;
		printInfo.nHorizontalAlign = ALIGN_CENTER;
		printInfo.nVerticalAlign = ALIGN_MIDDLE;
		printInfo.nPaperAlign = PAPERALIGN_LEFT;
        
        if (isFuncAvailable(kFuncCarbonPrint, printerName)) {
            isCarbon = false;
        }
        
        if (isFuncAvailable(kFuncDashPrint, printerName)) {
            isDashPrint = false;
        }
        
        if (isFuncAvailable(kFuncFeedMode, printerName)) {
            feedMode = 0;
        }
	}
    
	// Overwrite Paper Size Only if tapped 'Print Test PDF' button
	if ([printerName isEqualToString:@"Brother PJ-673"]) {
		if ([printButtonTitle isEqualToString:@"Print Test PDF(A4)"]) {
			printInfo.strPaperName      = @"A4_CutSheet";
			printInfo.nPrintMode = PRINT_FIT;
		}
	}
	
    if (isFuncAvailable(kFuncCarbonPrint, printerName) ||
        isFuncAvailable(kFuncDashPrint, printerName) ||
        isFuncAvailable(kFuncFeedMode, printerName))
    {
        if (isCarbon) {
            printInfo.nExtFlag |= EXT_PJ673_CARBON;
        }
        if (isDashPrint) {
            printInfo.nExtFlag |= EXT_PJ673_DASHPRINT;
        }
        
        printInfo.nExtFlag |= feedMode;
    }

    //	Set IP Address
	if (0 == [ipInput.text length]) {
		UIAlertView*	alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Bad IP Address." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[alert show];
		[alert release];
		return;
	}

	[ptp setIPAddress:ipInput.text];
    
/********************************************************************************************
    // Refer to the following structure members in order to get tape color or printing color,
    // every color is associated with an ID, the IDs are all described in the User's Manual.
 
    // For tape color -> (PTSTATUSINFO)status.byLabelColor
    // For printing color -> (PTSTATUSINFO)status.byFontColor
 
    // for example:
    PTSTATUSINFO    status;
    [ptp getPTStatus:&status];
    NSLog(@"byLabelColor[%d]",status.byLabelColor);
    NSLog(@"byFontColor[%d]",status.byFontColor);
*******************************************************************************************/
    
    if (isFuncAvailable(kFuncCustomPaper, printerName)) {
        //	Set custom paper
        if (0 == [printInfo.strPaperName compare:@"Custom"]) {
            NSString* strPaper = [printSetting stringForKey:@"customPaper"];
			NSString* strPath = nil;
			if (strPaper) {
				if (![customizedPapers(printerName) containsObject:strPaper]) {
					strPaper = defaultCustomizedPaper(printerName);
				}
				strPath = [[NSBundle mainBundle] pathForResource:strPaper ofType:@"bin"];
			}
			else{
				strPath = [[NSBundle mainBundle] pathForResource:defaultCustomizedPaper(printerName) ofType:@"bin"];
			}
			[ptp setCustomPaperFile:strPath];
        }
    }

	//	Set printInfo
	[ptp setPrintInfo:printInfo];
	
    
    UIApplication *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler: ^{
        //A handler to be called shortly before the app’s remaining background time reaches 0.
        // You should use this handler to clean up and mark the end of the background task.
		if (ptp) { [ptp release]; }
		if (printInfo) { [printInfo release]; }
    }];
    
    
    /* Print PDF */
    if(printKind == DocumentKindToPrintPDF){
		
		/* Print all pages inside of pdf file */
		NSUInteger length = 0;
		NSUInteger pageIndexes[] = {0};

		/* to print part of a pdf file, use the following code instead
		 // This is an example for print page.1 and page.2 .(All pages are numbered starting at 1.)
		 NSUInteger pageIndexes[] = {1,2};
		 NSUInteger length = sizeof(pageIndexes)/sizeof(pageIndexes[0]);
		 */
		if (self.pdfPathToPrint) {
			NSLog(@"Will start to print pdf file...");
			if (copies ==0) { copies = 1; }
			
			if ([ptp isPrinterReady]) {
				NSLog(@"Printer is ready !");
				[ptp printPDFAtPath:self.pdfPathToPrint pages:pageIndexes length:length copy:copies timeout:500];
			}
			else{
				UIAlertView*	alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please check your Network settings" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
				[alert show];
				[alert release];
			}
			
			
		}
    }
    /* Print Image */
    else{
        CGImageRef	imgRef;
        
        //	Get ImageRef
        imgRef = [imgView.image CGImage];
        if (nil == imgRef) {
            UIAlertView*	alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Bad Image." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            [alert release];
            return;
        }
        
        ///////////////////////
        //	Do print
        ///////////////////////
        if (copies ==0) { copies = 1; }
		
		if ([ptp isPrinterReady]) {
			NSLog(@"Will start to print image file...");
			NSLog(@"Printer is ready !");
			[ptp printImage:imgRef copy:copies timeout:500];
		}
		else{
			UIAlertView*	alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please check your Network settings" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
			[alert show];
			[alert release];
		}
		
    }
    [ptp release];
	[printInfo release];
    [app endBackgroundTask:bgTask];
	
}

- (BOOL)shouldStartSearch
{
	BOOL shouldStart = NO;
	
	Reachability *wifiReachability = [Reachability reachabilityForLocalWiFi];
	if (![wifiReachability currentReachabilityStatus] == NotReachable) {
		shouldStart = YES;
	}
	
	return shouldStart;
}


- (IBAction)showPingView:(id)sender {
	NSLog(@"showPingView");
	
	PingViewController *pingController = [[PingViewController alloc] initWithNibName:@"PingViewController" bundle:nil idAddress:self.ipInput.text];
	[self presentViewController:pingController animated:YES completion:nil];
	
}


-(IBAction)searchPrinter:(id)sender
{
	if (![self shouldStartSearch]) {
		UIAlertView*	alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please check your Network settings" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[alert show];
		[alert release];
		return;
	}

    PrinterView*	pv = [[PrinterView alloc] init];
	UINavigationController* nv = [[UINavigationController alloc] initWithRootViewController:pv];
	
	[self presentViewController:nv animated:YES completion:nil];
	[pv release];
	[nv release];
}


- (IBAction)selectPrinter:(id)sender {
    [self showPicker];
}

////////////////////////////////////////////////////////////////////
//
//	Push [Cancel] on ActionSheet
//
////////////////////////////////////////////////////////////////////
- (void)cancelDidPush {
    
	//	Dismiss ActionSheet
	[actionSheet removeFromSuperview];
    
}

////////////////////////////////////////////////////////////////////
//
//	Push [Done] on ActionSheet
//
////////////////////////////////////////////////////////////////////
- (void)doneDidPush {
	
    [selectPrinterButton setTitle:[printerList objectAtIndex:selectedPrinterIndex] forState:UIControlStateNormal];
    
    NSUserDefaults *userSettings = [NSUserDefaults standardUserDefaults];
    [userSettings setObject:[printerList objectAtIndex:selectedPrinterIndex] forKey:@"LastSelectedPrinter"];
    

    // Switch Option View
    NSString *optionViewName = [self optionViewForPrinter:selectPrinterButton.currentTitle];
    OptionView *newOption = [[[OptionView alloc] initWithNibName:optionViewName bundle:nil]autorelease];
    newOption.printerName = selectPrinterButton.currentTitle;
    self.option = newOption;
    
    if ([selectPrinterButton.currentTitle isEqualToString:@"Brother PJ-673"]) {
        self.ipInput.text = @"169.254.100.1";
        [userSettings setObject:self.ipInput.text forKey:@"ipAddress"];
    }
	else{ /* only PJ673 can support printing pdf file */
		if (printKind == DocumentKindToPrintPDF) {
			printKind = DocumentKindToPrintImage;
			imgView.image = nil;
		}
	}

    
    [userSettings synchronize];
    
    [selectPDF setHidden:![selectPrinterButton.currentTitle isEqualToString:@"Brother PJ-673"]];
	
	//	Dismiss ActionSheet
	[actionSheet removeFromSuperview];

}

////////////////////////////////////////////////////////////////////
//
//	Show picker
//
////////////////////////////////////////////////////////////////////
- (void) showPicker{
    //	Create ActionSheet
	CGRect screenSize = [[UIScreen mainScreen] applicationFrame];
	actionSheet = [[UIView alloc]initWithFrame:screenSize];

	//	Create Picker
	CGFloat pickerHeight = 216.0f;
	UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, screenSize.size.height-pickerHeight, screenSize.size.width, pickerHeight)];
    pickerView.backgroundColor = [UIColor whiteColor];
	pickerView.delegate = self;
	pickerView.showsSelectionIndicator = YES;
    [pickerView selectRow:selectedPrinterIndex inComponent:0 animated:YES];
	
	//	Create ToolBar
	CGFloat toolBarHeight = 44.0;
	UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, screenSize.size.height-pickerHeight-toolBarHeight, screenSize.size.width, toolBarHeight)];
	toolBar.barStyle = UIBarStyleDefault;
	[toolBar sizeToFit];
    
	//	Create Cancel Button
	UIBarButtonItem *cancel = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelDidPush)] autorelease];
	
	//	Create FrexibleSpace
	UIBarButtonItem *spacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil] autorelease];
    
	//	Create Done button
	UIBarButtonItem *done = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneDidPush)] autorelease];
	
	NSArray *items = [NSArray arrayWithObjects:cancel, spacer, done, nil];
	[toolBar setItems:items animated:YES];
	
	//	Embedded to the ActionSheet & Display
	[actionSheet addSubview:toolBar];
	[actionSheet addSubview:pickerView];
	[self.view addSubview:actionSheet];
	
	[toolBar release];
	[pickerView release];
	[actionSheet release];
}

- (IBAction)selectPDFFile:(id)sender
{
	PDFSelectVIewControllerViewController *pdfViewCtr = [[PDFSelectVIewControllerViewController alloc]
                                                         initWithNibName:@"PDFSelectVIewControllerViewController" bundle:nil delegate:self];
	[pdfViewCtr loadView];
	[self presentViewController:pdfViewCtr animated:YES completion:nil];
	[pdfViewCtr release];
}

/************************************************************
 MainViewControllerProtocol
 *************************************************************/
- (void)tableView:(UIViewController *)viewCtr didSelectPDFPath:(NSString *)pdfPath
{
	[viewCtr dismissViewControllerAnimated:YES completion:nil];
	
	if (self.pdfPathToPrint) {
		[self.pdfPathToPrint release];
	}
	self.pdfPathToPrint = pdfPath;
	printKind = DocumentKindToPrintPDF;
	imgView.image = [self previewImageFromPDF:pdfPath];
}

- (UIImage *)previewImageFromPDF:(NSString *)pdfPath
{
	UIImage *image = nil;
	
    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:pdfPath]];
    CFDataRef dataRef = (CFDataRef)data;
	CGDataProviderRef provider = CGDataProviderCreateWithCFData(dataRef);
    CGPDFDocumentRef pdf = CGPDFDocumentCreateWithProvider(provider);
	CGDataProviderRelease(provider);
	CGPDFPageRef firstPageRef = CGPDFDocumentGetPage(pdf, 1);
	CGRect mediarect = CGPDFPageGetBoxRect(firstPageRef, kCGPDFMediaBox);
	CGFloat scale = 600.0/mediarect.size.width;
	UIGraphicsBeginImageContext(CGSizeMake(600.0, mediarect.size.height*scale));
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f);
	CGContextFillRect(context, mediarect);
	CGContextTranslateCTM(context, 0.0, mediarect.size.height*scale);
    CGContextScaleCTM(context, 1.0*scale, -1.0*scale);
	CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetRenderingIntent(context, kCGRenderingIntentDefault);
	CGContextDrawPDFPage(context, firstPageRef);
	image = UIGraphicsGetImageFromCurrentImageContext();
	CGPDFDocumentRelease(pdf);
	UIGraphicsEndImageContext();
	
	return image;
}


/************************************************************
                        Picker Data Source
 *************************************************************/
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [printerList count];
}


/************************************************************
                        Picker Delegate
 *************************************************************/

////////////////////////////////////////////////////////////////////
//
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	NSString *printName = [printerList objectAtIndex:row];
	return printName;
}


////////////////////////////////////////////////////////////////////
//
- (void) pickerView:(UIPickerView *)picker didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    selectedPrinterIndex = row;
}

- (void)dealloc {
	[selectPrinterButton release];
	[printerList release];
	[selectPDF release];
	[super dealloc];
}
@end
