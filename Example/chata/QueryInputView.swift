//
//  QueryInputView.swift
//  chata_Example
//
//  Created by Vicente Rincon on 11/09/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import chata
class QueryInputView: UIView {
    let inputQuery = QueryInput()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        inputQuery.start(mainView: self, align: "topp")
        //loadTable()
    }
}
