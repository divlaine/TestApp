import UIKit

extension UIBarButtonItem {
    
    var style: String {
        get { return "" }
        set { Styles.shared.applyStyle(newValue, self) }
    }
}
