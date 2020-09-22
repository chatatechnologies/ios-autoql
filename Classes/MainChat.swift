//
//  MainChat.swift
//  chata
//
//  Created by Vicente Rincon on 22/09/20.
//

import Foundation
public class MainChat: UIView {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    public func show(query: String = "") {
        let vwFather: UIView = UIApplication.shared.keyWindow!
        self.center = CGPoint(x: vwFather.center.x, y: vwFather.frame.height + self.frame.height/2)
        vwFather.addSubview(self)
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeAction) )
        self.addGestureRecognizer(tap)
        self.edgeTo(vwFather, safeArea: .safe)
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
}
