import Foundation

struct ApiRequest {
    
    let jsonrpc: String = "2.0"
    var id: String
    var method: String
    var action: String
    var params: [String:Any]
    
    init(method: String, id: String = "", action: String = "") {
        self.id = id == "" ? NSUUID().uuidString : id
        self.method = method
        self.action = action
        self.params = [String:Any]()
    }
    
    func getJson() -> [String:Any] {
        return [
            "id": self.id,
            "method": self.method,
            "action": self.action,
            "params": self.params,
            "jsonrpc": self.jsonrpc
        ]
    }
}
