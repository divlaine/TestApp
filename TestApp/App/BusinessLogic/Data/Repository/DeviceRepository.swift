import UIKit

protocol DeviceRepository: AnyObject {
    
    var device: Device { get set }
    var fcm: FcmCredentials { get set }
    var isBackground: Bool { get set }
    var isMainApplication: Bool { get set }
}

class DeviceRepositoryImpl: DeviceRepository {
    
    private var userDefaultsProvider: UserDefaultsProvider
    
    var device: Device
    var fcm: FcmCredentials {
        didSet {
            userDefaultsProvider.fcm = fcm
        }
    }
    var isBackground: Bool = false
    var isMainApplication: Bool = true
    
    init(userDefaultsProvider: UserDefaultsProvider, timezone: Int) {
        self.userDefaultsProvider = userDefaultsProvider
        fcm = userDefaultsProvider.fcm
        
        let uid = UIDevice.current.identifierForVendor!.uuidString
        let lang = Locale.current.languageCode ?? "en"
        let region = Locale.current.regionCode ?? "US"
        
        device = Device()
        device.appId = Bundle.main.bundleIdentifier!
        device.appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        device.releaseVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
        device.brand = "Apple"
        device.deviceId = "\(device.appId)_\(uid)".sha256
        device.locale = "\(lang)_\(region)"
        device.model = getModelName()
        device.modelName = mapToDevice(model: device.model)
        device.os = UIDevice.current.systemName
        device.osVersion = UIDevice.current.systemVersion
        device.timezone = "\(timezone)"
    }
    
    private func getModelName() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        return machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0
            else {
                return identifier
            }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
    }
    
    private func mapToDevice(model: String) -> String {
        switch model {
        case "iPhone14,5": return "iPhone 13"
        case "iPhone14,4": return "iPhone 13 Mini"
        case "iPhone14,3": return "iPhone 13 Pro Max"
        case "iPhone14,2": return "iPhone 13 Pro"
        case "iPhone13,4": return "iPhone 12 Pro Max"
        case "iPhone13,3": return "iPhone 12 Pro"
        case "iPhone13,2": return "iPhone 12"
        case "iPhone13,1": return "iPhone 12 Mini"
        case "iPhone12,8": return "iPhone SE2"
        case "iPhone12,5": return "iPhone 11 Pro Max"
        case "iPhone12,3": return "iPhone 11 Pro"
        case "iPhone12,1": return "iPhone 11"
        case "iPhone11,8": return "iPhone XR"
        case "iPhone11,4", "iPhone11,6": return "iPhone XS Max"
        case "iPhone11,2": return "iPhone XS"
        case "iPhone10,3", "iPhone10,6": return "iPhone X"
        case "iPhone10,2", "iPhone10,5": return "iPhone 8 Plus"
        case "iPhone10,1", "iPhone10,4": return "iPhone 8"
        case "iPhone9,2", "iPhone9,4": return "iPhone 7 Plus"
        case "iPhone9,1", "iPhone9,3":   return "iPhone 7"
        case "iPhone8,4": return "iPhone SE"
        case "iPhone8,2": return "iPhone 6s Plus"
        case "iPhone8,1": return "iPhone 6s"
        case "iPhone7,2": return "iPhone 6"
        case "iPhone7,1": return "iPhone 6 Plus"
        case "iPhone6,1", "iPhone6,2": return "iPhone 5s"
        case "iPhone5,3", "iPhone5,4": return "iPhone 5c"
        case "iPhone5,1", "iPhone5,2": return "iPhone 5"
        case "iPhone4,1": return "iPhone 4s"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3": return "iPhone 4"
    
        case "iPad13,1", "iPad13,2": return "iPad Air 4"
        case "iPad11,6","iPad11,7": return "iPad 8"
        case "iPad11,1","iPad11,2": return "iPad Mini 5"
        case "iPad11,3","iPad11,4": return "iPad Air 3"
        case "iPad8,11","iPad8,12": return "iPad Pro 4 (12.9-inch)"
        case "iPad8,9", "iPad8,10": return "iPad Pro 2 (11-inch)"
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8": return "iPad Pro 3 (12.9-inch)"
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4": return "iPad Pro 3 (11-inch)"
        case "iPad7,11","iPad7,12": return "iPad 7"
        case "iPad7,5", "iPad7,6": return "iPad 6"
        case "iPad7,3", "iPad7,4": return "iPad Pro 2 (10.5-inch)"
        case "iPad7,1", "iPad7,2": return "iPad Pro 2 (12.9-inch)"
        case "iPad6,11","iPad6,12": return "iPad 5"
        case "iPad6,7", "iPad6,8": return "iPad Pro (12.9-inch)"
        case "iPad6,3", "iPad6,4": return "iPad Pro (9.7-inch)"
        case "iPad5,3", "iPad5,4": return "iPad Air 2"
        case "iPad5,1", "iPad5,2": return "iPad Mini 4"
        case "iPad4,7", "iPad4,8", "iPad4,9": return "iPad Mini 3"
        case "iPad4,4", "iPad4,5", "iPad4,6": return "iPad Mini 2"
        case "iPad4,1", "iPad4,2", "iPad4,3": return "iPad Air"
        case "iPad3,4", "iPad3,5", "iPad3,6": return "iPad 4"
        case "iPad3,1", "iPad3,2", "iPad3,3": return "iPad 3"
        case "iPad2,5", "iPad2,6", "iPad2,7": return "iPad Mini"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return "iPad 2"
        case "iPad1,1", "iPad1,2": return "iPad"
        
        case "i386", "x86_64": return "Simulator \(mapToDevice(model: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
        
        default: return model
        }
    }
}
