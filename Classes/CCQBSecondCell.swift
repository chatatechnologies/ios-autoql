//
//  CCQBSecondCell.swift
//  chata
//
//  Created by Vicente Rincon on 06/01/21.
//

import Foundation
class QBSecondCell : UITableViewCell{
    var lblText = UILabel()
    var imgDefault = UIImageView()
    static var identifier: String {
        return String(describing: self)
    }
    func configCell(option: String) {
        let height = getSizeText(option, 400)
        let image  = UIImage(named: "icPlay.png", in: Bundle(for: type(of: self)), compatibleWith: nil) ?? UIImage()
        let image2 = image.resizeT(maxWidthHeight: 20)
        imgDefault.image = image2
        self.addSubview(imgDefault)
        imgDefault.edgeTo(self, safeArea: .rightCenterY, height: 30, padding: -8)
        self.addSubview(lblText)
        lblText.setConfig(text: option,
                          textColor: chataDrawerTextColorPrimary,
                          align: .left)
        lblText.edgeTo(self, safeArea: .leftCenterY, height: height, imgDefault, padding: -8)
        imgDefault.isHidden = option.contains("See more...")
        textLabel?.transform = CGAffineTransform(scaleX: 1,y: 1)
        self.backgroundColor = chataDrawerBackgroundColorPrimary
    }
}
