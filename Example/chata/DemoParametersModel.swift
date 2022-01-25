//
//  DemoParametersModel.swift
//  chata_Example
//
//  Created by Vicente Rincon on 05/03/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
struct DemoSectionsModel {
    var title: String
    var arrParameters: [DemoParameter]
    init(title: String = "", arrParameters: [DemoParameter] = [] ) {
        self.title = title
        self.arrParameters = arrParameters
    }
}
struct DemoParameter {
    var label: String
    var type: DemoParameterType
    var options: [String]
    var value: String
    var action: Selector?
    var key: String
    var inputType: DemoInputType
    var placeholder: String
    init(label: String = "", type: DemoParameterType = .defaultCase,
         options: [String] = [], value: String = "",
         action: Selector? = nil, key: String = "",
         inputType: DemoInputType = .normal,
         placeholder: String = "") {
        self.label = label
        self.type = type
        self.options = options
        self.value = value
        self.action = action
        self.key = key
        self.inputType = inputType
        self.placeholder = placeholder
    }
}
enum DemoParameterType {
    case toggle
    case input
    case button
    case segment
    case color
    case defaultCase
}
enum DemoInputType{
    case normal
    case mail
    case password
}
