//
//  DashboardComponent.swift
//  chata
//
//  Created by Vicente Rincon on 04/05/20.
//

import Foundation
import WebKit
protocol DashboardComponentCellDelegate: class{
    func sendDrillDown(idQuery: String, obj: String, name: String, title: String)
    func sendDrillDownManualDashboard(newData: [[String]], columns: [ChatTableColumn], title: String)
    func updateComponent(text: String, first: Bool, position: Int)
}
class DashboardComponentCell: UITableViewCell, WKNavigationDelegate, WKScriptMessageHandler, ChatViewDelegate {
    var mainData: DashboardModel = DashboardModel()
    let vwComponent = UIView()
    let vwWebview = UIView()
    let vwSecondWebview = UIView()
    var wbMain = WKWebView()
    let lblMain = UILabel()
    let lblDefault = UILabel()
    var position = 0
    var mainText = "Hit 'Execute' to run this dashboard"
    weak var delegateSend: ChatViewDelegate?
    weak var delegate: DashboardComponentCellDelegate?
    var first = false
    //let newView = UIView()
    static var identifier: String {
        return String(describing: self)
    }
    func configCell(data: DashboardModel, pos: Int, loading: Int = 0, secondLoading: Int = 0) {
        self.mainData = data
        self.position = pos
        styleComponent()
        loadTitle()
        let secondType = ChatComponentType.withLabel(data.secondDisplayType)
        if data.splitView{
            let multiLoad = loading == 0 ? 0 : secondLoading == 2 && loading == 2 ? 2 : 1
            loadComponent(view: vwWebview, nsType: .bottomPaddingtoTopHalf, connect: lblMain, loading: multiLoad, type: data.type )
            vwWebview.addBorder()
            loadComponent(view: vwSecondWebview, connect: vwWebview, loading: secondLoading, type: secondType)
            loadType(view: vwWebview,
                     text: data.text,
                     type: data.type,
                     webview: data.webview,
                     list: data.items,
                     loading: multiLoad
            )
            loadType(view: vwSecondWebview,
                     text: data.subDashboardModel.text,
                     type: data.subDashboardModel.type,
                     webview: data.subDashboardModel.webview,
                     list: data.subDashboardModel.items,
                     firstView: false,
                     loading: secondLoading
                     )
            if loading == 1 {
                loaderWebview(view: vwWebview, type2: data.type)
            }
            if secondLoading == 1 {
                loaderWebview(view: vwSecondWebview, type2: secondType)
            }
        } else {
            loadComponent(view: vwWebview, connect: lblMain, loading: loading, type: data.type)
            loadType(view: vwWebview, text: data.text, type: data.type, webview: data.webview, list: data.items, loading: loading)
            if loading == 1 {
                loaderWebview(view: vwWebview, type2: data.type )
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
    func loadComponent(view: UIView, nsType: DViewSafeArea = .bottomPaddingtoTop, connect: UIView, loading: Int = 0, type: ChatComponentType) {
        vwComponent.addSubview(view)
        view.edgeTo(vwComponent, safeArea: nsType, connect,  padding: 8)
        loadDefault(view: view, loading: loading, type: type)
    }
    func loadTitle() {
        lblMain.text = mainData.title
        vwComponent.addSubview(lblMain)
        lblMain.edgeTo(vwComponent, safeArea: .topPadding, height: 30, padding: 8)
        lblMain.textColor = chataDrawerAccentColor
    }
    func loadDefault(view: UIView ,loading: Int = 0, type: ChatComponentType) {
        if loading == 0 {
            let newLbl = UILabel()
            newLbl.text = mainText
            newLbl.numberOfLines = 0
            newLbl.tag = 1
            newLbl.textColor = chataDrawerTextColorPrimary
            newLbl.textAlignment = .center
            view.addSubview(newLbl)
            newLbl.edgeTo(view, safeArea: .none)
        } else {
            loaderWebview(true, view: view, type2: type)
        }
    }
    func loadType(view: UIView,
                  text: String,
                  type: ChatComponentType,
                  webview: String = "",
                  list: [String] = [],
                  firstView: Bool = true,
                  loading: Int = 0
    ) {
        switch type {
        case .Safetynet:
            print("fullSuggestion")
        case .Suggestion:
            loadSuggestion(view: view, list: list, firstView: firstView)
        case .Introduction:
            loadIntro(view: view, text: text)
        case .Bar, .Line, .Column, .Pie, .Bubble, .Heatmap, .StackBar, .StackColumn, .Table, .Webview, .StackArea:
            loadWebView(view: view, webview: webview, loading: loading)
        case .QueryBuilder:
            print("no supported for dashboard")
        }
    }
    private func loadSuggestion(view: UIView, list: [String], firstView: Bool) {
        let newView = SuggestionView()
        view.removeView(tag: 1)
        newView.delegate = self
        newView.loadConfig(options: list, query: mainData.text, first: firstView)
        //newView.loadWebview(strWebview: data.webView)
        newView.cardView()
        view.addSubview(newView)
        newView.edgeTo(view, safeArea: .paddingTop)
        self.sizeToFit()
    }
    func loadWebView(view: UIView, webview: String, loading: Int = 0){
        //self.wbMain = WKWebView(frame: self.bounds)
        //wbMain.navigationDelegate = self
        if loading == 2 {
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
            loaderWebview(view: view, type2: .Webview)
            wbMain.loadHTMLString(webview, baseURL: nil)
        }
    }
    func loadIntro(view: UIView, text: String) {
        if text != "" {
            loadDefault(view: view, loading: 0, type: .Introduction)
            view.changeTextSubView(tag: 1, newText: text)
            if DataConfig.autoQLConfigObj.enableDrilldowns{
                if text != "No query was supplied for this tile." && text != "Invalid Request Parameters"{
                    let tapgesture = UITapGestureRecognizer(target: self, action: #selector(showDrillDown))
                    vwWebview.addGestureRecognizer(tapgesture)
                }
            }
        }
        loaderWebview(false, view: view, type2: .Introduction)
    }
    @objc func showDrillDown() {
        delegate?.sendDrillDown(idQuery: mainData.idQuery, obj: "", name: "", title: mainData.query)
    }
    func loaderWebview(_ load: Bool = true, view: UIView, type2: ChatComponentType){
        var isLoading = false
        view.subviews.forEach { (view) in
            if view.tag == 5{
                isLoading = true
                view.removeView(tag: 1)
            }
        }
        if load {
            if !isLoading{
                view.removeView(tag: 1)
                mainText = ""
                let imageView2 = UIImageView(image: nil)
                let bundle = Bundle(for: type(of: self))
                let path = bundle.path(forResource: "gifBalls", ofType: "gif")
                let url = URL(fileURLWithPath: path!)
                imageView2.loadGif(url: url)
                //let jeremyGif = UIImage.gifImageWithName("preloader")
                //let imageView = UIImageView(image: image)
                imageView2.tag = 5
                view.addSubview(imageView2)
                imageView2.edgeTo(view, safeArea: .centerSize, height: 50, padding: 100)
            }
        } else{
            view.removeView(tag: 5)
            if isLoading && type2 != .Introduction{
                view.removeView(tag: 1)
            }
        }
    }
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        //if data.columnsInfo.count  <= 3 {
            if message.name == "drillDown" && DataConfig.autoQLConfigObj.enableDrilldowns {
                /*var names: [String] = []
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
                }*/
                var msg = message.body as? String ?? ""
                var secondQuery: Bool = false
                //var column: Int = data.stringColumnIndex
                if msg.contains("SecondQuery") {
                    msg = msg.replace(target: "SecondQuery" , withString: "")
                    //column = data.stringColumnIndexSecond
                    secondQuery = true
                }
                let columns = secondQuery ? mainData.subDashboardModel.columnsInfo : mainData.columnsInfo
                if columns.count <= 3{
                    let name = mainData.columnsInfo.count > 0 ? mainData.columnsInfo[0].originalName : ""
                    let name2 = mainData.columnsInfo.count > 1 ? mainData.columnsInfo[1].originalName : ""
                    let nameFinal = (message.body as? String ?? "")?.contains("_") ?? false ? "\(name)º\(name2)" : name
                    delegate?.sendDrillDown(idQuery: mainData.idQuery, obj: msg, name: nameFinal, title: mainData.query)
                } else {
                    if secondQuery {
                        if mainData.subDashboardModel.type == .Table || mainData.subDashboardModel.type == .Webview {
                            
                        } else{
                            newDrilldown(data: msg)
                        }
                    } else {
                        if mainData.type == .Table || mainData.type == .Webview {
                            
                        } else{
                            newDrilldown(data: msg)
                        }
                    }
                }
                //delegate?.sendDrillDown(idQuery: data.idQuery, obj: columns, name: names, title: data.query)
                /*let name = data.columnsInfo[0].originalName
                let name2 = data.columnsInfo[1].originalName
                let nameFinal = (message.body as? String ?? "")?.contains("_") ?? false ? "\(name)º\(name2)" : name
                delegate?.sendDrillDown(idQuery: idQuery, obj: message.body as? String ?? "", name: nameFinal)*/
            }
        //}
    }
    func newDrilldown(data: String) {
        var position = -1
        mainData.columnsInfo.enumerated().forEach { (index, type) in
            if type.type == .date{
                if position == -1{
                    position = index
                }
            }
        }
        var newData: [[String]] = []
        mainData.cleanRows.forEach { (row) in
            row.forEach { (column) in
                if column == data {
                    newData.append(row)
                }
            }
        }
        delegate?.sendDrillDownManualDashboard(newData: newData,
                                      columns: mainData.columnsInfo,
                                      title: mainData.title)
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loaderWebview(false, view: webView.superview ?? UIView(), type2: .Webview)
        //progress(off: true, viewT: wbChart!)
    }
    func sendText(_ text: String, _ safe: Bool) {
        delegate?.updateComponent(text: text, first: safe, position: position)
    }
    
    func sendDrillDown(idQuery: String, obj: String, name: String) {
        
    }
    func sendDrillDownManual(newData: [[String]], columns: [ChatTableColumn], idQuery: String) {
        
    }
}
