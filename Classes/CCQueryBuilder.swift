//
//  CCQueryBuilder.swift
//  chata
//
//  Created by Vicente Rincon on 28/08/20.
//

import Foundation
protocol QueryBuilderViewDelegate: class {
    func updateSize(numQBOptions: Int, index: Int)
    func callTips(text: String)
}
class QueryBuilderView: UIView, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    let lblMain = UILabel()
    let tbMain = UITableView()
    let vwSecond = UIView()
    let tbSecond = UITableView()
    let lblInfo = UITextView()
    var dataQB: [QueryBuilderModel] = []
    var dataSelection: [String] = []
    weak var delegate: ChatViewDelegate?
    weak var delegateQB: QueryBuilderViewDelegate?
    var selectSection = -1
    var selectOption = -1
    var titleFooter = "Use 💡Explore Queries to further explore the possibilities"
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        start()
    }
    func start() {
        self.backgroundColor = chataDrawerBackgroundColorPrimary
        tbMain.bounces = false
        tbSecond.bounces = false
        tbSecond.backgroundColor = .clear
        tbMain.allowsSelection = true
        tbMain.isUserInteractionEnabled = true
        tbMain.delaysContentTouches = false
        tbSecond.allowsSelection = true
        tbSecond.isUserInteractionEnabled = true
        let txt = self.loadText(key: "dm1")
        lblMain.setConfig(text: txt,
                          textColor: chataDrawerTextColorPrimary,
                          align: .left)
        addSubview(lblMain)
        lblMain.edgeTo(self, safeArea: .topHeight, height: 30, padding: 8)
        addSubview(lblInfo)
        lblInfo.edgeTo(self, safeArea: .bottomHeight, height: 60, padding: 8)
        addSubview(tbMain)
        tbMain.edgeTo(self, safeArea: .fullPadding, lblMain, lblInfo, padding: 16)
        tbMain.backgroundColor = chataDrawerBackgroundColorPrimary
        lblInfo.clipsToBounds = true
        let txt2 = loadText(key: "dm2")
        titleFooter = txt2
        lblInfo.text = txt2
        lblInfo.isScrollEnabled = false
        lblInfo.bounces = false
        lblInfo.font = generalFont
        lblInfo.delegate = self
        lblInfo.backgroundColor = chataDrawerBackgroundColorPrimary
        lblInfo.textColor = chataDrawerTextColorPrimary
        refererToQueryTips()
        addSubview(vwSecond)
        vwSecond.edgeTo(tbMain, safeArea: .none)
        vwSecond.isHidden = true
        vwSecond.backgroundColor = chataDrawerBackgroundColorPrimary
        let button = UIButton()
        let image = UIImage(named: "icArrowLeft.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
        let image2 = image?.resizeT(maxWidthHeight: 30)
        button.setImage(image2, for: .normal)
        button.setImage(button.imageView?.changeColor().image, for: .normal)
        button.addTarget(self, action: #selector(returnSelection), for: .touchUpInside)
        vwSecond.addSubview(button)
        button.edgeTo(vwSecond, safeArea: .widthLeft, height: 25, padding: 8 )
        vwSecond.addSubview(tbSecond)
        tbSecond.edgeTo(vwSecond, safeArea: .noneAsymetric, padding: 32, secondPadding: 0)
        tbSecond.backgroundColor = chataDrawerBackgroundColorPrimary
        loadTable()
        addNotifications()
    }
    @IBAction func returnSelection(_ sender: AnyObject){
        toggleAnimationSecond(hide: true)
        selectOption = -1
        tbMain.reloadData()
    }
    func addNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(closeModal),
                                               name: notifcloseQueryTips,
                                               object: nil)
    }
    func removeNotifications() {
        NotificationCenter.default.removeObserver(self,
                                                  name: notifcloseQueryTips,
                                                  object: nil)
    }
    @objc func closeModal() {
        lblInfo.isSelectable = true
    }
    func toggleAnimationSecond(hide: Bool = false){
        let pos: CGFloat = !hide ? 500 : 0
        let pos2: CGFloat = !hide ? 0 : 500
        self.vwSecond.transform = CGAffineTransform(translationX: pos, y: 0)
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: {
                        self.vwSecond.isHidden = hide
                        self.vwSecond.transform = CGAffineTransform(translationX: pos2, y: 0)
        }, completion: { finished in
        })
    }
    func loadTable() {
        tbMain.setConfig(dataSource: self, separate: true)
        loadData()
        tbSecond.setConfig(dataSource: self, separate: true)
    }
    func loadData() {
        loadingView(mainView: self, inView: tbMain)
        ChataServices.instance.getDataQueryBuilder { (options) in
            DispatchQueue.main.async {
                self.dataQB = options
                loadingView(mainView: self, inView: self.tbMain, false)
                self.delegateQB?.updateSize(numQBOptions: options.count, index: 0)
                self.tbMain.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == tbMain ? dataQB.count : dataSelection.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader = UIView()
        if tableView == tbSecond {
            let viewHeader = UIView()
            viewHeader.backgroundColor = chataDrawerBackgroundColorPrimary
            let lbl = UILabel()
            lbl.setConfig(text: "",
                          textColor: chataDrawerTextColorPrimary,
                          align: .left)
            lbl.textColor = chataDrawerTextColorPrimary
            if selectSection != -1 {
                lbl.text = dataQB[selectSection].topic
            }
            viewHeader.addSubview(lbl)
            let gesture = UITapGestureRecognizer(target: self, action: #selector(returnSelection))
            viewHeader.addGestureRecognizer(gesture)
            lbl.edgeTo(viewHeader, safeArea: .noneTopPadding, padding: 4)
            return viewHeader
        }
        return viewHeader
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let heightFinal: CGFloat = tableView == tbMain ? 0 : 25
        return heightFinal
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tbSecond {
            let height = getSizeText(dataSelection[indexPath.row], 400)
            return height
        }
        let heightFinal: CGFloat = tableView == tbMain ? 40 : 70
        return heightFinal
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tbMain {
            let cell = UITableViewCell()
            var imageView = UIImageView()
            cell.contentView.addSubview(imageView)
            let image = UIImage(named: "icArrowLeft.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
            let image2 = image?.resizeT(maxWidthHeight: 30)
            imageView.image = image2
            imageView = imageView.changeColor()
            imageView.edgeTo(cell.contentView, safeArea: .widthRight, height: 25, padding: 16)
            imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            cell.backgroundColor = chataDrawerBackgroundColorPrimary
            let backgroundView = UIView()
            backgroundView.backgroundColor = chataDrawerAccentColor
            cell.selectedBackgroundView = backgroundView
            cell.textLabel?.text = dataQB[indexPath.row].topic
            cell.textLabel?.font = generalFont
            cell.textLabel?.textColor = chataDrawerTextColorPrimary
            if selectSection == indexPath.row {
                cell.textLabel?.textColor = .white
                cell.backgroundColor = chataDrawerAccentColor
                imageView = imageView.changeColor(color: .white)
            }
            return cell
        } else {
            let cell = QBSecondCell()
            cell.configCell(option: dataSelection[indexPath.row])
            //cell.imageView?.flipX()
            
            
            if selectOption == indexPath.row {
                cell.backgroundColor = chataDrawerAccentColor
                cell.textLabel?.textColor = .white
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tbMain {
            let txt = self.loadText(key: "dm5")
            dataSelection = dataQB[indexPath.row].queries + ["💡 \(txt)..."]
            selectSection = indexPath.row
            toggleAnimationSecond()
            tbSecond.reloadData()
        } else {
            if indexPath.row != dataSelection.count - 1{
                let typingSend = TypingSend(text: dataSelection[indexPath.row], safe: true)
                selectOption = indexPath.row
                tbSecond.reloadData()
                NotificationCenter.default.post(name: notifTypingText,
                                                object: typingSend)
            }
            else {
                delegateQB?.callTips(text: dataQB[selectSection].topic)
            }
            
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == tbSecond {
            if selectSection != -1 {
                return dataQB[selectSection].topic
            }
        }
        return ""
    }
    func refererToQueryTips() {
        let finalColor = "#28A8E0".hexToColor()
        let msgAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor : finalColor,
            .underlineStyle: NSUnderlineStyle.double.rawValue,
            .font: generalFont
        ]
        let range = LANGUAGEDEVICE == "es" ? NSRange(location: 7, length: 20) :NSRange(location: 4, length: 17)
        let mainAttr = NSMutableAttributedString(string: "\(titleFooter)")
        mainAttr.addAttribute(.link, value: "\(0)", range: range)
        mainAttr.addAttributes(msgAttributes, range: range)
        let range2 = NSRange(location: 0, length: titleFooter.count)
        let attributedString:[NSAttributedString.Key: Any] = [
            .font: generalFont,
            .foregroundColor : chataDrawerTextColorPrimary,
        ]
        mainAttr.addAttributes(attributedString, range: range2)
        lblInfo.attributedText = mainAttr
    }
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        delegateQB?.callTips(text: "")
        return true
    }
}
struct QueryBuilderModel {
    var topic: String
    var queries: [String]
    init(
        topic: String = "",
        queries: [String] = []
    ) {
        self.topic = topic
        self.queries = queries
    }
}
extension UIView {
    /// Flip view horizontally.
    func flipX() {
        transform = CGAffineTransform(scaleX: -transform.a, y: transform.d)
    }
 }
