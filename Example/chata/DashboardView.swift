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
    let btnExecute = UIButton()
    let lbTextrun = UILabel()
    let vwDash = UIView()
    let dash = Dashboard()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    func configLoad(authFinal: authentication, mainView: UIView = UIView()){
        let blueColor = "#28A8E0".hexToColor()
        btnExecute.setTitle("▷ Execute", for: .normal)
        btnExecute.setTitleColor(blueColor, for: .normal)
        btnExecute.cardView(color: blueColor)
        btnExecute.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        lbTextrun.text = "Run Dashboard Automatically"
        lbTextrun.textAlignment = .center
        addSubview(btnExecute)
        btnExecute.edgeTo(self, safeArea: .secondTop, height: 30)
        addSubview(vwDash)
        vwDash.edgeTo(self, safeArea:.fullState, btnExecute)
        vwDash.addSubview(dash)
        let auth: authentication = authentication(apiKey: authFinal.apiKey, domain: authFinal.domain, token: authFinal.token)
        dash.loadDashboard(view: vwDash, autentification: auth, mainView: mainView )
        btnExecute.addTarget(self, action: #selector(executeDashboard), for: .touchUpInside)
    }
    @objc func executeDashboard(sender: UIButton) {
        dash.executeDashboard()
    }
}
