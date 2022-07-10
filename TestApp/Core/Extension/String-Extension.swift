import UIKit
import CommonCrypto

// MARK: - Compare
extension String {
    
    static func < (lhs:String, rhs:String) -> Bool {
        return lhs.compare(rhs, options: .numeric) == .orderedAscending
    }
    
    func compare(toVersion targetVersion: String) -> ComparisonResult {
        var current = self.components(separatedBy: ".").compactMap({ Int($0) ?? 0 })
        var target = targetVersion.components(separatedBy: ".").compactMap({ Int($0) ?? 0})
        while current.count < target.count {
            current.append(0)
        }
        while target.count < current.count {
            target.append(0)
        }
        for index  in 0 ..< current.count {
            if current[index] < target[index] {
                return .orderedAscending
            }
            if current[index] > target[index] {
                return .orderedDescending
            }
        }
        return .orderedSame
    }
    
    func isLessThan(version: String) -> Bool {
        return compare(version) == .orderedAscending
    }
}

extension MutableCollection where Self: RandomAccessCollection {
    
    mutating func sort(
        by firstPredicate: (Element, Element) -> Bool,
        _ secondPredicate: (Element, Element) -> Bool,
        _ otherPredicates:((Element, Element) -> Bool)...
    ) {
        sort(by:) { lhs, rhs in
            if firstPredicate(lhs, rhs) { return true }
            if firstPredicate(rhs, lhs) { return false }
            if secondPredicate(lhs, rhs) { return true }
            if secondPredicate(rhs, lhs) { return false }
            for _predicate in otherPredicates {
                if _predicate(lhs, rhs) { return true }
                if _predicate(rhs, lhs) { return false }
            }
            return false
        }
    }
}

extension Sequence {
    
    mutating func sorted(
        by firstPredicate: (Element, Element) -> Bool,
        _ secondPredicate: (Element, Element) -> Bool,
        _ otherPredicates:((Element, Element) -> Bool)...
        ) -> [Element] {
        return sorted(by:) { lhs, rhs in
            if firstPredicate(lhs, rhs) { return true }
            if firstPredicate(rhs, lhs) { return false }
            if secondPredicate(lhs, rhs) { return true }
            if secondPredicate(rhs, lhs) { return false }
            for _predicate in otherPredicates {
                if _predicate(lhs, rhs) { return true }
                if _predicate(rhs, lhs) { return false }
            }
            return false
        }
    }
}

// MARK: - String Replace
extension String {
    
    func replacingFirstOccurrence(of string: String, with replacement: String) -> String {
        guard let range = self.range(of: string) else { return self }
        return replacingCharacters(in: range, with: replacement)
    }
}

// MARK: - Text Size
extension String {
    
    func getTextSize(width: CGFloat, font:UIFont) -> CGRect {
        let textSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let size = self.boundingRect(with: textSize, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return size
    }
    
    func height(width:CGFloat, font:UIFont) -> CGFloat {
        return ceil(getTextSize(width: width, font: font).height)
    }
}

// MARK: - Validation
extension String {
    
    var isValidEmail: Bool {
        get {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: self)
        }
    }
    
    var isValidPin: Bool {
        get { return (Config.shared.minCountPhoneCode...Config.shared.maxCountPhoneCode) ~= self.numberString.count }
    }
    
    var isValidPassword: Bool {
        get { return self.count >= Config.shared.minCountPassword }
    }
    
    var isValidPhone: Bool {
        get { return self.numberString.count == Config.shared.maxCountPhoneNumber }
    }
    
    var isValidTimestamp: Bool {
        get { return self.count == 19 && self != "0000-00-00 00:00:00" }
    }
}

// MARK: - Formatter
extension String {
    
    var numberString: String {
        get { return self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() }
    }
    
    private func getWithFormat(_ format: String) -> String {
        let cleanString = self.numberString
        var result = ""
        var index = cleanString.startIndex
        for ch in format where index < cleanString.endIndex {
            if ch == "x" {
                result.append(cleanString[index])
                index = cleanString.index(after: index)
            }
            else {
                result.append(ch)
            }
        }
        return result
    }
    
    var withFormatPhone: String {
        get { return self.getWithFormat("+x (xxx) xxx-xxxx") }
    }
    
    var withFormatPhoneCall: String {
        get { return self.getWithFormat("+x(xxx)xxx-xxxx") }
    }
    
    var withFormatCardNumber: String {
        get { return self.getWithFormat("xxxx xxxx xxxx xxxx xxx") }
    }
    
    var withFormatCardDate: String {
        get { return self.getWithFormat("xx/xx") }
    }
    
    var withFormatYYYYMMDD: String {
        get {
            if self.count >= 10 {
                return String(self.prefix(10)).replacingOccurrences(of: "-", with: "")
            }
            return ""
        }
    }
}

// MARK: - SHA256
extension String {
    
    var sha256: String {
        get {
            guard let data = self.data(using: .utf8) else { return "" }
            let dData = digest(input: data as NSData)
            return hexStringFromData(input: dData)
        }
    }
    
    private func digest(input: NSData) -> NSData {
        let length = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: length)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: length)
    }
    
    private func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        var hexString = ""
        for byte in bytes {
            hexString += String(format: "%02x", UInt8(byte))
        }
        return hexString
    }
}

// MARK: - Date
extension String {
    
    var date: Date? {
        get {
            if !self.isValidTimestamp { return nil }
            Date.dateFormatter.dateFormat = "yyyy-MMdd HH:mm:ss"
            return Date.dateFormatter.date(from: self)
        }
    }
}
