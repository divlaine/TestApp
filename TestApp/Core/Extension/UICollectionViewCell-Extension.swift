import UIKit

extension UICollectionViewCell {
    
    static var identifier: String {
        get { return String(describing: self)}
    }
    
    static var nib: UINib {
        get { return UINib(nibName: identifier, bundle: nil) }
    }
}
