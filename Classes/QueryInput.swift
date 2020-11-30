//
//  QueryInput.swift
//  chata
//
//  Created by Vicente Rincon on 14/09/20.
//

import Foundation
public protocol QueryInputDelegate: class {
    func requestQuery(text: String)
}
public class QueryInput: UIView, UITableViewDelegate, UITableViewDataSource {
    public var authenticationInput: authentication = authentication()
    public var autoQLConfig: autoQLConfigInput = autoQLConfigInput()
    public var themeConfig: themeConfigInput = themeConfigInput()
    public var isDisabled: Bool = false
    public var placeholder: String = "Type Your Queries here"
    public var showChataIcon: Bool = true
    public var enableVoiceRecord: Bool = true
    public var autoCompletePlacement: String = "above"
    public var inputPlacement: String = "top"
    weak public var delegate: QueryInputDelegate?
    let tfMain = UITextField()
    let btnSend = UIButton()
    let tbAutoComplete = UITableView()
    var isMic = true
    var arrAutocomplete: [String] = []
    var noFlicker = false
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    public func start(mainView: UIView) {
        let finalAlign: DViewSafeArea = inputPlacement == "top" ? .topPadding : .bottomPadding
        mainView.addSubview(self)
        self.backgroundColor = chataDrawerBackgroundColorSecondary
        self.edgeTo(mainView, safeArea: finalAlign, height: 60 )
        DataConfig.authenticationObj = self.authenticationInput
        wsUrlDynamic = self.authenticationInput.domain
        generateComponents()
    }
    private func generateComponents() {
        let size: CGFloat = 40.0
        let padding: CGFloat = -16
        btnSend.backgroundColor = chataDrawerAccentColor
        btnSend.addTarget(self, action: #selector(actionSend), for: .touchUpInside)
        btnSend.addTarget(self, action: #selector(actionMicrophoneStart), for: .touchDown)
        self.addSubview(btnSend)
        btnSend.edgeTo(self, safeArea: .rightCenterY, height: size, padding:padding)
        btnSend.circle(size)
        changeButton()
        loadTextField()
        loadTable()
        
    }
    func loadTable() {
        tbAutoComplete.delegate = self
        tbAutoComplete.dataSource = self
        tbAutoComplete.cardView()
        tbAutoComplete.bounces = false
        tbAutoComplete.clipsToBounds = true
        let vwFather: UIView = UIApplication.shared.keyWindow!
        vwFather.addSubview(tbAutoComplete)
        tbAutoComplete.isHidden = true
        tbAutoComplete.edgeTo(self, safeArea: .dropDownTopView, height: 150, tfMain, padding: -16 )
    }
    func loadTextField() {
        tfMain.borderRadius()
        tfMain.configStyle()
        tfMain.loadInputPlace(placeholder)
        tfMain.addTarget(self, action: #selector(actionTyping), for: .editingChanged)
        tfMain.isEnabled = !isDisabled
        tfMain.backgroundColor = isDisabled ? chataDrawerBorderColor : chataDrawerBackgroundColorPrimary
        self.addSubview(tfMain)
        tfMain.edgeTo(self, safeArea: .leftCenterY, height: 30, btnSend, padding: -16)
        toggleIcon()
    }
    @objc func actionTyping() {
        changeButton()
        noFlicker = true
        let query = self.tfMain.text ?? ""
        loadingView(mainView: self, inView: tbAutoComplete)
        if autoQLConfig.enableAutocomplete && query != ""{
            ChataServices().getQueries(query: query) { (queries) in
                if self.noFlicker {
                    DispatchQueue.main.async {
                        loadingView(mainView: self, inView: self.tbAutoComplete, false)
                        let invalidQ = (self.tfMain.text ?? "") == ""
                        self.arrAutocomplete = invalidQ ? [] : queries
                        self.tbAutoComplete.isHidden = invalidQ
                        self.tbAutoComplete.reloadData()
                    }
                }
            }
        }
    }
    func toggleIcon() {
        if showChataIcon {
            let image = UIImage(named: "iconProjectBubble.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
            let image2 = image?.resizeT(maxWidthHeight: 30) ?? UIImage()
            tfMain.addLeftImageTo(image: image2)
        } else {
            tfMain.setLeftPaddingPoints(20)
        }
    }
    func changeButton() {
        let emptyInput = self.tfMain.text?.isEmpty ?? true
        isMic = emptyInput && enableVoiceRecord
        if !DataConfig.enableVoiceRecord{
            btnSend.isEnabled = !emptyInput
        }
        let imageStr = isMic ? "icMic.png" : "icSend.png"
        let image = UIImage(named: imageStr, in: Bundle(for: type(of: self)), compatibleWith: nil)!
        btnSend.setImage(image, for: .normal)
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAutocomplete.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = arrAutocomplete[indexPath.row]
        return cell
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let query = arrAutocomplete[indexPath.row]
        sendQuery(query: query)
    }
    func sendQuery(query: String) {
        delegate?.requestQuery(text: query)
        tfMain.text = ""
        tbAutoComplete.isHidden = true
        noFlicker = false
        self.endEditing(true)
    }
    @objc func actionSend() {
        let query = self.tfMain.text ?? ""
        if isMic {
            stopRecording()
            btnSend.backgroundColor = chataDrawerAccentColor
        }
        if query != "" {
            sendQuery(query: query)
        }
    }
    @objc func actionMicrophoneStart() {
        isTypingMic = true
        if isMic {
            loadRecord(textbox: tfMain)
            btnSend.backgroundColor = .red
        }
    }
}
public struct autoQLConfigInput {
    public var enableAutocomplete: Bool
    init(enableAutocomplete: Bool = true) {
        self.enableAutocomplete = enableAutocomplete
    }
}
public struct themeConfigInput {
    public var theme: String
    public var accentColor: String
    public init(theme: String = "light", accentColor: String = "#28a8e0") {
        self.theme = theme
        self.accentColor = accentColor
    }
}
