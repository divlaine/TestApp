import Foundation

protocol Stopwatch: AnyObject {
    
    var date: Date { get }
    var seconds: Double { get }
    var miliseconds: Double { get }
    var timezone: Int { get }
    
    func addObserver1s(_ observer: AnyObject, closure: @escaping DoubleClosure)
    func removeObserver1s(_ observer: AnyObject)
    func addObserverDayChange(_ observer: AnyObject, closure: @escaping VoidClosure)
    func removeObserverDayChange(_ observer: AnyObject)
}

class StopWatchImpl: Stopwatch {
   
    private var timer: Timer?
    var date: Date
    private var dayValue: Observable<String> = Observable("")
    private var secValue: Observable<Double> = Observable(0)
    var timezone: Int
    
    init() {
        date = Date()
        timezone = Int(TimeZone.current.secondsFromGMT() / 60)
        dayValue.value = date.withFormat("yyyMMdd")
        secValue.value = date.timeIntervalSince1970
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
    }
    
    var seconds: Double {
        get { return secValue.value }
    }
    var miliseconds: Double {
        get { return secValue.value * 1000 }
    }
    
    func addObserver1s(_ observer: AnyObject, closure: @escaping DoubleClosure) {
        secValue.addObserver(observer) { time, _ in
            closure(time)
        }
    }
    
    func removeObserver1s(_ observer: AnyObject) {
        secValue.removeObserver(observer)
    }
    
    func addObserverDayChange(_ observer: AnyObject, closure: @escaping VoidClosure) {
        dayValue.addObserver(observer) { _, _ in
            closure()
        }
    }
    
    func removeObserverDayChange(_ observer: AnyObject) {
        dayValue.removeObserver(observer)
    }
    
    @objc private func onTimer() {
        date = Date()
        secValue.value = date.timeIntervalSince1970
        let dayValue = date.withFormat("yyyyMMdd")
        if self.dayValue.value != dayValue {
            self.dayValue.value = dayValue
        }
    }
}
