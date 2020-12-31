//
//  introductionView.swift
//  chata
//
//  Created by Vicente Rincon on 24/02/20.
//

import Foundation
class IntroductionView: UIView {
    let lbl = UILabel()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func loadLabel(text: String, user: Bool = false) {
        lbl.text = text
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.sizeToFit()
        lbl.translatesAutoresizingMaskIntoConstraints = true
        lbl.textColor = chataDrawerTextColorPrimary
        //lbl.lineBreakMode = .byTruncatingTail
        lbl.setSize(16, user)
        self.addSubview(lbl)
        lbl.edgeTo(self, safeArea: .padding)
        layoutIfNeeded()
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
