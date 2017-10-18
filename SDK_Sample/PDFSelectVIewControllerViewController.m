//
//  PDFSelectVIewControllerViewController.m
//  SDK_Sample
//
//  Created by Sha Peng on 9/9/14.
//
//

#import "PDFSelectVIewControllerViewController.h"

@interface PDFSelectVIewControllerViewController ()

@end

@implementation PDFSelectVIewControllerViewController
@synthesize sharedPDFArray;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id)delegateIn
{
	self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.delegate = delegateIn;
		self.sharedPDFArray = [[NSArray alloc] initWithArray:[[self contentsPathArrayFromDirectory:sharedDocumentRootPath()] copy]];
	}
	return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}


- (NSArray *)contentsPathArrayFromDirectory:(NSString *)directoryPath
{
    NSError *error = nil;
    NSMutableArray *contentsArray = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
    NSArray *contents = [NSArray arrayWithArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:&error]];
    NSMutableArray *fileArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    if (contents.count > 0) {
        for (NSString *fileName in contents) {
            BOOL isDir;
            NSString *aPath = [directoryPath stringByAppendingPathComponent:fileName];
            [[NSFileManager defaultManager] fileExistsAtPath:aPath isDirectory:&isDir];
            
            if (!isDir) {
                if ([[aPath pathExtension].lowercaseString isEqualToString:@"pdf"])
				{
					[fileArray addObject:aPath];
					[aPath release];
				}
			}
        }
    }
    if (fileArray.count > 0) {
        [contentsArray addObjectsFromArray:fileArray];
    }
	[fileArray release];

    return (NSArray *)contentsArray;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.sharedPDFArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger rowIndex = indexPath.row;
	[self.delegate tableView:self didSelectPDFPath:self.sharedPDFArray[rowIndex]];
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger rowIndex = indexPath.row;
	NSString *cellTitle = nil;
	
	UITableViewCell *newTableViewCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
	cellTitle = [(NSString *)self.sharedPDFArray[rowIndex] lastPathComponent];
	[newTableViewCell.textLabel setText:cellTitle];
	
	return newTableViewCell;
}

- (void)dealloc {
	[super dealloc];
}

@end
