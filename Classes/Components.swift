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
    lblGeneral.setConfig(text: text,
                         textColor: chataDrawerTextColorPrimary,
                         align: .center)
    lblGeneral.setSize(size, bold)
    return lblGeneral
}
