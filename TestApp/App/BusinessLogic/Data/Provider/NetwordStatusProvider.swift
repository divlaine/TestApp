protocol NetworkStatusProvider: AnyObject {
    
    var isOn: Bool { get }
    func addObserver(completion: @escaping BoolClosure)
    func removeObserver()
    
    func start()
}

class NetworkStatusProviderImpl: NetworkStatusProvider {
    
    private let networkService: NetworkService
    
    var isOn: Bool { networkService.isOn }
    
    init(networkService: NetworkService) {
        self.networkService = networkService
        start()
    }
    
    func addObserver(completion: @escaping BoolClosure) {
        networkService.addObserver(self) { isOn, _ in
            completion(isOn)
        }
    }
    
    func removeObserver() {
        networkService.removeObserver(self)
    }
    
    func start() {
        networkService.start()
    }
}
