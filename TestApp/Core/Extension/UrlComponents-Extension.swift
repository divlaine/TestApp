import UIKit

extension URLComponents {
    
    init(scheme: String, host: String, path: String, params: [String:Any]) {
        self.init()
        self.scheme = scheme
        self.host = host
        self.path = path
        self.queryItems = params.compactMap({ URLQueryItem(name: $0.0, value: $0.1 as? String ?? "") })
    }
}
