//
//  MainChat.swift
//  chata
//
//  Created by Vicente Rincon on 22/09/20.
//

import Foundation
protocol MainChatDelegate: class {
    func callTips()
}
public class MainChat: UIView, ToolbarViewDelegate, QBTipsDelegate {
    //var vwToolbar = ToolbarView()
    var vwToolbar = ToolbarView()
    let newChat = Chat()
    let viewNot = UIView()
    let newTips = QTMainView()
    var vwDynamicView = UIView()
    var vwMain = UIView()
    let svButtons = UIStackView()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        vwToolbar.delegate = self
    }
    public func show(query: String = "") {
        let vwFather: UIView = UIApplication.shared.keyWindow!
        self.center = CGPoint(x: vwFather.center.x, y: vwFather.frame.height + self.frame.height/2)
        vwFather.addSubview(self)
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        //self.addGestureRecognizer(tap)
        self.edgeTo(vwFather, safeArea: .safe)
        self.addSubview(vwMain)
        vwMain.edgeTo(self, safeArea: .safeChat, padding: 30)
        self.newChat.tag = 1
        self.newTips.tag = 2
        UIView.animate(withDuration: 0.50, delay: 0, usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 10, options: UIView.AnimationOptions(rawValue: 0), animations: {
                        self.center = vwFather.center
                        self.start(query: query)
        }, completion: nil)
        //let newChat = Chat()
        //newChat.show(vwFather: self, query: query)
        /*self.addSubview(vwMain)
        vwMain.backgroundColor = .black
        vwMain.edgeTo(vwFather, safeArea: .safeChat, padding: 30)
        UIView.animate(withDuration: 0.50, delay: 0, usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 10, options: UIView.AnimationOptions(rawValue: 0), animations: {
                        self.center = vwFather.center
                        self.loadView()
        }, completion: nil)*/
    }
    func addNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ToogleNotification),
                                               name: notifAlert,
                                               object: nil)
    }
    @objc func closeAction(sender: UITapGestureRecognizer) {
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
        svButtons.getSide(spacing: 0, axis: .vertical)
        let newView = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeAction) )
        newView.addGestureRecognizer(tap)
        self.addSubview(newView)
        newView.edgeTo(self, safeArea: .safeFH, vwDynamicView)
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
        newView.addSubview(svButtons)
        svButtons.edgeTo(self, safeArea: .safeButtons, height: 150, vwDynamicView, padding: 4)
    }
    @objc func changeViewChat() {
        loadSelectBtn(tag: 1)
        vwToolbar.updateTitle(text: DataConfig.title)
    }
    @objc func changeViewTips() {
        loadTips()
    }
    @objc func changeViewNotifications() {
        loadSelectBtn(tag: 3)
        vwToolbar.updateTitle(text: "Notifications", noDeleteBtn: true)
    }
    func loadTips(){
        loadSelectBtn(tag: 2)
        vwToolbar.updateTitle(text: "Explore Queries", noDeleteBtn: true)
    }
    func delete() {
        newChat.delete()
    }
}
extension MainChat {
    private func loadToolbar() {
        vwMain.addSubview(vwToolbar)
        vwToolbar.edgeTo(vwMain, safeArea: .topView, height: 40.0)
    }
    private func loadMainView() {
        vwDynamicView.backgroundColor = chataDrawerBackgroundColor
        vwMain.addSubview(vwDynamicView)
        vwDynamicView.edgeTo(vwMain, safeArea: .fullState, vwToolbar)
    }
    func start(query: String) {
        loadToolbar()
        loadMainView()
        loadButtonsSide()
        self.newChat.show(vwFather: self.vwDynamicView, query: query)
        self.newChat.delegateQB = self
        self.newTips.show(vwFather: self.vwDynamicView)
        loadSelectBtn(tag: 1)
        addNotifications()
    }
    func loadSelectBtn(tag: Int) {
        svButtons.subviews.forEach { (view) in
            let viewT = view as? UIButton ?? UIButton()
            if viewT.tag == tag{
                viewT.backgroundColor = .white
                viewT.setImage(viewT.imageView?.changeColor().image, for: .normal)
                //view.isHidden = false
            } else {
                viewT.backgroundColor = chataDrawerAccentColor
                viewT.setImage(viewT.imageView?.changeColor(color: UIColor.white).image, for: .normal)
                //view.isHidden = true
            }
        }
        vwDynamicView.subviews.forEach { (view) in
            view.isHidden = tag != view.tag
        }
    }
    func callTips() {
        loadTips()
    }
    @objc func ToogleNotification(_ notification: NSNotification) {
        let valid = notification.object as? Bool ?? false
        if !valid {
            self.removeView(tag: 100)
        } else {
            viewNot.backgroundColor = .red
            viewNot.tag = 100
            viewNot.cardView(border: true, borderRadius: 10)
            svButtons.subviews.forEach { (btn) in
                let originalBtn = btn as? UIButton ?? UIButton()
                if originalBtn.tag == 3 {
                    self.addSubview(viewNot)
                    viewNot.edgeTo(originalBtn, safeArea: .widthRightY, height: 15, padding: 0)
                }
            }
        }
    }
}