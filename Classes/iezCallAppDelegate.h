//
//  iezCallAppDelegate.h
//  iezCall
//
//  Created by Nagendra Shukla on 9/4/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//
#import <MessageUI/MessageUI.h>
@interface iezCallAppDelegate : NSObject<UIApplicationDelegate, UITabBarControllerDelegate,MFMailComposeViewControllerDelegate > {

    UIWindow *window;
    UITabBarController *tabBarController;
	
	NSMutableArray *arrProfile;

}
@property (nonatomic,retain) NSMutableArray *arrProfile;
//@property (nonatomic,retain) NSUserDefaults *defaults;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

- (NSString *)applicationDocumentsDirectory;
- (void) persist;

- (IBAction) shareAppButtonTap;
- (IBAction) emailButtonTap;
- (IBAction) agreementButtonTab:(UISegmentedControl *)sender;

- (NSDictionary *)parseQueryString:(NSString *)query ;
-(void)displayComposerSheet :(NSString *)to 
                 withSubject:(NSString *) subject
                    withBody:(NSString *)body;
-(void)launchMailAppOnDevice :(NSString *)url;


@end

