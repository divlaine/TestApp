import Foundation

struct ApiRequestSession {
    
    var request: RequestRouter
    var session: URLSessionDataTask
    
    init(request: RequestRouter, session: URLSessionDataTask) {
        self.request = request
        self.session = session
    }
}
