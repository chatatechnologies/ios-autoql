//
//  AutoComplete.swift
//  chata
//
//  Created by Vicente Rincon on 19/02/20.
//

import Foundation
import UIKit
protocol QBTipsDelegate: class {
    func callTips()
}
protocol ChatViewDelegate: class {
    func sendText(_ text: String, _ safe: Bool)
    func sendDrillDown(idQuery: String, obj: String, name: String)
    func sendDrillDownManual(newData: [[String]], columns: [ChatTableColumn], idQuery: String)
}
class ChatView: UIView, ChatViewDelegate, DataChatCellDelegate, QueryBuilderViewDelegate {
    let tableView = UITableView()
    weak var delegate: ChatViewDelegate?
    weak var delegateQB: QBTipsDelegate?
    var data = [
        ChatComponentModel(type: .Introduction, text: "Hi \(DataConfig.userDisplayName)! \(DataConfig.introMessage)"),
        ChatComponentModel(type: .QueryBuilder, text: "")
    ]
    private var cellAnimationsFlags = [IndexPath]()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        if DataConfig.authenticationObj.token == "" {
            data.remove(at: 1)
        }
    }
    override func didMoveToSuperview() {
        configLoad()
    }
    func deleteQuery(numQuery: Int) {
        if data.count >= numQuery {
            let numDeletes = validateDeletes(numQuery: numQuery)
            DispatchQueue.main.async {
                var indexs: [IndexPath] = []
                for idx in 0..<numDeletes  {
                    let finalPos = numQuery - idx
                    let newIndex = IndexPath(row: finalPos, section: 0)
                    indexs.append(newIndex)
                }
                self.tableView.deleteRows(at: indexs, with: .automatic)
                //self.tableView.reloadData()
                let endIndex = IndexPath(row: numQuery - numDeletes, section: 0)
                self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: false)
            }
        }
    }
    func validateDeletes(numQuery: Int) -> Int {
        var numDeletes = 1
        data.remove(at: numQuery)
        if data[numQuery-1].type == .Introduction{
            if data[numQuery-1].user {
                numDeletes = 2
                data.remove(at: numQuery - 1)
            } else if data[numQuery-1].referenceID == "1.1.430" ||
                data[numQuery-1].referenceID == "1.1.431" {
                numDeletes = 3
                data.remove(at: numQuery - 1)
                data.remove(at: numQuery - 2)
            }
        }
        return numDeletes
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
        cell.delegateQB = self
        cell.configCell(allData: data[indexPath.row], index: indexPath.row, lastQueryFinal: (indexPath.row == data.count - 1))
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
        let finalSize = getSize(row: data[indexPath.row], width: self.frame.width)
        return finalSize
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
    func updateSize(numRows: Int, index: Int, toTable: Bool, isTable: Bool) {
        let indexPath = IndexPath(row: index, section: 0)
        guard let cell = self.tableView.cellForRow(at: indexPath) as? DataChatCell else {return}
        cell.updateChart()
        if toTable{
            // diferencias si es table o webview
            if data.count > index {
                data[index].numRow = numRows
                data[index].type = isTable ? .Table : data[index].type
                //tableView.reloadRows(at: [indexPath], with: .none)
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }
        
    }
    func sendDrillDown(idQuery: String, obj: String, name: String) {
        delegate?.sendDrillDown(idQuery: idQuery, obj: obj, name: name)
    }
    func sendDrillDownManual(newData: [[String]], columns: [ChatTableColumn], idQuery: String) {
        delegate?.sendDrillDownManual(newData: newData, columns: columns, idQuery: idQuery)
    }
    func updateSize(numQBOptions: Int, index: Int) {
        if data.count > index {
            DispatchQueue.main.async {
                self.data[index].numQBoptions = numQBOptions
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
        }
    }
    func callTips() {
        delegateQB?.callTips()
    }
}
