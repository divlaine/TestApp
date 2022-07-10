protocol DeviceService {
    
    var isBackground: Bool { get set }
    var isMainApplication: Bool { get set }
    var device: Device { get }
    var fcm: FcmCredentials { get set }
    
    func save()
}

class DeviceServiceImpl: DeviceService {
    
    private let authRepository: AuthRepository
    private let deviceRepository: DeviceRepository
    private let requestFactory: RequestFactory
    
    init(repositoryFactory: RepositoryFactory, requestFactory: RequestFactory) {
        self.authRepository = repositoryFactory.authRepository
        self.deviceRepository = repositoryFactory.deviceRepository
        self.requestFactory = requestFactory
    }
    
    var device: Device {
        get { return deviceRepository.device }
    }
    
    var fcm: FcmCredentials {
        get { return deviceRepository.fcm }
        set { return deviceRepository.fcm = newValue }
    }
    
    var isBackground: Bool {
        get { return deviceRepository.isBackground }
        set { deviceRepository.isBackground = newValue }
    }
    
    var isMainApplication: Bool {
        get { return deviceRepository.isMainApplication }
        set { deviceRepository.isMainApplication = newValue }
    }
    
    func save() {
        // Maing Save Device Request to Server
    }
}
