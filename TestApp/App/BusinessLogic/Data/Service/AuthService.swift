import Combine

protocol AuthService {
    
    var isAuthed: Bool { get }
    var credentials: AuthCredentials { get }
    
    func signIn(with credentials: AuthCredentials, completion: @escaping (Bool, String?) -> Void)
    func signOut(completion: BoolClosure?)
}

class AuthServiceImpl: AuthService {
   
    private var authRepository: AuthRepository
    
    var isAuthed: Bool { return !authRepository.data.token.isEmpty }
    var credentials: AuthCredentials { get { return authRepository.data } }
    var requestFactory: RequestFactory
    
    init(authRepository: AuthRepository, requestFactory: RequestFactory) {
        self.authRepository = authRepository
        self.requestFactory = requestFactory
    }
    
    func signIn(with credentials: AuthCredentials, completion: @escaping (Bool, String?) -> Void) {
        let authRequest = requestFactory.makeAuthRequestFactory()
        authRequest.signInByPassword(with: credentials) { [weak self] data in
            ActivityHelper.shared.remove(data.request?.httpBody)
            if case .success(let response) = data.result {
                guard let result = response.result else {
                    let message = response.error?.message ?? "An error occured while signing in"
                    completion(false, message)
                    return
                }
                self?.authRepository.data = AuthCredentials(credentials, result)
                completion(true, nil)
            }
        }
    }
    
    func signOut(completion: BoolClosure?) {
        let authRequest = requestFactory.makeAuthRequestFactory()
        authRequest.signOut { data in }
        authRepository.data = AuthCredentials()
        completion?(isAuthed)
    }
}
