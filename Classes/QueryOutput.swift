//
//  QueryOutput.swift
//  chata
//
//  Created by Vicente Rincon on 16/09/20.
//

import Foundation
import WebKit
public class QueryOutput: UIView, WKNavigationDelegate, SuggestionViewDelegate, SafetynetViewDelegate {
    public var authenticationOutput: authentication = authentication()
    public var queryResponse: [String: Any] = [:]
    public var displayType: String = "stacked_column"
    var finalComponent = ChatComponentModel()
    var wvMain = WKWebView()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    public func start(mainView: UIView, subViewTop: UIView? = nil) {
        mainView.addSubview(self)
        if let sub = subViewTop {
            self.edgeTo(mainView, safeArea: .midTopBottom2, sub)
        } else {
            self.edgeTo(mainView, safeArea: .none)
        }
        DataConfig.authenticationObj = self.authenticationOutput
        wsUrlDynamic = self.authenticationOutput.domain
    }
    private func loadType() {
        switch finalComponent.type {
        case .Safetynet:
            getSafetynet()
        case .Suggestion:
            loadSuggestion()
        case .Introduction, .IntroductionInteractive:
            loadIntro()
        case .Bar, .Line, .Column, .Pie, .Bubble, .Heatmap, .StackBar, .StackColumn, .Table, .Webview, .StackArea:
            loadWebview()
        case .QueryBuilder:
            print("no supported for dashboard")
        }
    }
    private func getSafetynet() {
        let newView = SafetynetView()
        self.addSubview(newView)
        newView.tag = 1
        let finalStr = finalComponent.options.count > 0 ? finalComponent.options[0] : ""
        let finalHeight = getSizeSafetynet(originalQuery: finalStr)
        newView.edgeTo(self, safeArea: .topHeight, height: finalHeight, padding: 16)
        newView.loadConfig(finalComponent, lastQueryFinal: false)
        newView.delegateSafetynet = self
        self.sizeToFit()
        loadingView(mainView: self, inView: self, false)
    }
    private func loadSuggestion() {
        let newView = SuggestionView()
        newView.delegateSuggestion = self
        newView.tag = 1
        newView.loadConfig(options: finalComponent.options, query: finalComponent.text)
        self.addSubview(newView)
        newView.edgeTo(self, safeArea: .noneTopPadding, height: 16, padding: 16)
        self.sizeToFit()
        loadingView(mainView: self, inView: self, false)
    }
    private func loadIntro() {
        let lblComponent = UILabel()
        lblComponent.setConfig(text: finalComponent.text,
                               textColor: chataDrawerTextColorPrimary,
                               align: .center)
        lblComponent.tag = 1
        self.addSubview(lblComponent)
        lblComponent.edgeTo(self, safeArea: .noneTopPadding, height: 16, padding: 16)
        loadingView(mainView: self, inView: self, false)
    }
    private func loadWebview() {
        self.addSubview(wvMain)
        wvMain.tag = 1
        wvMain.edgeTo(self, safeArea: .noneTopPadding, height: 16, padding: 16)
        self.wvMain.loadHTMLString(finalComponent.webView, baseURL: nil)
    }
    public func loadComponent(text: String, notification: Bool = false){
        loadingView(mainView: self, inView: self)
        if notification {
            loadNotificationQuery(idQuery: text)
        } else {
            loadSafe(query: text)
        }
    }
    private func loadNotificationQuery(idQuery: String) {
        NotificationServices.instance.getQueryNotification(idQuery: idQuery) { (component) in
            DispatchQueue.main.async {
                var finalComponent = component
                if component.text.contains("want"){
                    finalComponent.text = "Internal Service Error: Our system is experiencing an unexpected error. We're aware of this issue and are working to fix it as soon as possible."
                }
                self.loadFinalComponent(componentF: finalComponent)
            }
        }
    }
    private func loadSafe(query: String) {
        self.removeView(tag: 1)
        ChataServices.instance.getSafetynet(query: query) { (suggestion, responseMsg) in
            if suggestion.count == 0 {
                self.loadWS(query: query)
            } else {
                let finalComponentF = ChatComponentModel(
                    type: .Safetynet,
                    text: "I need your help matching a term you used to the exact corresponding term in your database. Verify by selecting the correct term from the menu below:",
                    user: true,
                    webView: "",
                    numRow: 0,
                    options: [query],
                    fullSuggestions: suggestion
                )
                DispatchQueue.main.async {
                    self.loadFinalComponent(componentF: finalComponentF)
                }
            }
        }
    }
    private func loadWS(query: String) {
        var type = displayType == "default" ? "" : displayType
        type = whiteListTypes(type: type) ? type : ""
        ChataServices.instance.getDataChat(query: query, type: type, queryOutput: true) { (component) in
            if component.referenceID == "1.1.430" || component.referenceID == "1.1.431" {
                if DataConfig.autoQLConfigObj.enableQuerySuggestions{
                    ChataServices.instance.getSuggestionsQueries(query: query, relatedQuery: component.idQuery) { (options) in
                        DispatchQueue.main.async {
                            self.finalComponent = component
                            self.finalComponent.type = .Suggestion
                            self.finalComponent.idQuery = component.idQuery+"suggestion"
                            self.finalComponent.options = options
                            self.loadType()
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.loadFinalComponent(componentF: component)
                }
            }
        }
    }
    func loadFinalComponent(componentF: ChatComponentModel) {
        self.finalComponent = componentF
        self.loadType()
    }
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingView(mainView: self, inView: self, false)
    }
    func selectSuggest(query: String) {
        loadingView(mainView: self, inView: self)
        loadSafe(query: query)
    }
    func runquery(query: String) {
        loadingView(mainView: self, inView: self)
        loadSafe(query: query)
    }
}

