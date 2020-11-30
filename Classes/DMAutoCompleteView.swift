//
//  vwAutoComplete.swift
//  chata
//
//  Created by Vicente Rincon on 09/03/20.
//


import Foundation
import UIKit
class AutoCompleteView: UIView {
    private let autoCompleteTable = UITableView()
    private var data: [String] = []
    private var cellAnimationsFlags = [IndexPath]()
    weak var delegate: ChatViewDelegate?
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        autoCompleteTable.delegate = self
        autoCompleteTable.dataSource = self
        autoCompleteTable.delaysContentTouches = false
        self.backgroundColor = chataDrawerBackgroundColorPrimary
    }
    private func loadConfig() {
        self.isHidden = true
        autoCompleteTable.separatorStyle = .none
        autoCompleteTable.backgroundColor = .clear
        self.cardViewShadow()
        self.addSubview(autoCompleteTable)
        autoCompleteTable.edgeTo(self, safeArea: .nonePadding, height: 7, padding: 7)
    }
    override func didMoveToSuperview() {
        loadConfig()
    }
    func toggleHide(_ hide: Bool){
        self.isHidden = hide
    }
    func updateTable(queries: [String]) {
        data = queries
        autoCompleteTable.reloadData()
    }
}
extension AutoCompleteView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textColor = chataDrawerTextColorPrimary
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.setSize()
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.minimumScaleFactor = 0.7
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.sendText(data[indexPath.row], true)
    }
}
