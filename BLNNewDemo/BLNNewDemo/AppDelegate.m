//
//  AppDelegate.m
//  BLNNewDemo
//
//  Created by 齐科 on 2019/8/28.
//  Copyright © 2019 齐科. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self registBLNSDK];
    return YES;
}
- (void)registYLSDK {
    [[YLSocialManager sharedInstance] verifyAppId:YouLingAppId secret:YouLingAppSecret complete:^(YLRespObject * _Nonnull object) {
        if (object.result) {
            NSLog(@"友令APP授权校验成功");
        }else {
            NSLog(@"友令APP授权失败,%@", object.ylError.userInfo);
        }
    }];
}
- (void)registBLNSDK {
    [[BLNSocialManager sharedInstance] verifyAppId:BLNAppId secret:BLNAppSecret complete:^(BLNRespObject * _Nonnull object) {
        if (object.result) {
            NSLog(@"玻璃牛APP授权校验成功");
        }else {
            NSLog(@"玻璃牛APP授权失败,%@", object.blnError.userInfo);
        }
    }];
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
//    if ([url.host containsString:@"youling"]) {
//        return [[YLSocialManager sharedInstance] handleOpenURL:url
//                                                      callBack:^(YLRespObject * _Nonnull respObject) {
//
//                                                      }];
//    }
    if ([url.host containsString:@"boliniu"]) {
        [[BLNSocialManager sharedInstance] handleOpenURL:url callBack:^(BLNRespObject * _Nonnull respObject) {
            
        }];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.host containsString:@"boliniu"]) {
        return [[BLNSocialManager sharedInstance]handleOpenURL:url callBack:^(BLNRespObject *respObject) {
            
        }];
        
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([url.host containsString:@"boliniu"]) {
        return [[BLNSocialManager sharedInstance]handleOpenURL:url callBack:^(BLNRespObject *respObject) {
            
        }];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
