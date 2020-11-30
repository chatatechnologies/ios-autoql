//
//  Components.swift
//  chata
//
//  Created by Vicente Rincon on 17/11/20.
//

import Foundation
import UIKit
func getLabel(text: String, size: CGFloat = 16, bold: Bool = false) -> UILabel {
    let lblGeneral = UILabel()
    lblGeneral.textColor = chataDrawerTextColorPrimary
    lblGeneral.setSize(size, bold)
    lblGeneral.textAlignment = .center
    lblGeneral.text = text
    lblGeneral.numberOfLines = 0
    return lblGeneral
}
