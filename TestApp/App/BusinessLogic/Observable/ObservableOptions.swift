struct ObservableOptions: OptionSet, CustomStringConvertible {
    
    static let inital = ObservableOptions(rawValue: 1 << 0)
    static let old = ObservableOptions(rawValue: 1 << 1)
    static let new = ObservableOptions(rawValue: 1 << 2)
    
    var rawValue: Int
    
    init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    var description: String {
        switch self {
        case .inital:
            return "initial"
        case .old:
            return "old"
        case .new:
            return "new"
        default:
            return "ObservableOptions(rawValue: \(rawValue)"
        }
    }
}
