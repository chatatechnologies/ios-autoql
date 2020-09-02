//
//  QTMainView.swift
//  chata
//
//  Created by Vicente Rincon on 01/09/20.
//

import Foundation
import  UIKit
class QTMainView: UIView, UITableViewDelegate, UITableViewDataSource {
    var vwToolbar = ToolbarView()
    var tfMain = UITextField()
    let svPaginator = UIStackView()
    let vwMainScrollChat = UIScrollView()
    var vwMainChat = UIView()
    var vwTextBox = UIView()
    let tbMain = UITableView()
    let lblDefault = UILabel()
    let btnSend = UIButton()
    var selectBtn = 1
    let btns = ["←", "1", "2", "3", "→"]
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .darkGray
        //print(testVAR)
    }
    public func show() {
        let vwFather: UIView = UIApplication.shared.keyWindow!
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
        loadToolbar()
        loadMainChat()
        loadInput()
        loadPagination()
        loadTable()
        loadDefault()
    }
    private func loadToolbar() {
        self.addSubview(vwToolbar)
        vwToolbar.reloadData("Explore Queries")
        vwToolbar.edgeTo(self, safeArea: .topView, height: 40.0)
    }
    private func loadMainChat() {
        self.addSubview(vwMainScrollChat)
        vwMainScrollChat.backgroundColor = .white
        vwMainScrollChat.edgeTo(self, safeArea: .fullState, vwToolbar )
        vwMainScrollChat.addSubview(vwMainChat)
        vwMainChat.edgeTo(self, safeArea: .fullState, vwToolbar)
        vwMainChat.backgroundColor = chataDrawerBackgroundColor
    }
    private func loadInput() {
        let size: CGFloat = 40.0
        let padding: CGFloat = -8
        addSubview(vwTextBox)
        vwTextBox.edgeTo(self, safeArea: .topHeight, height: 50.0, vwToolbar, padding: 16)
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
        tfMain.edgeTo(vwTextBox, safeArea: .leftCenterY, height: size, btnSend, padding: padding)
        //tfMain.edgeTo(self, safeArea: .topHeight, height: 50.0, vwToolbar, padding: 16)
        tfMain.cardView(borderRadius: 20)
        tfMain.loadInputPlace("Search relevant queries by topic")
        tfMain.configStyle()
        tfMain.setLeftPaddingPoints(20)
    }
    private func loadTable() {
        tbMain.delegate = self
        tbMain.dataSource = self
        tbMain.clipsToBounds = true
        tbMain.bounces = true
        tbMain.backgroundColor = chataDrawerBackgroundColor
        vwMainChat.addSubview(tbMain)
        tbMain.edgeTo(vwMainChat, safeArea: .fullPadding, tfMain, svPaginator, padding: 8)
    }
    func loadPagination() {
        vwMainChat.addSubview(svPaginator)
        svPaginator.edgeTo(vwMainChat, safeArea: .bottomPadding, height: 50.0, padding: 16)
        svPaginator.getHorizontal(dist: .equalCentering,spacing: 0)
        btns.enumerated().forEach { (index, titleBtn) in
            let btnGeneral = UIButton()
            btnGeneral.setTitle(titleBtn, for: .normal)
            btnGeneral.tag = index
            btnGeneral.circle(30)
            btnGeneral.titleLabel?.font = generalFont
            svPaginator.addArrangedSubview(btnGeneral)
            btnGeneral.addTarget(self, action: #selector(actionSearch), for: .touchUpInside)
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
        vwMainChat.addSubview(lblDefault)
        lblDefault.edgeTo(vwMainChat, safeArea: .fullStatePaddingAll, tfMain, padding: 16)
        lblDefault.text = """
        Discover what you can ask by entering a topic in the search bar above.


        Simply click on any of the returned options to run the query in Data Messenger.
        """
        lblDefault.textColor = chataDrawerTextColorPrimary
        lblDefault.numberOfLines = 0
        lblDefault.font = generalFont
        toogleView()
    }
    func toogleView(_ hideTable: Bool = true) {
        tbMain.isHidden = hideTable
        svPaginator.isHidden = hideTable
        lblDefault.isHidden = !hideTable
    }
    @objc func actionSearch(sender: UIButton!) {
        let numberButton = sender.tag == 0 || sender.tag == (btns.count - 1)
        if numberButton {
            var sum = 0
            if sender.tag == 0 {
                sum = selectBtn == 1 ? 0 : -1
            } else {
                sum = selectBtn == (btns.count - 2) ? 0 : 1
            }
            selectBtn += sum
        } else {
            selectBtn = sender.tag
        }
        loadMainBtn()
        let finalText = tfMain.text ?? ""
        print(finalText)
        tbMain.isHidden = false
        toogleView(false)
    }
    public func dismiss(animated: Bool) {
        self.layoutIfNeeded()
        if animated {
            UIView.animate(withDuration: 0.50,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 10,
                           options: UIView.AnimationOptions(rawValue: 0),
                           animations: {
                            self.center = CGPoint(x: self.center.x,
                                                             y: self.frame.height + self.frame.height/2)
            }, completion: { (_) in
                DataConfig.clearOnClose ? self.exit() : self.saveData()
            })
        } else {
            DataConfig.clearOnClose ? self.exit() : saveData()
        }
    }
    func exit() {
        removeFromSuperview()
    }
    func saveData() {
        removeFromSuperview()
        //self.isHidden = true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = ""
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = generalFont
        cell.contentView.backgroundColor = chataDrawerBackgroundColor
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
