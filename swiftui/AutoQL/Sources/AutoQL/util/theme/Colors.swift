//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 26/01/22.
//

import SwiftUI
let dark = DataConfiguration.instance.themeConfigObj.theme == "dark"
var qlAccentColor = Color.init(hex: "26a7df")
var qlColorWhite = Color.init(hex: "ffffff")
var qlBackgroundColorPrimary = dark ? Color.init(hex: "3B3F46") : Color.init(hex: "ffffff")
var qlBackgroundColorSecondary = dark ? Color.init(hex: "20252A") : Color.init(hex: "F1F3F5")
var qlBackgroundColorTertiary = dark ? Color.init(hex: "292929") : Color.init(hex: "cccccc")
var qlBorderColor = dark ? Color.init(hex: "53565c") : Color.init(hex: "e6e6e6")
var qlHoverColor = dark ? Color.init(hex: "4a4f56") : Color.init(hex: "ececec")
var qlTextColorPrimary = dark ? Color.init(hex: "ffffff") : Color.init(hex: "5d5d5d")
var qlTextColorPlaceholder = dark ? Color.init(hex: "ffffff9c") : Color.init(hex: "000000")
var qlHighlightColor = dark ? Color.init(hex: "ffffff") : Color.init(hex: "000")
var qlDangerColor = dark ? Color.init(hex: "ff584e") : Color.init(hex: "ca0b00")
var qlWarningColor = dark ? Color.init(hex: "ffcc00") : Color.init(hex: "ffcc00")
var qlSuccessColor = dark ? Color.init(hex: "2aca4d") : Color.init(hex: "2aca4d")
func reloadColors() {
    let dark = DataConfiguration.instance.themeConfigObj.theme == "dark"
    qlBackgroundColorPrimary = Color.init(hex: dark ? "3B3F46" : "ffffff")
    qlBackgroundColorSecondary = Color.init(hex: dark ? "20252A" : "F1F3F5")
    qlBackgroundColorTertiary = Color.init(hex: dark ? "292929" : "cccccc")
    qlBorderColor = Color.init(hex: dark ? "53565c" : "e6e6e6")
    qlHoverColor = Color.init(hex: dark ? "4a4f56" : "ececec")
    qlTextColorPrimary = Color.init(hex: dark ? "ffffff" : "5d5d5d")
    qlTextColorPlaceholder = Color.init(hex: dark ? "ffffff9c" : "000000")
    qlHighlightColor = Color.init(hex: dark ? "ffffff" : "000")
    qlDangerColor = Color.init(hex: dark ? "ff584e" : "ca0b00")
    qlWarningColor = Color.init(hex: dark ? "ffcc00" : "ffcc00")
    qlSuccessColor = Color.init(hex: dark ? "2aca4d" : "2aca4d")
    print("lc")
}
struct QLColors {
    static var dark = true
    static var qlBackgroundColorPrimary = dark ? "3B3F46" : "ffffff"
    static var qlBackgroundColorSecondary = Color.init(hex: dark ? "20252A" : "F1F3F5")
    static var qlBackgroundColorTertiary = Color.init(hex: dark ? "292929" : "cccccc")
    static var qlBorderColor = Color.init(hex: dark ? "53565c" : "e6e6e6")
    static var qlHoverColor = Color.init(hex: dark ? "4a4f56" : "ececec")
    static var qlTextColorPrimary = Color.init(hex: dark ? "ffffff" : "5d5d5d")
    static var qlTextColorPlaceholder = Color.init(hex: dark ? "ffffff" : "000000")
    static var qlHighlightColor = Color.init(hex: dark ? "ffffff" : "000")
    static var qlDangerColor = Color.init(hex: dark ? "ff584e" : "ca0b00")
    static var qlWarningColor = Color.init(hex: dark ? "ffcc00" : "ffcc00")
    static var qlSuccessColor = Color.init(hex: dark ? "2aca4d" : "2aca4d")
}
    
