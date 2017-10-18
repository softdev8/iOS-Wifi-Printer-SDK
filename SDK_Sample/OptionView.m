//
//  OptionView.m
//  SDK_Sample_RJ4040
//
//  Created by BIL on 12/08/01.
//  Copyright (c) 2012 Brother Industries, Ltd. All rights reserved.
//

#import "OptionView.h"
#import "Utilities.h"

@implementation OptionView

@synthesize paper;
@synthesize density;
@synthesize custom;
@synthesize orientation;
@synthesize printMode;
@synthesize halftone;
@synthesize horizontalAlign;
@synthesize verticalAlign;
@synthesize feedModeOption;
@synthesize carbon;
@synthesize dashPrint;
@synthesize printerName;


////////////////////////////////////////////////////////////////////
//
//	Update controllers
//
////////////////////////////////////////////////////////////////////
- (void) updateCtrlers{
    [self.paper setTitle:printInfo.strPaperName forState:UIControlStateNormal];
    [self.custom setTitle:customPaper forState:UIControlStateNormal];
    [self.density setTitle:[NSString stringWithFormat:@"%d",printInfo.nDensity] forState:UIControlStateNormal];
    
    switch (printInfo.nPrintMode) {
        case PRINT_ORIGINAL:
            self.printMode.selectedSegmentIndex = 0;
            break;
        case PRINT_FIT:
            self.printMode.selectedSegmentIndex = 1;
            break;
        default:
            self.printMode.selectedSegmentIndex = 0;
    }
    switch (printInfo.nOrientation) {
        case ORI_PORTRATE:
            self.orientation.selectedSegmentIndex = 0;
            break;
        case ORI_LANDSCAPE:
            self.orientation.selectedSegmentIndex = 1;
            break;
        default:
            self.orientation.selectedSegmentIndex = 0;
    }
    switch (printInfo.nHalftone) {
        case HALFTONE_BINARY:
            self.halftone.selectedSegmentIndex = 0;
            break;
        case HALFTONE_ERRDIF:
            self.halftone.selectedSegmentIndex = 1;
            break;
        case HALFTONE_DITHER:
            self.halftone.selectedSegmentIndex = 2;
            break;
        default:
            self.halftone.selectedSegmentIndex = 0;
    }
    switch (printInfo.nHorizontalAlign) {
        case ALIGN_LEFT:
            self.horizontalAlign.selectedSegmentIndex = 0;
            break;
        case ALIGN_CENTER:
            self.horizontalAlign.selectedSegmentIndex = 1;
            break;
        case ALIGN_RIGHT:
            self.horizontalAlign.selectedSegmentIndex = 2;
            break;
        default:
            self.horizontalAlign.selectedSegmentIndex = 0;
    }
    switch (printInfo.nVerticalAlign) {
        case ALIGN_TOP:
            self.verticalAlign.selectedSegmentIndex = 0;
            break;
        case ALIGN_MIDDLE:
            self.verticalAlign.selectedSegmentIndex = 1;
            break;
        case ALIGN_BOTTOM:
            self.verticalAlign.selectedSegmentIndex = 2;
            break;
        default:
            self.verticalAlign.selectedSegmentIndex = 0;
    }
    
    if (isFuncAvailable(kFuncAutoCut, self.printerName)) {
        if ((printInfo.nAutoCutFlag & FLAG_M_AUTOCUT) != 0) {
            [self.autoCutOption setOn:YES animated:YES];
        }
        else{
            [self.autoCutOption setOn:NO animated:YES];
        }
    }
    
    if (isFuncAvailable(kFuncHalfCut, self.printerName)) {
        if ((printInfo.nExMode & FLAG_K_HALFCUT) != 0) {
            [self.halfCutOption setOn:YES animated:YES];
        }
        else{
            [self.halfCutOption setOn:NO animated:YES];
        }
    }

    if (isFuncAvailable(kFuncChainPrint, self.printerName)) {
        if ((printInfo.nExMode & FLAG_K_NOCHAIN) != 0) {
            [self.chainPrintOption setOn:NO animated:YES];
        }
        else{
            [self.chainPrintOption setOn:YES animated:YES];
        }
    }
    
    if (isFuncAvailable(kFuncSpecialTape, self.printerName)) {
        if ((printInfo.nExMode & FLAG_K_SPTAPE) != 0) {
            [self.specialTapeOption setOn:YES animated:YES];
        }
        else{
            [self.specialTapeOption setOn:NO animated:YES];
        }
    }
    
    if (isFuncAvailable(kFuncCopies, self.printerName)) {
        [self.copiesOption setTitle:[NSString stringWithFormat:@"%d",copies] forState:UIControlStateNormal];
    }
    
    if (isFuncAvailable(kFuncCarbonPrint, self.printerName)) {
        if(isCarbon){
            self.carbon.on = YES;
        }else{
            self.carbon.on = NO;
        }
    }

    if (isFuncAvailable(kFuncDashPrint, self.printerName)) {
        if(isDashPrint){
            self.dashPrint.on = YES;
        }else{
            self.dashPrint.on = NO;
        }
    }

    if (isFuncAvailable(kFuncFeedMode, self.printerName)) {
        switch (feedMode) {
            case 0:
                self.feedModeOption.selectedSegmentIndex = 0;
                break;
            case EXT_PJ673_NFD:
                self.feedModeOption.selectedSegmentIndex = 1;
                break;
            case EXT_PJ673_EOP:
                self.feedModeOption.selectedSegmentIndex = 2;
                break;
            case EXT_PJ673_EPR:
                self.feedModeOption.selectedSegmentIndex = 3;
                break;
            default:
                self.feedModeOption.selectedSegmentIndex = 0;
        }
    }

}

////////////////////////////////////////////////////////////////////
//
//	initWithNibName
//
////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

////////////////////////////////////////////////////////////////////
//
//	Memory warning
//
////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


////////////////////////////////////////////////////////////////////
//
//	Initialize printInfo
//
////////////////////////////////////////////////////////////////////
- (void)initPrintInfo{
	NSString*	strPaperTmp;
	
    if(printInfo == nil){
        BRPtouchPrintInfo *newPrinter = [[BRPtouchPrintInfo alloc]init];
        printInfo = newPrinter;
    }

    printInfo.strPaperName = @"RD 102mm";
    printInfo.nPrintMode = PRINT_FIT;
    printInfo.nDensity = 0;
    printInfo.nOrientation = ORI_PORTRATE;
    printInfo.nHalftone = HALFTONE_ERRDIF;
    printInfo.nHorizontalAlign = ALIGN_CENTER;
    printInfo.nVerticalAlign = ALIGN_MIDDLE;
    printInfo.nPaperAlign = PAPERALIGN_LEFT;
    printInfo.nAutoCutFlag = 0;
    printInfo.nAutoCutCopies = 0;
    isCarbon = false;
    isDashPrint = false;
    feedMode = 0;
    customPaper = defaultCustomizedPaper(printerName);
    
    NSUserDefaults *printSetting = [NSUserDefaults standardUserDefaults];
	strPaperTmp = [printSetting stringForKey:@"paperName"];
    NSArray *paperSizes = [NSArray arrayWithArray:supportedPaperSizeForPrinter(self.printerName)];

	if (0 != [strPaperTmp length]) {
        
        if (![paperSizes containsObject:strPaperTmp]) {
            strPaperTmp = [paperSizes objectAtIndex:0];
            printInfo.strPaperName = [strPaperTmp retain];
        }
        else{
            printInfo.strPaperName = [printSetting stringForKey:@"paperName"];
        }

		printInfo.nPrintMode = [printSetting integerForKey:@"printMode"];
		printInfo.nPrintMode = [printSetting integerForKey:@"printMode"];
		
		NSInteger storedDensity	= [printSetting integerForKey:@"density"];
		if (!isAvailableDensity(self.printerName, storedDensity)) {
			storedDensity = 0;
			NSUserDefaults *printSetting = [NSUserDefaults standardUserDefaults];
			[printSetting setInteger: storedDensity forKey:@"density"];
		}
		
		printInfo.nDensity = storedDensity;
		printInfo.nOrientation = [printSetting integerForKey:@"orientation"];
		printInfo.nHalftone = [printSetting integerForKey:@"halftone"];
		printInfo.nHorizontalAlign = [printSetting integerForKey:@"horizontalAlign"];
		printInfo.nVerticalAlign = [printSetting integerForKey:@"verticalAlign"];
		printInfo.nPaperAlign  = [printSetting integerForKey:@"paperAlign"];

		if ([customizedPapers(printerName) containsObject:[printSetting stringForKey:@"customPaper"]]) {
			customPaper = [printSetting stringForKey:@"customPaper"];
		}
        
        if (isFuncAvailable(kFuncAutoCut, self.printerName)) {
            printInfo.nAutoCutFlag  =   [printSetting integerForKey:@"AutoCut"];
        }
        
        if (isFuncAvailable(kFuncChainPrint, self.printerName) ||
            isFuncAvailable(kFuncSpecialTape, self.printerName) ||
            isFuncAvailable(kFuncHalfCut, self.printerName)) {
            printInfo.nExMode       =   [printSetting integerForKey:@"ExMode"];
        }
        
        if (isFuncAvailable(kFuncCopies, self.printerName)) {
            copies = [printSetting integerForKey:@"Copies"];
        }
        else{
            copies = 0;
        }
        
        if (isFuncAvailable(kFuncCarbonPrint, self.printerName)) {
            isCarbon = [printSetting boolForKey:@"isCarbon"];
        }
        
        if (isFuncAvailable(kFuncDashPrint, self.printerName)) {
            isDashPrint = [printSetting boolForKey:@"isDashPrint"];
        }
        
        if (isFuncAvailable(kFuncFeedMode, self.printerName)) {
            feedMode = [printSetting integerForKey:@"feedMode"];
        }
        
	}
    
    [self updateCtrlers];
}

////////////////////////////////////////////////////////////////////
//
//	viewDidLoad
//
////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	pickerType = 0;
    [self initPrintInfo];
}

////////////////////////////////////////////////////////////////////
//
//	viewDidUnload
//
////////////////////////////////////////////////////////////////////
- (void)viewDidUnload
{
    [self setAutoCutOption:nil];
    [self setChainPrintOption:nil];
    [self setHalfCutOption:nil];
    [self setSpecialTapeOption:nil];
    [self setCopiesOption:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

////////////////////////////////////////////////////////////////////
//
//	Device rotate
//
////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

////////////////////////////////////////////////////////////////////
//
//	Save print settings
//
////////////////////////////////////////////////////////////////////
- (IBAction)savePrintSetting:(id)sender;{
    NSUserDefaults *printSetting = [NSUserDefaults standardUserDefaults];
    [printSetting setObject:printInfo.strPaperName forKey:@"paperName"];
    [printSetting setInteger: printInfo.nPrintMode forKey:@"printMode"];
    [printSetting setInteger: printInfo.nDensity forKey:@"density"];
    [printSetting setInteger: printInfo.nOrientation forKey:@"orientation"];
    [printSetting setInteger: printInfo.nHalftone forKey:@"halftone"];
    [printSetting setInteger: printInfo.nHorizontalAlign forKey:@"horizontalAlign"];
    [printSetting setInteger: printInfo.nVerticalAlign forKey:@"verticalAlign"];
    [printSetting setInteger: printInfo.nPaperAlign forKey:@"paperAlign"];
    [printSetting setObject:customPaper forKey:@"customPaper"];
    
    if (isFuncAvailable(kFuncAutoCut, self.printerName)) {
        [printSetting setInteger: printInfo.nAutoCutFlag forKey:@"AutoCut"];
    }
    
    if (isFuncAvailable(kFuncChainPrint, self.printerName) ||
        isFuncAvailable(kFuncSpecialTape, self.printerName) ||
        isFuncAvailable(kFuncHalfCut, self.printerName)) {
        [printSetting setInteger: printInfo.nExMode forKey:@"ExMode"];
    }
    
    if (isFuncAvailable(kFuncCopies, self.printerName)) {
        [printSetting setInteger: copies forKey:@"Copies"];
    }
    
    if (isFuncAvailable(kFuncCarbonPrint, self.printerName)) {
        [printSetting setBool:isCarbon forKey:@"isCarbon"];
    }
    
    if (isFuncAvailable(kFuncDashPrint, self.printerName)) {
        [printSetting setBool:isDashPrint forKey:@"isDashPrint"];
    }
    
    if (isFuncAvailable(kFuncFeedMode, self.printerName)) {
        [printSetting setInteger:feedMode forKey:@"feedMode"];
    }
    
    [printSetting synchronize];
    [self dismissModalViewControllerAnimated:YES];
}

////////////////////////////////////////////////////////////////////
//
- (IBAction)selectOrientation:(id)sender{
    switch ([sender selectedSegmentIndex])
	{
		case 0:	
		{
			printInfo.nOrientation = ORI_PORTRATE;
			break;
		}
		case 1: 
		{
			printInfo.nOrientation = ORI_LANDSCAPE;
			break;
		}
	}
}

////////////////////////////////////////////////////////////////////
//
- (IBAction)selectPrintMode:(id)sender{
    switch ([sender selectedSegmentIndex])
	{
		case 0:
		{
			printInfo.nPrintMode = PRINT_ORIGINAL;
			break;
		}
		case 1:
		{
			printInfo.nPrintMode = PRINT_FIT;
			break;
		}            
	}
}

////////////////////////////////////////////////////////////////////
//
- (IBAction)selectHalftone:(id)sender{
    switch ([sender selectedSegmentIndex])
	{
		case 0:
		{
			printInfo.nHalftone = HALFTONE_BINARY;
			break;
		}
		case 1:
		{
			printInfo.nHalftone = HALFTONE_ERRDIF;
			break;
		}
        case 2:
		{
			printInfo.nHalftone = HALFTONE_DITHER;
			break;
		}
	}
}

////////////////////////////////////////////////////////////////////
//
- (IBAction)selectHorizontalAlign:(id)sender{
    switch ([sender selectedSegmentIndex])
	{
		case 0:
		{
			printInfo.nHorizontalAlign = ALIGN_LEFT;
			break;
		}
		case 1:
		{
			printInfo.nHorizontalAlign = ALIGN_CENTER;
			break;
		}
        case 2:
		{
			printInfo.nHorizontalAlign = ALIGN_RIGHT;
			break;
		}
	}
}

////////////////////////////////////////////////////////////////////
//
- (IBAction)selectVerticalAlign:(id)sender{
    switch ([sender selectedSegmentIndex])
	{
		case 0:
		{
			printInfo.nVerticalAlign = ALIGN_TOP;
			break;
		}
		case 1:
		{
			printInfo.nVerticalAlign = ALIGN_MIDDLE;
			break;
		}
        case 2:
		{
			printInfo.nVerticalAlign = ALIGN_BOTTOM;
			break;
		}
	}
}

- (IBAction)selectAutoCut:(id)sender {
    UISwitch *aSwitch = (UISwitch *)sender;
    
    if (aSwitch.on) {
        printInfo.nAutoCutFlag |= FLAG_M_AUTOCUT;
    }
    else{
        printInfo.nAutoCutFlag &= ~FLAG_M_AUTOCUT;
    }
    
}

- (IBAction)selectHalfCut:(id)sender {
    UISwitch *aSwitch = (UISwitch *)sender;
    
    if (aSwitch.on) {
        printInfo.nExMode |= FLAG_K_HALFCUT;
    }
    else{
        printInfo.nExMode &= ~FLAG_K_HALFCUT;
    }
    
}

- (IBAction)selectChainPrint:(id)sender {
    UISwitch *aSwitch = (UISwitch *)sender;
    
    if (!aSwitch.on) {
        printInfo.nExMode |= FLAG_K_NOCHAIN;
    }
    else{
        printInfo.nExMode &= ~FLAG_K_NOCHAIN;
    }
}

- (IBAction)selectSpecialTape:(id)sender {
    UISwitch *aSwitch = (UISwitch *)sender;
    
    if (aSwitch.on) {
        printInfo.nExMode |= FLAG_K_SPTAPE;
    }
    else{
        printInfo.nExMode &= ~FLAG_K_SPTAPE;
    }
}

////////////////////////////////////////////////////////////////////
- (IBAction)selectFeedMode:(id)sender{
    switch ([sender selectedSegmentIndex])
	{
		case 0:
		{
			feedMode = 0;
			break;
		}
		case 1:
		{
			feedMode = EXT_PJ673_NFD;
			break;
		}
        case 2:
		{
			feedMode = EXT_PJ673_EOP;
			break;
		}
        case 3:
		{
			feedMode = EXT_PJ673_EPR;
			break;
		}
	}
}

////////////////////////////////////////////////////////////////////
- (IBAction)selectCarbon:(id)sender{
    if(self.carbon.on){
        isCarbon = true;
    }else{
        isCarbon = false;
    }
}

////////////////////////////////////////////////////////////////////
- (IBAction)selectDashPrint:(id)sender{
    if(self.dashPrint.on){
        isDashPrint = true;
    }else{
        isDashPrint = false;
    }
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
	pickerView.delegate = self;
	pickerView.showsSelectionIndicator = YES;
    [pickerView setBackgroundColor:[UIColor whiteColor]];
    if (pickerType == 0) /* PaperSize */
    {
        NSUInteger selectedIndex = [content indexOfObject:self.paper.currentTitle];
        if (selectedIndex != NSNotFound) {
            [pickerView selectRow:selectedIndex inComponent:0 animated:YES];
            pickerString = self.paper.currentTitle;
        }
        else{
            [pickerView selectRow:0 inComponent:0 animated:YES];
            pickerString = [content objectAtIndex:0];
        }
    }
    
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

////////////////////////////////////////////////////////////////////
//
//	Push [Paper list]
//
////////////////////////////////////////////////////////////////////
- (IBAction)selectPaper:(id)sender{
    NSLog(@"select paper for model[%@]",self.printerName);
    content = [[NSArray arrayWithArray:supportedPaperSizeForPrinter(self.printerName)] retain];
    
    pickerType = 0;
    [self showPicker];
}

////////////////////////////////////////////////////////////////////
//
//	Push [Custom Paper list]
//
////////////////////////////////////////////////////////////////////
- (IBAction)selectCustomPaperFile:(id)sender{
    content = [[NSArray alloc] initWithArray:customizedPapers(printerName)];
    pickerString = [content objectAtIndex:0];
    pickerType = 2;
    [self showPicker];
}

////////////////////////////////////////////////////////////////////
//
//	Push [Density Button]
//
////////////////////////////////////////////////////////////////////
- (IBAction)selectDensity:(id)sender{
	if ([self.printerName isEqualToString:kBROTHERPJ673]) {
		content = [[NSArray alloc] initWithObjects:@"0",@"1",@"2",@"3"
				   ,@"4",@"5",@"6",@"7"
				   ,@"8",@"9",@"10",nil];
	}
	else{
		content = [[NSArray alloc] initWithObjects:@"-5",@"-4",@"-3",@"-2"
				   ,@"-1",@"0",@"1",@"2"
				   ,@"3",@"4",@"5",nil];
	}
    
    pickerType = 1;
    pickerString = [content objectAtIndex:0];
    [self showPicker];
}

- (IBAction)selectCopies:(id)sender {
    content = [[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",
			   @"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",
			   @"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",
			   @"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",nil];
    pickerType = 3;
    pickerString = [content objectAtIndex:0];
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
	
	//	Process
    switch (pickerType) {
        case 0:
            printInfo.strPaperName = pickerString;
            [self.paper setTitle:pickerString forState:UIControlStateNormal];          
            break;            
        case 1:
            printInfo.nDensity = [pickerString intValue];
            [self.density setTitle:pickerString forState:UIControlStateNormal];
            break;
        case 2:
            customPaper = pickerString;
            [self.custom setTitle:pickerString forState:UIControlStateNormal];
            break;
        case 3:
            copies = pickerString.intValue;
            [self.copiesOption setTitle:pickerString forState:UIControlStateNormal];
            break;
    }
	//	Dismiss ActionSheet
	[actionSheet removeFromSuperview];
}

////////////////////////////////////////////////////////////////////
//
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)picker {
	
	//	the number of columns in the picker
	return 1;
}

////////////////////////////////////////////////////////////////////
//
- (NSInteger)pickerView:(UIPickerView *)picker numberOfRowsInComponent:(NSInteger)component {
	
	//	the number of rows in the picker
	return [content count];
}

////////////////////////////////////////////////////////////////////
//
- (NSString *)pickerView:(UIPickerView *)picker titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [content objectAtIndex:row];
}

////////////////////////////////////////////////////////////////////
//
- (void) pickerView:(UIPickerView *)picker didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    pickerString = [content objectAtIndex:row];
}

- (void)dealloc {
    [_autoCutOption release];
    [_chainPrintOption release];
    [_halfCutOption release];
    [_specialTapeOption release];
    [_copiesOption release];
    [super dealloc];
}
@end
