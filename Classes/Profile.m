//
//  Profile.m
//  iezCall
//
//  Created by Nagendra Shukla on 9/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Profile.h"

@implementation Profile 

@synthesize profileName, dialInNumber, passcode, meetingId, leaderPin, pauseCount,
hardPause, nameBeforePin, index;


- (void) dump {
	NSLog(@"ProfileName : %@", profileName);
	NSLog(@"DialNumber : %@", dialInNumber);
	NSLog(@"MeetingId : %@", meetingId);
	NSLog(@"Passcode : %@", passcode);
	NSLog(@"LeaderPin : %@", leaderPin);
	NSLog(@"Index :%@", index);
	NSLog(@"PauseCount: %@", pauseCount);
    NSLog(@"HardPause: %@", hardPause);
    NSLog(@"nameBeforePin: %@", nameBeforePin);

}

- (id) initWithCoder: (NSCoder *)coder
{
	//NSLog(@"init with coder called");
    if (self = [super init])
    {
        self.profileName = [coder decodeObjectForKey:@"profileName"];
        self.dialInNumber = [coder decodeObjectForKey:@"dialNumber"];
        self.meetingId = [coder decodeObjectForKey:@"meetingId"];
        self.passcode = [coder decodeObjectForKey:@"passcode"];
        self.leaderPin = [coder decodeObjectForKey:@"leaderPin"];
		self.pauseCount = [coder decodeObjectForKey:@"pauseCount"];
        self.hardPause = [coder decodeObjectForKey:@"hardPause"];
        self.nameBeforePin = [coder decodeObjectForKey:@"nameBeforePin"];
	}
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
	//NSLog(@"encode with coder called");
    [coder encodeObject:profileName forKey:@"profileName"];
    [coder encodeObject:dialInNumber forKey:@"dialNumber"];
    [coder encodeObject:meetingId forKey:@"meetingId"];
    [coder encodeObject:passcode forKey:@"passcode"];
    [coder encodeObject:leaderPin forKey:@"leaderPin"];
	[coder encodeObject:pauseCount forKey:@"pauseCount"];
    [coder encodeObject:pauseCount forKey:@"hardPause"];
    [coder encodeObject:nameBeforePin forKey:@"nameBeforePin"];
}

// In the implementation
-(id)copyWithZone:(NSZone *)zone
{
	// We'll ignore the zone for now
	Profile *another = [[Profile alloc] init];
	another.profileName = [profileName copyWithZone: zone];
	another.dialInNumber = [dialInNumber copyWithZone: zone];
	another.meetingId = [meetingId copyWithZone: zone];
	another.passcode = [passcode copyWithZone: zone];
	another.leaderPin = [leaderPin copyWithZone: zone];
	another.pauseCount = [pauseCount copyWithZone: zone];
    another.hardPause = [hardPause copyWithZone: zone];
    another.nameBeforePin = [nameBeforePin copyWithZone: zone];
	
	return another;
}
@end
