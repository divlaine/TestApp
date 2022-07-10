import Alamofire
import Foundation

typealias ApiAuthSignInByPasswordResponseClosure = (AFDataResponse<AuthSignInByPasswordResponse>) -> Void
typealias ApiAuthSignOutResponseClosure = (AFDataResponse<AuthSignOutResponse>) -> Void

import Combine

protocol AuthRequestFactory: AbstractRequestFactory {
    
    func signInByPassword(with credentials: AuthCredentials, completion: @escaping ApiAuthSignInByPasswordResponseClosure)
    func signOut(completion: @escaping ApiAuthSignOutResponseClosure)
}

class AuthRequestFactoryImpl: AuthRequestFactory {
    
    let errorParser: AbstractErrorParser
    let sessionManager: Session
    let queue: DispatchQueue
    let baseUrl = URL(string: Config.shared.urlApi)!
    
    private let authRepository: AuthRepository
    private let deviceRepository: DeviceRepository
    private weak var stopwatch: Stopwatch?
    
    init(errorParser: AbstractErrorParser, sessionManager: Session, queue: DispatchQueue, stopwatch: Stopwatch?, repositoryFactory: RepositoryFactory) {
        self.errorParser = errorParser
        self.sessionManager = sessionManager
        self.queue = queue
        self.authRepository = repositoryFactory.authRepository
        self.deviceRepository = repositoryFactory.deviceRepository
        self.stopwatch = stopwatch
    }
    
    func signInByPassword(with credentials: AuthCredentials, completion: @escaping ApiAuthSignInByPasswordResponseClosure) {
        let request = AuthSignInByPasswordRequest(
            baseUrl: baseUrl,
            stopwatch: stopwatch,
            authCredentials: credentials,
            deviceRepository: deviceRepository)
        self.request(request: request, completion: completion)
        ActivityHelper.shared.add(request.id)
    }
    
    func signOut(completion: @escaping ApiAuthSignOutResponseClosure) {
        let request = AuthSignOutRequest(
            baseUrl: baseUrl,
            stopwatch: stopwatch,
            authRepository: authRepository,
            deviceRepository: deviceRepository)
        self.request(request: request, completion: completion)
    }
}
