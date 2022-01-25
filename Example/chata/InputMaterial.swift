import UIKit

@IBDesignable class InputMaterial: UITextField {
    let animationDuration = 0.3
    var title = UILabel()
    var border = CALayer()
    // MARK: Properties
    override var accessibilityLabel: String? {
        get {
            if let txt = text, txt.isEmpty {
                return title.text
            } else {
                return text
            }
        }
        set {
            self.accessibilityLabel = newValue
        }
    }
    override var placeholder: String? {
        didSet {
            title.text = placeholder
            title.sizeToFit()
        }
    }
    override var attributedPlaceholder: NSAttributedString? {
        didSet {
            title.text = attributedPlaceholder?.string
            title.sizeToFit()
        }
    }
    var titleFont: UIFont = UIFont.systemFont(ofSize: 12.0) {
        didSet {
            title.font = titleFont
            title.sizeToFit()
        }
    }
    @IBInspectable var hintYPadding: CGFloat = 0.0
    @IBInspectable var titleYPadding: CGFloat = 0.0 {
        didSet {
            var newR = title.frame
            newR.origin.y = titleYPadding
            title.frame = newR
        }
    }
    // MARK: Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    var titleActiveTextColour = UIColor.blue
    var borderColor = UIColor.gray.cgColor
    var titleTextColour = UIColor.blue
    var borderColorL = UIColor.red.cgColor
    // MARK: Overrides
    override func layoutSubviews() {
        super.layoutSubviews()
        setTitlePositionForTextAlignment()
        let isResp = isFirstResponder
        if let txt = text, !txt.isEmpty && isResp {
            title.textColor = titleActiveTextColour
            border.borderColor = borderColor
        } else {
            title.textColor = titleTextColour
            border.borderColor = borderColorL
        }
        // Should we show or hide the title label?
        if let txt = text, txt.isEmpty {
            // Hide
            hideTitle(isResp)
        } else {
            // Show
            showTitle(isResp)
        }
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var newR = super.textRect(forBounds: bounds)
        if let txt = text, !txt.isEmpty {
            var top = ceil(title.font.lineHeight + hintYPadding)
            top = min(top, maxTopInset())
            newR = newR.inset(by: UIEdgeInsets(top: top,
                                                            left: 0.0,
                                                            bottom: 0.0,
                                                            right: 0.0))
        }
        return newR.integral
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var newR = super.editingRect(forBounds: bounds)
        if let txt = text, !txt.isEmpty {
            var top = ceil(title.font.lineHeight + hintYPadding)
            top = min(top, maxTopInset())
            newR = newR.inset(by: UIEdgeInsets(top: top,
                                                            left: 0.0,
                                                            bottom: 0.0,
                                                            right: 0.0))
        }
        return newR.integral
    }
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var newR = super.clearButtonRect(forBounds: bounds)
        if let txt = text, !txt.isEmpty {
            var top = ceil(title.font.lineHeight + hintYPadding)
            top = min(top, maxTopInset())
            newR = CGRect(x: newR.origin.x,
                          y: newR.origin.y + (top * 0.5),
                          width: newR.size.width,
                          height: newR.size.height)
        }
        return newR.integral
    }
    // MARK: Public Methods
    // MARK: Private Methods
    fileprivate func setup() {
        title.textColor = titleTextColour
        title.textColor = titleActiveTextColour
        border.borderColor = borderColorL
        //borderStyle = UITextField.BorderStyle.none
        // Set up title label
        title.alpha = 0.0
        title.font = titleFont
        title.textColor = titleTextColour
        title.textAlignment = .center
        if let str = placeholder, !str.isEmpty {
            title.text = str
            title.sizeToFit()
        }
        self.addSubview(title)
        let width = CGFloat(1.0)
        //border.borderColor = UIColor(red: 162/255, green: 205/255, blue: 85/255, alpha: 1).cgColor
        border.borderColor = borderColorL
        
        border.frame = CGRect(x: 0,
                              y: self.frame.size.height - width,
                              width: self.frame.size.width + 0,
                              height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    fileprivate func maxTopInset() -> CGFloat {
        if let fnt = font {
            return max(0, floor(bounds.size.height - fnt.lineHeight - 4.0))
        }
        return 0
    }
    fileprivate func setTitlePositionForTextAlignment() {
        let newR = textRect(forBounds: bounds)
        var paramX = newR.origin.x
        if textAlignment == NSTextAlignment.center {
            paramX = newR.origin.x + (newR.size.width * 0.5) - title.frame.size.width
        } else if textAlignment == NSTextAlignment.right {
            paramX = newR.origin.x + newR.size.width - title.frame.size.width
        }
        let wdt = UIScreen.main.bounds.size.width
        title.frame = CGRect(x: self.frame.origin.x-70,
                             y: title.frame.origin.y,
                             width: wdt,
                             height: title.frame.size.height)
    }
    fileprivate func showTitle(_ animated: Bool) {
        let dur = animated ? animationDuration : 0
        UIView.animate(withDuration: dur,
                       delay: 0,
                       options: [UIView.AnimationOptions.beginFromCurrentState,
                                 UIView.AnimationOptions.curveEaseOut],
                       animations: {
            // Animation
            self.title.alpha = 1.0
            var newR = self.title.frame
            newR.origin.y = self.titleYPadding
            self.title.frame = newR
        }, completion: nil)
    }
    fileprivate func hideTitle(_ animated: Bool) {
        let dur = animated ? animationDuration : 0
        UIView.animate(withDuration: dur,
                       delay: 0,
                       options:
                        [UIView.AnimationOptions.beginFromCurrentState,
                         UIView.AnimationOptions.curveEaseIn],
                       animations: {
            // Animation
            self.title.alpha = 0.0
            var newR = self.title.frame
            newR.origin.y = self.title.font.lineHeight + self.hintYPadding
            self.title.frame = newR
        }, completion: nil)
    }
}
