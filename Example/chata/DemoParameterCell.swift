//
//  DemoParameterCell.swift
//  chata_Example
//
//  Created by Vicente Rincon on 05/03/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//
import Foundation
import UIKit
protocol DemoParameterCellDelegate: class {
    func toogleAction(value: Bool, key: String)
    func butonAction(key: String)
    func segmentAction(key: String, value: String)
    func chageText(name: String, value: String, key: String, color: Bool)
}
class DemoParameterCell: UITableViewCell {
    private var Data: DemoParameter = DemoParameter()
    var blueColor = "#1890ff".hexToColor()
    weak var delegate: DemoParameterCellDelegate?
    static var identifier: String {
        return String(describing: self)
    }
    func configCell(data: DemoParameter) {
        //self.textLabel = "test"
        Data = data
        genereteData(data.type)
    }
    private func genereteData(_ type: DemoParameterType) {
        switch type {
        case .toggle:
            getToggle()
        case .input:
            getInput()
        case .button:
            getButton()
        case .segment:
            getSegment()
        case .color:
            getColor()
        case .defaultCase:
            getDefault()
        }
    }
    private func getToggle() {
        let label = getLabel()
        let button = UISwitch()
        button.onTintColor = blueColor
        button.isOn = Data.value == "true"
        button.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
        //button.addTarget(self, action: #selector(executeDashboard), for: .valueChanged)
        self.contentView.addSubview(button)
        button.edgeTo(self.contentView, safeArea: .fullBottomCenter, height: 50.0, label)
    }
    @objc func switchValueDidChange(sender:UISwitch!) {
        delegate?.toogleAction(value: sender.isOn, key: Data.key)
    }
    @objc func buttonPress(sender:UIButton!) {
        delegate?.butonAction(key: Data.key)
    }
    @objc func segmentPress(sender:UISegmentedControl!) {
        let pos = sender.selectedSegmentIndex
        let item = Data.options[pos]
        delegate?.segmentAction(key: Data.key, value: item)
        //delegate?.butonAction(name: Data.label)
    }
    @objc func changeText(sender: UITextField){
        delegate?.chageText(name: "", value: sender.text ?? "", key: Data.key, color: Data.type == .color)
    }
    private func getInput() {
        let label = getLabel()
        let input = UITextField()
        input.text = Data.value
        input.autocapitalizationType = .none
        input.textColor = .black
        input.keyboardType = Data.inputType == DemoInputType.mail ? .emailAddress : .default
        input.isSecureTextEntry = Data.inputType == DemoInputType.password
        input.textAlignment = .center
        input.addTarget(self, action: #selector(changeText), for: .editingChanged)
        input.borderRadius()
        self.contentView.addSubview(input)
        input.edgeTo(self.contentView, safeArea: .fullBottom, height: 50.0, label,self.contentView, padding: 10)
    }
    private func getButton() {
        let button = UIButton()
        button.setTitle(Data.label, for: .normal)
        button.backgroundColor = blueColor
        button.addTarget(self, action: #selector(buttonPress), for: .touchUpInside)
        self.contentView.addSubview(button)
        button.edgeTo(self.contentView, safeArea: .padding)
    }
    private func getSegment() {
        let label = getLabel()
        let items = Data.options
        let indexSelect = Data.options.firstIndex(of: Data.value) ?? 0
        let segment = UISegmentedControl(items : items)
        self.contentView.addSubview(segment)
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        if #available(iOS 13.0, *) {
            segment.selectedSegmentTintColor = blueColor
        } else {
            // Fallback on earlier versions
        }
        segment.center = self.contentView.center
        segment.layer.cornerRadius = 5.0
        segment.backgroundColor = .gray
        segment.selectedSegmentIndex = indexSelect
        segment.addTarget(self, action: #selector(segmentPress), for: .valueChanged)
        segment.edgeTo(self.contentView, safeArea: .fullBottom, height: 100.0, label, self.contentView, padding: 0)
    }
    private func getColor() {
        let label = getLabel()
        let input = UITextField()
        input.text = Data.value
        input.backgroundColor = Data.value.hexToColor()
        input.textAlignment = .center
        input.textColor = .white
        input.addTarget(self, action: #selector(changeText), for: .editingChanged)
        self.contentView.addSubview(input)
        input.edgeTo(self.contentView, safeArea: .fullBottom, height: 40.0, label, self.contentView, padding: 0)
    }
    private func getDefault() {
    }
    private func getLabel() -> UILabel {
        let label = UILabel()
        label.text = Data.label
        label.textColor = .black
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        self.contentView.addSubview(label)
        label.edgeTo(self.contentView, safeArea: .topView, height: 30.0)
        return label
    }
}
