//
//  Utilities.h
//  SDK_Sample
//
//  Created by Sha Peng on 5/15/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utilities : NSObject

BOOL isFuncAvailable(NSString *func , NSString *printerName);
NSDictionary* supportedFuncForPrinter(NSString *printerName);
NSArray* supportedPaperSizeForPrinter(NSString *printerName);
NSArray* customizedPapers(NSString *printerName);
NSString* defaultCustomizedPaper(NSString *printerName);
BOOL isAvailableDensity(NSString *printerName, NSInteger density);
NSString* sharedDocumentRootPath(void);

@end
