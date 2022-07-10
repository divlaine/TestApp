protocol AuthStatusProvider: AnyObject {
    
    var isAuthed: Bool { get }
}

class AuthStatusProviderImpl: AuthStatusProvider {
    
    private let authService: AuthService
    
    var isAuthed: Bool { authService.isAuthed }
    
    init(authService: AuthService) {
        self.authService = authService
    }
}
