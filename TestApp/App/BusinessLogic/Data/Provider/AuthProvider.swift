protocol AuthProvider {
    
    var isAuthed: Bool { get }
    
    func signIn(with credentials: AuthCredentials, completion: @escaping ((Bool, String?) -> Void))
    func signOut(completion: BoolClosure?)
}

class AuthProviderImpl: AuthProvider {
    
    var isAuthed: Bool { return authService.isAuthed }
    
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func signIn(with credentials: AuthCredentials, completion: @escaping ((Bool, String?) -> Void)) {
        authService.signIn(with: credentials, completion: completion)
    }
    
    func signOut(completion: BoolClosure?) {
        authService.signOut(completion: completion)
    }
}
