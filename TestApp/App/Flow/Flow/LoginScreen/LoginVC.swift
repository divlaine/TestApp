import UIKit

protocol LoginHandler {
    
    func onHandleSignIn()
}

class LoginVC: UIViewController {

    // MARK: - Coordinator
    var onSignIn: VoidClosure?
    
    
    // MARK: - Properties
    private var authProvider: AuthProvider
    
    // MARK: - Outlets
    @IBOutlet private weak var loginTextfield: UITextField!
    @IBOutlet private weak var passwordTextfield: UITextField!
    @IBOutlet private weak var signInButton: UIButton!
    
    // MARK: - View
    init(authProvider: AuthProvider) {
        self.authProvider = authProvider
        super.init(nibName: Self.identifier, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        addGestures()
        updateData()
    }
    
    // MARK: - Private
    private func configure() {
        self.view.backgroundColor = Styles.shared.c.vc
        loginTextfield.style = Styles.shared.tfs.odPrT
        passwordTextfield.style = Styles.shared.tfs.odPrB
        signInButton.style = Styles.shared.button.bevelDfSc
    }
    
    private func addGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(keyboardDismiss))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    // MARK: - Data
    func updateData() {
        loginTextfield.setPlaceholer("Login", with: Styles.shared.tfs.odPh)
        passwordTextfield.setPlaceholer("Password", with: Styles.shared.tfs.odPh)
        signInButton.setTitle("Sign In", for: .normal)
    }
    
    // MARK: - Taps
    @IBAction private func onTapSignIn(_ sender: UIButton) {
        self.onHandleSignIn()
    }
    
    // MARK: - Textfield
    @IBAction private func onEditingDidBegin(_ sender: UITextField) {
        sender.showTfOdFocused()
        sender.superview?.addSubview(sender)
    }
    
    @IBAction private func onEditingDidEnd(_ sender: UITextField) {
        sender.showTfOdUp()
    }
}

// MARK: - Keyboard
extension LoginVC {

    @objc func keyboardDismiss() {
        self.view.endEditing(true)
    }
}

// MARK: - Handle
extension LoginVC: LoginHandler {
   
    func onHandleSignIn() {
        let login = loginTextfield.text ?? ""
        let password = passwordTextfield.text ?? ""
        guard login.isValidEmail, password.isValidPassword else {
            // Showing Custom Toast
            if !login.isValidEmail {
                loginTextfield.showTfOdError()
            }
            if !password.isValidPin {
                passwordTextfield.showTfOdError()
            }
            return
        }
        
        authProvider.signIn(with: AuthCredentials(login: login, password: password)) { [weak self] isAuthed, errorMessage in
            if !isAuthed {
                // Showing Custom Alert
            }
            else {
                self?.onSignIn?()
            }
        }
    }
}

// MARK: Textfield Delegate
extension LoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextfield {
            loginTextfield.resignFirstResponder()
            passwordTextfield.becomeFirstResponder()
        }
        else {
            passwordTextfield.resignFirstResponder()
            onTapSignIn(signInButton)
        }
        return true
    }
}
