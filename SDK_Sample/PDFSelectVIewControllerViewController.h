//
//  PDFSelectVIewControllerViewController.h
//  SDK_Sample
//
//  Created by Sha Peng on 9/9/14.
//
//

#import <UIKit/UIKit.h>

@protocol MainViewControllerProtocol <NSObject>
@required
- (void)tableView:(UIViewController *)viewCtr didSelectPDFPath:(NSString *)pdfPath;
@end

@interface PDFSelectVIewControllerViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
	id <MainViewControllerProtocol> delegate;
	NSArray *sharedPDFArray;
}
@property(nonatomic, assign) id <MainViewControllerProtocol> delegate;
@property(nonatomic, retain) NSArray *sharedPDFArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id)delegate;

@end
