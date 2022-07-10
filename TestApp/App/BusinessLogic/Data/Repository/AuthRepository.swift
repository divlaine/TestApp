import Foundation

protocol AuthRepository: AnyObject{
    
    var data: AuthCredentials { get set }
    func clear()
}

class AuthRepositoryImpl: AuthRepository {
 
    private let keyChainKey = "auth"
    
    private var keychainWrapper: KeychainWrapper
    var data: AuthCredentials {
        get {
            if let data = keychainWrapper.data(forKey: keyChainKey),
               let credentials = try? JSONDecoder().decode(AuthCredentials.self, from: data) {
                return credentials
            }
            return AuthCredentials()
        }
        set {
            if let data = newValue.data {
                keychainWrapper.set(data, forKey: keyChainKey)
            }
            else {
                keychainWrapper.removeObject(forKey: keyChainKey)
            }
        }
    }
    
    init(keychainWrapper: KeychainWrapper) {
        self.keychainWrapper = keychainWrapper
    }
    
    func clear() {
        data = AuthCredentials()
    }
}
