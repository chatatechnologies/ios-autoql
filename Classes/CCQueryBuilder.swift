//
//  CCQueryBuilder.swift
//  chata
//
//  Created by Vicente Rincon on 28/08/20.
//

import Foundation
protocol QueryBuilderViewDelegate: class {
    func updateSize(numQBOptions: Int, index: Int)
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
        lblMain.text = "Some things you can ask me:"
        addSubview(lblMain)
        lblMain.edgeTo(self, safeArea: .topPadding, height: 30, padding: 8)
        lblMain.textColor = chataDrawerTextColorPrimary
        lblMain.font = generalFont
        
        addSubview(lblInfo)
        lblInfo.edgeTo(self, safeArea: .bottomPadding, height: 50, padding: 8)
        addSubview(tbMain)
        tbMain.edgeTo(self, safeArea: .fullPadding, lblMain, lblInfo, padding: 16)
        tbMain.backgroundColor = chataDrawerBackgroundColor
        lblInfo.clipsToBounds = true
        lblInfo.text = titleFooter
        lblInfo.font = generalFont
        lblInfo.delegate = self
        lblInfo.backgroundColor = chataDrawerBackgroundColor
        lblInfo.textColor = chataDrawerTextColorPrimary
        refererToQueryTips()
        addSubview(vwSecond)
        vwSecond.edgeTo(tbMain, safeArea: .none)
        vwSecond.isHidden = true
        vwSecond.backgroundColor = chataDrawerBackgroundColor
        let button = UIButton()
        let image = UIImage(named: "icArrowLeft.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
        let image2 = image?.resizeT(maxWidthHeight: 30)
        button.setImage(image2, for: .normal)
        button.setImage(button.imageView?.changeColor().image, for: .normal)
        button.addTarget(self, action: #selector(returnSelection), for: .touchUpInside)
        vwSecond.addSubview(button)
        button.edgeTo(vwSecond, safeArea: .widthLeft, height: 25, padding: 8 )
        vwSecond.addSubview(tbSecond)
        tbSecond.edgeTo(vwSecond, safeArea: .noneLeft, padding: 32)
        tbSecond.backgroundColor = chataDrawerBackgroundColor
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
                        // Slide the views by -offset
                        self.vwSecond.isHidden = hide
                        self.vwSecond.transform = CGAffineTransform(translationX: pos2, y: 0)
                        //self.tbMain.transform = CGAffineTransform.identity

        }, completion: { finished in
            // Remove the old view from the tabbar view.
        })
    }
    func loadTable() {
        tbMain.delegate = self
        tbMain.dataSource = self
        loadData()
        tbSecond.delegate = self
        tbSecond.dataSource = self
    }
    func loadData() {
        ChataServices.instance.getDataQueryBuilder { (options) in
            self.dataQB = options
            self.delegateQB?.updateSize(numQBOptions: options.count, index: 0)
            DispatchQueue.main.async {
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
            viewHeader.backgroundColor = chataDrawerBackgroundColor
            let lbl = UILabel()
            lbl.textColor = chataDrawerTextColorPrimary
            if selectSection != -1 {
                lbl.text = dataQB[selectSection].topic
            }
            viewHeader.addSubview(lbl)
            let gesture = UITapGestureRecognizer(target: self, action: #selector(returnSelection))
            viewHeader.addGestureRecognizer(gesture)
            lbl.edgeTo(viewHeader, safeArea: .nonePadding, padding: 4)
            return viewHeader
        }
        return viewHeader
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView == tbMain ? 0 : 25
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if tableView == tbMain {
            var imageView = UIImageView()
            cell.contentView.addSubview(imageView)
            let image = UIImage(named: "icArrowLeft.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
            let image2 = image?.resizeT(maxWidthHeight: 30)
            imageView.image = image2
            imageView = imageView.changeColor()
            imageView.edgeTo(cell.contentView, safeArea: .widthRight, height: 25, padding: 16)
            imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            cell.backgroundColor = chataDrawerBackgroundColor
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
            /*let image = UIImage(named: "icArrowLeft.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
            let image2 = image?.resizeT(maxWidthHeight: 30)
            //image2.transform = image2.transform.rotated(by: .pi)
            cell.imageView?.image = image2
            cell.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi)*/
            return cell
        } else {
            let backgroundView = UIView()
            backgroundView.backgroundColor = chataDrawerAccentColor
            cell.selectedBackgroundView = backgroundView
            cell.backgroundColor = chataDrawerBackgroundColor
            cell.textLabel?.text = dataSelection[indexPath.row]
            cell.textLabel?.font = generalFont
            cell.textLabel?.textColor = chataDrawerTextColorPrimary
            if selectOption == indexPath.row {
                cell.backgroundColor = chataDrawerAccentColor
                cell.textLabel?.textColor = .white
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tbMain {
            dataSelection = dataQB[indexPath.row].queries
            selectSection = indexPath.row
            toggleAnimationSecond()
            //vwSecond.isHidden = false
            tbSecond.reloadData()
        } else {
            let typingSend = TypingSend(text: dataSelection[indexPath.row], safe: true)
            selectOption = indexPath.row
            tbSecond.reloadData()
            NotificationCenter.default.post(name: notifTypingText,
                                            object: typingSend)
            //delegate?.sendText(dataSelection[indexPath.row], true)
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
        let range = NSRange(location: 4, length: 17)
        let mainAttr = NSMutableAttributedString(string: "\(titleFooter)")
        mainAttr.addAttribute(.link, value: "\(0)", range: range)
        mainAttr.addAttributes(msgAttributes, range: range)
        let range2 = NSRange(location: 0, length: titleFooter.count + 1)
        let attributedString:[NSAttributedString.Key: Any] = [
            .font: generalFont,
            .foregroundColor : chataDrawerTextColorPrimary,
        ]
        mainAttr.addAttributes(attributedString, range: range2)
        lblInfo.attributedText = mainAttr
    }
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let tips = QTMainView(frame: self.frame)
        tips.show()
        lblInfo.isSelectable = false
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
