struct ApiResponseError: Codable {
    
    var code: Int
    var message: String
    var tryAfter: Int
    
    enum CodingKeys: String, CodingKey {
        
        case code
        case message
        case tryAfter
    }
    
    init(_ json: [String:Any]? = nil) {
        self.code = Int(json?["code"])
        self.message = json?["message"] as? String ?? ""
        self.tryAfter = Int(json?["try_after"])
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = Int(try container.decode(String.self, forKey: .code))
        self.message = (try? container.decode(String.self, forKey: .message)) ?? ""
        if let tryAfter = try? container.decode(String.self, forKey: .tryAfter) {
            self.tryAfter = Int(tryAfter)
        }
        else {
            self.tryAfter = (try? container.decode(Int.self, forKey: .tryAfter)) ?? 0
        }
    }
}
