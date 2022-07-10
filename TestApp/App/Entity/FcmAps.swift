struct FcmAps {
    
    let alert: FcmApsAlert
    let badge: Int
    let sound: String
    
    init(_ json: [String:Any]? = nil) {
        alert = FcmApsAlert(json?["alert"] as? [String:Any])
        badge = Int(json?["badge"])
        sound = json?["sound"] as? String ?? "default"
    }
    
    init(title: String, text: String) {
        alert = FcmApsAlert(title: title, text: text)
        badge = 0
        sound = ""
    }
}

struct FcmApsAlert {
    
    let body:  String
    let title: String
    
    init(_ json: [String:Any]? = nil) {
        body  = json?["body"] as? String ?? ""
        title = json?["title"] as? String ?? ""
    }
    
    init(title: String, text: String) {
        self.title = title
        self.body = text
    }
}
