struct Device {
    
    var appId: String
    var appVersion: String
    var brand: String
    var deviceId: String
    var locale: String
    var model: String
    var modelName: String
    var os: String
    var osVersion: String
    var releaseVersion: String
    var timezone: String
    
    init(_ json: [String:String]? = nil) {
        appId = json?["appId"] ?? ""
        appVersion = json?["appVersion"] ?? "0.0.0"
        brand = json?["brand"] ?? ""
        deviceId = json?["deviceId"] ?? ""
        locale = json?["locale"] ?? ""
        model = json?["model"] ?? ""
        modelName = json?["modelName"] ?? ""
        os = json?["os"] ?? ""
        osVersion = json?["osVersion"] ?? ""
        releaseVersion = json?["releaseVersion"] ?? ""
        timezone = json?["timezone"] ?? ""
    }
    
    func getJson() -> [String:String] {
        return [
            "appId": appId,
            "appVersion": appVersion,
            "brand": brand,
            "deviceId": deviceId,
            "locale": locale,
            "model": model,
            "modelName": modelName,
            "os": os,
            "osVersion": osVersion,
            "releaseVersion": releaseVersion,
            "timezone": timezone
        ]
    }
}
