//
//  DashboardComponent.swift
//  chata
//
//  Created by Vicente Rincon on 04/05/20.
//

import Foundation
import WebKit
protocol DashboardComponentCellDelegate: class{
    func sendDrillDown(idQuery: String, obj: [String], name: [String], title: String)
}
class DashboardComponentCell: UITableViewCell, WKNavigationDelegate, WKScriptMessageHandler {
    var imageView2 = UIImageView(image: nil)
    var data: DashboardModel = DashboardModel()
    let vwComponent = UIView()
    let vwWebview = UIView()
    let vwSecondWebview = UIView()
    var wbMain = WKWebView()
    let lblMain = UILabel()
    let lblDefault = UILabel()
    weak var delegate: DashboardComponentCellDelegate?
    //let newView = UIView()
    static var identifier: String {
        return String(describing: self)
    }
    func configCell(data: DashboardModel, loading: Bool = false) {
        self.data = data
        if data.splitView{
            print("YES")
            styleComponent()
            loadTitle()
            loadComponent(view: vwWebview, nsType: .bottomPaddingtoTopHalf, connect: lblMain )
            loadComponent(view: vwSecondWebview, connect: vwWebview)
        } else {
            styleComponent()
            loadTitle()
            loadComponent(view: vwWebview, connect: lblMain)
            loadType()
            if loading {
                loaderWebview()
            }
        }
    }
    func styleComponent() {
        self.contentView.backgroundColor = backgroundDash
        vwComponent.cardView()
        vwComponent.backgroundColor = .white
        self.contentView.addSubview(vwComponent)
        vwComponent.edgeTo(self, safeArea: .nonePadding, height: 8, padding: 1)
    }
    func loadComponent(view: UIView, nsType: DViewSafeArea = .bottomPaddingtoTop, connect: UIView) {
        vwComponent.addSubview(view)
        view.edgeTo(vwComponent, safeArea: nsType, connect,  padding: 8)
        loadDefault(view: view)
    }
    func loadTitle() {
        lblMain.text = data.title
        vwComponent.addSubview(lblMain)
        lblMain.edgeTo(vwComponent, safeArea: .topPadding, height: 30, padding: 8)
        lblMain.textColor = chataDrawerAccentColor
    }
    func loadDefault(view: UIView) {
        let newLbl = UILabel()
        newLbl.text = "Hit 'Execute' to run this dashboard"
        newLbl.numberOfLines = 0
        newLbl.textColor = chataDrawerTextColorPrimary
        newLbl.textAlignment = .center
        //vwWebview.addSubview(lblDefault)
        view.addSubview(newLbl)
        newLbl.edgeTo(view, safeArea: .none)
    }
    func loadType() {
        switch data.type {
        case .Safetynet, .Suggestion:
            print("error")
        case .Webview:
            loadWebView()
        case .Table:
            loadWebView()
        case .Introduction:
            loadIntro()
        case .Bar, .Line, .Column, .Pie, .Bubble, .Heatmap, .StackBar, .StackColumn, .StackArea:
            loadWebView()
        case .QueryBuilder:
            print("no supported for dashboard")
        }
    }
    func loadWebView(){
        //self.wbMain = WKWebView(frame: self.bounds)
        //wbMain.navigationDelegate = self
        let contentController = WKUserContentController()
        let userScript = WKUserScript(
            source: "mobileHeader()",
            injectionTime: WKUserScriptInjectionTime.atDocumentEnd,
            forMainFrameOnly: true
        )
        contentController.addUserScript(userScript)
        contentController.add(self, name: "drillDown")
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        wbMain = WKWebView(frame: self.bounds, configuration: config)
        
        wbMain.navigationDelegate = self
        wbMain.scrollView.bounces = false
        wbMain.isOpaque = false
        wbMain.isUserInteractionEnabled = true
        wbMain.scrollView.isScrollEnabled = true
        vwWebview.addSubview(wbMain)
        self.wbMain.edgeTo(vwWebview, safeArea: .none)
        loaderWebview()
        wbMain.loadHTMLString(data.webview, baseURL: nil)
    }
    func loadIntro() {
        if data.text != ""{
            lblDefault.text = data.text
            if DataConfig.autoQLConfigObj.enableDrilldowns{
                let tapgesture = UITapGestureRecognizer(target: self, action: #selector(showDrillDown))
                vwWebview.addGestureRecognizer(tapgesture)
            }
        }
        loaderWebview(false)
    }
    @objc func showDrillDown() {
        delegate?.sendDrillDown(idQuery: data.idQuery, obj: [], name: [], title: data.query)
    }
    func loaderWebview(_ load: Bool = true){
        var isLoading = false
        vwWebview.subviews.forEach { (view) in
            if view.tag == 5{
                isLoading = true
            }
        }
        if load {
            if !isLoading{
                let bundle = Bundle(for: type(of: self))
                let path = bundle.path(forResource: "gifBalls", ofType: "gif")
                let url = URL(fileURLWithPath: path!)
                imageView2.loadGif(url: url)
                //let jeremyGif = UIImage.gifImageWithName("preloader")
                //let imageView = UIImageView(image: image)
                imageView2.tag = 5
                lblDefault.isHidden = true
                vwWebview.addSubview(imageView2)
                imageView2.edgeTo(vwWebview, safeArea: .centerSize, height: 50, padding: 100)
            }
        } else{
            vwWebview.subviews.forEach { (view) in
                if view.tag == 5{
                    view.removeFromSuperview()
                }
            }
        }
    }
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if data.columnsInfo.count  <= 3 {
            if message.name == "drillDown" && DataConfig.autoQLConfigObj.enableDrilldowns {
                print(message.body)
                var names: [String] = []
                var columns: [String] = []
                let name = message.body as? String ?? ""
                let column = data.columnsInfo[0].originalName
                columns.append(column)
                if name.contains("_") {
                    let column2 = data.columnsInfo[1].originalName
                    let newArr = name.components(separatedBy: "_")
                    names.append(newArr[0])
                    names.append(newArr[1])
                    columns.append(column2)
                } else {
                    names.append(name)
                }
                delegate?.sendDrillDown(idQuery: data.idQuery, obj: columns, name: names, title: data.query)
                /*let name = data.columnsInfo[0].originalName
                let name2 = data.columnsInfo[1].originalName
                let nameFinal = (message.body as? String ?? "")?.contains("_") ?? false ? "\(name)º\(name2)" : name
                delegate?.sendDrillDown(idQuery: idQuery, obj: message.body as? String ?? "", name: nameFinal)*/
            }
        }
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loaderWebview(false)
        //progress(off: true, viewT: wbChart!)
    }
}
