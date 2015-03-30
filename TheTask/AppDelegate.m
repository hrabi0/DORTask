//
//  AppDelegate.m
//  TheTask
//
//  Created by Bartek Kozłowski on 28/03/15.
//  Copyright (c) 2015 Bartosz Kozlowski. All rights reserved.
//

#import "AppDelegate.h"
#import "DatabaseManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"APPLICATION DIRECTORY: %@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[DatabaseManager sharedInstance] saveContext];
}


@end
