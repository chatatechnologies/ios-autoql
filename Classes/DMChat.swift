//
//  Chat.swift
//  chata
//
//  Created by Vicente Rincon on 14/02/20.
//

import Foundation
import UIKit
public class Chat: UIView, TextboxViewDelegate, ChatViewDelegate, QBTipsDelegate {
    let svButtons = UIStackView()
    let vwMainScrollChat = UIScrollView()
    var vwMainChat = UIView()
    let vwWaterMark = WaterMarkView()
    let vwTextBox = TextboxView()
    let vwDataMessenger = ChatView()
    let vwAutoComplete = AutoCompleteView()
    weak var delegateQB: QBTipsDelegate?
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        vwAutoComplete.delegate = self
        vwTextBox.delegate = self
        self.backgroundColor = chataDrawerBackgroundColorPrimary
    }
    public func show(vwFather: UIView, query: String = "") {
        self.center = CGPoint(x: vwFather.center.x, y: vwFather.frame.height + self.frame.height/2)
        vwFather.addSubview(self)
        /*self.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeAction) )
        self.addGestureRecognizer(tap)*/
        self.edgeTo(vwFather, safeArea: .safe)
        self.edgeTo(vwFather, safeArea: .safeChatRight, padding: 30)
        UIView.animate(withDuration: 0.50, delay: 0, usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 10, options: UIView.AnimationOptions(rawValue: 0), animations: {
                        self.center = vwFather.center
                        self.loadView()
        }, completion: nil)
    }
    private func loadView() {
        self.loadMainChat()
        self.loadTextBox()
        self.loadMarkWater()
        self.loadDataMessenger()
        self.loadAutoComplete()
    }
    private func loadMainChat() {
        self.addSubview(vwMainScrollChat)
        vwMainScrollChat.backgroundColor = .white
        vwMainScrollChat.edgeTo(self, safeArea: .none)
        vwMainScrollChat.addSubview(vwMainChat)
        vwMainChat.edgeTo(self, safeArea: .none)
    }
    private func loadAutoComplete() {
        self.vwMainChat.addSubview(vwAutoComplete)
        vwAutoComplete.edgeTo(self, safeArea: .bottomHeightFixPadding, height: 190.0, vwTextBox)
    }
    @objc func closeAction(sender: UITapGestureRecognizer) {
        dismiss(animated: DataConfig.clearOnClose)
    }
    @objc func buttonAction(sender: UIButton!) {
        dismiss(animated: DataConfig.clearOnClose)
    }
    public func dismiss(animated: Bool) {
        self.layoutIfNeeded()
        if animated {
            UIView.animate(withDuration: 0.50, delay: 0, usingSpringWithDamping: 1,
                           initialSpringVelocity: 10, options: UIView.AnimationOptions(rawValue: 0), animations: {
                            self.center = CGPoint(x: self.center.x,
                                                             y: self.frame.height + self.frame.height/2)
            }, completion: { (_) in
                DataConfig.clearOnClose ? self.exit() : self.saveData()
            })
        } else {
            DataConfig.clearOnClose ? self.exit() : saveData()
        }
    }
    func exit() {
        removeFromSuperview()
    }
    func saveData() {
        removeFromSuperview()
    }
    private func loadDataMessenger() {
        vwMainChat.addSubview(vwDataMessenger)
        vwDataMessenger.delegateQB = self
        vwMainChat.backgroundColor = chataDrawerBackgroundColorPrimary
        vwDataMessenger.backgroundColor = .clear
        vwDataMessenger.delegate = self
        vwDataMessenger.edgeTo(self, safeArea: .full, vwTextBox, vwWaterMark )
    }
    private func loadMarkWater() {
        vwMainChat.addSubview(vwWaterMark)
        vwWaterMark.edgeTo(self, safeArea: .bottomTop, height: 30.0, vwTextBox)
    }
    private func loadTextBox() {
        vwMainChat.addSubview(vwTextBox)
        vwTextBox.edgeTo(self, safeArea: .bottomHeight, height: 50.0, self)
        addObservers()
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.vwMainChat.frame.origin.y == 0 {
                self.vwMainChat.frame.origin.y -= keyboardSize.height
            }
        }
    }
    @objc func keyboardWillHide() {
        self.vwMainChat.frame.origin.y = 0
    }
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(receiveQuery), name: notifSendText, object: nil)
    }
    func removeObservers() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: notifSendText, object: nil)
    }
    @objc func receiveQuery(_ notification: Notification) {
        let query = notification.object as? String ?? ""
        sendText(query, true)
    }
    func sendText(_ text: String, _ safe: Bool) {
        let model = ChatComponentModel(type: .Introduction, text: text, user: true)
        vwDataMessenger.mainData.append(model)
        self.vwDataMessenger.updateTable()
        vwTextBox.tfMain.text = ""
        vwAutoComplete.isHidden = true
        self.endEditing(true)
        vwTextBox.changeButton()
        self.loadingQuery(true, async: safe)
        safe && DataConfig.autoQLConfigObj.enableQueryValidation ? loadSafety(text: text) : loadQuery(text: text)
    }
    func sendDrillDown(idQuery: String, obj: String, name: String) {
        let service = ChataServices()
        self.vwAutoComplete.isHidden = true
        self.loadingQuery(true)
        service.getDataChatDrillDown(obj: obj, idQuery: idQuery, name: name) { (component) in
            DispatchQueue.main.async {
                self.loadingQuery(false)
                var finalComponent = component
                let random = Int.random(in: 0..<1000)
                finalComponent.idQuery = idQuery+"drilldown\(random)"
                self.limitData(element: finalComponent)
            }
        }
    }
    func sendDrillDownManual(newData: [[String]], columns: [ChatTableColumn], idQuery: String) {
        let service = ChataServices.instance
        var newComponent = service.getDrillComponent(data: newData, columns: columns)
        DispatchQueue.main.async {
            self.loadingQuery(false)
            let random = Int.random(in: 0..<1000)
            newComponent.idQuery = idQuery+"drilldown\(random)"
            self.limitData(element: newComponent)
        }
    }
    private func loadSafety(text: String) {
        let service = ChataServices()
        service.getSafetynet(query: text) { (suggestion, responseMsg) in
            if suggestion.count == 0 {
                if responseMsg.contains("Error") {
                    let idQuery = UUID().uuidString
                    let finalComponent = ChatComponentModel(
                        type: .Introduction,
                        text: responseMsg,
                        user: false,
                        webView: "text",
                        idQuery: idQuery
                    )
                    self.limitData(element: finalComponent, load: true)
                } else {
                    self.loadQuery(text: text)
                }
            } else {
                let idQuery = UUID().uuidString
                let finalComponent = ChatComponentModel(
                    type: .Safetynet,
                    text: "Verify by selecting the correct term from the menu below:",
                    user: true,
                    options: [text],
                    fullSuggestions: suggestion,
                    idQuery: idQuery
                )
                self.limitData(element: finalComponent, load: true)
            }
        }
    }
    private func loadQuery(text: String) {
        DispatchQueue.main.async {
            let service = ChataServices()
            service.getDataChat(query: text) { (element) in
                DispatchQueue.main.async {
                    if element.referenceID == "1.1.430" || element.referenceID == "1.1.431" {
                        //self.loadingQuery(true)
                        if DataConfig.autoQLConfigObj.enableQuerySuggestions {
                            var finalElement = element
                            finalElement.webView = "error"
                            self.limitData(element: finalElement)
                            service.getSuggestionsQueries(query: text) { (items) in
                                var cloneElement = element
                                cloneElement.options = items
                                cloneElement.type = .Suggestion
                                self.limitData(element: cloneElement, load: true)
                            }
                        }
                        else {
                            var tt = element
                            tt.text = "the query suggestions are disabled"
                            self.limitData(element: tt)
                        }
                    } else {
                        self.limitData(element: element)
                    }
                }
            }
        }
    }
    private func loadingQuery(_ load: Bool, async: Bool = false){
        if load{
            self.isUserInteractionEnabled = false
            let imageView = UIImageView(image: nil)
            let bundle = Bundle(for: type(of: self))
            let path = bundle.path(forResource: "gifBalls", ofType: "gif")
            let url = URL(fileURLWithPath: path!)
            imageView.loadGif(url: url)
            imageView.tag = 100
            self.addSubview(imageView)
            imageView.edgeTo(self.vwDataMessenger, safeArea: .bottomSize, height: 40, padding: 10)
        } else {
            DRILLDOWNACTIVE = false
            if async {
                DispatchQueue.main.async {
                    self.isUserInteractionEnabled = true
                    self.removeView(tag: 100)
                }
            } else {
                self.isUserInteractionEnabled = true
                self.removeView(tag: 100)
            }
        }
    }
    func limitData(element: ChatComponentModel, load: Bool = false){
        loadingQuery(false, async: load)
        if self.vwDataMessenger.mainData.count < DataConfig.maxMessages {
            self.vwDataMessenger.mainData.append(element)
            self.vwDataMessenger.updateTable()
        } else {
            self.vwDataMessenger.mainData.remove(at: 2)
            self.vwDataMessenger.mainData.append(element)
            self.vwDataMessenger.updateWithLimit()
        }
    }
    func updateAutocomplete(_ queries: [String], _ hidden: Bool) {
        DispatchQueue.main.async {
           let emptyText = self.vwTextBox.tfMain.text?.isEmpty ?? false
           if !emptyText  {
                let height: CGFloat = queries.count >= 4 ? 190.0 : (CGFloat(queries.count) * 50.0)
                self.vwAutoComplete.constraints[4].constant = height
                self.vwAutoComplete.updateTable(queries: queries)
                UIView.transition(with: self.vwAutoComplete, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.vwAutoComplete.toggleHide(hidden)
                })
           } else {
                self.vwAutoComplete.toggleHide(true)
            }
        }
    }
    func delete() {
        let resetData: [ChatComponentModel] = DataConfig.authenticationObj.token == "" ? [self.vwDataMessenger.mainData[0]] : [self.vwDataMessenger.mainData[0], self.vwDataMessenger.mainData[1]]
        self.vwDataMessenger.mainData = resetData
        self.vwDataMessenger.tableView.reloadData()
    }
    func callTips(text: String) {
        delegateQB?.callTips(text: text)
    }
}
struct SideBtn {
    var imageStr: String
    var action: Selector
    var tag: Int
}
