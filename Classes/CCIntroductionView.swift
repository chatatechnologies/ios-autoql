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
    func loadLabel(text: String) {
        lbl.text = text
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        // lbMain.backgroundColor = .yellow
        lbl.sizeToFit()
        lbl.translatesAutoresizingMaskIntoConstraints = true
        lbl.lineBreakMode = .byTruncatingTail
        lbl.setSize()
        //self.edgeTo(self, safeArea: .paddingTop)
        self.addSubview(lbl)
        lbl.edgeTo(self, safeArea: .padding)
        layoutIfNeeded()
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
