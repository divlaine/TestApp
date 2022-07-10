import UIKit

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }

    convenience init(rgb: Int, a: CGFloat = 1.0) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            a: a
        )
    }
    
    func modified(withAdditionalHue hue: CGFloat = 0, additionalSaturation: CGFloat = 0, additionalBrightness: CGFloat) -> UIColor {
        var currentHue: CGFloat = 0
        var currentSaturation: CGFloat = 0
        var currentBrigghtness: CGFloat = 0
        var currentAlpha: CGFloat = 0
        if self.getHue(&currentHue, saturation: &currentSaturation, brightness: &currentBrigghtness, alpha: &currentAlpha) {
            return UIColor(hue: currentHue + hue, saturation: currentSaturation + additionalSaturation, brightness: currentBrigghtness + additionalBrightness, alpha: currentAlpha)
        }
        return self
    }
}
