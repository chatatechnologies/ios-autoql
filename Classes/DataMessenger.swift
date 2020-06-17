//
//  ChataDrawer.swift
//  chata
//
//  Created by Vicente Rincon on 13/02/20.
//
import Foundation
import UIKit
public class DataMessenger: UIButton {
    var buttonCenter = CGPoint()
    var father2 = UIView()
    //var authentication: authentication
    public var config = DataConfiguration.instance
    var colorTextPrimary: UIColor = .blue
    public convenience init( authentication: authentication, projectID: String) {
        //super.init(frame: frame)
        self.init(authenticationFinal: authentication, projectIDF: projectID)
        DataConfig = config
        //DataConfig.setValue(value: "MX", "dataFormatting", "currencyCode")
        //let isVisible = DataConfig.getDataValue("dataFormatting", "currencyCode")
    }
    convenience init(authenticationFinal: authentication, projectIDF: String) {
        self.init(authenticationF: authenticationFinal, projectIDFinal: projectIDF)
    }
    init(authenticationF: authentication,  projectIDFinal: String) {
        DataConfig.authenticationObj = authenticationF
        //self.authentication = authenticationF
        DataConfig.authenticationObj.token = authenticationF.token
        wsUrlDynamic = DataConfig.authenticationObj.domain
        let service = ChataServices()
        service.setProjectID(projectID: projectIDFinal)
        service.setJWT(jwt: DataConfig.authenticationObj.token)
        service.setLogin(active: true)
        super.init(frame: .zero)
    }
    public override func didMoveToSuperview() {
        self.loadStyle()
        self.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    private func loadStyle() {
        let width: CGFloat = 50
        let height: CGFloat = 50
        self.withWidth(width)
        self.withHeight(height)
        self.backgroundColor = chataDrawerBackgroundColor
        //let jeremyGif = UIImage.gifImageWithName("preloader")
        let image = UIImage(named: "iconBubble.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
        self.setImage(image, for: .normal)
        self.loadStyleBtn(width: width)
    }
    public func movePosition(){
        let type = DViewSafeArea.withLabel(DataConfig.placement) ?? DViewSafeArea.rightMiddle
        self.removeAllConstraints()
        self.edgeTo(father2, safeArea: type)
        self.layoutIfNeeded()
    }
    public func changeColor(){
        reloadColors()
        self.backgroundColor = chataDrawerBackgroundColor
    }
    public func login(body: [String: Any] = [:], completion: @escaping CompletionChatSuccess){
        
        /*if let finalAuth = auth as? authentication{
            
        }*/
        let service = ChataServices()
        service.login(parameters: body,  completion: { (success) in
            // si hay problemas utilizar instance
            service.getJWT(parameters: body) { (success) in
                completion(success)
            }
        })
    }
    public func logout(completion: @escaping CompletionChatSuccess){
        let service = ChataServices()
        service.logout { (success) in
            completion(success)
        }
    }
    public func show(_ vwFather: UIView) {
        self.isHidden = !DataConfig.isVisible
        vwFather.addSubview(self)
        father2 = vwFather
        let type = DViewSafeArea.withLabel(DataConfig.placement) ?? DViewSafeArea.rightMiddle
        self.edgeTo(father2, safeArea: type)
        let pan = UIPanGestureRecognizer(target: self, action:  #selector(buttonAction2))
        self.addGestureRecognizer(pan)
    }
    @objc func buttonAction(sender: UIButton!) {
        self.father2.endEditing(true)
        createChat()
    }
    @objc func buttonAction2(sender: UIPanGestureRecognizer!) {
        let loc = sender.location(in: father2)
        let safeXLeft = self.father2.frame.width - self.frame.width / 2
        let safeXRight = self.frame.width / 2
        if loc.x > safeXRight
            && loc.x < (safeXLeft)
            && loc.y > ((self.frame.height / 2) + 30)
            && loc.y < (self.father2.frame.height - self.frame.height / 2)
        {
            //self.center = loc
            let posX = loc.x > (self.father2.frame.width / 2) ? safeXLeft : safeXRight
            let Test = CGPoint(x: posX, y: loc.y)
            if sender.state == .began {
                //buttonCenter = Test // store old button center
            } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
                UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                    self.center = Test
                })
                //self.center = buttonCenter // restore button center
            } else {
                let location = sender.location(in: father2) // get pan location
                self.center = location // set button to where finger is
            }
        }
    }
    public func createChat() {
        let chat = Chat(frame: father2.frame)
        chat.show()
        //chat.loadAnimation(vwFather: father2)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension UIView {

    public func removeAllConstraints() {
        var _superview = self.superview

        while let superview = _superview {
            for constraint in superview.constraints {

                if let first = constraint.firstItem as? UIView, first == self {
                    superview.removeConstraint(constraint)
                }

                if let second = constraint.secondItem as? UIView, second == self {
                    superview.removeConstraint(constraint)
                }
            }

            _superview = superview.superview
        }

        self.removeConstraints(self.constraints)
        self.translatesAutoresizingMaskIntoConstraints = true
    }
}
