//
//  PDFViewController.h

//
//  Created by Akshay on 17/04/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PDFViewController : UIViewController {
	IBOutlet  UIWebView	*webView;
	NSURL		*pdfUrl;
	UIBarButtonItem *doneButton;
}

@property (nonatomic, retain) IBOutlet UIWebView	*webView;
@property (nonatomic, retain) NSURL			*pdfUrl;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil pdfURL:(NSURL*)pdfURL;
- (IBAction) handleDone:(UIBarButtonItem *)sender;

@end
