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
    let vwMainScrollChat = UIScrollView()
    var vwMainChat = UIView()
    var vwTextBox = UIView()
    let tbMain = UITableView()
    let lblDefault = UILabel()
    let btnSend = UIButton()
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
        //loadTable()
        //loadDefault()
        loadPagination()
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
        tbMain.edgeTo(vwMainChat, safeArea: .fullStatePadding, tfMain, padding: 8)
    }
    func loadPagination() {
        let stackedView = UIStackView()
        vwMainChat.addSubview(stackedView)
        stackedView.edgeTo(vwMainChat, safeArea: .bottomPadding, height: 50.0, padding: 0)
        stackedView.getHorizontal()
        let btn1 = UIButton()
        btn1.setTitle("1", for: .normal)
        let btn2 = UIButton()
        btn1.setTitle("2", for: .normal)
        let btn3 = UIButton()
        btn3.setTitle("3", for: .normal)
        stackedView.addArrangedSubview(btn1)
        stackedView.addArrangedSubview(btn2)
        stackedView.addArrangedSubview(btn3)
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
        tbMain.isHidden = true
    }
    @objc func actionSearch(sender: UIButton!) {
        let finalText = tfMain.text ?? ""
        print(finalText)
        tbMain.isHidden = false
        lblDefault.isHidden = true
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
        cell.textLabel?.text = "JoJo"
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = generalFont
        cell.contentView.backgroundColor = chataDrawerBackgroundColor
        cell.textLabel?.textColor = chataDrawerTextColorPrimary
        return cell
    }
}
