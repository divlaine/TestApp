import Foundation

protocol FactoryIssue {
    
    var providerFactory: ProviderFactory { get }
    var coordinatorFactory: CoordinatorFactory { get }
    
    func clear()
}

final class Factory: FactoryIssue {
    
    fileprivate let keychainWrapper: KeychainWrapper
    fileprivate let requestFactory: RequestFactory
    fileprivate let repositoryFactory: RepositoryFactory
    fileprivate let userDefaultsProvider: UserDefaultsProvider
    fileprivate let serviceFactory: ServiceFactory
    let providerFactory: ProviderFactory
    fileprivate let screenFactory: ScreenFactory
    let coordinatorFactory: CoordinatorFactory
    
    let stopwatch: Stopwatch = StopWatchImpl()
    
    init() {
        // storage
        keychainWrapper = KeychainWrapperImpl.standard
        userDefaultsProvider = UserDefaultsProviderImpl()
        
        // repository
        repositoryFactory = RepositoryFactoryImpl(
            keychainWrapper: keychainWrapper,
            userDefaultsProvider: userDefaultsProvider,
            stopwatch: stopwatch)
        
        // api
        requestFactory = RequestFactory(
            stopwatch: stopwatch,
            repositoryFactory: repositoryFactory)
        
        // provider
        serviceFactory = ServiceFactoryImpl(
            repositoryFactory: repositoryFactory,
            requestFactory: requestFactory,
            stopwatch: stopwatch,
            userDefaultsProvider: userDefaultsProvider)
        providerFactory = ProviderFactoryImpl(serviceFactory: serviceFactory)
        
        // coordinator
        screenFactory = ScreenFactoryImpl(
            serviceFactory: serviceFactory,
            providerFactory: providerFactory,
            userDefaultsProvider: userDefaultsProvider,
            stopwatch: stopwatch)
        
        // coordinator
        coordinatorFactory = CoordinatorFactoryImpl(
            screenFactory: screenFactory,
            providerFactory: providerFactory,
            userDefaultsProvider: userDefaultsProvider)
    }
    
    func clear() {
        repositoryFactory.clear()
    }
}

// MARK: - Coordinator
protocol CoordinatorFactory: AnyObject {
    
    func makeAppCoordinator(router: Router) -> AppCoordinator
    func makeLaunchCoordinator(router: Router) -> LaunchCoordinator
    func makeLoginCoordinator(router: Router) -> LoginCoordinator
}

class CoordinatorFactoryImpl: CoordinatorFactory {
    
    private let screenFactory: ScreenFactory
    private let providerFactory: ProviderFactory
    private let userDefaultsProvider: UserDefaultsProvider
    
    init(screenFactory: ScreenFactory, providerFactory: ProviderFactory, userDefaultsProvider: UserDefaultsProvider) {
        self.screenFactory = screenFactory
        self.providerFactory = providerFactory
        self.userDefaultsProvider = userDefaultsProvider
    }
    
    // MARK: - Screen
    func makeAppCoordinator(router: Router) -> AppCoordinator {
        return AppCoordinator(
            router: router,
            coordinatorFactory: self,
            providerFactory: providerFactory,
            userDefaultsProvider: userDefaultsProvider)
    }
    
    func makeLaunchCoordinator(router: Router) -> LaunchCoordinator {
        return LaunchCoordinator(router: router, screenFactory: screenFactory)
    }
    
    func makeLoginCoordinator(router: Router) -> LoginCoordinator {
        return LoginCoordinator(router: router, screenFactory: screenFactory, coordinatorFactory: self)
    }
}

// MARK: - Provider
protocol ProviderFactory: AnyObject {
    
    var networkStatusProvider: NetworkStatusProvider { get }
    
    var authProvider: AuthProvider { get }
    var authStatusProvider: AuthStatusProvider { get }
    var deviceProvider: DeviceProvider { get }
}

class ProviderFactoryImpl: ProviderFactory {
    
    private let serviceFactory: ServiceFactory
    
    init(serviceFactory: ServiceFactory) {
        self.serviceFactory = serviceFactory
    }
    
    var networkStatusProvider: NetworkStatusProvider {
        get { return NetworkStatusProviderImpl(networkService: serviceFactory.networkService) }
    }
    
    var authProvider: AuthProvider {
        get { return AuthProviderImpl(authService: serviceFactory.authService) }
    }
    
    var authStatusProvider: AuthStatusProvider {
        get { return AuthStatusProviderImpl(authService: serviceFactory.authService) }
    }
   
    var deviceProvider: DeviceProvider {
        get { return DeviceProviderImpl(deviceService: serviceFactory.deviceService) }
    }
}

// MARK: - Repository
protocol RepositoryFactory: AnyObject {
    
    var authRepository: AuthRepository { get }
    var deviceRepository: DeviceRepository { get }
    
    func clear()
}

class RepositoryFactoryImpl: RepositoryFactory {
    
    var authRepository: AuthRepository
    var deviceRepository: DeviceRepository
    
    init(keychainWrapper: KeychainWrapper, userDefaultsProvider: UserDefaultsProvider, stopwatch: Stopwatch) {
        authRepository = AuthRepositoryImpl(keychainWrapper: keychainWrapper)
        deviceRepository = DeviceRepositoryImpl(userDefaultsProvider: userDefaultsProvider, timezone: stopwatch.timezone)
    }
    
    func clear() {
        authRepository.clear()
    }
}

// MARK: - Screen
protocol ScreenFactory: AnyObject {
    
    // MARK: - Screens
    func makeLaunchScreen() -> LaunchVC
    func makeLoginScreen() -> LoginVC
}

class ScreenFactoryImpl: ScreenFactory {
    
    private let serviceFactory: ServiceFactory
    private let providerFactory: ProviderFactory
    private let userDefaultsProvider: UserDefaultsProvider
    private let stopwatch: Stopwatch
    
    init(serviceFactory: ServiceFactory, providerFactory: ProviderFactory, userDefaultsProvider: UserDefaultsProvider, stopwatch: Stopwatch) {
        self.serviceFactory = serviceFactory
        self.providerFactory = providerFactory
        self.userDefaultsProvider = userDefaultsProvider
        self.stopwatch = stopwatch
    }
    
    // MARK: - Screens
    func makeLaunchScreen() -> LaunchVC {
        return LaunchVC(authStatusProvider: providerFactory.authStatusProvider)
    }
    
    func makeLoginScreen() -> LoginVC {
        return LoginVC(authProvider: providerFactory.authProvider)
    }
}

// MARK: - Service
protocol ServiceFactory: AnyObject {
    
    var authService: AuthService { get }
    var deviceService: DeviceService { get }
    var networkService: NetworkService { get }
}

class ServiceFactoryImpl: ServiceFactory {
    
    private let repositoryFactory: RepositoryFactory
    private let requestFactory: RequestFactory
    private let stopwatch: Stopwatch
    private let userDefaultsProvider: UserDefaultsProvider
    
    init(repositoryFactory: RepositoryFactory, requestFactory: RequestFactory, stopwatch: Stopwatch, userDefaultsProvider: UserDefaultsProvider) {
        self.repositoryFactory = repositoryFactory
        self.requestFactory = requestFactory
        self.stopwatch = stopwatch
        self.userDefaultsProvider = userDefaultsProvider
    }
    
    lazy var authService: AuthService = {
        return AuthServiceImpl(
            authRepository: repositoryFactory.authRepository,
            requestFactory: requestFactory)
    }()
    
    lazy var deviceService: DeviceService = {
        return  DeviceServiceImpl(
        repositoryFactory: repositoryFactory,
        requestFactory: requestFactory)
    }()

    let networkService: NetworkService = NetworkServiceImpl()
}
