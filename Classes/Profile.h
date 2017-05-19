//
//  Profile.h
//  iezCall
//
//  Created by Nagendra Shukla on 9/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Profile : NSObject <NSCoding, NSCopying>{

	NSString *profileName;
	NSString *dialInNumber;
	NSString *meetingId;
	NSString *passcode;
	NSString *leaderPin;
	NSString *pauseCount;
    NSString *hardPause;
    NSString *nameBeforePin;
	int index;
	
}
@property int index;
@property (nonatomic, retain) NSString *profileName;
@property (nonatomic, retain) NSString *dialInNumber;
@property (nonatomic, retain) NSString *meetingId;
@property (nonatomic, retain) NSString *passcode;
@property (nonatomic, retain) NSString *leaderPin;
@property (nonatomic, retain) NSString *pauseCount;
@property (nonatomic, retain) NSString *hardPause;
@property (nonatomic, retain) NSString *nameBeforePin;


- (void) dump;

@end
