import Alamofire
import Foundation
import Combine

protocol AbstractRequestFactory {
    
    var errorParser: AbstractErrorParser { get }
    var sessionManager: Session { get }
    var queue: DispatchQueue { get }
    
    @discardableResult
    func request<T: Decodable>(request: URLRequestConvertible, completion: @escaping (AFDataResponse<T>) -> Void) -> DataRequest
}

extension AbstractRequestFactory {
    
    @discardableResult
    func request<T: Decodable>(request: URLRequestConvertible, completion: @escaping (AFDataResponse<T>) -> Void) -> DataRequest {
        return sessionManager.request(request)
            .responseCodable(
                errorParser: errorParser,
                completion: completion)
        
    }
}
