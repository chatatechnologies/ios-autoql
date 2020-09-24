//
//  NotificationView.swift
//  chata
//
//  Created by Vicente Rincon on 24/09/20.
//
import Foundation
import  UIKit

class NotificationView: UIView, UITableViewDelegate, UITableViewDataSource {
    let tbMain = UITableView()
    var notifications: [NotificationModel] = []
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
        loadTable()
    }
    private func loadTable() {
        tbMain.delegate = self
        tbMain.dataSource = self
        tbMain.separatorStyle = .none
        tbMain.clipsToBounds = true
        tbMain.bounces = true
        tbMain.backgroundColor = chataDrawerBackgroundColor
        self.addSubview(tbMain)
        tbMain.edgeTo(self, safeArea: .nonePadding, padding: 8)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NotificationCell()
        cell.configCell(item: notifications[indexPath.row], index: indexPath.row)
        cell.textLabel?.text = "TESt"
        return cell
    }
}

