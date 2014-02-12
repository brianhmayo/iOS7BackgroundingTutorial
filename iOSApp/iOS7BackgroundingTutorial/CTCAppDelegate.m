//
//  CTCAppDelegate.m
//  iOS7BackgroundingTutorial
//
//  Created by Brian H Mayo on 9/21/13.
//  Copyright (c) 2013 CapTech Consulting. All rights reserved.
//

#import "CTCAppDelegate.h"
#import "CTCViewController.h"

@interface CTCAppDelegate ()

@property (strong, nonatomic) CTCViewController *viewController;

@end

@implementation CTCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Set the minimum background fetch internal to the system minimum
    //  to disable the background fetching, set this to UIApplicationBackgroundFetchIntervalNever
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    return YES;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // send the message to perform the fetch and get back if new data was received
    // if new data, call the application delegate announcing new data, otherwise, no data
    // a third consideration is a failure, which is announced calling the application delegate
    //  with the UIBackgroundFetchResultFailed as the result
    self.viewController = (CTCViewController*) self.window.rootViewController;
    
    [self.viewController updateArticlesWithCompletionHandler:^(BOOL success, int fetchedArticlesCount) {
        if (success) {
            if (fetchedArticlesCount > 0) {
                completionHandler(UIBackgroundFetchResultNewData);
            } else {
                completionHandler(UIBackgroundFetchResultNoData);
            }
        } else {
            completionHandler(UIBackgroundFetchResultFailed);
        }
    }];
}
							
@end
