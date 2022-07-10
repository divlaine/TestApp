import UIKit

class AppCoordinator: BaseCoordinator {
    
    private let coordinatorFactory: CoordinatorFactory
    private let networkStatusProvider: NetworkStatusProvider
    private let deviceProvider: DeviceProvider
    private let userDefaultsProvider: UserDefaultsProvider
    private let router: Router
    
    private var isFirstLaunch = true
    private var isAuthed = false
    
    var firebaseDelegate: FirebaseDelegate?
    var notificationToShowAfterLaunch: [AnyHashable: Any]?
    
    var onSignOut: VoidClosure?
    
    var currentScreen: UIViewController? {
        get { return (router.toPresent() as? UINavigationController)?.topViewController }
    }
    
    init(router: Router, coordinatorFactory: CoordinatorFactory, providerFactory: ProviderFactory, userDefaultsProvider: UserDefaultsProvider) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.networkStatusProvider = providerFactory.networkStatusProvider
        self.deviceProvider = providerFactory.deviceProvider
        self.userDefaultsProvider = userDefaultsProvider
    }
    
    override func start() {
        if isFirstLaunch {
            runLaunchFlow()
            isFirstLaunch = false
            return
        }
        
        if !networkStatusProvider.isOn {
            runCriticalFlow()
        }
        else if isAuthed {
            // MARK: - Didn't add profile request to project,
            // So commented all other code
//            profileProvider.profileGet(completion: { [weak self] response in
//                if response == nil {
//                    self?.isAuthed = false
//                    self?.runLoginFlow()
//                }
//                else {
//                    self?.runMainFlow()
//                }
//            })
            isAuthed = false
            runLoginFlow()
        }
        else {
            self.onSignOut?()
            runLoginFlow()
        }
    }
    
    func restart() {
        isAuthed = false
        isFirstLaunch = true
        start()
    }
    
    // MARK: - Next Flow
    private func runCriticalFlow() {
        // Showing critical screen
    }
    
    private func runLaunchFlow() {
        let coordinator = coordinatorFactory.makeLaunchCoordinator(router: router)
        coordinator.finishFlow = { [weak self, weak coordinator] isAuthed in
            self?.isAuthed = isAuthed
            self?.start()
            self?.removeDependency(coordinator)
        }
        self.addDependency(coordinator)
        coordinator.start()
    }
    
    private func runLoginFlow() {
        self.deviceProvider.save()
        let coordinator = coordinatorFactory.makeLoginCoordinator(router: router)
        coordinator.finishFlow = { [weak self, weak coordinator] in
            self?.isAuthed = true
            self?.start()
            self?.removeDependency(coordinator)
        }
        self.addDependency(coordinator)
        coordinator.start()
    }
    
    private func runMainFlow() {
        // Showing main app content page
    }
    
    private func runUpdateFlow() {
        // Showing Need Update Screen
    }
}
