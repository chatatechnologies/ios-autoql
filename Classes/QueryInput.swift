//
//  QueryInput.swift
//  chata
//
//  Created by Vicente Rincon on 14/09/20.
//

import Foundation
public class QueryInput: UIView {
    var placeholder: String = "Type Your Queries here"
    let tfMain = UITextField()
    let btnSend = UIButton()
    var isMic = true
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    public func start(mainView: UIView, align: String = "top") {
        self.backgroundColor = .black
        let finalAlign: DViewSafeArea = align == "top" ? .topPadding : .bottomPadding
        mainView.addSubview(self)
        self.edgeTo(mainView, safeArea: finalAlign, height: 60 )
        generateComponents()
    }
    private func generateComponents() {
        let size: CGFloat = 40.0
        let padding: CGFloat = -8
        btnSend.backgroundColor = chataDrawerAccentColor
        //btnSend.addTarget(self, action: #selector(actionSend), for: .touchUpInside)
        //btnSend.addTarget(self, action: #selector(actionMicrophoneStart), for: .touchDown)
        //btnSend.addTarget(self, action: #selector(actionMicrophoneStop), for: .touchUpInside)
        self.addSubview(btnSend)
        btnSend.edgeTo(self, safeArea: .rightCenterY, height: size, padding:padding)
        btnSend.circle(size)
        changeButton()
        let tfMain = UITextField()
        tfMain.borderRadius()
        tfMain.configStyle()
        tfMain.loadInputPlace(DataConfig.inputPlaceholder)
        tfMain.addTarget(self, action: #selector(actionTyping), for: .editingChanged)
        tfMain.setLeftPaddingPoints(10)
        self.addSubview(tfMain)
        tfMain.edgeTo(self, safeArea: .leftCenterY, height: size, btnSend, padding: padding)
    }
    @objc func actionTyping() {
        changeButton()
        let query = self.tfMain.text ?? ""
        if DataConfig.autoQLConfigObj.enableAutocomplete {
            ChataServices().getQueries(query: query) { (queries) in
                //self.delegate?.updateAutocomplete(queries, query.isEmpty)
                //self.autoCompleteView.updateTable()
            }
        }
        // self.textbox.text?.isEmpty ?? true ? autoCompleteView.removeFromSuperview() : nil
    }
    func changeButton() {
        let emptyInput = self.tfMain.text?.isEmpty ?? true
        isMic = emptyInput && DataConfig.enableVoiceRecord
        if !DataConfig.enableVoiceRecord{
            btnSend.isEnabled = !emptyInput
        }
        let imageStr = isMic ? "icMic.png" : "icSend.png"
        let image = UIImage(named: imageStr, in: Bundle(for: type(of: self)), compatibleWith: nil)!
        btnSend.setImage(image, for: .normal)
    }
}

