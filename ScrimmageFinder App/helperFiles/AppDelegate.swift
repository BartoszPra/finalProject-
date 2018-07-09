

import UIKit
import CoreData
import Intents

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FIRFirestoreService.shared.configure()
        
        INPreferences.requestSiriAuthorization({status in
            print(String(reflecting: status))
        })
        
        return true
    }
    
    internal func application(_ application: UIApplication, continue UserActivity: NSUserActivity, restorationHandler: @escaping([Any]?)-> Void) -> Bool {
        
        
        guard let intent = userActivity?.interaction?.intent as? INStartWorkoutIntent else {return false}
        
        
        //guard let spokenPhrase = intent.workoutName?.spokenPhrase else {return false}
        
        guard let scrVC = application.keyWindow?.rootViewController as? UINavigationController else {return false}
        
        guard let detailVC = scrVC.topViewController as? SavedDetailViewController else {return false}
     
        //detailVC.add2Saved(spokenPhrase)
        
        //guard let savedVC = scrVC.topViewController as? SavedDetailViewController else {return false}
        
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
        // Saves changes in the application's managed object context before the application terminates.
        CoreDataController.shared.saveContext()
    }

}
