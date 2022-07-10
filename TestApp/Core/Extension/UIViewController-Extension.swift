import UIKit

protocol Presentable: AnyObject {
    
    func toPresent() -> UIViewController?
}

extension UIViewController: Presentable {
    
    func toPresent() -> UIViewController? {
        return self
    }
}

extension UIViewController {
    
    static var identifier: String {
        get { return String(describing: self) }
    }
    
    static func loadFromNib(presentationStyle: UIModalPresentationStyle = .fullScreen, transitionStyle: UIModalTransitionStyle = .crossDissolve) -> Self {
        func instantiateFromNib<T: UIViewController>(presentationStyle: UIModalPresentationStyle, transitionStyle: UIModalTransitionStyle) -> T {
            let viewController = T.init(nibName: String(describing: T.self), bundle: nil)
            viewController.modalPresentationStyle = presentationStyle
            viewController.modalTransitionStyle = transitionStyle
            return viewController
        }
        if isNibExists() {
            return instantiateFromNib(presentationStyle: presentationStyle, transitionStyle: transitionStyle)
        }
        return Self()
    }
    
    private static func isNibExists() -> Bool {
        let selfClass: AnyClass = self as AnyClass
        var className = NSStringFromClass(selfClass)
        let bundle = Bundle(for: selfClass)
        if bundle.path(forResource: className, ofType: "nib") == nil {
            className = (className as NSString).pathExtension
            if bundle.path(forResource: className, ofType: "nib") == nil {
                return false
            }
        }
        return true
    }
}
