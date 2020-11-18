//
//  DScrollView+.swift
//  TestingEasyUIScrollView
//
//  Created by Alex Nagy on 07/06/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import UIKit
var isTypingMic = false

extension String {
    func replaceRange(range: Range<Index>, start: Index, newText: String) -> String{
        var newString = self
        newString.removeSubrange(range)
        newString.insert(contentsOf: newText, at: start)
        return newString
    }
    func hexToColor () -> UIColor {
        var cString: String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        if (cString.count) <= 5 {
            return UIColor.gray
        }
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    func rgbColor(alpha: CGFloat = 1.0) -> UIColor {
        let colors = self.components(separatedBy: ",")
        if colors.count >= 3 {
            let colorsFinal: [CGFloat] = colors.map { (color) -> CGFloat in
                if let colorUI = NumberFormatter().number(from: color) {
                    return CGFloat(truncating: colorUI)
                } else {
                    return 255.0
                }
            }
            let red: CGFloat = colorsFinal.validData(0) ? colorsFinal[0].validateRangeColor() / 255 : 255
            let green: CGFloat = colorsFinal.validData(1) ? colorsFinal[1].validateRangeColor() / 255 : 255
            let blue: CGFloat = colorsFinal.validData(2) ? colorsFinal[2].validateRangeColor() / 255 : 255
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
        return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    }
    func replace(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target,
                                         with: withString,
                                         options: NSString.CompareOptions.literal,
                                         range: nil)
    }
    func replaceUnder() -> String {
        var new = self
        if new.contains("___") {
            new = new.replace(target: "___", withString: " (")
            new = "\(new))"
        }
        new = new.replace(target: "__", withString: " ")
        new = new.replace(target: "_", withString: " ")
        new = new.capitalized
        return new
    }
    func getTypeColumn(type: ChatTableColumnType) -> String {
        switch type {
        case .date:
            return self.toDate(true)
        case .string:
            return self
        case .dollar:
            return self.toMoney()
        case .quantity:
            return self.toQuantity()
        case .percent:
            let final = Double(self) ?? 0
            let color = final > 0.0 ? "green" : final < 0.0 ? "red" : ""
            return "<span class='\(color)'>\(self.toPercent())</span>"
        case .ratio:
            return self
        case .defaultType:
            return self
        case .dateString:
            return self
        }
    }
    func toMoney() -> String {
        let format = NumberFormatter()
        format.numberStyle = .currency
        format.currencyCode = DataConfig.dataFormattingObj.currencyCode
        format.minimumFractionDigits = DataConfig.dataFormattingObj.currencyDecimals
        format.maximumFractionDigits = DataConfig.dataFormattingObj.currencyDecimals
        format.locale = Locale.init(identifier: DataConfig.dataFormattingObj.languageCode)
        let money: Double = Double(self) ?? 0.0
        let dolar = format.string(from: NSNumber(value: money)) ?? ""
        let finalStr = self == "" ? "" : "\(String(describing: dolar))"
        return finalStr
    }
    func toQuantity() -> String {
        let format = NumberFormatter()
        format.minimumFractionDigits = DataConfig.dataFormattingObj.quantityDecimals
        let money: Double = Double(self) ?? 0.0
        let dolar = format.string(from: NSNumber(value: money)) ?? "0"
        return "\(String(describing: dolar))"
    }
    func toPercent() -> String {
        let format = NumberFormatter()
        format.minimumFractionDigits = 2
        let money: Double = (Double(self) ?? 0.0) * 100.0
        let dolar = format.string(from: NSNumber(value: money)) ?? "0"
        return "\(String(describing: dolar))%"
    }
    func toDate(_ day: Bool = false, _ hour: Bool = false) -> String {
        let formater = DateFormatter()
        formater.dateFormat = day
            ? DataConfig.dataFormattingObj.dayMonthYearFormat
            : DataConfig.dataFormattingObj.monthYearFormat
        if hour {
            formater.dateFormat = "MMMM ddº, YYYY h:mm a"
        }
        formater.timeZone = TimeZone(abbreviation: "GMT")
        let valid = Double(self) ?? 0.0
        let dates = NSDate(timeIntervalSince1970: valid)
        let form = formater.string(from: dates as Date)
        return valid == 0.0 ? self : form
    }
    func toStrDate(format: String = "yyyy-MM") -> String {
        let separete = self.components(separatedBy: " ")
        if format == "yyyy-MM"{
            let month = separete.count > 0 ? separete[0] : ""
            let year = separete.count > 1 ? separete[1] : ""
            let (finalMonth, valid) = month.monthStr()
            return valid ? "\(year)-\(finalMonth)" : self
        }
        return self
    }
    func monthStr() -> (String, Bool){
        let finalTxt = String(self.prefix(3)).lowercased()
        let months = [
            "",
            "jan",
            "feb",
            "mar",
            "apr",
            "may",
            "jun",
            "jul",
            "aug",
            "sep",
            "oct",
            "nov",
            "dec"
        ]
        let finalNumber = months.firstIndex(of: finalTxt) ?? 0
        if finalNumber == 0 {
            return (self, false)
        }
        let finalTxtSend = finalNumber > 9 ? "\(finalNumber)" : "0\(finalNumber)"
        return (finalTxtSend, true)
    }
    func toDate2(format: String = "yyyy-MM") -> String {
        if self.contains("W") {
            return self
        }
        let separete = self.components(separatedBy: "-")
        let format2 = format.components(separatedBy: "-")
        var year = ""
        var month = ""
        if format2.count > 0 {
            format2.enumerated().forEach { (index, formatE) in
                if separete.count > index {
                    let ff = formatE.lowercased()
                    if ff == "yyyy"{
                        year = "\(separete[index])"
                    } else if ff == "mm" || ff == "m"{
                        month = "\(separete[index].toMonth().prefix(3))"
                    } else if ff == "mmm" {
                        month = separete[index]
                    } else if ff == "mmmm" {
                        month = String(separete[index].prefix(3))
                    }
                }
            }
        }
        let finalDate = "\(month) \(year)"
        return finalDate
    }
    func toMonth() -> String {
        let months = ["",
                      "January",
                      "February",
                      "March",
                      "April",
                      "May",
                      "June",
                      "July",
                      "August",
                      "September",
                      "October",
                      "November",
                      "December"]
        let pos = Int(self) ?? 0
        return months[pos]
    }
}
extension Array {
    func validData(_ index: Int) -> Bool {
        return self.count > index
    }
}
extension CGFloat {
    func validateRangeColor() -> CGFloat {
        var finalColor = self >= 255 ? 255 : self
        finalColor = self <= 0 ? 0 : self
        return finalColor
    }
}
extension UIImage {
    func resizeT(maxWidthHeight : Double)-> UIImage? {

        let actualHeight = Double(size.height)
        let actualWidth = Double(size.width)
        var maxWidth = 0.0
        var maxHeight = 0.0

        if actualWidth > actualHeight {
            maxWidth = maxWidthHeight
            let per = (100.0 * maxWidthHeight / actualWidth)
            maxHeight = (actualHeight * per) / 100.0
        }else{
            maxHeight = maxWidthHeight
            let per = (100.0 * maxWidthHeight / actualHeight)
            maxWidth = (actualWidth * per) / 100.0
        }

        let hasAlpha = true
        let scale: CGFloat = 0.0

        UIGraphicsBeginImageContextWithOptions(CGSize(width: maxWidth, height: maxHeight), !hasAlpha, scale)
        self.draw(in: CGRect(origin: .zero, size: CGSize(width: maxWidth, height: maxHeight)))

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
}
extension UIButton {
    func padding(_ margin: CGFloat = 5) {
        self.imageEdgeInsets = UIEdgeInsets(top: margin, left: margin,
                                            bottom: margin, right: margin)
    }
    func circle(_ size: CGFloat){
        self.layer.cornerRadius = size / 2
    }
    func loadStyleBtn(width: CGFloat) {
        self.layer.borderWidth = 0
        self.layer.cornerRadius = (width / 2)
        self.layer.borderColor = chataDrawerBackgroundColorPrimary.cgColor
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5.0
        self.layer.masksToBounds = false
    }
}
extension UITextField {
    func addLeftImageTo(image: UIImage) {
        let size: CGFloat = 30
        let frame = CGRect(x: 0, y: 0, width: size, height: size)
        let imageView = UIImageView(frame: frame)
        imageView.image = image
        self.leftView = imageView
        self.leftViewMode = .always
    }
    func borderRadius() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 20.0
    }
    func configStyle() {
        keyboardAppearance = dark ? .dark : .light
        addDoneButtonOnKeyboard()
        textColor = chataDrawerTextColorPrimary
    }
    func loadInputPlace(_ txt: String) {
        attributedPlaceholder = NSAttributedString(string: txt,
        attributes: [
             NSAttributedString.Key.foregroundColor: chataDrawerMessengerTextColorPrimary,
             NSAttributedString.Key.font: generalFont
         ]
        )
    }
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
extension UIView {
    func cardView(border: Bool = true, borderRadius: CGFloat = 10) {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = borderRadius
        self.layer.borderColor = border ? chataDrawerBorderColor.cgColor : UIColor.clear.cgColor
        /*self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 1.0*/
        self.layer.masksToBounds = false
    }
    enum ViewSide {
        case left, right, top, bottom
    }

    func addBorder(side: ViewSide = .bottom, color: UIColor = chataDrawerBorderColor, width: CGFloat = 1 ) {
        let newBorder = UIView()
        newBorder.backgroundColor = color
        newBorder.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        switch side {
        case .bottom:
            newBorder.frame = CGRect(x: 0, y: frame.size.height - width, width: frame.size.width, height: width)
        case .top:
            newBorder.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
        case .left:
            newBorder.frame = CGRect(x: 0, y: 0, width: width, height: frame.size.height)
        case .right:
            newBorder.frame = CGRect(x: frame.size.width - width, y: 0, width: width, height: frame.size.height)
        }
        addSubview(newBorder)
    }
    func cardViewShadow() {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 20
          self.layer.borderWidth = 1.0
              self.layer.borderColor = UIColor.white.cgColor
              self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
              self.layer.shadowOffset = CGSize(width: 0, height: 0)
              self.layer.shadowOpacity = 0.5
              self.layer.shadowRadius = 5.0
              self.layer.masksToBounds = false
    }
    func removeView(tag: Int) {
        subviews.forEach { (view) in
            if view.tag == tag {
                view.removeFromSuperview()
            }
        }
    }
    func changeTextSubView(tag: Int, newText: String) {
        subviews.forEach { (view) in
            if view.tag == tag {
                (view as? UILabel ?? UILabel()).text = newText
            }
        }
    }
    @discardableResult
    public func withBackground(color: UIColor) -> UIView {
        backgroundColor = color
        return self
    }
    @discardableResult
    public func withBackground(image: UIImage, contentMode: ContentMode = .scaleAspectFit) -> UIView {
        let imageView = UIImageView(image: image.withRenderingMode(.alwaysOriginal))
        imageView.contentMode = contentMode
        self.addSubview(imageView)
        imageView.edgeTo(self)
        return self
    }
    
    @discardableResult
    public func addStatusBarCover(backgroundColor: UIColor = .white) -> UIView {
        let cover = UIView().withBackground(color: backgroundColor)
        addSubview(cover)
        
        cover.translatesAutoresizingMaskIntoConstraints = false
        
        cover.topAnchor.constraint(equalTo: topAnchor).isActive = true
        cover.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        cover.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        cover.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        
        return self
    }
    @discardableResult
    open func withSize(_ size: CGSize) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
        return self
    }
    
    @discardableResult
    open func withHeight(_ height: CGFloat) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
    @discardableResult
    open func withWidth(_ width: CGFloat) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        return self
    }
    
}
extension UITextField{
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}
extension UIImageView {
    func changeColor(color: UIColor = chataDrawerTextColorPrimary) -> UIImageView {
        let newImg: UIImageView = self
        newImg.image = newImg.image?.withRenderingMode(.alwaysTemplate)
        newImg.tintColor = color
        return newImg
    }
}
extension UIStackView{
    func getSide(dist: Distribution = .fillEqually,
                       spacing: CGFloat = 8,
                       axis: NSLayoutConstraint.Axis = .horizontal
                       
    ){
        self.axis = axis
        self.distribution  = dist
        self.alignment = UIStackView.Alignment.center
        self.spacing = spacing
    }
}
extension UILabel {
    func setSize(_ size: CGFloat = 16, _ bold: Bool = false) {
        font = !bold ? UIFont.systemFont(ofSize: size) : UIFont.boldSystemFont(ofSize: size)
    }
}
