//
//  RootViewController.m
//  iezCall
//
//  Created by Nagendra Shukla on 9/4/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "RootViewController.h"
#import "EditViewController.h"
#import "iezCallAppDelegate.h"
#import "Profile.h"

@implementation RootViewController

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];	

	// set the title
	[[self navigationItem] setTitle:@"Profiles"];
	// Set up the edit and add buttons.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
    
    // If there is not profile yet, go to the Insert New Object
    iezCallAppDelegate *delegate = (iezCallAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSMutableArray *arrProfile = [delegate arrProfile];	

    if (arrProfile.count == 0)
    {
        [self insertNewObject];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	//NSLog(@"RootController appeared");
	[self.tableView reloadData];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

- (void)viewDidUnload {
	// Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	// For example: self.myOutlet = nil;
}

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


#pragma mark -
#pragma mark Add a new object

- (void)insertNewObject {
	
	EditViewController *editViewController = [[EditViewController alloc] initWithNibName:@"EditViewController" bundle:nil];
	editViewController.newProfile = TRUE;
	[self.navigationController pushViewController:editViewController animated:YES];
	[editViewController release];
	
}

- (void)callButtonTapped:(NSIndexPath *)indexPath
{
    //NSLog(@"call button Tapped");

	iezCallAppDelegate *delegate = (iezCallAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSMutableArray *arrProfile = [delegate arrProfile];	
	
	int i = [indexPath indexAtPosition:1];
	Profile *prof =[arrProfile objectAtIndex:i];

    //[prof dump];
    
    NSString * callSeq =@"";
    
	Boolean hardPause = false;
    if ([[prof hardPause] isEqualToString:@"ON"])
        hardPause = true;
    
    Boolean nameBeforePin = false;
    if ([[prof nameBeforePin] isEqualToString:@"ON"])
        nameBeforePin = true;
        
    NSString *pause = [[NSString alloc] init];
    
    if (!hardPause){
        // Get the number of pauses
        NSString *pauseCount = [prof pauseCount] ;
        
        int count = 4;
        
        if (pauseCount != Nil)
            count = [pauseCount intValue];
	
        
        while(count > 0){
            pause = [pause stringByAppendingString:@","];
            count--;
        }
    }else{
            pause = @";";
    }

    // Dial number and pause
    NSString *dialNum = [[prof dialInNumber] stringByAppendingString:pause];
    
    // Meeting Id with hash and pauses
    NSString *meetId = [[prof meetingId] stringByAppendingString:pause];
   
    // Passcode 
    NSString *pass = [[prof passcode] stringByAppendingString:pause];
    
    // Name with hash and pauses
    NSString *name = [[prof meetingId] stringByAppendingString:pause];
    
    
    
    if ( [[prof leaderPin]length] == 0 ){ // Joining the call
        
        // 18666824770,,,,1074553#,,#,,123456#
        // diailNum + ",," + meetId + "#,,#,," + pass + "#"
        // tel:18666824770,,,,9988776,,,,,,,,123456,,,,
        if (meetId != Nil){
            callSeq = [dialNum stringByAppendingString:meetId];
            if (nameBeforePin){
                //NSLog(@"Name before Pin");
                // Calling the name before the password
                [callSeq stringByAppendingString:name];
                if (pass != Nil){
                    callSeq = [callSeq stringByAppendingString:pass];
                }
                
            }else{
                //NSLog(@"Pin before Name");
                if (pass != Nil){
                    callSeq = [callSeq stringByAppendingString:pass];
                }
                // Calling the name after the password
                [callSeq stringByAppendingString:name];
               
            }
            
        }else{
            callSeq = dialNum;
        }
        
        
    }else{ // Starting the call
        
        NSString *asLeader = @"*,,";
        NSString *start = @"1#,,,,#";
        // Leader Pin 
        NSString *leaderPin = [[prof leaderPin] stringByAppendingString:pause];
    
        // For starting the call
        //NSString[*telString = @"tel:18666824770,,,,1074553,,,,*,,999999999,,,,123456,,,,1#,,,,#";
        // Single Pause meeting id
         NSString *meetIdSP = [[prof meetingId] stringByAppendingString:pause];
        
        callSeq = [[[[[dialNum stringByAppendingString:meetIdSP]
                      stringByAppendingString:asLeader]
                     stringByAppendingFormat:leaderPin]
                    stringByAppendingString:pass]
                   stringByAppendingString:start];
    }
        

	
	NSString *telString = [NSString stringWithFormat:@"tel:%@",callSeq];
    
	NSLog(@"TelString is %@", telString);
    
    
    /* 
    Calling the phone with in the applciation
    When the call is done the control still remains in the application
    */
    if (false){
        UIWebView *webview = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame]; 
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:telString]]]; 
        webview.hidden = YES; 
        // Assume we are in a view controller and have access to self.view 
        [self.view addSubview:webview]; 
        [webview release]; 
	}else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
    }
	
   }


#pragma mark -
#pragma mark Table view methods
/*
- (void)setEditing:(BOOL)editing animated:(BOOL)animate {
    if (editing)
        NSLog(@"Editing is true");
    else
        NSLog(@"Editing is false");
    if (animate)
        NSLog(@"animate is true");
    else
        NSLog(@"animate is false");    
}
 */


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	iezCallAppDelegate *delegate = (iezCallAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSMutableArray *arrProfile = [delegate arrProfile];	
	//NSLog(@"Number of rows in section %d", arrProfile.count);
	return arrProfile.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.showsReorderControl = TRUE;
    }
	
	iezCallAppDelegate *delegate = (iezCallAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSMutableArray *arrProfile = [delegate arrProfile];	

	int i = [indexPath indexAtPosition:1];
	Profile *prof =[arrProfile objectAtIndex:i];
	
	cell.textLabel.text = [prof profileName];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
   // NSLog(@"accessory Button Tapped");
    
    EditViewController *editViewController = [[EditViewController alloc] initWithNibName:@"EditViewController" bundle:nil];
	
	editViewController.newProfile = FALSE;
	iezCallAppDelegate *delegate = (iezCallAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSMutableArray *arrProfile = [delegate arrProfile];	
	
	int i = [indexPath indexAtPosition:1];
	//Profile *prof = [[Profile alloc] init];
	Profile *prof =[[arrProfile objectAtIndex:i] copy];
	prof.index = i;
	//NSLog(@"Calling with newProfile value of false with index %d", prof.index);
	//[prof dump];
	editViewController.prof = prof;
	//[prof release];
	
	[self.navigationController pushViewController:editViewController animated:YES];
	[editViewController release];
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// 
    //NSLog(@"did select Row at Index");
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self callButtonTapped:indexPath]; 
      
   }



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

	int i = [indexPath indexAtPosition:1];
	iezCallAppDelegate *delegate = (iezCallAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSMutableArray *arrProfile = [delegate arrProfile];	
	//NSLog(@"Removing element from array at index %d", i);
	[arrProfile removeObjectAtIndex:i];
	[self.tableView reloadData];
	[delegate persist];
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    //return NO;
    return YES; // testing for reording, and implement moveRowAtIndexPath
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {

    int toIndex = [toIndexPath indexAtPosition:1];
    int fromIndex = [fromIndexPath indexAtPosition:1];
    
    //NSLog(@"Moving from %d", fromIndex);
    //NSLog(@"Moving to %d", toIndex);

	iezCallAppDelegate *delegate = (iezCallAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSMutableArray *arrProfile = [delegate arrProfile];	
    Profile *impactedObject = [[arrProfile objectAtIndex:fromIndex] copy];
    
    [arrProfile removeObjectAtIndex:fromIndex];
    [arrProfile insertObject:impactedObject atIndex:toIndex];
    
}



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	// Relinquish ownership of any cached data, images, etc that aren't in use.
}


- (void)dealloc {
    [super dealloc];
}


@end

