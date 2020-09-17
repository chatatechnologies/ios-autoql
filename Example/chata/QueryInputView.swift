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
class QueryInputView: UIView, QueryInputDelegate {
    let inputQuery = QueryInput()
    let outputQuery = QueryOutput()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        // spira
        //loadTable()
    }
    func loadView() {
        inputQuery.authenticationInput = auth
        inputQuery.start(mainView: self)
        inputQuery.delegate = self
        outputQuery.authenticationOutput = auth
        outputQuery.start(mainView: self, subView: inputQuery)
    }
    func requestQuery(text: String) {
        print(text)
        outputQuery.loadComponent(text: text)
    }
    
}
