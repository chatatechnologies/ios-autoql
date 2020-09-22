//
//  MainChat.swift
//  chata
//
//  Created by Vicente Rincon on 22/09/20.
//

import Foundation
public class MainChat: UIView, ToolbarViewDelegate {
    //var vwToolbar = ToolbarView()
    var vwToolbar = ToolbarView()
    let newChat = Chat()
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeAction) )
        let tapNothing = UITapGestureRecognizer(target: self, action: #selector(nothing) )
        self.addGestureRecognizer(tap)
        self.edgeTo(vwFather, safeArea: .safe)
        self.addSubview(vwMain)
        vwMain.addGestureRecognizer(tapNothing)
        vwMain.edgeTo(self, safeArea: .safeChat, padding: 30)
        UIView.animate(withDuration: 0.50, delay: 0, usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 10, options: UIView.AnimationOptions(rawValue: 0), animations: {
                        self.center = vwFather.center
                        self.start()
                        self.newChat.show(vwFather: self.vwDynamicView, query: query)
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
        svButtons.edgeTo(self, safeArea: .safeButtons, height: 150, vwDynamicView, padding: 4)
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
    func delete() {
        print("Delete")
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
    func start() {
        loadToolbar()
        loadMainView()
        loadButtonsSide()
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
}
