struct FcmCredentials {
    
    var token: String
    var state: Int
    
    init(_ json: [String:Any]? = nil) {
        token = json?["token"] as? String ?? ""
        state = Int(json?["state"])
    }
    
    init(token: String, state: Int) {
        self.token = token
        self.state = state
    }
    
    func getJson() -> [String:Any] {
        return [
            "state": state,
            "token": token
        ]
    }
}
