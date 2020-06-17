//
//  DashboardView.swift
//  chata_Example
//
//  Created by Vicente Rincon on 27/04/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import chata
class DashboardView: UIView {
    let swRun = UISwitch()
    let lbTextrun = UILabel()
    let vwDash = UIView()
    let tbMain = UITableView()
    let dash = Dashboard()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        loadTable()
    }
    func configLoad(authFinal: authentication, mainView: UIView = UIView()){
        lbTextrun.text = "Run Dashboard Automatically"
        lbTextrun.textAlignment = .center
        self.addSubview(lbTextrun)
        lbTextrun.edgeTo(self, safeArea: .topView, height: 40)
        self.addSubview(swRun)
        swRun.edgeTo(self, safeArea:.secondTop, height: 30, lbTextrun)
        self.addSubview(vwDash)
        vwDash.edgeTo(self, safeArea:.fullState, swRun)
        vwDash.addSubview(dash)
        let auth: authentication = authentication(apiKey: authFinal.apiKey, domain: authFinal.domain, token: authFinal.token)
        dash.loadDashboard(view: vwDash, autentification: auth, mainView: mainView )
        swRun.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
        loadTable()
    }
    @objc func switchValueDidChange(sender:UISwitch!) {
        if sender.isOn {
            dash.executeDashboard()
        }
    }
    private func loadTable() {
        tbMain.delegate = self
        tbMain.dataSource = self
    }
}
extension DashboardView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Joder"
        return cell
    }
    
    
}
