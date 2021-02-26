//
//  CCIntroductionInteractiveView.swift
//  chata
//
//  Created by Vicente Rincon on 30/12/20.
//

import Foundation
protocol IntroductionInteractionViewDelegate: class {
    func openReport()
}
class IntroductionInteractionView: UIView, UITextViewDelegate {
    let lblReport = UITextView()
    private var finalText = ""
    weak var delegate: IntroductionInteractionViewDelegate?
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func loadLabel(text: String, user: Bool = false) {
        self.backgroundColor = chataDrawerBackgroundColorPrimary
        finalText = text
        lblReport.text = text
        lblReport.textAlignment = .left
        lblReport.sizeToFit()
        lblReport.translatesAutoresizingMaskIntoConstraints = true
        lblReport.textColor = chataDrawerTextColorPrimary
        lblReport.clipsToBounds = true
        lblReport.isScrollEnabled = false
        lblReport.bounces = false
        lblReport.font = generalFont
        lblReport.delegate = self
        lblReport.backgroundColor = chataDrawerBackgroundColorPrimary
        lblReport.textColor = chataDrawerTextColorPrimary
        //lbl.lineBreakMode = .byTruncatingTail
        self.addSubview(lblReport)
        lblReport.edgeTo(self, safeArea: .noneTopPadding, height: 8, padding: 8)
        layoutIfNeeded()
        refererToQueryTips()
    }
    func refererToQueryTips() {
        let position = finalText.getPosition(needle: "<")
        finalText = finalText.replace(target: "<", withString: "")
        finalText = finalText.replace(target: ">", withString: "")
        let range = NSRange(location: position, length: 6)
        let finalColor = "#28A8E0".hexToColor()
        let msgAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor : finalColor,
            .underlineStyle: NSUnderlineStyle.double.rawValue,
            .font: generalFont
        ]
        let mainAttr = NSMutableAttributedString(string: "\(finalText)")
        mainAttr.addAttribute(.link, value: "\(0)", range: range)
        mainAttr.addAttributes(msgAttributes, range: range)
        let range2 = NSRange(location: 0, length: finalText.count)
        let attributedString:[NSAttributedString.Key: Any] = [
            .font: generalFont,
            .foregroundColor : chataDrawerTextColorPrimary,
        ]
        mainAttr.addAttributes(attributedString, range: range2)
        lblReport.attributedText = mainAttr
    }
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        delegate?.openReport()
        return true
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
extension String {
    func getPosition(needle: Character) -> Int {
        var pos = -1
        if let idx = self.firstIndex(of: needle) {
            pos = self.distance(from: self.startIndex, to: idx)
        }
        return pos
    }
}
