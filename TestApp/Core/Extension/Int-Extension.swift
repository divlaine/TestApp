import Foundation

extension Int {
    
    init(_ value: Any?, defaultValue: Int = 0) {
        self = Int(Double(value, defaultValue: Double(defaultValue)))
    }
}
