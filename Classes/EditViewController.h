//
//  EditViewController.h
//  iezCall
//
//  Created by Nagendra Shukla on 9/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Profile;
@interface EditViewController : UIViewController <UITextFieldDelegate> {
	
	
	IBOutlet UITextField *passcode;
	IBOutlet UITextField *leaderPin;
	IBOutlet UITextField *profileName;
	IBOutlet UITextField *dialInNumber;
	IBOutlet UITextField *meetingNumber;
	IBOutlet UITextField *pauseCount;
    IBOutlet UISwitch *hardPause;
    IBOutlet UISwitch *nameBeforePin;
	
	BOOL newProfile;
	
	Profile* prof;
	

}
- (void) populateView;
- (IBAction) emailButtonTap;
//- (IBAction)saveAndCall;
- (void) displayComposerSheet;
- (void) launchMailAppOnDevice;
@property (nonatomic, retain) Profile *prof;
@property (nonatomic) BOOL newProfile;
@property (nonatomic, retain) IBOutlet UITextField *passcode;
@property (nonatomic, retain) IBOutlet UITextField *leaderPin;
@property (nonatomic, retain) IBOutlet UITextField *profileName;
@property (nonatomic, retain) IBOutlet UITextField *dialInNumber;
@property (nonatomic, retain) IBOutlet UITextField *meetingNumber;
@property (nonatomic, retain) IBOutlet UITextField *pauseCount;
@property (nonatomic, retain) IBOutlet UISwitch *hardPause;
@property (nonatomic, retain) IBOutlet UISwitch *nameBeforePin;

@end
