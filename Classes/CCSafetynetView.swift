//
//  SafetynetView.swift
//  chata
//
//  Created by Vicente Rincon on 20/03/20.
//

import Foundation
import WebKit
class SafetynetView: UIView, UITableViewDataSource, UITableViewDelegate {
    let lbl = UILabel()
    let btnRunQuery = UIButton()
    let tbChange = UITableView()
    let vwTrasparent = UIView()
    let stack = UIStackView()
    var data: ChatComponentModel = ChatComponentModel()
    var dataSource: [String] = []
    var btnsDynamics: [UIButton] = []
    var numBtn = 0
    var finalStr = ""
    weak var delegate: ChatViewDelegate?
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func loadConfig(_ data: ChatComponentModel) {
        self.data = data
        tbChange.delegate = self
        tbChange.dataSource = self
        loadLabel()
        loadBtn()
        loadSafe()
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    func loadLabel() {
        lbl.text = data.text
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        // lbMain.backgroundColor = .yellow
        lbl.sizeToFit()
        lbl.translatesAutoresizingMaskIntoConstraints = true
        lbl.lineBreakMode = .byTruncatingTail
        lbl.textColor = chataDrawerTextColorPrimary
        //self.edgeTo(self, safeArea: .paddingTop)
        self.addSubview(lbl)
        lbl.edgeTo(self, safeArea: .topPadding, height: 60, padding: 8)
        layoutIfNeeded()
    }
    func loadSafe() {
        stack.axis = NSLayoutConstraint.Axis.vertical
        stack.distribution  = UIStackView.Distribution.fillEqually
        stack.alignment = UIStackView.Alignment.center
        stack.spacing = 0
        self.addSubview(stack)
        btnsDynamics = []
        stack.edgeTo(self, safeArea: .full, height: 0, lbl, btnRunQuery)
        let originalText = data.options[0]
        var lastPosition = 0
        let numR = Float(originalText.components(separatedBy: " ").count)
        let numRow: Float = numR / 3.0
        let numInt: Int = Int(numRow.rounded(.up))
        let numRows = numInt == 0 ? 1 : numInt
        var allStacks: [UIStackView] = []
        for _ in 0..<numRows{
            let firstStack = UIStackView()
            firstStack.getHorizontal()
            stack.addArrangedSubview(firstStack)
            firstStack.edgeTo(stack, safeArea: .fullStackHH, height: 0 , padding: 20)
            allStacks.append(firstStack)
        }
        var sumStr = 0
        for (index, change) in data.fullSuggestions.enumerated() {
            var posStack = getPos(index: index, sumStr: sumStr)
            let start = originalText.index(originalText.startIndex, offsetBy: change.start)
            let end = originalText.index(originalText.endIndex, offsetBy: change.end - originalText.count)
            let mySubstring = getRange(start: start, end: end, original: originalText)
            if change.start == lastPosition {
                generateButton(index: index, mySubstring: mySubstring, stack: allStacks[posStack])
                if (data.fullSuggestions.count - 1) == index {
                    if change.end != originalText.count{
                        let finalEnd = originalText.index(originalText.endIndex, offsetBy: 0)
                        let finalText = getRange(start: end, end: finalEnd, original: originalText)
                        let numWords = getRealNumWord(text: finalText)
                        sumStr += 1
                        posStack = getPos(index: index, sumStr: sumStr)
                        generateLabel(finalText: finalText, stack: allStacks[posStack])
                        sumStr += numWords >= 3 ? 2 : numWords == 0 ? 0 : numWords - 1
                    }
                }
            } else {
                let startFinal = originalText.index(originalText.startIndex, offsetBy: lastPosition)
                let rangeLast = startFinal..<start
                let finalW = String(originalText[rangeLast])
                let numWords = getRealNumWord(text: finalText)
                sumStr += 1
                posStack = getPos(index: index, sumStr: sumStr)
                generateLabel(finalText: finalW, stack: allStacks[posStack])
                sumStr += numWords >= 3 ? 2 : numWords == 0 ? 0 : numWords - 1
                posStack = getPos(index: index, sumStr: sumStr)
                generateButton(index: index, mySubstring: String(mySubstring), stack: allStacks[posStack])
                if (data.fullSuggestions.count - 1) == index {
                    if change.end != originalText.count{
                        let finalEnd = originalText.index(originalText.endIndex, offsetBy: 0)
                        let finalText = getRange(start: end, end: finalEnd, original: originalText)
                        let numWords = getRealNumWord(text: finalText)
                        sumStr += 1
                        posStack = getPos(index: index, sumStr: sumStr)
                        generateLabel(finalText: finalText, stack: allStacks[posStack])
                        sumStr += numWords >= 3 ? 2 : numWords == 0 ? 0 : numWords - 1
                    }
                }
            }
            lastPosition = change.end + 1
        }
        let label = UILabel()
        label.text = data.text
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
    private func generateButton(index: Int, mySubstring: String, stack: UIStackView) {
        btnsDynamics.append(UIButton())
        btnsDynamics[index].tag = index
        //btnsDynamics[index].cardView()
        let image = UIImage(named: "icDoubleArrow.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
        let image2 = image?.resizeT(maxWidthHeight: 20)
        btnsDynamics[index].setImage(image2, for: .normal)
        btnsDynamics[index].semanticContentAttribute = .forceRightToLeft
        btnsDynamics[index].contentMode = .scaleAspectFit
        btnsDynamics[index].titleLabel?.adjustsFontSizeToFitWidth = true
        btnsDynamics[index].titleLabel?.minimumScaleFactor = 0.5
        btnsDynamics[index].setTitle(mySubstring, for: .normal)
        btnsDynamics[index].setTitleColor(chataDrawerBlue, for: .normal)
        stack.addArrangedSubview(btnsDynamics[index])
        btnsDynamics[index].addTarget(self, action: #selector(openOptions), for: .touchUpInside)
        btnsDynamics[index].edgeTo(stack, safeArea: .fullStackV, height: 0, padding: 10 )
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
    @IBAction private func openOptions(_ sender: AnyObject){
        addTrasparentView(button: sender as? UIButton ?? UIButton())
    }
    @objc func removeTransparentView() {
        for element in self.subviews {
            if let viewWithTag = element.viewWithTag(-2) {
                viewWithTag.removeFromSuperview()
            }
            if let viewWithTag = element.viewWithTag(-1) {
                viewWithTag.removeFromSuperview()
            }
        }
    }
    private func addTrasparentView(button: UIButton){
        vwTrasparent.tag = -1
        //self.addSubview(vwTrasparent)
        //vwTrasparent.edgeTo(self, safeArea: .none)
        dataSource = []
        numBtn = button.tag
        let list = data.fullSuggestions[button.tag].suggestionList + [button.titleLabel?.text ?? ""]
        dataSource = list
        tbChange.reloadData()
        vwTrasparent.backgroundColor = chataDrawerBorderColor.withAlphaComponent(0.5)
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        vwTrasparent.addGestureRecognizer(tapgesture)
        //adaptar Vista centrada
        tbChange.tag = -2
        tbChange.backgroundColor = .black
        self.addSubview(tbChange)
        //tbChange.cardView()
        tbChange.edgeTo(button, safeArea: .dropDown, height: 40, padding: 8)
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector())
    }
    func loadBtn() {
        let image = UIImage(named: "icPlay.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
        let image2 = image?.resizeT(maxWidthHeight: 20)
        btnRunQuery.setImage(image2, for: .normal)
        btnRunQuery.imageView?.contentMode = .scaleAspectFit
        btnRunQuery.setTitle("Run Query", for: .normal)
        btnRunQuery.setTitleColor(chataDrawerTextColorPrimary, for: .normal)
        btnRunQuery.addTarget(self, action: #selector(runQuery), for: .touchUpInside)
        btnRunQuery.cardView()
        self.addSubview(btnRunQuery)
        btnRunQuery.edgeTo(self, safeArea: .bottomPadding, height: 30, padding: 8)
    }
    @objc func runQuery(sender: UIButton!) {
        var text = ""
        for firstLevel in stack.subviews {
            for secondLevel in firstLevel.subviews {
                let label = secondLevel as? UILabel
                let btn = secondLevel as? UIButton
                text += label != nil ? ((label?.text ?? "") + " ") : (btn?.titleLabel?.text ?? "") + " "
            }
        }
        text = text.replace(target: "  ", withString: " ")
        if text.last == " " {
            text = String(text.dropLast())
        }
        delegate?.sendText(text, false)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        //cell.cardView()
        cell.backgroundColor = chataDrawerBackgroundColor.withAlphaComponent(0.9)
        cell.textLabel?.text = dataSource[indexPath.row]
        cell.textLabel?.textColor = chataDrawerTextColorPrimary
        cell.textLabel?.textAlignment = .center
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let text = dataSource[indexPath.row]
        btnsDynamics[numBtn].setTitle(text, for: .normal)
        removeTransparentView()
    }
}
