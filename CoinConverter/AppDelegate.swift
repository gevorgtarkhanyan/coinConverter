//
//  AppDelegate.swift
//  CoinConverter
//
//  Created by Yuro Mnatsakanyan on 12/3/19.
//

import UIKit
import Firebase
import StoreKit
//import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
//    var restrictRotation: UIInterfaceOrientationMask = .portrait
    public var rotationEnabled = true
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        DatabaseManager.shared.migrateRealm()
        // MARK: -- App rate functionality
        setupRateApp()
        
        SKPaymentQueue.default().add(StoreObserver.shared)
        
//        registerForPushNotifications()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        UserDefaults.standard.removeObject(forKey: DefaultCases.inputValue.rawValue)
        SKPaymentQueue.default().remove(StoreObserver.shared)
    }
    
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return rotationEnabled ? .all : .portrait
    }
    
    // MARK: -- App rate functionality
    private func setupRateApp() {
        if let appOpenedCount = UserDefaults.standard.value(forKey: Constants.appOpenedCount) as? Int {
            if appOpenedCount < Constants.showRateAppOpenedTime {
                UserDefaults.standard.set(appOpenedCount + 1, forKey: Constants.appOpenedCount)
                debugPrint("App opened \(appOpenedCount) time ")
            }
        } else {
            UserDefaults.standard.set(1, forKey: Constants.appOpenedCount)
        }
    }
    
    //MARK: -- Push notifications implementation
    
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
//        let token = tokenParts.joined()
//        print("Device Token: \(token)")
//    }
//
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print("Failed to register: \(error)")
//    }
    
    
//    private func registerForPushNotifications() {
//        if #available(iOS 10.0, *) {
//            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (access, error) in
//
//                if access {
//                    self.getNotificationSettings()
//                }
//
//                debugPrint("Notifications access --- \(access)")
//            }
//        } else {
//            // Fallback on earlier versions
//        }
//    }
//
//    private func getNotificationSettings() {
//        if #available(iOS 10.0, *) {
//            UNUserNotificationCenter.current().getNotificationSettings { settings in
//                if settings.authorizationStatus == .authorized {
//                    DispatchQueue.main.async {
//                        UIApplication.shared.registerForRemoteNotifications()
//                    }
//                }
//            }
//        } else {
//            // Fallback on earlier versions
//        }
//    }

}

extension UIApplication {
    static var appDelegate: AppDelegate {
        return shared.delegate as! AppDelegate
    }
}
