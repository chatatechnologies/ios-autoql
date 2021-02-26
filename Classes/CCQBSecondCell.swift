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
        let image  = UIImage(named: "icPlay.png", in: Bundle(for: type(of: self)), compatibleWith: nil) ?? UIImage()
        let image2 = image.resizeT(maxWidthHeight: 20)
        imgDefault.image = image2
        self.addSubview(imgDefault)
        imgDefault.edgeTo(self, safeArea: .rightCenterY, height: 30, padding: -8)
        self.addSubview(lblText)
        lblText.text = option
        lblText.textAlignment = .left
        lblText.font = generalFont
        lblText.textColor = chataDrawerTextColorPrimary
        lblText.edgeTo(self, safeArea: .leftCenterY, height: 30, imgDefault, padding: -8)
        /*let backgroundView = UIView()
        backgroundView.backgroundColor = chataDrawerAccentColor
        selectedBackgroundView = backgroundView
        backgroundColor = chataDrawerBackgroundColorPrimary
        textLabel?.text = "J"
        textLabel?.backgroundColor = .yellow
        textLabel?.font = generalFont
        textLabel?.textColor = chataDrawerTextColorPrimary
        imageView?.image = image2
        imageView?.backgroundColor = .red
        //textLabel?.textAlignment = .right
        contentView.transform = CGAffineTransform(scaleX: 1,y: 1)*/
        
        //imageView?.transform = CGAffineTransform(scaleX: -1,y: 1)
        textLabel?.transform = CGAffineTransform(scaleX: 1,y: 1)
        self.backgroundColor = chataDrawerBackgroundColorPrimary
    }
}
