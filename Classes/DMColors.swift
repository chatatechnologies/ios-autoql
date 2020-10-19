//
//  Colors.swift
//  chata
//
//  Created by Vicente Rincon on 03/03/20.
//

import Foundation
import UIKit
var dark = DataConfig.themeConfigObj.theme == "dark"
var chataDrawerAccentColor = (DataConfig.themeConfigObj.accentColor).hexToColor()
var chataDrawerBackgroundColorPrimary = (dark ? "#3B3F46" : "#ffffff").hexToColor()
var chataDrawerBackgroundColorSecondary = (dark ? "#20252A" : "#F1F3F5").hexToColor()
var chataDrawerBackgroundColorTertiary = (dark ? "#292929" : "#cccccc").hexToColor()
var chataDrawerBorderColor = (dark ? "#838383" : "#d3d3d3").hexToColor()
var chataDrawerHoverColor = (dark ? "#5A5A5A" : "#ECECEC").hexToColor()
var chataDrawerTextColorPrimary = (dark ? "#FFFFFF" :  "#5D5D5D").hexToColor()
var chataDrawerTextColorPlaceholder = (dark ? "#333333" : "#000000").hexToColor()
var chataDashboardAccentColor = (dark ? "#ffffff" : "#28A8E0").hexToColor()
var chataDrawerMessengerTextColorPrimary = (dark ? "#8f908f" : "#838383").hexToColor()
var backgroundDash = (dark ? "fafafa" : "fafafa").hexToColor()
var chataDrawerBlue = "#28a8e0".hexToColor()
var chataDrawerWebViewBackground = dark ? "#636363" : "#ffffff"
var chataDrawerWebViewText = dark ? "#FFFFFF" : "#5D5D5D"



