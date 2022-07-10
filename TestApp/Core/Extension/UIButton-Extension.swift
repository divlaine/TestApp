import UIKit

extension UIButton {
    
    func setHighlightedBackgroundColor(_ color: UIColor) {
        let colorImage = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image(actions: { _ in
            color.setFill()
            UIBezierPath(rect: CGRect(x: 0, y: 0, width: 1, height: 1)).fill()
        })
        self.setBackgroundImage(colorImage, for: .highlighted)
    }
    
    func setDisabledBackgroundColor(_ color: UIColor) {
        let colorImage = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { _ in
            color.setFill()
            UIBezierPath(rect: CGRect(x: 0, y: 0, width: 1, height: 1)).fill()
        }
        setBackgroundImage(colorImage, for: .disabled)
    }
}
