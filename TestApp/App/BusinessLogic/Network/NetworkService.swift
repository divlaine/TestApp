import Foundation
import Reachability

protocol NetworkService {
    
    var isOn: Bool { get }
    
    func addObserver(_ observer: AnyObject, closure: @escaping ObservableCallback<Bool>)
    func removeObserver(_ observer: AnyObject)
    func start()
    func stop()
}

class NetworkServiceImpl: NetworkService {

    var monitor: Reachability?
    private var state: Observable<Bool> = Observable(false)
    
    var isOn: Bool {
        get { return state.value }
    }
    
    private var isReachable: Bool {
        get { return monitor?.connection != .unavailable }
    }
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(onStatusChanged), name: .reachabilityChanged, object: nil)
        start()
    }
    
    func start() {
        monitor = try? Reachability()
        onStatusChanged()
        try? monitor?.startNotifier()
    }
    
    func stop() {
        monitor?.stopNotifier()
    }
    
    func addObserver(_ observer: AnyObject, closure: @escaping ObservableCallback<Bool>) {
        state.addObserver(observer, closure: closure)
    }
    
    func removeObserver(_ observer: AnyObject) {
        state.removeObserver(observer)
    }
    
    @objc private func onStatusChanged() {
        state.value = isReachable
    }
}
