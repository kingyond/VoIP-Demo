//
//  AppDelegate.swift
//  VoIP-Demo
//
//  Created by Stefan Natchev on 2/5/15.
//  Copyright (c) 2015 ZeroPush. All rights reserved.
//

import UIKit
import PushKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PKPushRegistryDelegate, ZeroPushDelegate {

    var window: UIWindow?
    var viewController: ViewController?

    func registerVoipNotifications() {
        let voipRegistry: PKPushRegistry = PKPushRegistry(queue: dispatch_get_main_queue())
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = NSSet(object: PKPushTypeVoIP)
        NSLog("VoIP registered")
        let types: UIUserNotificationType = (UIUserNotificationType.Badge | UIUserNotificationType.Sound | UIUserNotificationType.Alert)
        let notificationSettings = UIUserNotificationSettings(forTypes:types, categories:nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
    }

    func pushRegistry(registry: PKPushRegistry!, didUpdatePushCredentials credentials: PKPushCredentials!, forType type: String!) {

        let voipZeroPush = ZeroPush()
        //TODO: set your own tokens here
#if DEBUG
        voipZeroPush.apiKey = "iosdev_xxxxxxxxxxx"
#else
        voipZeroPush.apiKey = "iosprod_xxxxxxxxxx"
#endif
        voipZeroPush.registerDeviceToken(credentials.token, channel: "me")

        //UI updates must happen on main thread
        dispatch_async(dispatch_get_main_queue(), {
            let deviceToken = ZeroPush.deviceTokenFromData(credentials.token)
            NSLog("VoIP Token: %@ subscribed to channel `me`", deviceToken)
            self.viewController?.tokenLabel.text = deviceToken
            self.viewController?.payloadLabel.hidden = false
        })
    }

    func pushRegistry(registry: PKPushRegistry!, didReceiveIncomingPushWithPayload payload: PKPushPayload!, forType type: String!) {
        //handle push event
        let data = payload.dictionaryPayload
        let notification = UILocalNotification()
        NSLog("%@", data)

        //UI updates must happen on main thread
        dispatch_async(dispatch_get_main_queue(), {
            let _ = self.viewController?.payloadLabel.text = data.description
        })

        //setup the notification
        let aps = (data["aps"] as [NSString: AnyObject])
        notification.alertBody = aps["alert"] as NSString!
        notification.category = aps["category"] as NSString!

        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }

    func pushRegistry(registry: PKPushRegistry!, didInvalidatePushTokenForType type: String!) {
        //unregister
        NSLog("Unregister")
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        viewController = self.window?.rootViewController as ViewController?;
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

