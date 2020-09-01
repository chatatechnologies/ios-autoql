//
//  QTMainView.swift
//  chata
//
//  Created by Vicente Rincon on 01/09/20.
//

import Foundation
class QTMainView: UIView {
    var vwToolbar = ToolbarView()
    var tfMain = UITextField()
    let vwMainScrollChat = UIScrollView()
    var vwMainChat = UIView()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .darkGray
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
        loadToolbar()
        loadMainChat()
        loadInput()
    }
    private func loadToolbar() {
        self.addSubview(vwToolbar)
        vwToolbar.reloadData("Explore Queries")
        vwToolbar.edgeTo(self, safeArea: .topView, height: 40.0)
    }
    private func loadMainChat() {
        self.addSubview(vwMainScrollChat)
        vwMainScrollChat.backgroundColor = .white
        vwMainScrollChat.edgeTo(self, safeArea: .fullState, vwToolbar )
        vwMainScrollChat.addSubview(vwMainChat)
        vwMainChat.edgeTo(self, safeArea: .fullState, vwToolbar)
        vwMainChat.backgroundColor = .white
    }
    private func loadInput() {
        addSubview(tfMain)
        tfMain.edgeTo(self, safeArea: .topHeight, height: 50.0, vwToolbar)
        tfMain.backgroundColor = .black
        tfMain.configStyle()
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
}
