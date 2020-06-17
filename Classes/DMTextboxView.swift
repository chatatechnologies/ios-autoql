//
//  TextboxView.swift
//  chata
//
//  Created by Vicente Rincon on 21/02/20.
//

import Foundation
import Speech
protocol TextboxViewDelegate: class {
    func sendText(_ text: String, _ safe: Bool)
    func updateAutocomplete(_ queries: [String], _ hidden: Bool)
}
class TextboxView: UIView {
    var isMic = true
    let textbox = UITextField()
    let btnSend = UIButton()
    var image = UIImage()
    let autoCompleteTable = UITableView()
    weak var delegate: TextboxViewDelegate?
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    func loadConfig() {
        let size: CGFloat = 40.0
        btnSend.backgroundColor = chataDrawerAccentColor
        btnSend.addTarget(self, action: #selector(actionSend), for: .touchUpInside)
        btnSend.addTarget(self, action: #selector(actionMicrophoneStart), for: .touchDown)
        //btnSend.addTarget(self, action: #selector(actionMicrophoneStop), for: .touchUpInside)
        self.addSubview(btnSend)
        let padding: CGFloat = -8
        btnSend.edgeTo(self, safeArea: .rightCenterY, height: size, padding:padding)
        btnSend.circle(size)
        changeButton()
        textbox.borderRadius()
        textbox.keyboardAppearance = dark ? .dark : .light
        textbox.addDoneButtonOnKeyboard()
        textbox.attributedPlaceholder = NSAttributedString(string: DataConfig.inputPlaceholder,
                                                           attributes: [NSAttributedString.Key.foregroundColor: chataDrawerMessengerTextColorPrimary])
        textbox.textColor = chataDrawerTextColorPrimary
        textbox.addTarget(self, action: #selector(actionTyping), for: .editingChanged)
        textbox.setLeftPaddingPoints(10)
        self.addSubview(textbox)
        textbox.edgeTo(self, safeArea: .leftCenterY, height: size, btnSend, padding: padding)
    }
    @objc func actionTyping() {
        changeButton()
        let query = self.textbox.text ?? ""
        if DataConfig.autoQLConfigObj.enableAutocomplete {
            ChataServices().getQueries(query: query) { (queries) in
                self.delegate?.updateAutocomplete(queries, query.isEmpty)
                //self.autoCompleteView.updateTable()
            }
        }
        // self.textbox.text?.isEmpty ?? true ? autoCompleteView.removeFromSuperview() : nil
    }
    @objc func actionSend() {
        let query = self.textbox.text ?? ""
        if isMic {
            stopRecording()
            btnSend.backgroundColor = chataDrawerAccentColor
        }
        if query != "" {
            delegate?.sendText(query, true)
        }
        // self.textbox.text?.isEmpty ?? true ? autoCompleteView.removeFromSuperview() : nil
    }
    @objc func actionMicrophoneStart() {
        isTypingMic = true
        if isMic {
            loadRecord(textbox: textbox)
            btnSend.backgroundColor = .red
        }
        // self.textbox.text?.isEmpty ?? true ? autoCompleteView.removeFromSuperview() : nil
    }
    func changeButton() {
        let emptyInput = self.textbox.text?.isEmpty ?? true
        isMic = emptyInput && DataConfig.enableVoiceRecord
        if !DataConfig.enableVoiceRecord{
            btnSend.isEnabled = !emptyInput
        }
        let imageStr = isMic ? "icMic.png" : "icSend.png"
        image = UIImage(named: imageStr, in: Bundle(for: type(of: self)), compatibleWith: nil)!
        btnSend.setImage(image, for: .normal)
    }
    override func didMoveToSuperview() {
        loadConfig()
    }
}
extension TextboxView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Example this is a large text for test the application with this have a large text"
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.minimumScaleFactor = 0.7
        return cell
    }
}
