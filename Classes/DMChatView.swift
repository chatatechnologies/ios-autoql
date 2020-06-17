//
//  AutoComplete.swift
//  chata
//
//  Created by Vicente Rincon on 19/02/20.
//

import Foundation
import UIKit
protocol ChatViewDelegate: class {
    func sendText(_ text: String, _ safe: Bool)
    func sendDrillDown(idQuery: String, obj: String, name: String)
}
class ChatView: UIView, ChatViewDelegate, DataChatCellDelegate {
    let tableView = UITableView()
    weak var delegate: ChatViewDelegate?
    var data = [
        ChatComponentModel(type: .Introduction, text: "Hi \(DataConfig.userDisplayName)! \(DataConfig.introMessage)")
        //ChatComponentModel(type: .QueryBuilder, text: "" )
        
    ]
    private var cellAnimationsFlags = [IndexPath]()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func didMoveToSuperview() {
        configLoad()
    }
    func deleteQuery(numQuery: Int) {
        data.remove(at: numQuery)
        let index1 = IndexPath(row: numQuery, section: 0)
        DispatchQueue.main.async {
            self.tableView.deleteRows(at: [index1], with: .automatic)
            self.tableView.reloadData()
            let endIndex = IndexPath(row: numQuery - 1, section: 0)
            self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: false)
        }
    }
}
extension ChatView : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DataChatCell()
        cell.selectionStyle = .none
        cell.delegate = self
        cell.configCell(allData: data[indexPath.row], index: indexPath.row)
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.cellAnimationsFlags.contains(indexPath) {
            return
        }
        self.cellAnimationsFlags.append(indexPath)
        let scale = CATransform3DScale(CATransform3DIdentity, 0, 0, 0)
        cell.layer.transform = scale
        UIView.animate(withDuration: 0.5) {
            cell.layer.transform = CATransform3DIdentity
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getSize(row: data[indexPath.row], width: self.frame.width)
    }
    private func configLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 600
        tableView.rowHeight = UITableView.automaticDimension
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.addSubview(tableView)
        
        tableView.edgeTo(self, safeArea: .none)
        tableView.delaysContentTouches = false
    }
    func updateTable(){
        let index1 = IndexPath(row: self.data.count - 1, section: 0)
        //let index2 = IndexPath(row: self.data.count - 2 , section: 0)
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [index1], with: .automatic)
            self.tableView.endUpdates()
            let endIndex = IndexPath(row: self.data.count - 1, section: 0)
            self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: true)
        }
    }
    func updateWithLimit(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
            let endIndex = IndexPath(row: self.data.count - 1, section: 0)
            self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: true)
        }
    }
    func sendText(_ text: String, _ safe: Bool) {
        delegate?.sendText(text, safe)
    }
    func updateSize(numRows: Int, index: Int) {
        data[index].numRow = numRows
        tableView.beginUpdates()
        tableView.endUpdates()
        let indexPath = IndexPath(row: index, section: 0)
        guard let cell = self.tableView.cellForRow(at: indexPath) as? DataChatCell else {return}
        cell.updateChart()
    }
    func sendDrillDown(idQuery: String, obj: String, name: String) {
        delegate?.sendDrillDown(idQuery: idQuery, obj: obj, name: name)
    }
}
