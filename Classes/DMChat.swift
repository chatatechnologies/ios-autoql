//
//  Chat.swift
//  chata
//
//  Created by Vicente Rincon on 14/02/20.
//

import Foundation
import UIKit
public class Chat: UIView, TextboxViewDelegate, ToolbarViewDelegate, ChatViewDelegate {
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
        //print(testVAR)
    }
    public func show() {
        let vwFather: UIView = UIApplication.shared.keyWindow!
        self.center = CGPoint(x: vwFather.center.x, y: vwFather.frame.height + self.frame.height/2)
        vwFather.addSubview(self)
        self.edgeTo(vwFather, safeArea: .safe)
        UIView.animate(withDuration: 0.50, delay: 0, usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 10, options: UIView.AnimationOptions(rawValue: 0), animations: {
                        self.center = vwFather.center
                        self.loadView()
        }, completion: nil)
    }
    private func loadView() {
        self.loadToolbar()
        self.loadMainChat()
        self.loadTextBox()
        self.loadMarkWater()
        self.loadDataMessenger()
        self.loadAutoComplete()
    }
    private func loadToolbar() {
        self.addSubview(vwToolbar)
        vwToolbar.edgeTo(self, safeArea: .topView, height: 40.0)
    }
    private func loadMainChat() {
        self.addSubview(vwMainScrollChat)
        vwMainScrollChat.backgroundColor = .white
        vwMainScrollChat.edgeTo(self, safeArea: .fullState, vwToolbar )
        vwMainScrollChat.addSubview(vwMainChat)
        vwMainChat.edgeTo(self, safeArea: .fullState, vwToolbar)
    }
    private func loadAutoComplete() {
        self.vwMainChat.addSubview(vwAutoComplete)
        vwAutoComplete.edgeTo(self, safeArea: .topY, height: 190.0, vwTextBox)
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
        //self.isHidden = true
    }
    private func loadDataMessenger() {
        vwMainChat.addSubview(vwDataMessenger)
        vwMainChat.backgroundColor = chataDrawerBackgroundColor
        vwDataMessenger.backgroundColor = .clear
        vwDataMessenger.delegate = self
        vwDataMessenger.edgeTo(self, safeArea: .full, vwToolbar, vwWaterMark )
    }
    private func loadMarkWater() {
        vwMainChat.addSubview(vwWaterMark)
        vwWaterMark.edgeTo(self, safeArea: .bottomSize, height: 30.0, vwTextBox)
    }
    private func loadTextBox() {
        vwMainChat.addSubview(vwTextBox)
        vwTextBox.edgeTo(self, safeArea: .bottomView, height: 50.0)
        addObservers()
        //let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing(_:)))
        //tap.cancelsTouchesInView = false
        //self.addGestureRecognizer(tap)
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
    }
    func removeObservers() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification, object: nil)
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
                self.vwDataMessenger.data.append(finalComponent)
                self.vwDataMessenger.updateTable()
            }
        }
    }
    private func loadQuery(text: String) {
        DispatchQueue.main.async {
            let service = ChataServices()
            self.loadingQuery(true)
            service.getDataChat(query: text) { (element) in
                DispatchQueue.main.async {
                    self.limitData(element: element)
                }
            }
        }
    }
    private func loadingQuery(_ load: Bool){
        if load{
            self.isUserInteractionEnabled = false
            let imageView = UIImageView(image: nil)
            let bundle = Bundle(for: type(of: self))
            let path = bundle.path(forResource: "gifBalls", ofType: "gif")
            let url = URL(fileURLWithPath: path!)
            imageView.loadGif(url: url)
            //let jeremyGif = UIImage.gifImageWithName("preloader")
            //let imageView = UIImageView(image: image)
            imageView.tag = 100
            self.addSubview(imageView)
            imageView.edgeTo(self.vwDataMessenger, safeArea: .bottomRight, height: 40, padding: 80)
        } else {
            DRILLDOWNACTIVE = false
            self.isUserInteractionEnabled = true
            for sub in self.subviews {
                if let viewWithTag = sub.viewWithTag(100) {
                    viewWithTag.removeFromSuperview()
                }
            }
        }
    }
    func limitData(element: ChatComponentModel){
        loadingQuery(false)
        if self.vwDataMessenger.data.count < DataConfig.maxMessages {
            self.vwDataMessenger.data.append(element)
            self.vwDataMessenger.updateTable()
        } else {
            self.vwDataMessenger.data.remove(at: 1)
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
                // print(self.vwAutoComplete.constraints[4].constant)
                self.vwAutoComplete.updateTable(queries: queries)
                UIView.transition(with: self.vwAutoComplete, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.vwAutoComplete.toggleHide(hidden)
                })
            }
        }
    }
    func delete() {
        let resetData: [ChatComponentModel] = DataConfig.authenticationObj.token == "" ? [self.vwDataMessenger.data[0]] : [self.vwDataMessenger.data[0], self.vwDataMessenger.data[1]]
        self.vwDataMessenger.data = resetData
        self.vwDataMessenger.tableView.reloadData()
    }
}
