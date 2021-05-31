//
//  WaterMarkView.swift
//  chata
//
//  Created by Vicente Rincon on 21/02/20.
//

import Foundation
class WaterMarkView: UIView {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    func loadConfig(){
        let lbMarkWater = UILabel()
        lbMarkWater.setConfig(text: "We run on AutoQL by Chata",
                              textColor: chataDrawerMessengerTextColorPrimary,
                              align: .center)
        self.addSubview(lbMarkWater)
        lbMarkWater.setSize()
        self.backgroundColor = chataDrawerBackgroundColorSecondary
        lbMarkWater.edgeTo(self, safeArea: .center)
        let image = UIImage(named: "icChat.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
        let imageChat = UIImageView(image: image)
        self.addSubview(imageChat.changeColor(color: chataDrawerMessengerTextColorPrimary))
        imageChat.edgeTo(self, safeArea: .leftAdjust, height: 15, lbMarkWater)
    }
    override func didMoveToSuperview() {
        loadConfig()
    }
}
