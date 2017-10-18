//
//  ViewController.h
//  SDK_Sample_RJ4040
//
//  Created by BIL on 12/08/01.
//  Copyright (c) 2012 Brother Industries, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionView.h"
#import "PrinterView.h"
#import "PDFSelectVIewControllerViewController.h"

#import <BRPtouchPrinterKit/BRPtouchPrinterKit.h>


typedef enum : NSInteger {
	DocumentKindToPrintImage = 0,
	DocumentKindToPrintPDF
} DocumentKindToPrint;


@interface ViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIPickerViewDelegate, UIPickerViewDataSource,MainViewControllerProtocol>
{
    IBOutlet UIImageView *imgView;
    UIView *actionSheet;
    NSArray       *content;
    NSArray         *printerList;
    IBOutlet UIButton *selectPrinterButton;
    NSInteger selectedPrinterIndex;
    UIBackgroundTaskIdentifier bgTask;
	DocumentKindToPrint printKind;
	IBOutlet UIButton *selectPDF;
}


@property(nonatomic, retain) UIImagePickerController *imgPickerCtrller;
@property(nonatomic, retain) OptionView *option;
@property(nonatomic, retain) IBOutlet UITextField *ipInput;
@property(nonatomic, retain) NSString *pdfPathToPrint;

- (IBAction)selectImage:(id)sender;

- (IBAction)printOption:(id)sender;

-(IBAction)printImage:(id)sender;

-(IBAction)searchPrinter:(id)sender;

@end
