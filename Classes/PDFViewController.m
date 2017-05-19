//
//  PDFViewController.m

//
//  Created by Akshay on 17/04/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "PDFViewController.h"


@implementation PDFViewController
@synthesize webView,pdfUrl,doneButton;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil pdfURL:(NSURL*)pdfURL{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		self.pdfUrl = pdfURL;
    }
    return self;
}

- (IBAction) handleDone:(UIBarButtonItem *)sender
{
	[self dismissModalViewControllerAnimated:YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	// Tells the webView to load pdfUrl
	[webView loadRequest:[NSURLRequest requestWithURL:pdfUrl]];
	webView.scalesPageToFit = YES;
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


// Dealloc method -- webView, pdfURL
- (void)dealloc {
	[webView release];
	[pdfUrl release];
	[super dealloc];
}



@end
