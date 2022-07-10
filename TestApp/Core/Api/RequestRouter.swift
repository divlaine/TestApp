import Foundation
import Alamofire

enum RequestRouterEncoding {
    case url, json
}

protocol RequestRouter: URLRequestConvertible {
    
    var baseUrl: URL { get }
    var httpMethod: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var fullUrl: URL { get }
    var encoding: RequestRouterEncoding { get }
    
    var action: String { get }
    var id: String { get }
    var method: String { get }
    var authCredentials: AuthCredentials { get }
    var deviceRepository: DeviceRepository { get }
    var time: String { get }
    var signature: String { get }
    var stopwatch: Stopwatch? { get set }
}

extension RequestRouter {
    
    func getTime() -> String {
        let ms = (stopwatch?.miliseconds ?? 0) + Double(Int.random(in: 1..<999)) / 1000.0
        return String(format: "%f", ms)
    }
    
    func getSignature() -> String {
        return "\(method)\(time)\(authCredentials.token)\(authCredentials.login.sha256)\(authCredentials.session)\(authCredentials.password.sha256)".sha256
    }
}

extension RequestRouter {
    
    var fullUrl: URL {
        get { return baseUrl.appendingPathComponent(path) }
    }
    
    var encoding: RequestRouterEncoding {
        get { return .json }
    }
    
    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: fullUrl)
        urlRequest.httpMethod = httpMethod.rawValue
        switch self.encoding {
        case .url:
            return try URLEncoding.default.encode(urlRequest, with: parameters)
        case .json:
            return try JSONEncoding.default.encode(urlRequest, withJSONObject: parameters)
        }
    }
}
