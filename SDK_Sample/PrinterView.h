//
//  PrinterView.h
//  SDK_Sample_Rj4040
//
//  Created by BIL on 12/09/03.
//
//

#import <Foundation/Foundation.h>
#import <BRPtouchPrinterKit/BRPtouchPrinterKit.h>

@interface PrinterView : UIViewController <BRPtouchNetworkDelegate>

{
	IBOutlet    UITableView*    tablePrinterList;		//	Printer List
	
	BRPtouchNetwork*			ptn;
	BRPtouchNetworkInfo*		pti;
	
	NSMutableArray*				aryListData;			//	IPAddress Array
    NSTimer*					tm;						//	Timer
	UIActivityIndicatorView*	indicator;				//	Indicator
	UIView*						loadingView;			//	Indicator view
    
}
@end
