import UIKit
    
extension UIWindow {
    
    static var keyWindow: UIWindow? = {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        }
        return UIApplication.shared.keyWindow
    }()
}
