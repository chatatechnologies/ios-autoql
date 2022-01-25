//
//  QTMainView.swift
//  chata
//
//  Created by Vicente Rincon on 01/09/20.
//

import Foundation
import  UIKit
protocol QTMainViewDelegate: class {
    func loadQueryTips(query: TypingSend)
}
class QTMainView: UIView, UITableViewDelegate, UITableViewDataSource {
    var tfMain = UITextField()
    let svPaginator = UIStackView()
    let vwMainScrollChat = UIScrollView()
    var vwMainChat = UIView()
    var vwTextBox = UIView()
    let tbMain = UITableView()
    let vwDefault = UIView()
    let lblDefault = UILabel()
    let btnSend = UIButton()
    var selectBtn = 1
    var btnsBase = ["←", "→"]
    var btns: [String] = []
    var Qtips: QTModel = QTModel()
    var titleDefault = ""
    weak var delegate: QTMainViewDelegate?
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .darkGray
    }
    public func show(vwFather: UIView) {
        self.center = CGPoint(x: vwFather.center.x, y: vwFather.frame.height + self.frame.height/2)
        vwFather.addSubview(self)
        self.edgeTo(vwFather, safeArea: .safe)
        UIView.animate(withDuration: 0.50, delay: 0, usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 10, options: UIView.AnimationOptions(rawValue: 0), animations: {
                        self.center = vwFather.center
                        self.loadView()
        }, completion: nil)
    }
    private func loadView() {
        loadMainChat()
        loadInput()
        loadDefaultPagination()
        loadTable()
        loadDefault()
    }
    func toogleButton(hideButton: Bool = false){
        //btnSend.isHidden = hideButton
        if !hideButton{
            reset()
        }
    }
    func reset(){
        Qtips.items = []
        self.tfMain.text = ""
        tbMain.reloadData()
        toogleView(true)
    }
    func runQuery(text: String) {
        
        let characters = text.map { $0 }
        var index = 0
        self.tfMain.text = ""
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { [weak self] timer in
            if index < text.count {
                let char = characters[index]
                self?.tfMain.text! += "\(char)"
                index += 1
            } else {
                timer.invalidate()
                self?.loadSearch(number: 1)
            }
        })
    }
    private func loadMainChat() {
        self.addSubview(vwMainScrollChat)
        vwMainScrollChat.backgroundColor = .clear
        vwMainScrollChat.edgeTo(self, safeArea: .none )
        vwMainScrollChat.addSubview(vwMainChat)
        vwMainChat.edgeTo(self, safeArea: .none)
        vwMainChat.backgroundColor = chataDrawerBackgroundColorSecondary
    }
    private func loadInput() {
        let size: CGFloat = 40.0
        let padding: CGFloat = -8
        addSubview(vwTextBox)
        vwTextBox.edgeTo(self, safeArea: .topHeight, height: 50.0, padding: 16)
        vwTextBox.addSubview(btnSend)
        btnSend.edgeTo(vwTextBox, safeArea: .rightCenterY, height: size, padding:padding)
        btnSend.backgroundColor = chataDrawerAccentColor
        btnSend.tag = 1
        btnSend.addTarget(self, action: #selector(actionSearch), for: .touchUpInside)
        let imageStr = "icSearch.png"
        let image = UIImage(named: imageStr, in: Bundle(for: type(of: self)), compatibleWith: nil)!
        btnSend.setImage(image, for: .normal)
        btnSend.circle(size)
        vwTextBox.addSubview(tfMain)
        let txtTF = loadText(key: "qt1")
        tfMain.edgeTo(vwTextBox, safeArea: .leftCenterY, height: size, btnSend, padding: padding)
        tfMain.cardView(borderRadius: 20)
        tfMain.loadInputPlace(txtTF)
        tfMain.backgroundColor = chataDrawerBackgroundColorPrimary
        tfMain.configStyle()
        tfMain.setLeftPaddingPoints(10)
    }
    private func loadTable() {
        tbMain.setConfig(dataSource: self)
        tbMain.backgroundColor = chataDrawerBackgroundColorSecondary
        vwMainChat.addSubview(tbMain)
        tbMain.edgeTo(vwMainChat, safeArea: .fullPadding, tfMain, svPaginator, padding: 8)
    }
    func loadDefaultPagination() {
        vwMainChat.addSubview(svPaginator)
        svPaginator.edgeTo(vwMainChat, safeArea: .bottomHeight, height: 50.0, padding: 16)
        svPaginator.getSide(dist: .equalCentering,spacing: 0)
    }
    func loadPagination() {
        var defaultSecond = 2
        btns = btnsBase
        svPaginator.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        if Qtips.pagination.totalPages > 4 {
            btns.insert("1", at: 1)
            
            let defaultMed: String = selectBtn == 1 || selectBtn == Qtips.pagination.totalPages ? "..." : "\(selectBtn + 1)"
            if selectBtn < Qtips.pagination.totalPages-2{
                btns.insert("\(defaultMed)", at: 2)
            } else {
                btns.insert("", at: 2)
            }
            btns.insert("\(Qtips.pagination.totalPages)", at: 3)
            if Qtips.pagination.totalPages > 6{
                if (defaultMed != "..."){
                    defaultSecond = selectBtn
                }
                btns.insert("\(defaultSecond)", at: 2)
                btns.insert("\(Qtips.pagination.totalPages - 1)", at: 4)
            }
        } else {
            for btn in 0..<Qtips.pagination.totalPages{
                let number = btn + 1
                btns.insert("\(number)", at: number)
            }
        }
        btns.enumerated().forEach { (index, titleBtn) in
            let btnGeneral = UIButton()
            var number = Int(titleBtn) ?? -1
            if titleBtn == "" {
                number = 0
            }
            var finalIndex = number
            if number == -1 {
                if titleBtn == "..."{
                    finalIndex = btns.count - 1
                } else if index == 0 || index == (btns.count - 1){
                    finalIndex = index
                }
            }
            btnGeneral.setConfig(text: titleBtn,
                                 backgroundColor: .clear,
                                 textColor: chataDrawerTextColorPrimary,
                                 executeIn: self,
                                 action: #selector(actionChangePage))
            btnGeneral.tag = finalIndex
            svPaginator.addArrangedSubview(btnGeneral)
            btnGeneral.edgeTo(svPaginator, safeArea: .fullStackV, height: 30, padding: 8)
        }
        loadMainBtn()
    }
    private func loadMainBtn() {
        svPaginator.subviews.enumerated().forEach { (index, view) in
            if view.tag == selectBtn{
                svPaginator.subviews[index].backgroundColor = chataDrawerAccentColor
                (svPaginator.subviews[index] as? UIButton)?.setTitleColor(.white, for: .normal)
            }
            else {
                svPaginator.subviews[index].backgroundColor = .clear
                let colorText = index == 0 || index == (svPaginator.subviews.count - 1) ? chataDrawerAccentColor : chataDrawerTextColorPrimary
                (svPaginator.subviews[index] as? UIButton)?.setTitleColor(colorText, for: .normal)
            }
        }
    }
    private func loadDefault() {
        vwMainChat.addSubview(vwDefault)
        vwDefault.edgeTo(vwMainChat, safeArea: .fullStatePaddingAll, tfMain, padding: 0)
        vwDefault.addSubview(lblDefault)
        lblDefault.edgeTo(vwDefault, safeArea: .topHeight, height: 150, padding: 16)
        let txt = loadText(key: "qt2")
        let txt2 = loadText(key: "qt3")
        let strText = titleDefault == "" ? """
        \(txt)
        
        \(txt2)
        """: titleDefault
        toogleView()
        lblDefault.setConfig(text: strText,
                             textColor: chataDrawerTextColorPrimary,
                             align: .center)
    }
    func toogleView(_ hideTable: Bool = true) {
        tbMain.isHidden = hideTable
        svPaginator.isHidden = hideTable
        vwDefault.isHidden = !hideTable
    }
    @objc func actionChangePage(sender: UIButton!) {
        if sender.tag != 0 {
            let limitMin = sender.tag == 0 ? selectBtn == 1 : false
            let limitMax = sender.tag == (btns.count - 1) ? selectBtn == Qtips.pagination.totalPages : false
            let sameBtn = selectBtn == sender.tag
            let invalidRequest = sameBtn || limitMax || limitMin
            loadSearch(number: sender.tag, pagination: btns.count > 4, sameBtn: invalidRequest)
        }
    }
    @objc func actionSearch(sender: UIButton!) {
        self.endEditing(true)
        loadSearch(number: sender.tag)
    }
    func loadSearch(number: Int, pagination: Bool = true, sameBtn: Bool = false) {
        if !sameBtn{
            selectPage(numberPage: number)
            loadMainBtn()
            let finalText = tfMain.text ?? ""
            toogleView(false)
            Qtips.items = []
            tbMain.reloadData()
            loadingView(mainView: self, inView: vwMainChat)
            QTServices.instance.getTips(txtSearch: finalText, page: selectBtn, pageSize: 7) { (qtModel) in
                self.Qtips = qtModel
                DispatchQueue.main.async {
                    if self.Qtips.items.count > 0 {
                        loadingView(mainView: self, inView: self.vwMainChat, false)
                        if pagination {
                            self.loadPagination()
                        }
                        self.tbMain.reloadData()
                    } else{
                        loadingView(mainView: self, inView: self.vwMainChat, false)
                        let txtD = self.loadText(key: "qt4")
                        self.lblDefault.text = """
                        \(txtD)
                        """
                        self.toogleView()
                    }
                }
            }
       }
    }
    func selectPage(numberPage: Int){
        let numberButton = numberPage == 0 || numberPage == (btns.count - 1)
        if numberButton {
            var sum = 0
            if numberPage == 0 {
                sum = selectBtn == 1 ? 0 : -1
            } else {
                sum = selectBtn >= Qtips.pagination.totalPages ? 0 : 1
            }
            selectBtn += sum
        } else {
            selectBtn = numberPage
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Qtips.items.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let typingSend = TypingSend(text: Qtips.items[indexPath.row], safe: true)
        delegate?.loadQueryTips(query: typingSend)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = Qtips.items[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = generalFont
        cell.contentView.backgroundColor = chataDrawerBackgroundColorSecondary
        cell.textLabel?.textColor = chataDrawerTextColorPrimary
        return cell
    }
}
struct QTModel {
    var items: [String]
    var pagination: PaginationModel
    init(
        items: [String] = [],
        pagination: PaginationModel = PaginationModel()
    ) {
        self.items = items
        self.pagination = pagination
    }
}
struct PaginationModel {
    var currentPage: Int
    var nextUrl: String
    var pageSize: Int
    var totalItems: Int
    var totalPages: Int
    init(
        currentPage: Int = 0,
        nextUrl: String = "",
        pageSize: Int = 0,
        totalItems: Int = 0,
        totalPages: Int = 0
    ) {
        self.currentPage = currentPage
        self.nextUrl = nextUrl
        self.pageSize = pageSize
        self.totalItems = totalItems
        self.totalPages = totalPages
    }
}
