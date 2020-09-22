//
//  Chat.swift
//  chata
//
//  Created by Vicente Rincon on 14/02/20.
//

import Foundation
import UIKit
public class Chat: UIView, TextboxViewDelegate, ToolbarViewDelegate, ChatViewDelegate {
    var vwMain = UIView()
    let svButtons = UIStackView()
    var vwToolbar = ToolbarView()
    let vwMainScrollChat = UIScrollView()
    var vwMainChat = UIView()
    let vwWaterMark = WaterMarkView()
    let vwTextBox = TextboxView()
    let vwDataMessenger = ChatView()
    let vwAutoComplete = AutoCompleteView()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        vwAutoComplete.delegate = self
        vwTextBox.delegate = self
        vwToolbar.delegate = self
        self.backgroundColor = chataDrawerBackgroundColor
    }
    public func show(query: String = "") {
        let vwFather: UIView = UIApplication.shared.keyWindow!
        self.center = CGPoint(x: vwFather.center.x, y: vwFather.frame.height + self.frame.height/2)
        vwFather.addSubview(self)
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeAction) )
        self.addGestureRecognizer(tap)
        self.edgeTo(vwFather, safeArea: .safe)
        self.addSubview(vwMain)
        vwMain.backgroundColor = .black
        vwMain.edgeTo(vwFather, safeArea: .safeChat, padding: 30)
        UIView.animate(withDuration: 0.50, delay: 0, usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 10, options: UIView.AnimationOptions(rawValue: 0), animations: {
                        self.center = vwFather.center
                        self.loadView()
        }, completion: nil)
    }
    private func loadButtonsSide() {
        svButtons.getSide(spacing: 0, axis: .vertical)
        let buttons: [SideBtn] = [
            SideBtn(imageStr: "icSideChat", action: #selector(changeViewChat), tag: 1),
            SideBtn(imageStr: "icSideExplore", action: #selector(changeViewTips), tag: 2),
            SideBtn(imageStr: "icSideNotification", action: #selector(changeViewNotifications), tag: 3)
        ]
        for btn in buttons {
            let newButton = UIButton()
            newButton.backgroundColor = chataDrawerAccentColor
            let image = UIImage(named: btn.imageStr, in: Bundle(for: type(of: self)), compatibleWith: nil)!
            let image2 = image.resizeT(maxWidthHeight: 25)
            newButton.setImage(image2, for: .normal)
            newButton.tag = btn.tag
            newButton.addTarget(self, action: btn.action, for: .touchUpInside)
            newButton.setImage(newButton.imageView?.changeColor(color: UIColor.white).image, for: .normal)
            svButtons.addArrangedSubview(newButton)
        }
        self.addSubview(svButtons)
        svButtons.edgeTo(self, safeArea: .safeButtons, height: 150, vwMain, padding: 4)
        loadSelectBtn(tag: 1)
    }
    @objc func changeViewChat() {
        loadSelectBtn(tag: 1)
        vwToolbar.updateTitle(text: DataConfig.title)
    }
    @objc func changeViewTips() {
        loadSelectBtn(tag: 2)
        vwToolbar.updateTitle(text: "Explore Queries", noDeleteBtn: true)
    }
    @objc func changeViewNotifications() {
        loadSelectBtn(tag: 3)
        vwToolbar.updateTitle(text: "Notifications", noDeleteBtn: true)
    }
    func loadSelectBtn(tag: Int) {
        svButtons.subviews.forEach { (view) in
            let viewT = view as? UIButton ?? UIButton()
            if viewT.tag == tag{
                viewT.backgroundColor = .white
                viewT.setImage(viewT.imageView?.changeColor().image, for: .normal)
            } else {
                viewT.backgroundColor = chataDrawerAccentColor
                viewT.setImage(viewT.imageView?.changeColor(color: UIColor.white).image, for: .normal)
            }
        }
    }
    private func loadView() {
        self.loadToolbar()
        self.loadMainChat()
        self.loadTextBox()
        self.loadMarkWater()
        self.loadDataMessenger()
        self.loadAutoComplete()
        self.loadButtonsSide()
    }
    private func loadToolbar() {
        vwMain.addSubview(vwToolbar)
        vwToolbar.edgeTo(vwMain, safeArea: .topView, height: 40.0)
    }
    private func loadMainChat() {
        vwMain.addSubview(vwMainScrollChat)
        vwMainScrollChat.backgroundColor = .white
        vwMainScrollChat.edgeTo(vwMain, safeArea: .fullState, vwToolbar )
        vwMainScrollChat.addSubview(vwMainChat)
        vwMainChat.edgeTo(vwMain, safeArea: .fullState, vwToolbar)
    }
    private func loadAutoComplete() {
        self.vwMainChat.addSubview(vwAutoComplete)
        vwAutoComplete.edgeTo(vwMain, safeArea: .topY, height: 190.0, vwTextBox)
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
        vwMainChat.backgroundColor = chataDrawerBackgroundColor
        vwDataMessenger.backgroundColor = .clear
        vwDataMessenger.delegate = self
        vwDataMessenger.edgeTo(vwMain, safeArea: .full, vwToolbar, vwWaterMark )
    }
    private func loadMarkWater() {
        vwMainChat.addSubview(vwWaterMark)
        vwWaterMark.edgeTo(vwMain, safeArea: .bottomSize, height: 30.0, vwTextBox)
    }
    private func loadTextBox() {
        vwMainChat.addSubview(vwTextBox)
        vwTextBox.edgeTo(vwMain, safeArea: .bottomView, height: 50.0)
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
        vwDataMessenger.data.append(model)
        //vwDataMessenger.tableView.reloadData()
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
                self.limitData(element: component)
            }
        }
    }
    func sendDrillDownManual(newData: [[String]], columns: [ChatTableColumn]) {
        let service = ChataServices.instance
        let newComponent = service.getDrillComponent(data: newData, columns: columns)
        DispatchQueue.main.async {
            self.loadingQuery(false)
            self.limitData(element: newComponent)
        }
    }
    private func loadSafety(text: String) {
        let service = ChataServices()
        service.getSafetynet(query: text) { (suggestion) in
            if suggestion.count == 0 {
                self.loadQuery(text: text)
            } else {
                let finalComponent = ChatComponentModel(
                    type: .Safetynet,
                    text: "Verify by selecting the correct term from the menu below:",
                    user: true,
                    webView: "",
                    numRow: 0,
                    options: [text],
                    fullSuggestions: suggestion
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
                    self.limitData(element: element)
                    if element.referenceID == "1.1.430" || element.referenceID == "1.1.431" {
                        self.loadingQuery(true)
                        service.getSuggestionsQueries(query: text) { (items) in
                            var cloneElement = element
                            cloneElement.options = items
                            cloneElement.type = .Suggestion
                            self.limitData(element: cloneElement, load: true)
                        }
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
            vwMain.addSubview(imageView)
            imageView.edgeTo(self.vwDataMessenger, safeArea: .bottomRight, height: 40, padding: 80)
        } else {
            DRILLDOWNACTIVE = false
            if async {
                DispatchQueue.main.async {
                    self.isUserInteractionEnabled = true
                    self.vwMain.removeView(tag: 100)
                }
            } else {
                self.isUserInteractionEnabled = true
                self.vwMain.removeView(tag: 100)
            }
        }
    }
    func limitData(element: ChatComponentModel, load: Bool = false){
        loadingQuery(false, async: load)
        if self.vwDataMessenger.data.count < DataConfig.maxMessages {
            self.vwDataMessenger.data.append(element)
            self.vwDataMessenger.updateTable()
        } else {
            self.vwDataMessenger.data.remove(at: 2)
            self.vwDataMessenger.data.append(element)
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
        let resetData: [ChatComponentModel] = DataConfig.authenticationObj.token == "" ? [self.vwDataMessenger.data[0]] : [self.vwDataMessenger.data[0], self.vwDataMessenger.data[1]]
        self.vwDataMessenger.data = resetData
        self.vwDataMessenger.tableView.reloadData()
    }
}
struct SideBtn {
    var imageStr: String
    var action: Selector
    var tag: Int
}
