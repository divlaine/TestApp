import UIKit

extension UIView {

    private func animateState(_ borderColor: UIColor, _ bgColor: UIColor) {
        self.layer.animateBorderColor(to: borderColor)
        self.layer.animateBgColor(to: bgColor)
    }
    
    func showTfOdUp() {
        self.animateState(Styles.shared.c.tfOdBorderUp, Styles.shared.c.tfOdBgUp)
    }
    
    func showTfOdFocused() {
        self.animateState(Styles.shared.c.tfOdBorderFocused, Styles.shared.c.tfOdBgFocused)
    }
    
    func showTfOdError() {
        self.animateState(Styles.shared.c.tfOdBorderError, Styles.shared.c.tfOdBgError)
    }
    
    func setLeftTopCornerRadius(value: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = value
        self.layer.maskedCorners = [.layerMinXMinYCorner]
    }
    
    func setLeftBottomCornerRadius(value: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = value
        self.layer.maskedCorners = [.layerMinXMaxYCorner]
    }
    
    func setLeftCornerRadius(value: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = value
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    
    func setRightCornerRadius(value: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = value
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
    
    func setRightTopCornerRadius(value: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = value
        self.layer.maskedCorners = [.layerMaxXMinYCorner]
    }
    
    func setRightBottomCornerRadius(value: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = value
        self.layer.maskedCorners = [.layerMaxXMaxYCorner]
    }
    
    func setTopCornerRadius(value: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = value
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func setBottomCornerRadius(value: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = value
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func applyStyle(style: String) {
        Styles.shared.applyStyle(style, self)
    }
    
    var style: String {
        get { return "" }
        set { Styles.shared.applyStyle(newValue, self) }
    }
}
