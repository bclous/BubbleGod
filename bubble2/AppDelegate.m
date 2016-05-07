//
//  AppDelegate.m
//  bubble2
//
//  Created by Brian Clouser on 4/13/16.
//  Copyright © 2016 Clouser. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resignActiveCalled" object:nil];
    
    NSLog(@"app will resign active called");
    
 
    

    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"didEnterBackgroundCalled" object:nil];
    
    NSLog(@"app did enter background called");
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
     NSLog(@"app will enter foreground called");
    
    
    NSLog(@"were in app coming backin app delegate");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"willEnterForegroundCalled" object:nil];
    
      // [[NSNotificationCenter defaultCenter] postNotificationName:@"appComingBack" object:nil];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSLog(@"application did become active called");
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"didBecomeActiveCalled" object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
