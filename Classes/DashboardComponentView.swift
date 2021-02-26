//
//  DashboardComponent.swift
//  chata
//
//  Created by Vicente Rincon on 04/05/20.
//

import Foundation
import WebKit
protocol DashboardComponentCellDelegate: class{
    func sendDrillDown(idQuery: String, obj: String, name: String, title: String, webview: String, mainData: DashboardModel)
    func sendDrillDownManualDashboard(newData: [[String]], columns: [ChatTableColumn], title: String, webview: String, mainData: DashboardModel)
    func updateComponent(text: String, first: Bool, position: Int)
}
class DashboardComponentCell: UITableViewCell, WKNavigationDelegate, WKScriptMessageHandler, ChatViewDelegate {
    var mainData: DashboardModel = DashboardModel()
    let vwComponent = UIView()
    let vwWebview = UIView()
    let vwSecondWebview = UIView()
    var vwFather: UIView = UIApplication.shared.keyWindow!
    var wbMain = WKWebView()
    let lblMain = UILabel()
    let lblDefault = UILabel()
    var position = 0
    let btnReport = UIButton()
    var mainText = "Hit 'Execute' to run this dashboard"
    var problemMessage = ""
    var buttonReport = UIButton()
    var loadWB = true
    private var menuReportProblem: [StackSelection] = [
        StackSelection(title: "The data is incorrect", action: #selector(reportProblem), tag: 0),
        StackSelection(title: "The data is incomplete", action: #selector(reportProblem), tag: 1),
        StackSelection(title: "Other", action: #selector(reportProblem), tag: 2)
    ]
    weak var delegateSend: ChatViewDelegate?
    weak var delegate: DashboardComponentCellDelegate?
    var first = false
    //let newView = UIView()
    static var identifier: String {
        return String(describing: self)
    }
    func configCell(data: DashboardModel, pos: Int, loading: Int = 0, secondLoading: Int = 0) {
        self.backgroundColor = chataDrawerBackgroundColorPrimary
        self.contentView.backgroundColor = chataDrawerBackgroundColorPrimary
        self.mainData = data
        self.position = pos
        styleComponent()
        loadTitle()
        let secondType = ChatComponentType.withLabel(data.secondDisplayType)
        vwWebview.addSubview(buttonReport)
        let image = UIImage(named: "icReport", in: Bundle(for: type(of: self)), compatibleWith: nil)
        let image2 = image?.resizeT(maxWidthHeight: 30)
        buttonReport.setImage(image2, for: .normal)
        buttonReport.cardView()
        buttonReport.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        buttonReport.backgroundColor = chataDrawerBackgroundColorPrimary
        buttonReport.edgeTo(vwWebview, safeArea: .bottomRight, height: 30, padding: 8)
        buttonReport.isHidden = loadWB
        buttonReport.layer.zPosition = 48
        if data.splitView{
            let multiLoad = loading == 0 ? 0 : secondLoading == 2 && loading == 2 ? 2 : 1
            loadComponent(view: vwWebview, nsType: .bottomPorcent, connect: lblMain, loading: multiLoad, type: data.type )
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
    @IBAction func showMenu(_ sender: AnyObject){
        genereMenuReport()
    }
    @IBAction func hideMenu(_ sender: AnyObject){
        superview?.removeView(tag: 2)
    }
    func genereMenuReport() {
        let vwBackgroundMenu = UIView()
        superview?.addSubview(vwBackgroundMenu)
        vwBackgroundMenu.edgeTo(vwFather, safeArea: .none)
        vwBackgroundMenu.tag = 2
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideMenu))
        vwBackgroundMenu.addGestureRecognizer(gesture)
        let vwMenu = UIView()
        vwMenu.backgroundColor = chataDrawerBackgroundColorPrimary
        vwBackgroundMenu.addSubview(vwMenu)
        vwMenu.cardView()
        vwMenu.edgeTo(self, safeArea: .dropDownBottomHeightLeft, height: 120, buttonReport)
        /*contentView.subviews.forEach { (subView) in
            if subView.tag == 1 {
                let finalSafe: DViewSafeArea = .dropDownBottomHeightLeft
                /*if self.mainData.type == .Introduction {
                    finalSafe = .dropDownBottomHeight
                } else if lastQuery {
                    let rowValidation = self.mainData.dataRows.count < 3
                    finalSafe = rowValidation ? .dropDownBottomHeightLeft : finalSafe
                }*/
                vwMenu.edgeTo(self, safeArea: finalSafe, height: 120, subView)
            }
        }*/
        let newStack = UIStackView()
        newStack.getSide(axis: .vertical)
        vwMenu.addSubview(newStack)
        newStack.edgeTo(vwMenu, safeArea: .none)
        menuReportProblem.forEach { (newItem) in
            let newView = UIButton()
            newView.setTitle(newItem.title, for: .normal)
            newView.titleLabel?.font = generalFont
            newView.setTitleColor(chataDrawerTextColorPrimary, for: .normal)
            newView.addTarget(self, action: newItem.action, for: .touchUpInside)
            newView.tag = newItem.tag
            newStack.addArrangedSubview(newView)
            newView.edgeTo(newStack, safeArea: .fullStackH)
            newView.clipsToBounds = true
        }
    }
    func styleComponent() {
        self.contentView.backgroundColor = chataDrawerBackgroundColorSecondary
        vwComponent.cardView()
        vwComponent.backgroundColor = chataDrawerBackgroundColorPrimary
        self.contentView.addSubview(vwComponent)
        vwComponent.edgeTo(self, safeArea: .noneTopPadding, height: 8, padding: 1)
    }
    func loadComponent(view: UIView, nsType: DViewSafeArea = .midTopBottom2, connect: UIView, loading: Int = 0, type: ChatComponentType) {
        vwComponent.addSubview(view)
        vwComponent.backgroundColor = chataDrawerBackgroundColorPrimary
        view.edgeTo(vwComponent, safeArea: nsType, height: 0.38, connect,  padding: 8)
        loadDefault(view: view, loading: loading, type: type)
    }
    func loadTitle() {
        lblMain.text = mainData.title
        vwComponent.addSubview(lblMain)
        lblMain.edgeTo(vwComponent, safeArea: .topHeight, height: 30, padding: 8)
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
        case .Introduction, .IntroductionInteractive:
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
        newView.cardView()
        view.addSubview(newView)
        newView.edgeTo(view, safeArea: .paddingTop)
        self.sizeToFit()
    }
    func loadWebView(view: UIView, webview: String, loading: Int = 0){
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
            self.wbMain.edgeTo(view, safeArea: .noneBottom, secondPadding: 40)
            loaderWebview(view: view, type2: .Webview)
            buttonReport.isHidden = false
            buttonReport.layer.zPosition = 48
            loadWB = false
            wbMain.layer.zPosition = 49
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
        let finalWebview = mainData.type == .Webview || mainData.type == .Table ? "" : mainData.webview
        delegate?.sendDrillDown(idQuery: mainData.idQuery, obj: "", name: "", title: mainData.query, webview: finalWebview, mainData: mainData)
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
                    delegate?.sendDrillDown(idQuery: mainData.idQuery, obj: msg, name: nameFinal, title: mainData.query, webview: finalWebview, mainData: mainData)
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
        delegate?.sendDrillDownManualDashboard(newData: newData,
                                      columns: mainData.columnsInfo,
                                      title: mainData.title,
                                      webview: finalWebview,
                                      mainData: mainData
        )
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loaderWebview(false, view: webView.superview ?? UIView(), type2: .Webview)
    }
    func sendText(_ text: String, _ safe: Bool) {
        delegate?.updateComponent(text: text, first: safe, position: position)
    }
    
    func sendDrillDown(idQuery: String, obj: String, name: String) {
        
    }
    func sendDrillDownManual(newData: [[String]], columns: [ChatTableColumn], idQuery: String) {
        
    }
    @IBAction func reportProblem(_ sender: UIButton){
        switch sender.tag {
        case 0:
            showAlertResult(msg: "The data is incorrect")
        case 1:
            showAlertResult(msg: "The data is incomplete")
        case 2:
            generatePopUp()
        default:
            print("error")
        }
        superview?.removeView(tag: 2)
    }
    func showAlertResult(msg: String) {
        let newAlert = UIAlertController(title: "", message: "Thank you for your feedback", preferredStyle: .alert)
        newAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        var finalID = mainData.idQuery
        if finalID.contains("drilldown"){
            let newFinalID = finalID.components(separatedBy: "drilldown")
            finalID = newFinalID[0]
        }
        ChataServices.instance.reportProblem(queryID: finalID, problemType: msg) { (success) in
            DispatchQueue.main.async {
                newAlert.message = success ? "Thank you for your feedback" : "Error in report"
                UIApplication.shared.keyWindow?.rootViewController?.present(newAlert, animated: true, completion: nil)
            }
        }
    }
    @IBAction func closeModal(_ sender: AnyObject) {
        vwFather.removeView(tag: 200)
    }
    func generatePopUp () {
        let vwBackgroundMenu = UIView()
        vwBackgroundMenu.tag = 200
        vwBackgroundMenu.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        vwFather.addSubview(vwBackgroundMenu)
        vwBackgroundMenu.edgeTo(vwFather, safeArea: .none)
        let newView = UIView()
        newView.backgroundColor = chataDrawerBackgroundColorPrimary
        newView.cardView()
        vwBackgroundMenu.addSubview(newView)
        newView.edgeTo(vwBackgroundMenu, safeArea: .centerSizeUp, height: 260, padding: 300)
        let lblTitle = UILabel()
        lblTitle.textColor = chataDrawerTextColorPrimary
        lblTitle.text = "Report Problem"
        newView.addSubview(lblTitle)
        lblTitle.edgeTo(newView, safeArea: .topHeight, height: 50)
        lblTitle.font = generalFont
        lblTitle.textAlignment = .center
        let buttonCancel = UIButton()
        buttonCancel.setTitle("✕", for: .normal)
        buttonCancel.setTitleColor(chataDrawerBorderColor, for: .normal)
        buttonCancel.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        newView.addSubview(buttonCancel)
        buttonCancel.edgeTo(newView, safeArea: .alignViewLeft, height: 50, lblTitle)
        let lblInfo = UILabel()
        lblInfo.text = "Please tell us more about the problem you are experiencing:"
        newView.addSubview(lblInfo)
        lblInfo.edgeTo(newView, safeArea: .topHeightPadding, height: 50, lblTitle, padding: 16)
        lblInfo.font = generalFont
        lblInfo.numberOfLines = 0
        lblInfo.textAlignment = .center
        lblInfo.textColor = chataDrawerTextColorPrimary
        let tfReport = UITextField()
        tfReport.font = generalFont
        tfReport.textColor = chataDrawerTextColorPrimary
        newView.addSubview(tfReport)
        tfReport.edgeTo(newView, safeArea: .topHeightPadding, height: 70, lblInfo, padding: 16)
        tfReport.cardView()
        tfReport.setLeftPaddingPoints(10)
        tfReport.configStyle()
        tfReport.addTarget(self, action: #selector(actionTyping), for: .editingChanged)
        let stackView = UIStackView()
        stackView.getSide()
        newView.addSubview(stackView)
        stackView.edgeTo(newView, safeArea:.midTopBottom2, tfReport, padding: 16)
        let btnCancel = UIButton()
        btnCancel.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        btnCancel.cardView()
        btnCancel.setTitleColor(chataDrawerTextColorPrimary, for: .normal)
        btnCancel.setTitle("Cancel", for: .normal)
        stackView.addArrangedSubview(btnCancel)
        btnCancel.edgeTo(stackView, safeArea: .fullStackV, height: 100)
        btnReport.cardView()
        btnReport.backgroundColor = chataDrawerBorderColor
        btnReport.setTitle("Report", for: .normal)
        btnReport.addTarget(self, action: #selector(reportProblemName), for: .touchUpInside)
        stackView.addArrangedSubview(btnReport)
        btnReport.edgeTo(stackView, safeArea: .fullStackV, height: 100)
    }
    @objc func reportProblemName(_ sender: UIButton) {
        vwFather.removeView(tag: 200)
        showAlertResult(msg: problemMessage)
    }
    @objc func actionTyping(_ sender: UITextField) {
        let valid = (sender.text ?? "") != ""
        UIView.animate(withDuration: 0.3) {
            self.btnReport.backgroundColor = valid ? chataDrawerAccentColor : chataDrawerBorderColor
        }
        btnReport.isEnabled = valid
        problemMessage = sender.text ?? ""
    }
}
