typealias ObservableCallback<T> = (T, ObservableOptions) -> Void

class Observable<T> {
    
    fileprivate class Callback {
        
        fileprivate weak var observer: AnyObject?
        fileprivate let options: [ObservableOptions]
        fileprivate let closure: ObservableCallback<T>
        
        fileprivate init(observer: AnyObject, options: [ObservableOptions], closure: @escaping ObservableCallback<T>) {
            self.observer = observer
            self.options = options
            self.closure = closure
        }
    }
    
    // MARK: - Properties
    var value: T {
        didSet {
            removeNilObserverCallback()
            notifyCallbacks(value: oldValue, option: .old)
            notifyCallbacks(value: value, option: .new)
        }
    }
    
    // MARK: - Lifecycle
    init(_ value: T) {
        self.value = value
    }
    
    // MARK: - Observe
    private var callbacks = [Callback]()
    
    func addObserver(_ observer: AnyObject,
                     removeIfExists: Bool = true,
                     options: [ObservableOptions] = [.new],
                     closure: @escaping ObservableCallback<T>) {
        if removeIfExists {
            removeObserver(observer)
        }
        let callback = Callback(observer: observer, options: options, closure: closure)
        callbacks.append(callback)
        if options.contains(.inital) {
            closure(value, .inital)
        }
    }
    
    func removeObserver(_ observer: AnyObject) {
        callbacks = callbacks.filter({ $0.observer !== observer })
    }
    
    // MARK: - Private
    private func removeNilObserverCallback() {
        callbacks = callbacks.filter({ $0.observer != nil })
    }
    
    private func notifyCallbacks(value: T, option: ObservableOptions) {
        let callbacksToNotify = callbacks.filter({ $0.options.contains(option) })
        callbacksToNotify.forEach({ $0.closure(value, option) })
    }
}
