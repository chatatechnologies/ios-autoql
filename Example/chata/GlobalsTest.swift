//
//  Globals.swift
//  chata_Example
//
//  Created by Vicente Rincon on 17/09/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import chata
let token = ""
var auth = authentication(apiKey: "", domain: "", token: token)
var isIpad: Bool = false
extension UITextField {
    func setPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.rightView = paddingView
        self.leftViewMode = .always
        self.rightViewMode = .always
    }
    
}
