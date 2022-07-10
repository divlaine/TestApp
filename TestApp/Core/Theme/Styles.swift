import Foundation
import UIKit

struct MFont {
    
    var size: CGFloat
    var name: String
    var color: UIColor
    var ha: NSTextAlignment
    var adj: Bool
    var a: CGFloat
    
    init(_ size: CGFloat, _ name: String, _ color: UIColor, _ ha: NSTextAlignment, _ adj: Bool = false, _ a: CGFloat = 1.0) {
        self.size = size
        self.name = name
        self.color = color
        self.ha = ha
        self.adj = adj
        self.a = a
    }
}

class Styles {
    
    static let shared = Styles()
    
    let button = ButtonStyles()
    let label = LabelStyles()
    let tfs = TextfieldStyles()
    let view = ViewStyles()
    
    let c = Colors()
    let fs = FontSizes()
    
    private let fontR = "SourceSansPro-Regular"
    private let fontB = "SourceSansPro-SemiBold"
    
    private var tf = [String:MFont]()
    private var tfFonts = [String:UIFont]()
    
    init() {
        tf[button.bevelDfSc] = MFont(fs.fs24, fontB, c.gray, NSTextAlignment.left)
        tf[tfs.odPh] = MFont(fs.fs24, fontR, c.white, NSTextAlignment.left, false, 0.4)
        tf[tfs.odPr] = MFont(fs.fs24, fontB, c.white, NSTextAlignment.left)
        tf[view.navbarPr] = MFont(fs.fs20, fontB, c.black, NSTextAlignment.left, false, 0.55)
        tf[view.navbarPrC] = MFont(fs.fs20, fontB, c.black, NSTextAlignment.center, false, 0.55)
    }
    
    func getFontStyle(_ style: String) -> MFont {
        return tf[style]!
    }
    
    func getFont(_ style: String) -> UIFont {
        let fontStyle = getFontStyle(style)
        let fontName = "\(fontStyle.name)\(fontStyle.size)"
        if tfFonts[fontName] == nil {
            tfFonts[fontName] = UIFont(name: fontStyle.name, size: fontStyle.size)
        }
        return tfFonts[fontName]!
    }
    
    func getFontColor(_ style: String) -> UIColor {
        let fontStyle = getFontStyle(style)
        return fontStyle.color.withAlphaComponent(fontStyle.a)
    }
    
    func applyStyle(_ style: String, _ button: UIButton) {
        self.button.applyStyle(style, button)
    }
    
    func applyStyle(_ style: String, _ barButtonItem: UIBarButtonItem) {
        self.button.applyStyle(style, barButtonItem)
    }
    
    func applyStyle(_ style: String, _ switchButton: UISwitch) {
        self.button.applyStyle(style, switchButton)
    }
    
    func applyStyle(_ style: String, _ label: UILabel) {
        self.label.applyStyle(style, label)
    }
    
    func applyStyle(_ style: String, _ textfield: UITextField) {
        self.tfs.applyStyle(style, textfield)
    }
    
    func applyStyle(_ style: String, _ textview: UITextView) {
        self.tfs.applyStyle(style, textview)
    }
    
    func applyStyle(_ style: String, _ view: UIView) {
        if view.isKind(of: UILabel.self) {
            self.applyStyle(style, view as! UILabel)
        }
        else if view.isKind(of: UIButton.self) {
            self.applyStyle(style, view as! UIButton)
        }
        else if view.isKind(of: UISwitch.self) {
            self.applyStyle(style, view as! UISwitch)
        }
        else if view.isKind(of: UITextField.self) {
            self.applyStyle(style, view as! UITextField)
        }
        else if view.isKind(of: UITextView.self) {
            self.applyStyle(style, view as! UITextView)
        }
        else {
            self.view.applyStyle(style, view)
        }
    }
    
    func getAttributedString(for string: String, with style: String) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: self.getAttributes(style))
    }
    
    func getAttributes(_ name: String) -> [NSAttributedString.Key: Any] {
        let font = tf[name]!
        return [
            NSAttributedString.Key.foregroundColor: font.color.withAlphaComponent(font.a),
            NSAttributedString.Key.font: UIFont(name: font.name, size: font.size)!
        ]
    }
   
    func addShadow(layer: CALayer, path: UIBezierPath, offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.shadowPath = path.cgPath
    }

    func addShadow(_ view: UIView, x: Double, y: Double, a: Double, blur: Double = 10.0, cornerRadius: CGFloat = 0) {
        if cornerRadius == 0 {
            addShadow(layer: view.layer, path: UIBezierPath(rect: view.bounds), offset: CGSize(width: x, height: y), color: .black, opacity: Float(a), radius: CGFloat(blur))
        }
        else {
            addShadow(layer: view.layer, path: UIBezierPath(roundedRect: view.bounds, cornerRadius: cornerRadius), offset: CGSize(width: x, height: y), color: .black, opacity: Float(a), radius: CGFloat(blur))
        }
    }
}

// MARK: - Colors
class Colors {
    
    // TODO: . Colors - to assets
    let vc = UIColor(rgb: 0xffffff)
    let black = UIColor(rgb: 0x000000)
    let gray = UIColor(rgb: 0x646464)
    let white = UIColor(rgb: 0xffffff)

    let buttonScUp = UIColor(rgb: 0xfafafa)
    let buttonScDown: UIColor

    let tfOdBorderUp = UIColor(rgb: 0x3d5976)
    let tfOdBorderFocused = UIColor(rgb: 0xaaaaaa)
    let tfOdBorderError = UIColor(rgb: 0xf9b290)
    let tfOdBgUp = UIColor(rgb: 0xffffff, a: 0)
    let tfOdBgFocused = UIColor(rgb: 0xffffff, a: 0.05)
    let tfOdBgError = UIColor(rgb: 0xf9b290)
    
    init() {
        buttonScDown = buttonScUp.modified(additionalBrightness: -0.05)
    }
}

// MARK: - FontSizes
class FontSizes {
    
    let fs14: CGFloat  = 14.0
    let fs16: CGFloat = 16.0
    let fs18: CGFloat = 18.0
    let fs20: CGFloat = 20.0
    let fs22: CGFloat = 22.0
    let fs24: CGFloat = 24.0
    let fs26: CGFloat = 26.0
    let fs28: CGFloat = 28.0
    let fs40: CGFloat = 40.0
    let fs44: CGFloat = 44.0
}

// MARK: - Button
class ButtonStyles {
    
    let bevelDfSc = "bevelDfSc"
    
    let sizeSm: CGFloat = 34
    let sizeDf: CGFloat = 50
    let sizeLg: CGFloat = 60
    let sizeFlow: CGFloat = 64
    
    let cornerDf: CGFloat = 10
    let cornerSm: CGFloat = 5
    
    func applyStyle(_ style: String, _ button: UIButton) {
        switch style {
        case bevelDfSc: setStyleBevelDfSc(style, button)
        case Styles.shared.view.navbarPr: setStyleNavbarPr(style, button)
        default:
            print("no button style \(style)")
        }
    }
    
    func applyStyle(_ style: String, _ button: UIBarButtonItem) {
        switch style {
        case Styles.shared.view.navbarPr: setStyleNavbarPr(style, button)
        default:
            print("no barbutton style \(style)")
        }
    }
    
    func applyStyle(_ style: String, _ button: UISwitch) {
        print("no switch style \(style)")
    }
    
    private func setTextFont(_ style: String, _ button: UIButton, _ state: UIControl.State = .normal) {
        let fontStyle = Styles.shared.getFontStyle(style)
        button.titleLabel?.font = Styles.shared.getFont(style)
        button.setTitleColor(fontStyle.color.withAlphaComponent(fontStyle.a), for: state)
    }

    private func setStyleCommon(button: UIButton, upColor: UIColor, downColor: UIColor, height: CGFloat, cornerRadius: CGFloat, fontStyle: String) {
        button.backgroundColor = upColor
        button.setHighlightedBackgroundColor(downColor)
        button.heightAnchor.constraint(equalToConstant: height).isActive = true
        if cornerRadius > 0 {
            button.clipsToBounds = true
            button.layer.cornerRadius = cornerRadius
        }
        if !fontStyle.isEmpty {
            setTextFont(fontStyle, button)
        }
    }

    private func setStyleBevelDfSc(_ style: String, _ button: UIButton) {
        setStyleCommon(button: button,
                       upColor: Styles.shared.c.buttonScUp,
                       downColor: Styles.shared.c.buttonScDown,
                       height: sizeDf,
                       cornerRadius: cornerDf,
                       fontStyle: style)
    }

    private func setStyleNavbarPr(_ style: String, _ button: UIButton) {
        setTextFont(style, button)
    }

    private func setStyleNavbarPr(_ style: String, _ button: UIBarButtonItem) {
        let attributes = Styles.shared.getAttributes(style)
        button.setTitleTextAttributes(attributes, for: .normal)
        button.setTitleTextAttributes(attributes, for: .highlighted)
    }
}

// MARK: - Label
class LabelStyles {
    
    func applyStyle(_ style: String, _ label: UILabel) {
        let fontStyle = Styles.shared.getFontStyle(style)
        label.font = Styles.shared.getFont(style)
        label.textColor = fontStyle.color.withAlphaComponent(fontStyle.a)
        label.textAlignment = fontStyle.ha
    }
}

// MARK: - Textfield
class TextfieldStyles {
    
    let odPh = "odPh"
    let odPr = "odPr"
    let odPrT = "odPrT"
    let odPrB = "odPrB"

    let sizeDf: CGFloat = 50
    let sizeLg: CGFloat = 60
    let cornerDf: CGFloat = 10
    let paddingDf: CGFloat = 10
    
    func applyStyle(_ style: String, _ textfield: UITextField) {
        switch style {
        case odPr: setStyleOdPr(style, textfield)
        case odPrT: setStyleOdPrT(style, textfield)
        case odPrB: setStyleOdPrB(style, textfield)
        default:
            print("no tf style \(style)")
        }
    }
    
    func applyStyle(_ style: String, _ textview: UITextView) {
        print("no tv style \(style)")
    }
    
    private func setTextFont(_ style: String, textfield: UITextField) {
        let fontStyle = Styles.shared.getFontStyle(style)
        textfield.font = Styles.shared.getFont(style)
        textfield.textColor = fontStyle.color.withAlphaComponent(fontStyle.a)
        textfield.textAlignment = fontStyle.ha
    }

    private func setStyleCommon(_ textfield: UITextField, _ fontStyle: String, _ phStyle: String, _ cornerRadius: CGFloat = 0) {
        textfield.borderStyle = .none
        textfield.clipsToBounds = true
        textfield.layer.masksToBounds = true
        textfield.layer.borderWidth = 1
        if cornerRadius > 0 {
            textfield.layer.cornerRadius = cornerRadius
        }
        textfield.setHorizontalTextPadding(paddingDf)
        textfield.tintColor = Styles.shared.getFontColor(fontStyle)
        textfield.setPlaceholer(textfield.placeholder ?? "", with: phStyle)
        setTextFont(fontStyle, textfield: textfield)
    }
    private func setStyleOdCommon(_ style: String, _ textfield: UITextField, _ cornerRadius: CGFloat = 0) {
        setStyleCommon(textfield, odPr, odPh, cornerRadius)
        textfield.showTfOdUp()
    }

    private func setStyleOdPr(_ style: String, _ textfield: UITextField) {
        setStyleOdCommon(style, textfield, cornerDf)
    }

    private func setStyleOdPrT(_ style: String, _ textfield: UITextField) {
        setStyleOdCommon(style, textfield)
        textfield.setTopCornerRadius(value: cornerDf)
    }

    private func setStyleOdPrB(_ style: String, _ textfield: UITextField) {
        setStyleOdPr(style, textfield)
        textfield.setBottomCornerRadius(value: cornerDf)
    }
}

// MARK: - View
class ViewStyles {
    
    let navbarPr = "navbarPr"
    let navbarPrC = "navbarPrC"
    
    let cornerDf: CGFloat = 10
    let cornerPopup: CGFloat = 15
    let sizeNavbar: CGFloat = 44
    
    private var _topInset = CGFloat.zero
    private var _bottomInset = CGFloat.zero
    
    var topInset: CGFloat {
        get {
            if _topInset > 0 {
                return _topInset
            }
            _topInset = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? .zero
            return _topInset
        }
    }
    
    var bottomInset: CGFloat {
        get {
            if _bottomInset > 0 {
                return _bottomInset
            }
            _bottomInset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? .zero
            return _bottomInset
        }
    }
    
    var screenWidth: CGFloat {
        get { return UIScreen.main.bounds.width }
    }
    
    var screenHeight: CGFloat {
        get { return UIScreen.main.bounds.height }
    }
    
    func applyStyle(_ style: String, _ view: UIView) {
        print("no view style \(style)")
    }
}
