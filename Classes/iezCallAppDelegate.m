//
//  iezCallAppDelegate.m
//  iezCall
//
//  Created by Nagendra Shukla on 9/4/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "iezCallAppDelegate.h"
#import "PDFViewController.h"
//#import "FlurryAnalytics.h"
#import "Profile.h"

#import "AddressBook/AddressBook.h"
#import "AddressBook/ABRecord.h"

static UIViewController *prevSelectedController = nil;
@implementation iezCallAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize arrProfile;




#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application { 

//    [FlurryAnalytics startSession:@"MAC1EBW7C1K3Z5WJBU6A"];
    
    // Override point for customization after app launch    

	//RootViewController *rootViewController = (RootViewController *)[navigationController topViewController];
	
	// Initialize the profile array
	NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
	NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:@"Profiles"];
	if (dataRepresentingSavedArray != nil)
	{
        NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
        if (oldSavedArray != nil)
			arrProfile = [[NSMutableArray alloc] initWithArray:oldSavedArray];
        else
			arrProfile = [[NSMutableArray alloc] init];
	}else{
		arrProfile = [[NSMutableArray alloc] init];
	}
    
    [window addSubview:tabBarController.view];

	prevSelectedController = [[tabBarController viewControllers] objectAtIndex:0];
    
    [window makeKeyAndVisible];
    
    
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	
  
}


// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
	prevSelectedController = viewController;
    UIViewController *aboutVC = [[self.tabBarController viewControllers] objectAtIndex:1];
    if (aboutVC == viewController){
        UIWebView *adView = (UIWebView*)[[viewController view] viewWithTag:1];
    
        NSURL *url = [NSURL URLWithString:@"http://mtgr8.com/mobile/pocketlistings/ads/pezcads1.html"];
        [adView loadRequest:[NSURLRequest requestWithURL:url]];
        adView.scalesPageToFit = YES;
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
	if(prevSelectedController == viewController)
		return NO;
	return YES;
}

#pragma mark -
#pragma mark Persistence

- (void) persist{
	[[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:arrProfile] forKey:@"Profiles"];
}


- (void) shareAppButtonTap{
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
            
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
            NSString *to = @"";
            NSString *subject = @"Check out pocketEzCall";
            NSString *body = @"Check out this application that lets you just Tap 'n Join your conference call. <br/> <a href=\"http://itunes.apple.com/us/app/pocketezcall/id499442279?mt=8\">Download pocketEzCall from App Store</a> <br/><br/><br/> \
            For <a href=\"http:pocketezcall.com\">help</a> and updates \"Like\" our Facebook Page.<br/>";
            
            [self displayComposerSheet:to withSubject:subject withBody:body];

        }
	}
	

}

- (void) emailButtonTap{
    //NSLog(@"Email button clicked");
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    NSString *url = @"mailto:info@pocketezcall.com?subject=pocketEzCall%20Feedback";
    
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
            NSString *to = @"info@pocketezcall.com";
            NSString *subject = @"pocketEzCall Feedback";
            NSString *body = @"<br/><br/>";
            
            [self displayComposerSheet:to withSubject:subject withBody:body];
        }
		else
		{
			[self launchMailAppOnDevice:url];
		}
	}
	else
	{
		[self launchMailAppOnDevice:url];
	}

}


- (void) displayComposerSheet :(NSString *)to withSubject:(NSString *)subject withBody:(NSString *)body {
   // NSURL *proto = [NSURL URLWithString:@"pocketezcall://save?name=joe&cdn=18666824770&mid=1074553&pcode=123456&hp=no"];
    //[[UIApplication sharedApplication] openURL:proto];
   
     UIViewController *mainVC = [[tabBarController viewControllers] objectAtIndex:0];
     MFMailComposeViewController *composeVC = [[MFMailComposeViewController alloc] init];
     composeVC.mailComposeDelegate = self;
     [composeVC setSubject:subject];
     NSArray *arrTo = [NSArray arrayWithObject:to];
     [composeVC setToRecipients:arrTo];
     [composeVC setMessageBody:body isHTML:YES];
     [mainVC presentModalViewController:composeVC animated:YES];
     [composeVC release];
     
}

- (void) launchMailAppOnDevice:(NSString *) url{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}



// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{   
    UIViewController *mainVC = [[tabBarController viewControllers] objectAtIndex:0];
    [mainVC dismissModalViewControllerAnimated:YES];
}



- (IBAction) agreementButtonTab:(UISegmentedControl *)sender
{
	//NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"License" ofType:@"pdf"]];
    NSURL *url = [NSURL URLWithString:@"http://spreadyourbrand.com/pocketamp/License.pdf"];
	PDFViewController *pdfVC = [[PDFViewController alloc] initWithNibName:@"PDFViewController" bundle:[NSBundle mainBundle] pdfURL:url];
	[self.tabBarController presentModalViewController:pdfVC animated:YES];
    
}
- (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] initWithCapacity:6] autorelease];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    //NSLog(@"url host %@",[url host]);
    NSDictionary *dic = [self parseQueryString:[url query]];
    
    //pocketezcall://save,name=joe,cdn=18666824770,mid=9988776,pcode=123456,hp=no
    
    Profile *profile = [[Profile alloc] init];
      
    if ([dic objectForKey:@"name"])
        [profile setProfileName:[dic objectForKey:@"name"]];
    
    if ([dic objectForKey:@"cdn"])
        [profile setDialInNumber:[dic objectForKey:@"cdn"]];
    
    if ([dic objectForKey:@"mid"])
        [profile setMeetingId:[dic objectForKey:@"mid"]];
    
    if ([dic objectForKey:@"pcode"])
        [profile setPasscode:[dic objectForKey:@"pcode"]];
    
    if ([dic objectForKey:@"hp"]){
        if ([[dic objectForKey:@"hp"] isEqual:@"on"])
            [profile setHardPause:@"ON"];
        else
            [profile setHardPause:@"OFF"];
    }
    if ([dic objectForKey:@"pbn"]){
        if ([[dic objectForKey:@"pbn"] isEqual:@"on"])
            [profile nameBeforePin:@"ON"];
        else
            [profile nameBeforePin:@"OFF"];
    }
    
    
    //[profile dump];
	
    [[self arrProfile] addObject: profile];
    [self persist];
    [profile release];
    UIViewController *navVC = [[tabBarController viewControllers] objectAtIndex:0];
    [navVC viewWillAppear:TRUE];


	return YES;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[arrProfile release];
	[tabBarController release];
	[window release];
	[super dealloc];
}


@end

