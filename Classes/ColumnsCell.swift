//
//  ColumnsCell.swift
//  chata
//
//  Created by Vicente Rincon on 12/04/21.
//

import Foundation
protocol ColumnsCellDelegate: class {
    func updateCell(index: Int, visibility: Bool)
}
class ColumnsCell: UITableViewCell {
    private var lblTitle = UILabel()
    private var imgCheck = UIImageView()
    var itemColumn = ColumnsItemModel()
    var index = 0
    private var vwMain = UIView()
    weak var delegate: ColumnsCellDelegate?
    static var identifier: String {
        return String(describing: self)
    }
    func configCell(item: ColumnsItemModel, index: Int) {
        itemColumn = item
        self.index = index
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        self.index = index
        loadComponents()
    }
    func loadComponents() {
        contentView.addSubview(vwMain)
        contentView.backgroundColor = chataDrawerBackgroundColorPrimary
        vwMain.edgeTo(self, safeArea: .noneTopPadding, height: 4, padding: 4)
        let imgCheckStr = itemColumn.visibility ? "icCheckTrue" : "icCheckFalse"
        let image = UIImage(named: imgCheckStr, in: Bundle(for: type(of: self)), compatibleWith: nil)!
        let image2 = image.resizeT(maxWidthHeight: 25)
        imgCheck.image = image2
        vwMain.addSubview(imgCheck)
        imgCheck.edgeTo(vwMain, safeArea: .rightCenterY, height: 25, padding: -8)
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeState) )
        imgCheck.isUserInteractionEnabled = true
        imgCheck.addGestureRecognizer(tap)
        lblTitle.setConfig(text: itemColumn.columnName,
                           textColor: chataDrawerTextColorPrimary,
                           align: .left)
        vwMain.addSubview(lblTitle)
        lblTitle.edgeTo(self, safeArea: .leftCenterY, height: 25, imgCheck, padding: -8)
    }
    func setStatus(visibility: Bool){
        itemColumn.visibility = visibility
        toggleStatus()
    }
    func toggleStatus(){
        let imgCheckStr = itemColumn.visibility ? "icCheckTrue" : "icCheckFalse"
        let image = UIImage(named: imgCheckStr, in: Bundle(for: type(of: self)), compatibleWith: nil)!
        let image2 = image.resizeT(maxWidthHeight: 25)
        imgCheck.image = image2
    }
    @objc func changeState(sender: UITapGestureRecognizer) {
        itemColumn.visibility = !itemColumn.visibility
        toggleStatus()
        delegate?.updateCell(index: self.index, visibility: itemColumn.visibility)
    }
    @IBAction func hideMenu(_ sender: AnyObject){
        superview?.removeView(tag: 2)
    }
    @objc func deleteNotification() {
        //delegate?.deleteNotification(index: index, id: itemNotif.id)
    }
}
struct ColumnsItemModel {
    var columnName: String
    var visibility: Bool
    init(
        columnName: String = "",
        visibility: Bool = false) {
        self.columnName = columnName
        self.visibility = visibility
    }
}
