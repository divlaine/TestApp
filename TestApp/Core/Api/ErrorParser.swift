import Foundation

class ErrorParser: AbstractErrorParser {
    
    func parse(_ result: Error) -> Error {
        return result
    }
    
    func parse(response: HTTPURLResponse?, data: Data?, error: Error?) -> Error? {
        if let error = error {
            return error
        }
        do {
            _ = try verify(by: response, data: data)
        }
        catch (let error) {
            return error
        }
        return nil
    }
    
    private func verify(by response: HTTPURLResponse?, data: Data?) throws -> Error? {
        guard let response = response else {
            throw ApiError.internalError
        }
        switch response.statusCode {
        case _ where (200...299) ~= response.statusCode: break
        default: throw ApiError.unexptectedResponse(response.statusCode)
        }
        
        guard let _ = data else { throw ApiError.undefinedError }
        return nil
    }
}
