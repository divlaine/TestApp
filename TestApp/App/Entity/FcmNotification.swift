import Foundation

struct FcmNotification {
    
    let documentType: Int
    let orderState: Int
    let orderId: Int
    let pushId: Int
    let gcmMessageId: Double
    let aps: FcmAps
    
    init(_ json: [AnyHashable:Any]? = nil) {
        documentType = Int(json?["documentType"])
        orderState = Int(json?["orderState"])
        orderId = Int(json?["orderId"])
        pushId = Int(json?["pushId"])
        gcmMessageId = Double(json?["gcm.message_id"])
        aps = FcmAps(json?["aps"] as? [String:Any])
    }
    
    init(title: String, text: String) {
        documentType = 0
        orderState = 0
        orderId = 0
        pushId = 0
        gcmMessageId = 0
        aps = FcmAps(title: title, text: text)
    }
}
