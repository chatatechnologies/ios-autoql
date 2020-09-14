//
//  QueryInput.swift
//  chata
//
//  Created by Vicente Rincon on 14/09/20.
//

import Foundation
public class QueryInput: UIView, UITableViewDelegate, UITableViewDataSource {
    public var authenticationInput: authentication = authentication()
    public var autoQLConfig: autoQLConfigInput = autoQLConfigInput()
    public var themeConfig: themeConfigInput = themeConfigInput()
    public var isDisabled: Bool = false
    public var placeholder: String = "Type Your Queries here"
    public var showLoadingDots: Bool = true
    public var showChataIcon: Bool = true
    public var enableVoiceRecord: Bool = true
    public var autoCompletePlacement: String = "above"
    public var inputPlacement: String = "top"
    let tfMain = UITextField()
    let btnSend = UIButton()
    let tbAutoComplete = UITableView()
    var isMic = true
    var arrAutocomplete: [String] = []
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    public func start(mainView: UIView) {
        let finalAlign: DViewSafeArea = inputPlacement == "top" ? .topPadding : .bottomPadding
        mainView.addSubview(self)
        self.edgeTo(mainView, safeArea: finalAlign, height: 60 )
        DataConfig.authenticationObj = self.authenticationInput
        wsUrlDynamic = self.authenticationInput.domain
        generateComponents()
    }
    private func generateComponents() {
        let size: CGFloat = 40.0
        let padding: CGFloat = -16
        btnSend.backgroundColor = chataDrawerAccentColor
        //btnSend.addTarget(self, action: #selector(actionSend), for: .touchUpInside)
        //btnSend.addTarget(self, action: #selector(actionMicrophoneStart), for: .touchDown)
        //btnSend.addTarget(self, action: #selector(actionMicrophoneStop), for: .touchUpInside)
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
        let vwFather: UIView = UIApplication.shared.keyWindow!
        vwFather.addSubview(tbAutoComplete)
        tbAutoComplete.isHidden = true
        tbAutoComplete.edgeTo(self, safeArea: .dropDownTopView, height: 200, tfMain, padding: -16 )
    }
    func loadTextField() {
        tfMain.borderRadius()
        tfMain.configStyle()
        tfMain.loadInputPlace(placeholder)
        tfMain.addTarget(self, action: #selector(actionTyping), for: .editingChanged)
        tfMain.isEnabled = !isDisabled
        tfMain.backgroundColor = isDisabled ? chataDrawerBorderColor : chataDrawerBackgroundColor
        self.addSubview(tfMain)
        tfMain.edgeTo(self, safeArea: .leftCenterY, height: 30, btnSend, padding: -16)
        toggleIcon()
    }
    @objc func actionTyping() {
        changeButton()
        let query = self.tfMain.text ?? ""
        if autoQLConfig.enableAutocomplete && query != ""{
            ChataServices().getQueries(query: query) { (queries) in
                DispatchQueue.main.async {
                    let invalidQ = (self.tfMain.text ?? "") == ""
                    self.arrAutocomplete = invalidQ ? [] : queries
                    self.tbAutoComplete.isHidden = invalidQ
                    self.tbAutoComplete.reloadData()
                    //self.delegate?.updateAutocomplete(queries, query.isEmpty)
                    //self.autoCompleteView.updateTable()
                }
            }
        }
        // self.textbox.text?.isEmpty ?? true ? autoCompleteView.removeFromSuperview() : nil
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
        print(arrAutocomplete[indexPath.row])
        tbAutoComplete.isHidden = true
    }
    
}
public struct autoQLConfigInput {
    var enableAutocomplete: Bool
    init(enableAutocomplete: Bool = true) {
        self.enableAutocomplete = enableAutocomplete
    }
}
public struct themeConfigInput {
    var theme: String
    var accentColor: String
    init(theme: String = "light", accentColor: String = "#28a8e0") {
        self.theme = theme
        self.accentColor = accentColor
    }
}