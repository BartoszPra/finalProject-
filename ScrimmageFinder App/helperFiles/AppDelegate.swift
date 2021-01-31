import UIKit
import CoreData
import Intents
import FBSDKCoreKit
import GoogleSignIn
import Firebase
import GooglePlaces

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    var coordinator: MainCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSPlacesClient.provideAPIKey("AIzaSyBNk2WUV6PAjpcRJXL-2JoMtpgUZzy_nM8")
        SFAppearance.setUpApperance()
        let navController = CoordinatedNavigationController()
        coordinator = MainCoordinator(navigationController: navController)
        coordinator?.start()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        FirebaseApp.configure()
		GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
		GIDSignIn.sharedInstance()?.delegate = self
		
        return true
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {

		if let error = error {
            print("Error \(error.localizedDescription)")
            return
        }

        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
		Auth.auth().signIn(with: credential) { (_, err) in
			if err == nil {
                self.coordinator?.startTabBarCoordinator(viewController: (self.window?.rootViewController)!)
            } else {
                print(err?.localizedDescription as Any)
                return
            }
		}
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any])
        -> Bool {
			
			return (GIDSignIn.sharedInstance()?.handle(url))!
		//return GIDSignIn.sharedInstance().handle(url)
            
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
