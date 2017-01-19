//
//  AppDelegate.swift
//  JoanClarke for iOS
//
//  Created by Carine Iskander on 8/17/16.
//  Copyright © 2016 Carine Iskander. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       /* let mainClaim = Claim(maxLength: 11, startIndex: 1, count: 2)
        let str = mainClaim.ClaimedText("hello world")
        print(str)

        var claim2 = Claim(maxLength: 5)
        claim2 = claim2.NextUnclaimedCharacter(1) // claims the first letter
        claim2 = claim2.NextUnclaimedCharacter(2) // claims the next 2 letters after the first letter
        print(claim2.ClaimedText("world"))
        
        claim2 = Claim(maxLength: 5)
        var claimPrev : Claim?
        claimPrev = claim2.NextUnclaimedCharacter(claimPrev)
        print(claimPrev!.ClaimedText("world"))
        claimPrev = claimPrev!.NextUnclaimedCharacter(claimPrev)
        print(claimPrev!.ClaimedText("world")) */
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

