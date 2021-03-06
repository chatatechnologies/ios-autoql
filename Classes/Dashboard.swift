//
//  Dashboard.swift
//  chata
//
//  Created by Vicente Rincon on 28/04/20.
//

import Foundation
import WebKit
public class Dashboard: UIView, DashboardComponentCellDelegate, WKNavigationDelegate, ChatViewDelegate, WKScriptMessageHandler {
    //public var themeConfig2: themeConfig = themeConfig
    var themeConfigDashboard : themeConfigInput =  themeConfigInput()
    let tbMain = UITableView()
    let vwEmptyDash = UIView()
    let tbListDashboard = UITableView()
    var dataDash: [DashboardModel] = []
    var imageView = UIImageView(image: nil)
    let vwDrillDown = UIView()
    var mainView = UIView()
    var vwWebview = UIView()
    var vwSecondWebview = UIView()
    var wbMain = WKWebView()
    var wbSecond = WKWebView()
    var imageView2 = UIImageView(image: nil)
    var spinnerDashboard = UIButton()
    var listDash: [DashboardList] = []
    var loadingGeneral: Int = 0
    var mainData: DashboardModel = DashboardModel()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        //self.backgroundColor =
    }
    func loadDashboardView(){
        loadTableD(table: tbMain)
        loadTableD(table: tbListDashboard)
        self.addSubview(spinnerDashboard)
        spinnerDashboard.edgeTo(self, safeArea: .topPadding, height: 40, padding: 8)
        spinnerDashboard.titleLabel?.font = generalFont
        spinnerDashboard.setTitleColor(chataDrawerAccentColor, for: .normal)
        spinnerDashboard.cardView()
        spinnerDashboard.addTarget(self, action: #selector(toggleDash), for: .touchUpInside)
        self.addSubview(tbMain)
        tbMain.edgeTo(self, safeArea: .fullStatePaddingTop, spinnerDashboard, padding: 8)
        loadEmptyView()
        self.addSubview(tbListDashboard)
        tbListDashboard.backgroundColor = chataDrawerBackgroundColorPrimary
        tbListDashboard.edgeTo(self, safeArea: .dropDownTop, height: 200, spinnerDashboard, padding: 0)
        tbListDashboard.cardView()
        tbListDashboard.clipsToBounds = true
        tbListDashboard.isHidden = true
    }
    @IBAction func toggleDash(_ sender: AnyObject){
        toggleListDashboard(tbListDashboard.isHidden)
    }
    func loadEmptyView() {
        self.addSubview(vwEmptyDash)
        vwEmptyDash.edgeTo(self, safeArea: .topHeight, height: 100, spinnerDashboard)
        vwEmptyDash.isHidden = true
        let lblText = UILabel()
        lblText.text = "Empty Dashboard"
        lblText.textColor = chataDrawerTextColorPrimary
        lblText.textAlignment = .center
        lblText.textColor = chataDrawerTextColorPrimary
        vwEmptyDash.addSubview(lblText)
        lblText.edgeTo(vwEmptyDash, safeArea: .none)
    }
    public func loadDashboard(
        view: UIView,
        autentification: authentication,
        mainView: UIView,
        theme : themeConfigInput = themeConfigInput()
    ){
        self.themeConfigDashboard = theme
        reloadColors(dark: themeConfigDashboard.theme == "dark")
        self.backgroundColor = chataDrawerBackgroundColorSecondary
        loadDashboardView()
        self.edgeTo(view, safeArea: .none)
        self.mainView = mainView
        DashboardService().getDashboards(apiKey: autentification.apiKey) { (dashboards) in
            DispatchQueue.main.async {
                let firstDash = dashboards.count > 0 ? dashboards[0] : DashboardList()
                let name = "\(firstDash.name) ⌄"
                self.spinnerDashboard.setTitle(name, for: .normal)
                self.listDash = dashboards
                self.dataDash = firstDash.data
                self.tbMain.reloadData()
                self.tbListDashboard.reloadData()
                self.toggleTable()
            }
            
        }
    }
    func toggleTable() {
        tbMain.isHidden = dataDash.count == 0
        vwEmptyDash.isHidden = !(dataDash.count == 0)
    }
    func sendDrillDown(idQuery: String, obj: String, name: String, title: String, webview: String, mainData: DashboardModel ) {
        self.mainData = mainData
        createDrillDown(title: title, webview: webview)
        ChataServices.instance.getDataChatDrillDown(obj: obj, idQuery: idQuery, name: name) { (dataComponent) in
            DispatchQueue.main.async {
                self.wbMain.loadHTMLString(dataComponent.webView, baseURL: nil)
            }
        }
        /*DashboardService.instance.getDrillDownDashboard(idQuery: idQuery, name: , value: name) { (dataComponent) in
            DispatchQueue.main.async {
                self.wbMain.loadHTMLString(dataComponent.webView, baseURL: nil)
            }
        }*/
    }
    func createDrillDown(title: String, webview: String = "" ) {
        
        vwDrillDown.tag = 100
        vwDrillDown.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        mainView.addSubview(vwDrillDown)
        vwDrillDown.edgeTo(mainView, safeArea: .none)
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(closeDrillDown))
        vwDrillDown.addGestureRecognizer(tapgesture)
        let component = UIView()
        component.backgroundColor = .white
        component.cardView()
        vwDrillDown.addSubview(component)
        component.edgeTo(vwDrillDown, safeArea: .nonePadding, height: 30, padding: 50)
        let lbTitle = UILabel()
        lbTitle.text = title
        lbTitle.textAlignment = .center
        component.addSubview(lbTitle)
        lbTitle.edgeTo(component, safeArea: .topPadding, height: 30, padding: 20)
        lbTitle.addBorder()
        component.addSubview(vwWebview)
        vwWebview.backgroundColor = .gray
        if webview != "" && webview != "text" {
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
            wbSecond = WKWebView(frame: self.bounds, configuration: config)
            component.addSubview(self.vwSecondWebview)
            self.vwSecondWebview.backgroundColor = .blue
            self.vwSecondWebview.edgeTo(component, safeArea: .bottomPaddingtoTopHalf, lbTitle, padding: 20 )
            self.vwSecondWebview.addSubview(wbSecond)
            wbSecond.edgeTo(vwSecondWebview, safeArea: .none)
            wbSecond.navigationDelegate = self
            loaderWebview(mView: vwSecondWebview)
            DispatchQueue.main.async {
                self.wbSecond.loadHTMLString(webview, baseURL: nil)
            }
            vwWebview.edgeTo(component, safeArea: .bottomPaddingtoTop, vwSecondWebview, padding: 20 )
        } else {
            vwWebview.edgeTo(component, safeArea: .bottomPaddingtoTop, lbTitle, padding: 20 )
        }
        vwWebview.addSubview(wbMain)
        wbMain.edgeTo(vwWebview, safeArea: .none)
        wbMain.navigationDelegate = self
        loaderWebview(mView: vwWebview)
    }
    func sendDrillDownManualDashboard(newData: [[String]], columns: [ChatTableColumn], title: String, webview: String, mainData: DashboardModel) {
        self.mainData = mainData
        createDrillDown(title: title, webview: webview)
        let newComponent = ChataServices.instance.getDrillComponent(data: newData, columns: columns)
        self.wbMain.loadHTMLString(newComponent.webView, baseURL: nil)
    }
    func loaderWebview(mView: UIView, _ load: Bool = true){
        if load {
            let bundle = Bundle(for: type(of: self))
            let path = bundle.path(forResource: "gifBalls", ofType: "gif")
            let url = URL(fileURLWithPath: path!)
            imageView2.loadGif(url: url)
            imageView2.tag = 5
            mView.addSubview(imageView2)
            imageView2.edgeTo(mView, safeArea: .centerSize, height: 50, padding: 100)
        } else{
            mView.subviews.forEach { (view) in
                if view.tag == 5{
                    view.removeFromSuperview()
                }
            }
        }
    }
    @objc func closeDrillDown(){
        self.wbMain.loadHTMLString("", baseURL: nil)
        for view in mainView.subviews{
            if view.tag == 100 {
                view.removeFromSuperview()
            }
        }
    }
    public func executeDashboard(){
        loadingGeneral = 1
        tbMain.reloadData()
        for (index, dash) in self.dataDash.enumerated() {
            if dash.splitView {
                loadTwoDash(query: dash.secondQuery, type: dash.secondDisplayType, index: index, column: dash.stringColumnIndexSecond)
            }
            loadOneDash(query: dash.query, type: dash.type, index: index, column: dash.stringColumnIndex)
        }
    }
    func loadTwoDash(query: String, type: String, index: Int, column: Int) {
        DashboardService().getDashQuery(query: query,
                                        type: ChatComponentType.withLabel(type),
                                        position: index,
                                        column: column,
                                        second: "SecondQuery") { (component) in
            DispatchQueue.main.async {
                let pos = component.position
                let newSub = SubDashboardModel(
                        webview: component.webView,
                        text: component.text,
                        type: component.type,
                        idQuery: component.idQuery,
                        loading: 2,
                        items: component.options,
                        columnsInfo: component.columnsInfo,
                        rowsClean: component.rowsClean
                )
                self.dataDash[pos].subDashboardModel = newSub
                let indexPath = IndexPath(row: pos, section: 0)
                self.tbMain.reloadRows(at: [indexPath], with: .none)
            }
        }
    }
    func loadOneDash(query: String, type: ChatComponentType, index: Int, column: Int ) {
        DashboardService().getDashQuery(query: query,
                                        type: type,
                                        position: index) { (component) in
            DispatchQueue.main.async {
                let pos = component.position
                if self.dataDash.count > pos {
                    self.dataDash[pos].webview = component.webView
                    self.dataDash[pos].cleanRows = component.rowsClean
                    self.dataDash[pos].type = component.type
                    self.dataDash[pos].text = component.text
                    self.dataDash[pos].idQuery = component.idQuery
                    self.dataDash[pos].columnsInfo = component.columnsInfo
                    self.dataDash[pos].loading = 2
                    let indexPath = IndexPath(row: pos, section: 0)
                    self.tbMain.reloadRows(at: [indexPath], with: .none)
                }
            }
        }
    }
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loaderWebview(mView: webView.superview ?? UIView(), false)
    }
    func toggleListDashboard(_ show: Bool = true) {
        tbListDashboard.isHidden = !show
    }
    func refreshDrillDown(idQuery: String, obj: String, name: String, title: String, webview: String ) {
        ChataServices.instance.getDataChatDrillDown(obj: obj, idQuery: idQuery, name: name) { (dataComponent) in
            DispatchQueue.main.async {
                self.wbMain.loadHTMLString(dataComponent.webView, baseURL: nil)
            }
        }
    }
    func refreshManualDrillDown(newData: [[String]], columns: [ChatTableColumn], title: String, webview: String) {
        let newComponent = ChataServices.instance.getDrillComponent(data: newData, columns: columns)
        self.wbMain.loadHTMLString(newComponent.webView, baseURL: nil)
    }
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
            if message.name == "drillDown" && DataConfig.autoQLConfigObj.enableDrilldowns {
                var msg = message.body as? String ?? ""
                var secondQuery: Bool = false
                if msg.contains("SecondQuery") {
                    msg = msg.replace(target: "SecondQuery" , withString: "")
                    secondQuery = true
                }
                let columns = secondQuery ? mainData.subDashboardModel.columnsInfo : mainData.columnsInfo
                if columns.count <= 3{
                    let name = mainData.columnsInfo.count > 0 ? mainData.columnsInfo[0].originalName : ""
                    let name2 = mainData.columnsInfo.count > 1 ? mainData.columnsInfo[1].originalName : ""
                    let nameFinal = (message.body as? String ?? "")?.contains("_") ?? false ? "\(name)º\(name2)" : name
                    let finalWebview = mainData.type == .Webview || mainData.type == .Table ? "" : mainData.webview
                    refreshDrillDown(idQuery: mainData.idQuery, obj: msg, name: nameFinal, title: mainData.query, webview: finalWebview)
                    //delegate?.sendDrillDown(idQuery: mainData.idQuery, obj: msg, name: nameFinal, title: mainData.query, webview: finalWebview, mainData: ma)
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
            }
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
        let finalWebview = mainData.type == .Webview || mainData.type == .Table ? "" : mainData.webview
        refreshManualDrillDown(newData: newData,
                         columns: mainData.columnsInfo,
                         title: mainData.title,
                         webview: finalWebview)
        /*delegate?.sendDrillDownManualDashboard(newData: newData,
                                      columns: mainData.columnsInfo,
                                      title: mainData.title,
                                      webview: finalWebview
        )*/
    }
}
extension Dashboard: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == tbMain ? dataDash.count : listDash.count
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tbMain {
            let finalSize = getSizeDashboard(row: dataDash[indexPath.row], width: self.frame.width)
            return finalSize
        } else {
            return 50
        }
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tbMain {
            let cell = DashboardComponentCell()
            cell.delegate = self
            cell.delegateSend = self
            cell.configCell(data: dataDash[indexPath.row],
                            pos: indexPath.row,
                            loading: self.dataDash[indexPath.row].loading == 2 ? 2 : loadingGeneral,
                            secondLoading: self.dataDash[indexPath.row].subDashboardModel.loading == 2 ? 2 : loadingGeneral
            )
            return cell
        }
        if tableView == tbListDashboard {
            let cell = UITableViewCell()
            cell.backgroundColor = chataDrawerBackgroundColorPrimary
            cell.tintColor = chataDrawerBackgroundColorPrimary
            cell.textLabel?.text = listDash[indexPath.row].name
            cell.textLabel?.textColor = chataDrawerTextColorPrimary
            cell.textLabel?.font = generalFont
            cell.textLabel?.textColor = chataDrawerTextColorPrimary
            return cell
        }
        return UITableViewCell()
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tbListDashboard {
            loadingGeneral = 0
            let name = "\(listDash[indexPath.row].name) ⌄"
            spinnerDashboard.setTitle(name, for: .normal)
            toggleListDashboard(false)
            dataDash = listDash[indexPath.row].data
            toggleTable()
            tbMain.reloadData()
        }
    }
    func loadTableD(table: UITableView) {
        table.delegate = self
        table.dataSource = self
        table.bounces = false
    }
    func sendText(_ text: String, _ safe: Bool) {
        
    }
    func updateComponent(text: String, first: Bool, position: Int) {
        let query = first ? dataDash[position].query : dataDash[position].secondQuery
        if first {
            loadOneDash(query: query, type: dataDash[position].type, index: position, column: dataDash[position].stringColumnIndex)
        } else {
            loadTwoDash(query: text, type: "", index: position, column: dataDash[position].stringColumnIndexSecond )
        }
    }
    func sendDrillDown(idQuery: String, obj: String, name: String) {
    }
    
    func sendDrillDownManual(newData: [[String]], columns: [ChatTableColumn], idQuery: String) {
    }
    
}
