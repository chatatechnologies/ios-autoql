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
class DashboardComponentCell: UITableViewCell, WKNavigationDelegate, WKScriptMessageHandler, ChatViewDelegate {
    var data: DashboardModel = DashboardModel()
    let vwComponent = UIView()
    let vwWebview = UIView()
    let vwSecondWebview = UIView()
    var wbMain = WKWebView()
    let lblMain = UILabel()
    let lblDefault = UILabel()
    weak var delegateSend: ChatViewDelegate?
    weak var delegate: DashboardComponentCellDelegate?
    //let newView = UIView()
    static var identifier: String {
        return String(describing: self)
    }
    func configCell(data: DashboardModel, loading: Bool = false) {
        self.data = data
        styleComponent()
        loadTitle()
        if data.splitView{
            loadComponent(view: vwWebview, nsType: .bottomPaddingtoTopHalf, connect: lblMain )
            vwWebview.addBorder()
            loadComponent(view: vwSecondWebview, connect: vwWebview)
            loadType(view: vwWebview,
                     text: data.text,
                     type: data.type,
                     webview: data.webview,
                     list: data.items)
            loadType(view: vwSecondWebview,
                     text: data.subDashboardModel.text,
                     type: data.subDashboardModel.type,
                     webview: data.subDashboardModel.webview,
                     list: data.subDashboardModel.items,
                     firstView: false)
            if loading {
                loaderWebview(view: vwWebview)
                loaderWebview(view: vwSecondWebview)
            }
        } else {
            loadComponent(view: vwWebview, connect: lblMain)
            loadType(view: vwWebview, text: data.text, type: data.type, webview: data.webview, list: data.items)
            if loading {
                loaderWebview(view: vwWebview)
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
        newLbl.tag = 1
        newLbl.textColor = chataDrawerTextColorPrimary
        newLbl.textAlignment = .center
        view.addSubview(newLbl)
        newLbl.edgeTo(view, safeArea: .none)
    }
    func loadType(view: UIView,
                  text: String,
                  type: ChatComponentType,
                  webview: String = "",
                  list: [String] = [],
                  firstView: Bool = true
    ) {
        switch type {
        case .Safetynet:
            print("fullSuggestion")
        case .Suggestion:
            loadSuggestion(view: view, list: list, firstView: firstView)
        case .Webview:
            loadWebView(view: view, webview: webview)
        case .Table:
            loadWebView(view: view, webview: webview)
        case .Introduction:
            loadIntro(view: view, text: text)
        case .Bar, .Line, .Column, .Pie, .Bubble, .Heatmap, .StackBar, .StackColumn, .StackArea:
            loadWebView(view: view, webview: webview)
        case .QueryBuilder:
            print("no supported for dashboard")
        }
    }
    private func loadSuggestion(view: UIView, list: [String], firstView: Bool) {
        let newView = SuggestionView()
        view.removeView(tag: 1)
        newView.delegate = self
        newView.loadConfig(options: list, query: data.text, first: firstView)
        //newView.loadWebview(strWebview: data.webView)
        newView.cardView()
        view.addSubview(newView)
        newView.edgeTo(view, safeArea: .paddingTop)
        self.sizeToFit()
    }
    func loadWebView(view: UIView, webview: String){
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
        view.addSubview(wbMain)
        self.wbMain.edgeTo(view, safeArea: .none)
        loaderWebview(view: view)
        wbMain.loadHTMLString(webview, baseURL: nil)
    }
    func loadIntro(view: UIView, text: String) {
        if text != "" {
            view.changeTextSubView(tag: 1, newText: text)
            if DataConfig.autoQLConfigObj.enableDrilldowns{
                let tapgesture = UITapGestureRecognizer(target: self, action: #selector(showDrillDown))
                vwWebview.addGestureRecognizer(tapgesture)
            }
        }
        loaderWebview(false, view: view)
    }
    @objc func showDrillDown() {
        delegate?.sendDrillDown(idQuery: data.idQuery, obj: [], name: [], title: data.query)
    }
    func loaderWebview(_ load: Bool = true, view: UIView){
        var isLoading = false
        view.subviews.forEach { (view) in
            if view.tag == 5{
                isLoading = true
            }
        }
        if load {
            if !isLoading{
                let imageView2 = UIImageView(image: nil)
                let bundle = Bundle(for: type(of: self))
                let path = bundle.path(forResource: "gifBalls", ofType: "gif")
                let url = URL(fileURLWithPath: path!)
                imageView2.loadGif(url: url)
                //let jeremyGif = UIImage.gifImageWithName("preloader")
                //let imageView = UIImageView(image: image)
                view.removeView(tag: 1)
                imageView2.tag = 5
                view.addSubview(imageView2)
                imageView2.edgeTo(view, safeArea: .centerSize, height: 50, padding: 100)
            }
        } else{
            view.removeView(tag: 5)
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
        loaderWebview(false, view: webView.superview ?? UIView())
        //progress(off: true, viewT: wbChart!)
    }
    func sendText(_ text: String, _ safe: Bool) {
        delegateSend?.sendText(text, safe)
    }
    
    func sendDrillDown(idQuery: String, obj: String, name: String) {
        
    }
}
