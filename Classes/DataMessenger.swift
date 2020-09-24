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
    public var config = DataConfiguration.instance
    var colorTextPrimary: UIColor = .blue
    public convenience init( authentication: authentication, projectID: String) {
        self.init(authenticationFinal: authentication, projectIDF: projectID)
        DataConfig = config
    }
    convenience init(authenticationFinal: authentication, projectIDF: String) {
        self.init(authenticationF: authenticationFinal, projectIDFinal: projectIDF)
    }
    init(authenticationF: authentication,  projectIDFinal: String) {
        if authenticationF.token != "" && !DataConfig.demo{
            DataConfig.authenticationObj = authenticationF
            //self.authentication = authenticationF
            DataConfig.authenticationObj.token = authenticationF.token
            wsUrlDynamic = DataConfig.authenticationObj.domain
            let service = ChataServices()
            service.setProjectID(projectID: projectIDFinal)
            service.setJWT(jwt: DataConfig.authenticationObj.token)
            service.setLogin(active: true)
        }
        super.init(frame: .zero)
    }
    public override func didMoveToSuperview() {
        self.loadStyle()
        self.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
    }
    private func loadStyle() {
        let width: CGFloat = 50
        let height: CGFloat = 50
        self.withWidth(width)
        self.withHeight(height)
        self.configBubble()
        self.loadStyleBtn(width: width)
    }
    public func movePosition() {
        let type = DViewSafeArea.withLabel(DataConfig.placement) ?? DViewSafeArea.rightMiddle
        self.removeAllConstraints()
        self.edgeTo(father2, safeArea: type)
        self.layoutIfNeeded()
    }
    public func changeColor() {
        reloadColors()
        self.backgroundColor = chataDrawerBackgroundColor
    }
    public func login(body: [String: Any] = [:], completion: @escaping CompletionChatSuccess){
        let service = ChataServices()
        service.login(parameters: body,  completion: { (success) in
            if success {
                service.getJWTResponse(parameters: body) { (success) in
                    DispatchQueue.main.async {
                        let nameImage = "iconProject" + self.getImageProject(url: wsUrlDynamic)
                        if nameImage == "iconProjectBubble"{
                            self.configBubble()
                        } else{
                            self.backgroundColor = chataDrawerBackgroundColor
                            let image = UIImage(named: "\(nameImage).png", in: Bundle(for: type(of: self)), compatibleWith: nil)
                            self.setImage(image, for: .normal)
                        }
                        LOGIN = true
                        NotificationServices.instance.getNotifications(number: 0)
                        DispatchQueue.main.async {
                            Timer.scheduledTimer(withTimeInterval: 30, repeats: true) {
                                (time) in
                                if LOGIN{
                                    NotificationServices.instance.getNotifications(number: 0)
                                }
                                else{
                                    time.invalidate()
                                }
                            }
                        }
                    }
                    completion(success)
                }
            } else {
                completion(false)
            }
        })
    }
    private func getImageProject(url: String) -> String  {
        switch url {
        case let str where str.contains("stripe"):
            return "Stripe"
        case let str where str.contains("qbo"):
            return "QBO"
        case let str where str.contains("hotel"):
            return "Hotel"
        case let str where str.contains("restaurant"):
            return "Restaurant"
        case let str where str.contains("spira"):
            return "Spira"
        case let str where str.contains("xero"):
            return "Xero"
        default:
            return "Bubble"
        }
        
    }
    private func configBubble(){
        self.backgroundColor = chataDrawerAccentColor
        let image = UIImage(named: "iconProjectBubble.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
        self.setImage(image, for: .normal)
        self.setImage(self.imageView?.changeColor(color: .white).image, for: .normal)
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
            let posX = loc.x > (self.father2.frame.width / 2) ? safeXLeft : safeXRight
            let Test = CGPoint(x: posX, y: loc.y)
            if sender.state == .began {
            } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
                UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                    self.center = Test
                })
            } else {
                let location = sender.location(in: father2) // get pan location
                self.center = location // set button to where finger is
            }
        }
    }
    public func createChat() {
        /*let chat = Chat(frame: father2.frame)
        chat.show()*/
        let mainChat = MainChat()
        mainChat.show()
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
