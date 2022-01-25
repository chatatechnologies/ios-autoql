//
//  MainChat.swift
//  chata
//
//  Created by Vicente Rincon on 22/09/20.
//

import Foundation
protocol MainChatDelegate: class {
    func callTips(text: String)
}
public class MainChat: UIView, ToolbarViewDelegate, QBTipsDelegate, QTMainViewDelegate {
    var vwToolbar = ToolbarView()
    let newChat = Chat()
    let viewNot = UIView()
    let newTips = QTMainView()
    let vwNotifications = NotificationView()
    var vwDynamicView = UIView()
    var vwMain = UIView()
    let svButtons = UIStackView()
    var csMain: DViewSafeArea = .safeChatRight
    var csTrasparent: DViewSafeArea = .safeFHRight
    var csBottoms: DViewSafeArea = .safeButtons
    var buttonAxis: NSLayoutConstraint.Axis = .vertical
    var heightButtonsStack: CGFloat = 150
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        vwToolbar.delegate = self
        let txt2 = self.loadText(key: "ws1")
        ERRORDEFAULT = txt2
    }
    public func show(query: String = "", defaultTab: Int = 0) {
        getMainChatPosition()
        let vwFather: UIView = UIApplication.shared.keyWindow!
        self.center = CGPoint(x: vwFather.center.x, y: vwFather.frame.height + self.frame.height/2)
        vwFather.addSubview(self)
        let alpha: CGFloat = DataConfig.darkenBackgroundBehind ? 0.5 : 0-0
        self.backgroundColor = UIColor.gray.withAlphaComponent(alpha)
        self.edgeTo(vwFather, safeArea: .safe)
        self.addSubview(vwMain)
        vwMain.edgeTo(self, safeArea: csMain, padding: 30)
        self.newChat.tag = 1
        self.newTips.tag = 2
        self.vwNotifications.tag = 3
        self.newTips.delegate = self
        UIView.animate(withDuration: 0.50, delay: 0, usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 10, options: UIView.AnimationOptions(rawValue: 0), animations: {
                        self.center = vwFather.center
                        self.start(query: query, defaultTab: defaultTab)
        }, completion: nil)
    }
    func getMainChatPosition(){
        switch DataConfig.placement {
        case "right":
            csMain = .safeChatRight
            csTrasparent = .safeFHRight
            csBottoms = .safeButtons
            buttonAxis = .vertical
            heightButtonsStack = 150
        case "left":
            csMain = .safeChatLeft
            csTrasparent = .safeFHLeft
            csBottoms = .safeButtonsLeft
            buttonAxis = .vertical
            heightButtonsStack = 150
        case "top":
            csMain = .safeChatTop
            csTrasparent = .safeFHTop
            csBottoms = .safeButtonsTop
            buttonAxis = .horizontal
            heightButtonsStack = 150
        case "bottom":
            csMain = .safeChatBottom
            csTrasparent = .safeFHBottom
            csBottoms = .safeButtonsBottom
            buttonAxis = .horizontal
            heightButtonsStack = 150
        default:
            print("defaultPosition")
        }
    }
    func addNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ToogleNotification),
                                               name: notifAlert,
                                               object: nil)
    }
    @objc func closeAction(sender: UITapGestureRecognizer) {
        let vwFather: UIView = UIApplication.shared.keyWindow!
        vwFather.removeView(tag: 2)
        dismiss(animated: DataConfig.clearOnClose)
    }
    @objc func nothing(sender: UITapGestureRecognizer) {
        
    }
    public func dismiss(animated: Bool) {
        self.layoutIfNeeded()
        if animated {
            UIView.animate(withDuration: 0.50, delay: 0, usingSpringWithDamping: 1,
                           initialSpringVelocity: 10, options: UIView.AnimationOptions(rawValue: 0), animations: {
                            self.center = CGPoint(x: self.center.x,
                                                             y: self.frame.height + self.frame.height/2)
            }, completion: { (_) in
                self.exit()
            })
        } else {
            self.exit()
        }
    }
    func exit() {
        removeFromSuperview()
    }
    private func loadButtonsSide() {
        svButtons.getSide(spacing: 0, axis: buttonAxis)
        let newView = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeAction) )
        newView.addGestureRecognizer(tap)
        self.addSubview(newView)
        let referer = DataConfig.placement == "bottom" ? vwMain : vwDynamicView
        newView.edgeTo(self, safeArea: csTrasparent, referer)
        var buttons: [SideBtn] = [
            SideBtn(imageStr: "icSideChat", action: #selector(changeViewChat), tag: 1),
            SideBtn(imageStr: "icSideExplore", action: #selector(changeViewTips), tag: 2),
            SideBtn(imageStr: "icSideNotification", action: #selector(changeViewNotifications), tag: 3)
        ]
        if !DataConfig.autoQLConfigObj.enableNotifications || !DataConfig.autoQLConfigObj.enableNotificationTab{
            buttons.remove(at: 2)
        }
        if !DataConfig.autoQLConfigObj.enableExploreQueriesTab {
            buttons.remove(at: 1)
        }
        if buttons.count == 1 {
            buttons.remove(at: 0)
        }
        heightButtonsStack = 50.0 * CGFloat(buttons.count)
        for btn in buttons {
            let newButton = UIButton()
            newButton.backgroundColor = chataDrawerAccentColor
            let image = UIImage(named: btn.imageStr, in: Bundle(for: type(of: self)), compatibleWith: nil)!
            let image2 = image.resizeT(maxWidthHeight: 30)
            newButton.setImage(image2, for: .normal)
            newButton.tag = btn.tag
            newButton.addTarget(self, action: btn.action, for: .touchUpInside)
            newButton.setImage(newButton.imageView?.changeColor(color: UIColor.white).image, for: .normal)
            newButton.imageView?.contentMode = .scaleAspectFit
            svButtons.addArrangedSubview(newButton)
        }
        newView.addSubview(svButtons)
        svButtons.edgeTo(newView, safeArea: csBottoms, height: heightButtonsStack, referer, padding: 0)
    }
    @objc func changeViewChat() {
        loadChat()
    }
    @objc func changeViewTips() {
        loadTips(text: "")
    }
    @objc func changeViewNotifications() {
        loadSelectBtn(tag: 3)
        vwToolbar.updateTitle(text: "Notifications", noDeleteBtn: true)
        NotificationServices.instance.readNotification()
    }
    func loadChat() {
        loadSelectBtn(tag: 1)
        vwToolbar.updateTitle(text: DataConfig.title)
    }
    func loadTips(text: String){
        loadSelectBtn(tag: 2)
        let txt = self.loadText(key: "eq1")
        
        
        vwToolbar.updateTitle(text: txt, noDeleteBtn: true)
        if text != "" {
            newTips.toogleButton(hideButton: true)
            newTips.runQuery(text: text)
        } else {
            newTips.toogleButton(hideButton: false)
        }
    }
    func delete() {
        newChat.delete()
    }
}
extension MainChat {
    private func loadToolbar() {
        vwMain.addSubview(vwToolbar)
        vwToolbar.edgeTo(vwMain, safeArea: .topHeight, height: 40.0)
    }
    private func loadMainView() {
        vwDynamicView.backgroundColor = chataDrawerBackgroundColorSecondary
        vwMain.addSubview(vwDynamicView)
        vwDynamicView.edgeTo(vwMain, safeArea: .fullState, vwToolbar)
    }
    func start(query: String, defaultTab: Int = 0) {
        loadToolbar()
        loadMainView()
        loadButtonsSide()
        self.newChat.show(vwFather: self.vwDynamicView, query: query)
        self.newChat.delegateQB = self
        self.newTips.show(vwFather: self.vwDynamicView)
        self.vwNotifications.show(vwFather: self.vwDynamicView)
        loadSelectBtn(tag: 1)
        addNotifications()
        initLogin()
        if defaultTab != 0 {
            self.loadTips(text: "")
        }
    }
    func loadSelectBtn(tag: Int) {
        svButtons.subviews.forEach { (view) in
            let viewT = view as? UIButton ?? UIButton()
            if viewT.tag == tag{
                viewT.backgroundColor = chataDrawerBackgroundColorSecondary
                viewT.setImage(viewT.imageView?.changeColor().image, for: .normal)
            } else {
                viewT.backgroundColor = chataDrawerAccentColor
                viewT.setImage(viewT.imageView?.changeColor(color: UIColor.white).image, for: .normal)
            }
        }
        vwDynamicView.subviews.forEach { (view) in
            view.isHidden = tag != view.tag
        }
    }
    func callTips(text: String) {
        loadTips(text: text)
    }
    @objc func ToogleNotification(_ notification: NSNotification) {
        let valid = notification.object as? Bool ?? false
        if !valid {
            DispatchQueue.main.async {
                self.removeView(tag: 100)
            }
        } else {
            DispatchQueue.main.async {
                self.viewNot.backgroundColor = .red
                self.viewNot.tag = 100
                self.viewNot.cardView(border: true, borderRadius: 10)
                self.svButtons.subviews.forEach { (btn) in
                    let originalBtn = btn as? UIButton ?? UIButton()
                    if originalBtn.tag == 3 {
                        self.addSubview(self.viewNot)
                        self.viewNot.edgeTo(originalBtn, safeArea: .widthRight, height: 15, padding: 0, secondPadding: 10)
                    }
                }
            }
        }
    }
    func initLogin() {
        if LOGIN {
            DispatchQueue.main.async {
                if DataConfig.autoQLConfigObj.enableNotifications {
                    NotificationServices.instance.getStateNotifications(number: 0)
                    Timer.scheduledTimer(withTimeInterval: 60, repeats: true) {
                        (time) in
                        if LOGIN && DataConfig.autoQLConfigObj.enableNotifications{
                            if notificationsAttempts < 6 {
                                NotificationServices.instance.getStateNotifications(number: 0)
                            } else {
                                time.invalidate()
                            }
                        }
                        else{
                            time.invalidate()
                        }
                    }
                }
                
            }
        }
    }
    func loadQueryTips(query: TypingSend) {
        loadChat()
        NotificationCenter.default.post(name: notifTypingText,
                                        object: query)
    }
}
