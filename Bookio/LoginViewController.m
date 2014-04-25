//
//  LoginViewController.m
//  Bookio
//
//  Created by Shrutika Dasgupta on 4/20/14.
//  Copyright (c) 2014 Shrutika Dasgupta. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
{
    AppDelegate *delegateApp;
    AppDelegate *appDelegateCore;
}
@synthesize managedObjectContext;



- (IBAction)buttonTouched:(id)sender
{
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for basic_info permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             [self makeRequestForUserData];
             
             // Retrieve the app delegate
             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
         }];
    }
}

- (void) makeRequestForUserData
{
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
           // NSLog(@"user info: %@", result);
            
            NSString *uid = [[NSString alloc] init];
            uid = [ result objectForKey:@"username"];
            NSString *ufn = [[NSString alloc] init];
            ufn = [result objectForKey:@"first_name"];
            NSString *uln = [[NSString alloc]init];
            uln = [result objectForKey:@"last_name"];
            
           // NSLog(@"uid-->%@\nufn-->%@\nuln-->%@",uid,ufn,uln);
            
            NSMutableDictionary *allUserDetails = [[NSMutableDictionary alloc] init];
            
            [allUserDetails setObject:uid forKey:@"user_id"];
            [allUserDetails setObject:ufn forKey:@"user_fname"];
            [allUserDetails setObject:uln forKey:@"user_lname"];
            
            delegateApp.userData = allUserDetails;
            
//            NSLog(@"test:%@",delegateApp.userData);
            
        } else {
            // An error occurred, we need to handle the error
            NSLog(@"error1 %@", error.description);
        }
    }];
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
    
    delegateApp = [[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegateCore.managedObjectContext;
    
  }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
@end