import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let navController = window?.rootViewController as? UINavigationController,
           let todoListViewController = navController.topViewController as? TodoListViewController {
            todoListViewController.title = "Todo List"
        }
        return true
    }

}
