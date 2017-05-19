//
//  EditViewController.m
//  iezCall
//
//  Created by Nagendra Shukla on 9/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EditViewController.h"
#import "iezCallAppDelegate.h"
#import "Profile.h"


@implementation EditViewController

@synthesize profileName, dialInNumber, meetingNumber, passcode, leaderPin, newProfile, prof, pauseCount, hardPause, nameBeforePin;

/*

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	NSLog(@"called editview NIG");
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveAction)];
	//NSLog(@"editViewCtrl newProfile is %d", newProfile);	
	if (self.newProfile == FALSE){
		[self populateView];
	}
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
	
	passcode.delegate = self;
	leaderPin.delegate = self;
	profileName.delegate = self;
	dialInNumber.delegate = self;
	meetingNumber.delegate = self;
	pauseCount.delegate = self; 
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

}

-(void)dismissKeyboard {
    [profileName resignFirstResponder];
    [dialInNumber resignFirstResponder];
    [meetingNumber resignFirstResponder];
    [passcode resignFirstResponder];
    [leaderPin resignFirstResponder];
	//[pauseCount resignFirstResponder];
	

}
// PopualteView

- (void) populateView {
	//NSLog(@"Called editViewCtrl populateView");
	self.profileName.text = [prof profileName];
	self.dialInNumber.text = [prof dialInNumber];
	self.meetingNumber.text = [prof meetingId];
	self.passcode.text = [prof passcode];
	self.leaderPin.text = [prof leaderPin];
	self.pauseCount.text = [prof pauseCount];
    if ([[prof hardPause] isEqualToString:@"ON"])
        [hardPause setOn:true ];
    else
        [hardPause setOn:false ];
    if ([[prof nameBeforePin] isEqualToString:@"ON"])
        [nameBeforePin setOn:true ];
    else
        [nameBeforePin setOn:false ];
}

// this helps dismiss the keyboard when the "done" button is clicked
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField == profileName){
		[textField resignFirstResponder];
		[dialInNumber becomeFirstResponder];
	}else if (textField == dialInNumber){
		[textField resignFirstResponder];
		[meetingNumber becomeFirstResponder];
	}else if (textField == meetingNumber){
		[textField resignFirstResponder];
		[passcode becomeFirstResponder];
	}else if (textField == passcode){
		[textField resignFirstResponder];
    }else if (textField == leaderPin){
		[textField resignFirstResponder];
	//	[pauseCount becomeFirstResponder];
	//}else if (textField == pauseCount){
	//	[textField resignFirstResponder];
	}
    

	return YES;
}

// Save the entry
- (void)saveAction
{
	iezCallAppDelegate *delegate = (iezCallAppDelegate*)[[UIApplication sharedApplication] delegate];

	Profile *profile = [[Profile alloc] init];

	if ((profileName.text.length > 0 ) && (dialInNumber.text.length > 0)){
		[profile setProfileName:profileName.text];
		
		dialInNumber.text.length > 0 ? [profile setDialInNumber:dialInNumber.text] : [profile setDialInNumber:dialInNumber.placeholder];
		
        meetingNumber.text.length > 0 ?[profile setMeetingId:meetingNumber.text]:[profile setMeetingId:meetingNumber.placeholder];
		
        passcode.text.length > 0 ? [profile setPasscode:passcode.text] : [profile setPasscode:passcode.placeholder];
		
        leaderPin.text.length > 0 ? [profile setLeaderPin:leaderPin.text]:[profile setLeaderPin:leaderPin.placeholder];
		//pauseCount.text.length > 0 ? [profile setPauseCount:pauseCount.text]:[profile setPauseCount:pauseCount.placeholder];
        
        [profile setPauseCount:@"4"]; // hardcoding
        
        if ([hardPause isOn])
            [profile setHardPause:@"ON"];
        else
            [profile setHardPause:@"OFF"];
       
        if ([nameBeforePin isOn])
           [profile setNameBeforePin:@"ON"];
        else
            [profile setNameBeforePin:@"OFF"];
        
		//[profile dump];
	
        if (self.newProfile == TRUE){
			//NSLog(@"Newprofile at index %d", self.prof.index);
			[[delegate arrProfile] addObject: profile];
		}else{
			//NSLog(@"OldProfile at index %d", self.prof.index);
			[[delegate arrProfile] removeObjectAtIndex:self.prof.index];
			[[delegate arrProfile] insertObject:profile atIndex:self.prof.index];

		}
		self.prof.index = -1;
		//NSLog(@"Size of array %d", delegate.arrProfile.count);
	
		//[[(iezCallAppDelegate*)[[UIApplication sharedApplication] delegate] navigationController] popToRootViewControllerAnimated:YES];
        
        [[[[delegate tabBarController] viewControllers] objectAtIndex:0] popViewControllerAnimated:YES];
        
        
	}else {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		UIAlertView *progressAlert = [[UIAlertView alloc] initWithTitle:@""
																message: @"Profile Name and Dial-in #  can't be empty."
															   delegate: self
													  cancelButtonTitle: nil
													  otherButtonTitles: @"Ok",nil];
		
		[progressAlert show];
		[progressAlert release];
		[pool drain];
		
	}
		
	[delegate persist];
	
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
//[self saveAction];
}


- (void) emailButtonTap{
    //NSLog(@"Email button clicked");
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			[self displayComposerSheet];
		}
		else
		{
			[self launchMailAppOnDevice];
		}
	}
	else
	{
		[self launchMailAppOnDevice];
	}
    
}


- (void) displayComposerSheet{
    iezCallAppDelegate *delegate = (iezCallAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //UIViewController *mainVC = [[[delegate tabBarController] viewControllers] objectAtIndex:0];
    MFMailComposeViewController *composeVC = [[MFMailComposeViewController alloc] init];
    composeVC.mailComposeDelegate = delegate;
    NSString *subject = @"pocketEzCall Settings: ";
    [composeVC setSubject:[subject stringByAppendingFormat:profileName.text]];
    NSArray *arrTo = [NSArray arrayWithObject:@""];
    [composeVC setToRecipients:arrTo];
    
    NSString *signature =@"<br/> To install pocketEzCall tap <A href=\"http://itunes.apple.com/us/app/pocketezcall/id499442279?mt=8\">here</A><br/><br/>\
    For <a href=\"http:pocketezcall.com\">help</a> and updates \"Like\" our Facebook Page.<br/>";
    
    NSString *name = [NSString stringWithFormat:@"Conf. Name: %@", profileName.text];
    NSString *dialin = [@"Dial-in #: " stringByAppendingString:dialInNumber.text];
    NSString *mid = @"Meeting ID: ";
    NSString *code = @"Passcode: ";
    
    if (meetingNumber.text != Nil)
         mid = [mid stringByAppendingString:meetingNumber.text];
    if (passcode.text != Nil)
        code = [code stringByAppendingString:passcode.text];
    
    //NSURL *proto = [NSURL URLWithString:@"pocketezcall://save?name=joe&cdn=18666824770&mid=1074553&pcode=123456&hp=no"];
    NSString *url = [NSString stringWithFormat:@"To save this profile to pocketEzCall tap <A href=\"pocketezcall://save?name=%@&cdn=%@&mid=%@&pcode=%@\">here</A>",profileName.text, dialInNumber.text,meetingNumber.text, passcode.text];
    
 
    NSString *body = [NSString stringWithFormat:@"%@<br/>%@<br/>%@<br/>%@<br/><br/>%@<br/>",name,dialin,mid, code, url]; 
    
    [composeVC setMessageBody:[body stringByAppendingFormat:signature] isHTML:YES];
    [self presentModalViewController:composeVC animated:YES];
    [composeVC release];
    
}

- (void) launchMailAppOnDevice{
    NSString *recipients = @"mailto:?subject=Sharing profile";
    
    
    NSString *signature =@"<br/><br/>-----------------------------<br/>\
    sent from <A href=\"http://itunes.apple.com/us/app/pocketezcall/id499442279?mt=8\">pocketEzCall</A>    <br/> \
    ----------------------------- <br/>";
    NSString *name = [NSString stringWithFormat:@"Name = %@", profileName.text];
    NSString *dialin = [@"Dialin = " stringByAppendingString:dialInNumber.text];
    NSString *mid = [@"MeetingId = " stringByAppendingString:meetingNumber.text];
    NSString *code = [@"Passcode = " stringByAppendingString:passcode.text];
    
    NSString *body = [NSString stringWithFormat:@"&body=%@<br/>%@<br/>%@<br/>%@%@",name,dialin,mid, code, signature]; 
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
    
    
}


- (void)dealloc {
	[prof dealloc];
    [super dealloc];
}


@end
