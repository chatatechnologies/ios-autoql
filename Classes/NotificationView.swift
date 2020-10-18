//
//  NotificationView.swift
//  chata
//
//  Created by Vicente Rincon on 24/09/20.
//
import Foundation
import  UIKit
class NotificationView: UIView, UITableViewDelegate, UITableViewDataSource, NotificationCellDelegate {
    let tbMain = UITableView()
    let lblDefault = UILabel()
    var notifications: [NotificationItemModel] = []
    var lastSelect = -1
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
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
        loadNotifications()
        loadTable()
    }
    func loadDefaul() {
        if notifications.count == 0{
            lblDefault.textColor = chataDrawerTextColorPrimary
            lblDefault.font = generalFont
            lblDefault.textAlignment = .center
            lblDefault.text = "You don't have any notifications yet."
            lblDefault.tag = 2
            lblDefault.numberOfLines = 0
            self.addSubview(lblDefault)
            lblDefault.edgeTo(self, safeArea: .topPadding, height: 20, padding: 16)
        }
        else{
            self.removeView(tag: 2)
        }
    }
    private func loadNotifications() {
        NotificationServices.instance.getNotifications(currentNumber: notifications.count) { (notifications) in
            self.notifications += notifications
            self.checkNotification()
        }
    }
    private func loadTable() {
        tbMain.delegate = self
        tbMain.dataSource = self
        tbMain.separatorStyle = .none
        tbMain.clipsToBounds = true
        tbMain.bounces = false
        tbMain.backgroundColor = chataDrawerBackgroundColor
        self.addSubview(tbMain)
        tbMain.edgeTo(self, safeArea: .nonePadding, padding: 8)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if lastSelect != indexPath.row {
            if lastSelect < notifications.count && lastSelect >= 0 {
                notifications[lastSelect].expandable = false
            }
            let lastIndex = IndexPath(row: lastSelect, section: 0)
            lastSelect = indexPath.row
            notifications[indexPath.row].expandable = true
            tbMain.reloadRows(at: [lastIndex, indexPath], with: .automatic)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NotificationCell()
        cell.delegate = self
        cell.configCell(item: notifications[indexPath.row], index: indexPath.row)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return notifications[indexPath.row].expandable ? 350 : 100
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom <= height {
            loadNotifications()
        }
    }
    func deleteNotification(index: Int, id: String) {
        NotificationServices.instance.deleteNotification(idNotification: id)
        let newIndex: Int = (notifications.firstIndex { (item) -> Bool in
            item.id == id
        }) ?? 0
        self.notifications.remove(at: newIndex)
        self.checkNotification(reload: false, index: newIndex)
    }
    func checkNotification(reload: Bool = true, index: Int = 0) {
        DispatchQueue.main.async {
            self.loadDefaul()
            if reload {
                self.tbMain.reloadData()
            } else {
                let indexPath = IndexPath(row: index, section: 0)
                self.tbMain.deleteRows(at: [indexPath], with: .none)
            }
        }
    }
}

