import Foundation

@propertyWrapper
struct MUserDefaultsManager<Value> {
    
    let key: String
    let container: UserDefaults = .standard

    var wrappedValue: Value? {
        get { return container.object(forKey: key) as? Value }
        set { container.set(newValue, forKey: key) }
    }
}

protocol UserDefaultsProvider {
    
    var fcm: FcmCredentials { get set }
    var urlApiServer: String { get set }
    var appMinVersion: String { get set }
}

class UserDefaultsProviderImpl: UserDefaultsProvider {
    
    enum Keys {
        static let fcm = "fcm"
        static let urlApiCustom = "url_api_custom"
        static let appMinVersion = "app_min_version"
    }
    
    @MUserDefaultsManager(key: Keys.fcm)
    private var _fcm: [String:Any]?
    var fcm: FcmCredentials {
        get { return FcmCredentials(_fcm) }
        set { _fcm = newValue.getJson() }
    }

    @MUserDefaultsManager(key: Keys.urlApiCustom)
    private var _urlApiServer: String?
    var urlApiServer: String {
        get { return _urlApiServer ?? "" }
        set { _urlApiServer = newValue }
    }
    
    @MUserDefaultsManager(key: Keys.appMinVersion)
    private var _appMinVersion: String?
    var appMinVersion: String {
        get { return _appMinVersion ?? "0.0.0" }
        set { _appMinVersion = newValue }
    }
}
