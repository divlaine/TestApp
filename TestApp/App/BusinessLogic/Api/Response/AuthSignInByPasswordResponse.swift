struct AuthSignInByPasswordResponse: Codable {
    
    var result: AuthSignInByPasswordCredentials?
    var error: ApiResponseError?
}

struct AuthSignInByPasswordCredentials: Codable {
    
    var token: String
    var refreshToken: String
    var session: String
}
