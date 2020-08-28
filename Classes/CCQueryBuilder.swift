//
//  CCQueryBuilder.swift
//  chata
//
//  Created by Vicente Rincon on 28/08/20.
//

import Foundation
class QueryBuilderView: UIView {
    let lblMain = UILabel()
    let tbMain = UITableView()
    let lblInfo = UILabel()
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
    }
}
