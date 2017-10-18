//
//  OptionView.h
//  SDK_Sample_RJ4040
//
//  Created by BIL on 12/08/01.
//  Copyright (c) 2012 Brother Industries, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BRPtouchPrinterKit/BRPtouchPrintInfo.h>
//#import <BRPtouchPrinterKit/BrPtRj4040_def.h>


@interface OptionView : UIViewController<UIActionSheetDelegate,UIPickerViewDelegate, UIPickerViewDataSource>{
    BRPtouchPrintInfo *printInfo;
	UIView *actionSheet;
    NSArray       *content;
    NSString *pickerString;
    NSString *customPaper;
    int copies;
    int pickerType;
    BOOL isCarbon;
    BOOL isDashPrint;
    int feedMode;
}
@property (nonatomic, retain) IBOutlet UIButton *paper;
@property (nonatomic, retain) IBOutlet UIButton *density;
@property (nonatomic, retain) IBOutlet UIButton *custom;
@property (nonatomic, retain) IBOutlet UISegmentedControl *orientation;
@property (nonatomic, retain) IBOutlet UISegmentedControl *printMode;
@property (nonatomic, retain) IBOutlet UISegmentedControl *halftone;
@property (nonatomic, retain) IBOutlet UISegmentedControl *horizontalAlign;
@property (nonatomic, retain) IBOutlet UISegmentedControl *verticalAlign;
@property (retain, nonatomic) IBOutlet UISwitch *autoCutOption;
@property (retain, nonatomic) IBOutlet UISwitch *chainPrintOption;
@property (retain, nonatomic) IBOutlet UISwitch *halfCutOption;
@property (retain, nonatomic) IBOutlet UISwitch *specialTapeOption;
@property (retain, nonatomic) IBOutlet UIButton *copiesOption;
@property (nonatomic, retain) IBOutlet UISegmentedControl *feedModeOption;
@property (nonatomic, retain) IBOutlet UISwitch *carbon;
@property (nonatomic, retain) IBOutlet UISwitch *dashPrint;

@property (retain, nonatomic) NSString *printerName;

- (IBAction)selectOrientation:(id)sender;
- (IBAction)selectPrintMode:(id)sender;
- (IBAction)selectHalftone:(id)sender;
- (IBAction)selectHorizontalAlign:(id)sender;
- (IBAction)selectVerticalAlign:(id)sender;
- (IBAction)savePrintSetting:(id)sender;
- (IBAction)selectPaper:(id)sender;
- (IBAction)selectDensity:(id)sender;
- (IBAction)selectCustomPaperFile:(id)sender;
- (IBAction)selectFeedMode:(id)sender;
- (IBAction)selectCarbon:(id)sender;
- (IBAction)selectDashPrint:(id)sender;
//- (BOOL)closePicker:(id)sender;

@end
