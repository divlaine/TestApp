import UIKit

class LaunchVC: UIViewController {

    // MARK: - Coordinator
    var onCheckAuthStatus: BoolClosure?
    
    
    // MARK: - Properties
    private var authStatusProvider: AuthStatusProvider
    
    init(authStatusProvider: AuthStatusProvider) {
        self.authStatusProvider = authStatusProvider
        super.init(nibName: Self.identifier, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAuthStatus()
    }
    
    // MARK: - Private
    private func checkAuthStatus() {
        self.onCheckAuthStatus?(authStatusProvider.isAuthed)
    }
}
