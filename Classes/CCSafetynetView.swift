//
//  SafetynetView.swift
//  chata
//
//  Created by Vicente Rincon on 20/03/20.
//

import Foundation
import WebKit
class SafetynetView: UIView, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    let lbl = UILabel()
    let btnRunQuery = UIButton()
    let tbChange = UITableView()
    let vwTrasparent = UIView()
    let stack = UIStackView()
    var data: ChatComponentModel = ChatComponentModel()
    var dataSource: [String] = []
    var btnsDynamics: [UIButton] = []
    var originalText = ""
    var originalTexts: [String] = []
    var numBtn = 0
    var finalStr = ""
    let mainLabel = UITextView()
    var listArr: [String] = []
    var listValue: [String] = []
    var selectString: [String] = []
    var posSelected = 0
    var lastQuery = false
    let vwFather: UIView = UIApplication.shared.keyWindow!
    weak var delegate: ChatViewDelegate?
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func loadConfig(_ data: ChatComponentModel, lastQueryFinal: Bool = false) {
        lastQuery = lastQueryFinal
        self.data = data
        tbChange.delegate = self
        tbChange.dataSource = self
        loadLabel()
        loadBtn()
        loadSafeLabel()
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        mainLabel.delegate = self
    }
    func loadLabel() {
        lbl.text = data.text
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        // lbMain.backgroundColor = .yellow
        lbl.sizeToFit()
        lbl.translatesAutoresizingMaskIntoConstraints = true
        lbl.lineBreakMode = .byTruncatingTail
        lbl.setSize()
        lbl.textColor = chataDrawerTextColorPrimary
        //self.edgeTo(self, safeArea: .paddingTop)
        self.addSubview(lbl)
        lbl.edgeTo(self, safeArea: .topPadding, height: 60, padding: 8)
        layoutIfNeeded()
    }
    
    func loadSafeLabel(){
        mainLabel.backgroundColor = .clear
        mainLabel.translatesAutoresizingMaskIntoConstraints = true
        mainLabel.textColor = chataDrawerTextColorPrimary
        originalText = data.options[0]
        mainLabel.textAlignment = .center
        mainLabel.isEditable = false
        mainLabel.font = generalFont
        self.addSubview(mainLabel)
        mainLabel.isUserInteractionEnabled = true
        mainLabel.edgeTo(self, safeArea: .fullPadding, height: 0, lbl, btnRunQuery, padding: 8)
        createLabel()
    }
    func createLabel(_ first: Bool = true) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let attributedString:[NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraph,
            .font: generalFont,
            .foregroundColor : chataDrawerTextColorPrimary,
        ]
        var mainAttr = NSMutableAttributedString(string: "\(originalText)")
        var newString = ""
        for (index, change) in data.fullSuggestions.enumerated() {
            let start = originalText.index(originalText.startIndex, offsetBy: change.start)
            let end = originalText.index(originalText.endIndex, offsetBy: change.end - originalText.count)
            let originText = getRange(start: start, end: end, original: originalText)
            var mySubstring = change.suggestionList[0].text
            newString = originalText.replace(target: originText, withString: mySubstring)
            if first{
                originalTexts.append(originText)
                listArr.append(mySubstring)
                selectString.append(mySubstring)
            } else {
                let newSelect = selectString[index]
                newString = originalText.replace(target: originText, withString: newSelect)
                mySubstring = newSelect
            }
            let msgAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor : chataDrawerAccentColor,
                .underlineStyle: NSUnderlineStyle.double.rawValue,
                .font: generalFont,
                .paragraphStyle: paragraph
            ]
            
            mainAttr = NSMutableAttributedString(string: "\(newString)")
            
            let range = NSRange(location: change.start, length: mySubstring.count)
            mainAttr.addAttribute(.link, value: "\(index)", range: range)
            mainAttr.addAttributes(msgAttributes, range: range)
        }
        let range2 = NSRange(location: 0, length: newString.count)
        mainAttr.addAttributes(attributedString, range: range2)
        mainLabel.attributedText = mainAttr
    }
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        listArr.enumerated().forEach { (index, list) in
            if URL.absoluteString == "\(index)"{
                addTrasparentViewLabel(labelText: list, pos: index)
                posSelected = index
            }
        }
        return true
    }
    private func getRealNumWord(text: String) -> Int {
        var numWords = text.components(separatedBy: " ")
        if let index = numWords.firstIndex(of: "") {
            numWords.remove(at: index)
        }
        return numWords.count
    }
    private func getPos(index: Int, sumStr: Int) -> Int {
        let posStackFloat: Float = (Float(index) + Float(sumStr)) / 3.0
        let posStack: Int = Int(posStackFloat.rounded(.down))
        return posStack
    }
    private func getRange(start: String.Index, end: String.Index, original: String) -> String {
        let rangeLast = start..<end
        let finalText = String(original[rangeLast])
        //finalText.replace(target: " ", withString: "")
        return finalText
    }
    private func generateLabel(finalText: String, stack: UIStackView){
        let label = UILabel()
        //label.cardView()
        label.textColor = chataDrawerTextColorPrimary
        label.text = String(finalText)
        label.textAlignment = .center
        stack.addArrangedSubview(label)
        label.edgeTo(stack, safeArea: .fullStackV, height: 0, padding: 10 )
    }
    @objc func removeTransparentView() {
        for element in vwFather.subviews {
        //for element in self.superview!.superview!.superview!.superview!.subviews {
            if let viewWithTag = element.viewWithTag(-2) {
                viewWithTag.removeFromSuperview()
            }
            if let viewWithTag = element.viewWithTag(-1) {
                viewWithTag.removeFromSuperview()
            }
        }
    }
    private func addTrasparentViewLabel(labelText: String, pos: Int){
        vwTrasparent.tag = -1
        tbChange.cardView()
        dataSource = []
        let originalTerm = "\(originalTexts[pos]) (Original Term)"
        let list = data.fullSuggestions[pos].suggestionList.map({ (data) -> String in
            let text = data.valueLabel
            return "\(data.text) (\(text))"
            
        }) + [originalTerm]
        listValue = data.fullSuggestions[pos].suggestionList.map({ (data) -> String in
            return data.text
        }) + [originalTexts[pos]]
        dataSource = list
        tbChange.reloadData()
        vwTrasparent.backgroundColor = chataDrawerBorderColor.withAlphaComponent(0.5)
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        vwTrasparent.addGestureRecognizer(tapgesture)
        tbChange.tag = -2
        vwFather.addSubview(tbChange)
        let height: CGFloat = CGFloat(41 * list.count)
        tbChange.backgroundColor = .none
        tbChange.bounces = false
        tbChange.clipsToBounds = true
        tbChange.edgeTo(mainLabel, safeArea: .dropDown, height: height, padding: -24)
    }
    func loadBtn() {
        let image = UIImage(named: "icPlay.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
        let image2 = image?.resizeT(maxWidthHeight: 20)
        btnRunQuery.setImage(image2, for: .normal)
        btnRunQuery.imageView?.contentMode = .scaleAspectFit
        btnRunQuery.setTitle("Run Query", for: .normal)
        btnRunQuery.titleLabel?.font = generalFont
        btnRunQuery.setTitleColor(chataDrawerTextColorPrimary, for: .normal)
        btnRunQuery.addTarget(self, action: #selector(runQuery), for: .touchUpInside)
        btnRunQuery.cardView()
        self.addSubview(btnRunQuery)
        btnRunQuery.edgeTo(self, safeArea: .bottomPadding, height: 30, padding: 8)
    }
    @objc func runQuery(sender: UIButton!) {
        let text = mainLabel.text ?? ""
        //delegate?.sendText(text, false)
        let typingSend = TypingSend(text: text, safe: false)
        NotificationCenter.default.post(name: notifTypingText,
                                        object: typingSend)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = chataDrawerBackgroundColor.withAlphaComponent(0.9)
        cell.textLabel?.text = dataSource[indexPath.row]
        cell.textLabel?.font = generalFont
        cell.textLabel?.textColor = chataDrawerTextColorPrimary
        cell.textLabel?.textAlignment = .center
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let text = listValue[indexPath.row]
        selectString[posSelected] = text
        removeTransparentView()
        createLabel(false)
    }
}
extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        //let textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                              //(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)

        //let locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
                                                        // locationOfTouchInLabel.y - textContainerOffset.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }

}
struct TypingSend {
    var text: String
    var safe: Bool
    init(text: String = "", safe: Bool = false) {
        self.text = text
        self.safe = safe
    }
}
