import UIKit

protocol DeviceProvider {
    
    var device: Device { get }
    var fcm: FcmCredentials { get set }
    var isBackground: Bool { get set }
    var isIpad: Bool { get }
    var isMainApplication: Bool { get set }
    
    func save()
}

class DeviceProviderImpl: DeviceProvider {
    
    private var deviceService: DeviceService
    
    init(deviceService: DeviceService) {
        self.deviceService = deviceService
    }
    
    var device: Device {
        get { return deviceService.device }
    }
    
    var fcm: FcmCredentials {
        get { return deviceService.fcm }
        set { deviceService.fcm = newValue }
    }
    
    var isIpad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var isBackground: Bool {
        get { return deviceService.isBackground }
        set { deviceService.isBackground = newValue }
    }
    
    var isMainApplication: Bool {
        get { return deviceService.isMainApplication }
        set { deviceService.isMainApplication = newValue }
    }
    
    func save() {
        deviceService.save()
    }
}
