//
//  CCQueryBuilder.swift
//  chata
//
//  Created by Vicente Rincon on 28/08/20.
//

import Foundation
class QueryBuilderView: UIView, UITableViewDelegate, UITableViewDataSource {
    let lblMain = UILabel()
    let tbMain = UITableView()
    let vwSecond = UIView()
    let tbSecond = UITableView()
    let lblInfo = UILabel()
    var dataQB: [QueryBuilderModel] = []
    var dataSelection: [String] = []
    weak var delegate: ChatViewDelegate?
    var selectSection = -1
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
        addSubview(tbMain)
        tbMain.edgeTo(self, safeArea: .topHeight, height: 200, lblMain)
        addSubview(lblInfo)
        lblInfo.edgeTo(self, safeArea: .bottomPaddingtoTop, tbMain)
        lblInfo.text = "Use Explore Queries to further explore the possibilities"
        lblInfo.font = generalFont
        lblInfo.textColor = chataDrawerTextColorPrimary
        lblInfo.numberOfLines = 0
        addSubview(vwSecond)
        vwSecond.edgeTo(tbMain, safeArea: .none)
        vwSecond.isHidden = true
        vwSecond.backgroundColor = chataDrawerBackgroundColor
        let button = UIButton()
        let image = UIImage(named: "icArrowLeft.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
        let image2 = image?.resizeT(maxWidthHeight: 30)
        button.setImage(image2, for: .normal)
        button.addTarget(self, action: #selector(returnSelection), for: .touchUpInside)
        vwSecond.addSubview(button)
        button.edgeTo(vwSecond, safeArea: .widthLeft, height: 30 )
        vwSecond.addSubview(tbSecond)
        tbSecond.edgeTo(vwSecond, safeArea: .noneLeft, padding: 30)
        tbSecond.addBorder(side: .left)
        
        loadTable()
    }
    @IBAction func returnSelection(_ sender: AnyObject){
        toggleAnimationSecond(hide: true)
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
            DispatchQueue.main.async {
                self.tbMain.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == tbMain ? dataQB.count : dataSelection.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if tableView == tbMain {
            cell.textLabel?.text = dataQB[indexPath.row].topic
            cell.textLabel?.font = generalFont
            cell.textLabel?.textColor = chataDrawerTextColorPrimary
            return cell
        } else {
            cell.textLabel?.text = dataSelection[indexPath.row]
            cell.textLabel?.font = generalFont
            cell.textLabel?.textColor = chataDrawerTextColorPrimary
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
            delegate?.sendText(dataSelection[indexPath.row], true)
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
