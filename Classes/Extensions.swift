//
//  DScrollView+.swift
//  TestingEasyUIScrollView
//
//  Created by Alex Nagy on 07/06/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import UIKit
var isTypingMic = false
public enum DViewSafeArea: String, CaseIterable {
    case topView, elementToRight, leading, trailing, bottomView, vertical, horizontal, all, none, noneLeft, widthLeft , widthRight, widthRightY, none2, full, fullStack, fullLimit, fullWidth, leftBottom, rightTop, rightBottom, fullStatePaddingAll, rightCenterY, safe , safeChat, safeChatLeft, safeChatTop, safeChatBottom, safeButtons, safeButtonsLeft, safeButtonsTop, safeButtonsBottom, safeFH, safeFHLeft, safeFHTop, safeFHBottom, leftCenterY, fullState, fullState2, bottomSize, center, leftAdjust, padding, paddingTop, rightMiddle = "right", leftMiddle = "left", topMiddle = "top", bottomMiddle = "bottom", fullBottom, fullBottomCenter, paddingTopLeft, paddingTopRight, modal, modal2, modal2Right, secondTop, bottomPaddingtoTop, bottomPaddingtoTopHalf, fullPadding, topHeight, topHeightPadding, fullStatePaddingTop, dropDownBottomHeight, dropDownBottomHeightLeft,
    topY, nonePadding, fullStackH, topPadding, fullStatePadding, bottomPadding, fullStackV, fullStackHH, dropDown, dropDownTop, dropDownTopView, dropDownTopHeight,dropDownTopHeightLeft, centerSize, bottomRight, centerSizeUp
    static func withLabel(_ str: String) -> DViewSafeArea? {
        return self.allCases.first {
            "\($0.description)" == str
        }
    }
    var description: String {
        return self.rawValue
    }
}
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
        //format.currencyCode = "$"
        format.minimumFractionDigits = DataConfig.dataFormattingObj.quantityDecimals
        //format.locale = Locale.init(identifier: "en_us")
        let money: Double = Double(self) ?? 0.0
        let dolar = format.string(from: NSNumber(value: money)) ?? "0"
        return "\(String(describing: dolar))"
    }
    func toPercent() -> String {
        let format = NumberFormatter()
        //format.currencyCode = "$"
        //format.minimumFractionDigits = DataMessenger.dataFormattingObj.quantityDecimals
        format.minimumFractionDigits = 2
        //format.locale = Locale.init(identifier: "en_us")
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
        self.layer.borderColor = chataDrawerBackgroundColor.cgColor
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
        
        //var image = UIImage(named: imageStr, in: Bundle(for: type(of: self)), compatibleWith: nil)
        //image = image?.resizeT(maxWidthHeight: Double(size))
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
    public func edgeTo(_ view: UIView,
                       safeArea: DViewSafeArea = .none,
                       height: CGFloat = 0,
                       _ top: UIView = UIView(),
                       _ bottom: UIView = UIView(),
                       padding: CGFloat = -8) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        
        switch safeArea {
        case .topView:
            topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .topPadding:
            topAnchor.constraint(equalTo: view.topAnchor, constant: padding).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .elementToRight:
            topAnchor.constraint(equalTo: view.topAnchor, constant: padding).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
            trailingAnchor.constraint(equalTo: top.leadingAnchor, constant: -padding).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .bottomPaddingtoTop:
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding).isActive = true
            leadingAnchor.constraint(equalTo: top.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: top.trailingAnchor).isActive = true
            topAnchor.constraint(equalTo: top.bottomAnchor, constant: padding).isActive = true
        case .bottomPaddingtoTopHalf:
            //let finalHeight = (view.frame.height / 2) - top.frame.height
            //heightAnchor.constraint(equalToConstant: finalHeight).isActive = true
            
            heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.38).isActive = true
            //bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding).isActive = true
            leadingAnchor.constraint(equalTo: top.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: top.trailingAnchor).isActive = true
            topAnchor.constraint(equalTo: top.bottomAnchor, constant: padding).isActive = true
        case .bottomPadding:
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .bottomRight:
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
            widthAnchor.constraint(equalToConstant: padding).isActive = true
        case .leading:
            topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        case .trailing:
            topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        case .bottomView:
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .bottomSize:
            bottomAnchor.constraint(equalTo: top.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .vertical:
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        case .horizontal:
            topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        case .all:
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        case .none:
            topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        case .noneLeft:
            topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        case .widthLeft:
            topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
            widthAnchor.constraint(equalToConstant: height).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .widthRight:
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
            widthAnchor.constraint(equalToConstant: height).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
            centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        case .widthRightY:
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
            widthAnchor.constraint(equalToConstant: height).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
            centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -10).isActive = true
        case .safe:
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        case .safeButtons:
            centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            //topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
            trailingAnchor.constraint(equalTo: top.leadingAnchor, constant: 1).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .safeButtonsLeft:
            centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            //topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: top.trailingAnchor, constant: -1).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
            //bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        case .safeButtonsTop:
            centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            //topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            topAnchor.constraint(equalTo: top.safeAreaLayoutGuide.bottomAnchor, constant: -1).isActive = true
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding).isActive = true
            widthAnchor.constraint(equalToConstant: height).isActive = true
        case .safeButtonsBottom:
            centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            //topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            topAnchor.constraint(equalTo: view.topAnchor, constant: padding).isActive = true
            bottomAnchor.constraint(equalTo: top.topAnchor, constant: 1).isActive = true
            widthAnchor.constraint(equalToConstant: height).isActive = true
        case .safeFH:
            //centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: top.leadingAnchor).isActive = true
            //heightAnchor.constraint(equalToConstant: height).isActive = true
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        case .safeFHLeft:
        //centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: top.trailingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            //heightAnchor.constraint(equalToConstant: height).isActive = true
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        case .safeFHTop:
        //centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            topAnchor.constraint(equalTo: top.bottomAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            //heightAnchor.constraint(equalToConstant: height).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        case .safeFHBottom:
        //centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            //heightAnchor.constraint(equalToConstant: height).isActive = true
            bottomAnchor.constraint(equalTo: top.topAnchor).isActive = true
        case .safeChat:
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        case .safeChatLeft:
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        case .safeChatTop:
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding).isActive = true
        case .safeChatBottom:
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        case .nonePadding:
            topAnchor.constraint(equalTo: view.topAnchor, constant: padding).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: height).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -height).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -height).isActive = true
        case .none2:
            topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        case .modal2:
            topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
            widthAnchor.constraint(equalToConstant: padding).isActive = true
            //trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
            //bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        case .modal2Right:
            topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
            rightAnchor.constraint(equalTo: top.rightAnchor, constant: 5).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
            widthAnchor.constraint(equalToConstant: padding).isActive = true
        //trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        //bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        case .modal:
            //topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
            centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            //heightAnchor.constraint(equalToConstant: height).isActive = true
            //widthAnchor.constraint(equalToConstant: 200).isActive = true
        //trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        //bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        case .padding:
            //topAnchor.constraint(equalTo: view.topAnchor, constant: 2).isActive = true
            centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
            //bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 2).isActive = true
        case .paddingTop:
            topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        case .paddingTopLeft:
            topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
            trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -10).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        case .paddingTopRight:
            topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
            leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 58).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        case .secondTop:
            topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
            widthAnchor.constraint(equalToConstant: height * 4).isActive = true
            centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true            
        case .fullState:
            topAnchor.constraint(equalTo: top.bottomAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        case .fullStatePadding:
            topAnchor.constraint(equalTo: top.bottomAnchor, constant: padding).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding).isActive = true
        case .fullStatePaddingAll:
            topAnchor.constraint(equalTo: top.bottomAnchor, constant: padding).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding).isActive = true
        case .fullStatePaddingTop:
            topAnchor.constraint(equalTo: top.bottomAnchor, constant: padding).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        case .fullState2:
            topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            heightAnchor.constraint(equalToConstant: 300.0).isActive = true
        case .full:
            topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: bottom.topAnchor).isActive = true
        case .fullStack:
            topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .fullPadding:
            topAnchor.constraint(equalTo: top.bottomAnchor).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: bottom.topAnchor).isActive = true
        case .fullLimit:
            topAnchor.constraint(equalTo: top.bottomAnchor).isActive = true
            leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor).isActive = true
            trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: bottom.topAnchor).isActive = true
        case .fullBottom:
            topAnchor.constraint(equalTo: top.bottomAnchor, constant: padding).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding).isActive = true
            widthAnchor.constraint(equalToConstant: height).isActive = true
            centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        case .fullBottomCenter:
            topAnchor.constraint(equalTo: top.bottomAnchor, constant: 10).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
            widthAnchor.constraint(equalToConstant: height).isActive = true
            centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        case .topY:
            bottomAnchor.constraint(equalTo: top.topAnchor, constant: 0).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .topHeight:
            topAnchor.constraint(equalTo: top.bottomAnchor, constant: padding).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .topHeightPadding:
            topAnchor.constraint(equalTo: top.bottomAnchor, constant: padding / 2).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .fullWidth:
            leadingAnchor.constraint(equalTo: top.trailingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: bottom.leadingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .leftBottom:
            leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
            widthAnchor.constraint(equalToConstant: height).isActive = true
        case .leftCenterY:
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -padding).isActive = true
            centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            heightAnchor.constraint(equalTo: top.heightAnchor).isActive = true
            trailingAnchor.constraint(equalTo: top.leadingAnchor, constant: padding).isActive = true
        case .rightCenterY:
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: padding).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
            widthAnchor.constraint(equalToConstant: height).isActive = true
            centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        case .rightBottom:
            trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
            widthAnchor.constraint(equalToConstant: height).isActive = true
        case .rightTop:
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
            topAnchor.constraint(equalTo: view.topAnchor, constant: padding).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
            widthAnchor.constraint(equalToConstant: height).isActive = true
        case .center:
            centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        case .centerSize:
            centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
            widthAnchor.constraint(equalToConstant: padding).isActive = true
        case .centerSizeUp:
            centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -130).isActive = true
            centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
            widthAnchor.constraint(equalToConstant: padding).isActive = true
        case .leftAdjust:
            centerYAnchor.constraint(equalTo: top.centerYAnchor).isActive = true
            trailingAnchor.constraint(equalTo: top.leadingAnchor, constant: -8).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
            widthAnchor.constraint(equalToConstant: height).isActive = true
        case .rightMiddle:
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            self.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            self.heightAnchor.constraint(equalToConstant: 50).isActive = true
            self.widthAnchor.constraint(equalToConstant: 50).isActive = true
        case .leftMiddle:
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            self.heightAnchor.constraint(equalToConstant: 50).isActive = true
            self.widthAnchor.constraint(equalToConstant: 50).isActive = true
            self.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        case .topMiddle:
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            self.heightAnchor.constraint(equalToConstant: 50).isActive = true
            self.widthAnchor.constraint(equalToConstant: 50).isActive = true
        case .bottomMiddle:
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            self.heightAnchor.constraint(equalToConstant: 50).isActive = true
            self.widthAnchor.constraint(equalToConstant: 50).isActive = true
        case .fullStackH:
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .fullStackHH:
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .fullStackV:
            topAnchor.constraint(equalTo: view.topAnchor, constant: padding).isActive = true
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding).isActive = true
            //leadingAnchor.constraint(equalTo: top.trailingAnchor, constant: padding).isActive = true
            widthAnchor.constraint(equalToConstant: height).isActive = true
            centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        case .dropDown:
            topAnchor.constraint(equalTo: view.bottomAnchor, constant: padding).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -padding).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: padding).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .dropDownTop:
            topAnchor.constraint(equalTo: top.bottomAnchor, constant: 1).isActive = true
            leadingAnchor.constraint(equalTo: top.leadingAnchor, constant: -padding).isActive = true
            trailingAnchor.constraint(equalTo: top.trailingAnchor, constant: padding).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .dropDownTopView:
            topAnchor.constraint(equalTo: top.bottomAnchor, constant: 1).isActive = true
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -padding).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: padding).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .dropDownTopHeight:
            topAnchor.constraint(equalTo: top.bottomAnchor, constant: 1).isActive = true
            //leadingAnchor.constraint(equalTo: top.leadingAnchor, constant: -padding).isActive = true
            trailingAnchor.constraint(equalTo: top.trailingAnchor, constant: padding).isActive = true
            widthAnchor.constraint(equalToConstant: 250).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .dropDownTopHeightLeft:
            topAnchor.constraint(equalTo: top.bottomAnchor, constant: 1).isActive = true
            leadingAnchor.constraint(equalTo: top.leadingAnchor, constant: -padding).isActive = true
            //trailingAnchor.constraint(equalTo: top.trailingAnchor, constant: padding).isActive = true
            widthAnchor.constraint(equalToConstant: 250).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .dropDownBottomHeight:
            bottomAnchor.constraint(equalTo: top.topAnchor, constant: 1).isActive = true
            leadingAnchor.constraint(equalTo: top.leadingAnchor, constant: -padding).isActive = true
            //trailingAnchor.constraint(equalTo: top.trailingAnchor, constant: padding).isActive = true
            widthAnchor.constraint(equalToConstant: 250).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        case .dropDownBottomHeightLeft:
            bottomAnchor.constraint(equalTo: top.topAnchor, constant: 1).isActive = true
            //leadingAnchor.constraint(equalTo: top.leadingAnchor, constant: -padding).isActive = true
            trailingAnchor.constraint(equalTo: top.trailingAnchor, constant: padding).isActive = true
            widthAnchor.constraint(equalToConstant: 250).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        
        return self
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
