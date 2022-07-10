import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var factory: Factory = { return Factory() }()
    var appCoordinator: AppCoordinator?
    var window: UIWindow?
    lazy var firebase = FirebaseDelegate(providerFactory: factory.providerFactory)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().titleTextAttributes = Styles.shared.getAttributes(Styles.shared.view.navbarPrC)
        
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: Assets.shared.appbarBack)
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: Assets.shared.appbarBack)
        UINavigationBar.appearance().tintColor = Styles.shared.getFontColor(Styles.shared.view.navbarPr)
        
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 0.1), NSAttributedString.Key.foregroundColor: UIColor.clear]
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .highlighted)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        let router = RouterImpl(rootController: navigationController)
        appCoordinator = factory.coordinatorFactory.makeAppCoordinator(router: router)
        appCoordinator?.onSignOut = { [weak self] in
            self?.factory.clear()
        }
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        appCoordinator?.start()
        
        firebase.canShowMessage = canShowNotificationMessage
        appCoordinator?.firebaseDelegate = firebase
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        var deviceProvider = factory.providerFactory.deviceProvider
        deviceProvider.isBackground = true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        var deviceProvider = factory.providerFactory.deviceProvider
        deviceProvider.isBackground = false
        application.applicationIconBadgeNumber = 0
    }
    
    func restart() {
        self.factory.clear()
        appCoordinator?.restart()
    }
}

extension AppDelegate {
    
    private func canShowNotificationMessage() -> Bool {
        guard let vc = appCoordinator?.currentScreen,
              !vc.isKind(of: LoginVC.self)
        else {
            return false
        }
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard canShowNotificationMessage() else { return }
        if let vc = appCoordinator?.currentScreen, vc.isKind(of: LaunchVC.self) {
            appCoordinator?.notificationToShowAfterLaunch = userInfo
            return
        }
        completionHandler(UIBackgroundFetchResult.newData)
        firebase.didReceiveRemoteNotification(userInfo)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        firebase.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        firebase.didFailToRegisterForRemoteNotificationsWithError(error)
    }
}
