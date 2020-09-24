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
    let tfMain = UITextField()
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
        tfMain.borderRadius()
        tfMain.configStyle()
        tfMain.loadInputPlace(DataConfig.inputPlaceholder)
        tfMain.addTarget(self, action: #selector(actionTyping), for: .editingChanged)
        tfMain.setLeftPaddingPoints(10)
        self.addSubview(tfMain)
        tfMain.edgeTo(self, safeArea: .leftCenterY, height: size, btnSend, padding: padding)
        addNotifications()
    }
    @objc func actionTyping() {
        changeButton()
        let query = self.tfMain.text ?? ""
        if DataConfig.autoQLConfigObj.enableAutocomplete {
            ChataServices().getQueries(query: query) { (queries) in
                self.delegate?.updateAutocomplete(queries, query.isEmpty)
            }
        }
    }
    @objc func actionSend() {
        let query = self.tfMain.text ?? ""
        if isMic {
            stopRecording()
            btnSend.backgroundColor = chataDrawerAccentColor
        }
        if query != "" {
            delegate?.sendText(query, true)
        }
    }
    @objc func actionMicrophoneStart() {
        isTypingMic = true
        if isMic {
            loadRecord(textbox: tfMain)
            btnSend.backgroundColor = .red
        }
    }
    func addNotifications(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(receiveQuery),
                                               name: notifTypingText,
                                               object: nil)
    }
    func removeNotificatios() {
        NotificationCenter.default.removeObserver(self,
                                                  name: notifTypingText, object: nil)
    }
    @objc func receiveQuery(_ notif: Notification) {
        let query = notif.object as? TypingSend ?? TypingSend()
        self.animateAppName(query: query.text, safe: query.safe)
    }
    func changeButton() {
        let emptyInput = self.tfMain.text?.isEmpty ?? true
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
    func animateAppName(query: String, safe: Bool) {
        tfMain.text = ""
        let characters = query.map { $0 }
        var index = 0
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { [weak self] timer in
            if index < query.count {
                let char = characters[index]
                self?.tfMain.text! += "\(char)"
                index += 1
            } else {
                timer.invalidate()
                self?.delegate?.sendText(query, safe)
            }
        })
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
        cell.textLabel?.setSize()
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.minimumScaleFactor = 0.7
        return cell
    }
}
