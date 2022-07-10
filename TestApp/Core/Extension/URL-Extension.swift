import UIKit

extension URL {
    
    func withQuery(_ query: [String:String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = query.compactMap({ URLQueryItem(name: $0.0, value: $0.1) })
        return components?.url
    }
    
    var queryParameters: [String:String]? {
        get {
            guard let componetns = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = componetns.queryItems else { return nil }
            return queryItems.reduce(into: [String:String]()) { (result, item) in
                result[item.name] = item.value
            }
        }
    }
}
