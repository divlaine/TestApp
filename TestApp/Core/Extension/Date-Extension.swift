import UIKit

extension Date {
    
    static let timezoneDelta = Double(TimeZone.current.secondsFromGMT())
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_EN")
        formatter.timeZone = TimeZone.init(secondsFromGMT: TimeZone.current.secondsFromGMT())
        return formatter
    }()
}

// MARK: - Calculation
extension Date {
    
    func offset(from date: Date) -> [Int] {
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: date, to: self)
        //let components = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
        return [abs(components.hour ?? 0), abs(components.minute ?? 0), abs(components.second ?? 0)]
    }
    
    var isToday: Bool {
        get { return Calendar.current.isDateInToday(self) }
    }
    
    var isTomorrow: Bool {
        get { return Calendar.current.isDateInTomorrow(self) }
    }
    
    func isInRangeOf7Days(from date: Date) -> Bool {
        guard let date = Calendar.current.date(byAdding: .day, value: -7, to: date) else { return false }
        let date7 = Calendar.current.startOfDay(for: date)
        return self < date7
    }
}

// MARK: - Formatter
extension Date {
    
    func withFormat(_ format: String) -> String {
        Date.dateFormatter.dateFormat = format
        return Date.dateFormatter.string(from: self)
    }
}

// MARK: - Convert
extension Date {
    
    var timestamp: String {
        get {
            let date = Date(timeIntervalSince1970: self.timeIntervalSince1970 - Date.timezoneDelta)
            Date.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return Date.dateFormatter.string(from: date)
        }
    }
    
    var utcDate: Date {
        get { return Date(timeIntervalSince1970: self.timeIntervalSince1970 - Date.timezoneDelta) }
    }
}
