//
//  AppDelegate.swift
//  iTime
//
//  Created by Димас on 6/7/16.
//  Copyright © 2016 Димас. All rights reserved.
//

import UIKit
import CoreLocation
import HockeySDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var locationController = LocationController()

    
    var userDefaults = NSUserDefaults.standardUserDefaults()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        initializeNotificationServices()
        UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        BITHockeyManager.sharedHockeyManager().configureWithIdentifier("2e6de5dd25d9413286c5683a84e0c5bf");
        BITHockeyManager.sharedHockeyManager().startManager();
        BITHockeyManager.sharedHockeyManager().authenticator.authenticateInstallation(); // This line is obsolete in the crash only build

        print("background fetch time = \(UIApplicationBackgroundFetchIntervalMinimum)")
        //locationController = LocationController()
        
        let ud = NSUserDefaults.standardUserDefaults()
        if let data = ud.objectForKey("user") as? NSData {
            if let user = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? LoginData {
                print("\n\n\n\n\n\n\n got user as user model\n\n\n\n\n\n\n\n")
                Manager.loginData = user
                Manager.user_id = user.internalIdentifier!
                self.setRootMainController(withIdentifier: startShiftTimeController)
            } else {
                print("\n\n\n\n\n\n error unarchive data\n\n\n\n\n\n\n")
                self.setRootMainController(withIdentifier: loginControllerName)
            }
            print("\n\n\n\n\nuser here\nset main controller to root\n\n\n\n\n")
        } else {
            self.setRootMainController(withIdentifier: loginControllerName)
            print("\n\n\n\n\nneed login and main controlelr - language selection \n\n\n\n\n\n\n")
        }
        
        // Override point for customization after application launch.
        return true
    }
    //MARK: - set root for nav mainController
    private func setRootMainController(withIdentifier identifier: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let rootController = storyboard.instantiateInitialViewController() as? UINavigationController {
            let main = storyboard.instantiateViewControllerWithIdentifier(identifier)
            rootController.setViewControllers([main], animated: false)
            print("opening controlelr with storyboardName = \(identifier)")
            if let win = self.window {
                win.rootViewController = rootController
            }
        }
    }
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        print("backgroundFetch started");
        completionHandler(UIBackgroundFetchResult.NewData)
        
        
        sendOrSaveData()
        
    }
    func sendOrSaveData() {
        print("background fetch f off")
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        print("enter background")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        print("become active")
        
       // if let records = userDefaults.valueForKey(<#T##key: String##String#>)
        
            print("start sending")
            Manager.dataSaver.sendRecords { result in
                if result {
                    print("Everything ok and data sended")
                }
            }
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: - push
    func initializeNotificationServices() -> Void {
        let settings = UIUserNotificationSettings(forTypes: [.Sound, .Alert, .Badge], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        // This is an asynchronous method to retrieve a Device Token
        // Callbacks are in AppDelegate.swift
        // Success = didRegisterForRemoteNotificationsWithDeviceToken
        // Fail = didFailToRegisterForRemoteNotificationsWithError
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let deviceTokenStr = convertDeviceTokenToString(deviceToken)
        print("device token = \(deviceTokenStr)")
        // ...register device token with our Time Entry API server via REST
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Device token for push notifications: FAIL -- ")
        print(error.description)
    }

    private func convertDeviceTokenToString(deviceToken:NSData) -> String {
        //  Convert binary Device Token to a String (and remove the <,> and white space charaters).
        var deviceTokenStr = deviceToken.description.stringByReplacingOccurrencesOfString(">", withString: "")
        deviceTokenStr = deviceTokenStr.stringByReplacingOccurrencesOfString("<", withString: "")
        deviceTokenStr = deviceTokenStr.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        // Our API returns token in all uppercase, regardless how it was originally sent.
        // To make the two consistent, I am uppercasing the token string here.
        //deviceTokenStr = deviceTokenStr.uppercaseString
        return deviceTokenStr
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("recive remote notification")
        if let notification = userInfo["aps"] as? NSDictionary,let alert = notification["alert"] as? String {
            print("notification = \(notification)")
            print("alert = \(alert)")
            
        }
    }
    


}

