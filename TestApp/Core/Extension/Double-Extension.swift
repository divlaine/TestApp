import Foundation

// MARK: - Formatter
extension Double {
    
    static let earthRadius = 6371000.0
    
    var fixed1:  Double {
        get { return Double(String(format: "%.1f", self))! }
    }
    
    var fixed6:  Double {
        get { return Double(String(format: "%.6f", self))! }
    }
}

// MARK: - Convert
extension Double {
    
    init(_ value: Any?, defaultValue: Double = 0) {
        if let val = value as? NSNumber {
            self = val.doubleValue
            return
        }
        else if let val = value as? String {
            if val.isEmpty {
                self = 0
                return
            }
            if let val = Double(val) {
                self = val
                return
            }
        }
        self = defaultValue
    }
    
    var date: Date {
        get { return Date(timeIntervalSince1970: self / 1000) }
    }
    
    var radians: Double {
        get { return self * .pi / 180 }
    }
}
