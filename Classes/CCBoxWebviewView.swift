//
//  BoxWebviewView.swift
//  chata
//
//  Created by Vicente Rincon on 04/03/20.
//

import Foundation
import WebKit
protocol BoxWebviewViewDelegate: class{
    func sendDrillDown(idQuery: String, obj: String, name: String)
    func sendDrillDownManual(newData: [[String]], columns: [ChatTableColumn], idQuery: String)
}
class BoxWebviewView: UIView, WKNavigationDelegate, WKScriptMessageHandler {
    var wbMain: WKWebView = WKWebView()
    var imageView = UIImageView(image: nil)
    var idQuery = ""
    var dataMain = ChatComponentModel()
    var drilldown = false
    weak var delegate: BoxWebviewViewDelegate?
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func updateType(newType: ChatComponentType) {
        dataMain.type = newType
    }
    func loadWebview(strWebview: String, idQuery: String) {
        self.idQuery = idQuery
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
        self.wbMain = WKWebView(frame: self.bounds, configuration: config)
        wbMain.navigationDelegate = self
        wbMain.scrollView.bounces = false
        wbMain.isOpaque = false
        wbMain.isUserInteractionEnabled = true
        wbMain.scrollView.isScrollEnabled = true
        self.addSubview(wbMain)
        self.wbMain.edgeTo(self, safeArea: .nonePadding, height: 8, padding: 10)
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: "gifBalls", ofType: "gif")
        let url = URL(fileURLWithPath: path!)
        imageView.loadGif(url: url)
        imageView.tag = 1
        imageView = imageView.changeColor()
        self.addSubview(imageView)
        imageView.edgeTo(self, safeArea: .centerSize, height: 50, padding: 100)
        self.wbMain.loadHTMLString(strWebview, baseURL: nil)
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        imageView.isHidden = false
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        for sub in self.subviews {
            if let viewWithTag = sub.viewWithTag(1) {
                viewWithTag.removeFromSuperview()
            }
        }
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let table = dataMain.type == .Webview || dataMain.type == .Table
        if dataMain.columnsInfo.count > 3 && table {
        } else {
            if message.name == "drillDown" && DataConfig.autoQLConfigObj.enableDrilldowns && !DRILLDOWNACTIVE
            {
                if dataMain.columnsInfo.count > 3 {
                    newDrilldown(data: message.body as? String ?? "")
                } else{
                    DRILLDOWNACTIVE = true
                    let name = dataMain.columnsInfo.count > 0 ? dataMain.columnsInfo[0].originalName : ""
                    let name2 = dataMain.columnsInfo.count > 1 ? dataMain.columnsInfo[1].originalName : ""
                    let nameFinal = (message.body as? String ?? "")?.contains("_") ?? false ? "\(name)º\(name2)" : name
                    delegate?.sendDrillDown(idQuery: idQuery, obj: message.body as? String ?? "", name: nameFinal)
                }
            }
        }
    }
    func newDrilldown(data: String) {
        var position = -1
        dataMain.columns.enumerated().forEach { (index, type) in
            if type == .date{
                if position == -1{
                    position = index
                }
            }
        }
        var newData: [[String]] = []
        dataMain.rowsClean.forEach { (row) in
            row.forEach { (column) in
                if column == data {
                    newData.append(row)
                }
            }
        }
        delegate?.sendDrillDownManual(newData: newData, columns: dataMain.columnsInfo, idQuery: dataMain.idQuery)
    }
}
