//
//  QueryOutput.swift
//  chata
//
//  Created by Vicente Rincon on 16/09/20.
//

import Foundation
import WebKit
public class QueryOutput: UIView, WKNavigationDelegate, SuggestionViewDelegate, SafetynetViewDelegate {
    public var authenticationInput: authentication = authentication()
    public var queryResponse: [String: Any] = [:]
    //public var queryInputRef = nil
    public var displayType: String = ""
    public var height: Int = 0
    public var width: Int = 0
    public var activeChartElementKey: String = ""
    public var renderTooltips: Bool = true
    public var autoSelectQueryValidationSuggestion: Bool = true
    public var queryValidationSelections : String = ""
    public var renderSuggestionsAsDropdown: Bool = false
    public var suggestionSelection: String = ""
    var finalComponent = ChatComponentModel()
    //public var dataFormatting: [S
    var wvMain = WKWebView()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    public func start(mainView: UIView, subView: UIView) {
        mainView.addSubview(self)
        self.edgeTo(mainView, safeArea: .bottomPaddingtoTop, subView)
        //DataConfig.authenticationObj = self.authenticationInput
        //wsUrlDynamic = self.authenticationInput.domain
        
    }
    private func loadType() {
        switch finalComponent.type {
        case .Safetynet:
            getSafetynet()
        case .Suggestion:
            loadSuggestion()
        case .Introduction:
            loadIntro()
            //loadIntro(view: view, text: text)
        case .Bar, .Line, .Column, .Pie, .Bubble, .Heatmap, .StackBar, .StackColumn, .Table, .Webview, .StackArea:
            loadWebview()
            //loadWebView(view: view, webview: webview, loading: loading)
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
        newView.edgeTo(self, safeArea: .topPadding, height: finalHeight, padding: 16)
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
        //newView.loadWebview(strWebview: data.webView)
        self.addSubview(newView)
        newView.edgeTo(self, safeArea: .nonePadding, height: 16, padding: 16)
        self.sizeToFit()
        loadingView(mainView: self, inView: self, false)
    }
    private func loadIntro() {
        let lblComponent = UILabel()
        lblComponent.font = generalFont
        lblComponent.text = finalComponent.text
        lblComponent.tag = 1
        lblComponent.numberOfLines = 0
        lblComponent.textColor = chataDrawerTextColorPrimary
        lblComponent.textAlignment = .center
        self.addSubview(lblComponent)
        lblComponent.edgeTo(self, safeArea: .nonePadding, height: 16, padding: 16)
        loadingView(mainView: self, inView: self, false)
    }
    private func loadWebview() {
        self.addSubview(wvMain)
        wvMain.tag = 1
        wvMain.edgeTo(self, safeArea: .nonePadding, height: 16, padding: 16)
        self.wvMain.loadHTMLString(finalComponent.webView, baseURL: nil)
    }
    public func loadComponent(text: String){
        loadingView(mainView: self, inView: self)
        loadSafe(query: text)
    }
    private func loadSafe(query: String) {
        self.removeView(tag: 1)
        ChataServices.instance.getSafetynet(query: query) { (suggestion) in
            if suggestion.count == 0 {
                self.loadWS(query: query)
            } else {
                let finalComponentF = ChatComponentModel(
                    type: .Safetynet,
                    text: "Verify by selecting the correct term from the menu below:",
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
        ChataServices.instance.getDataChat(query: query) { (component) in
            if component.referenceID == "1.1.430" || component.referenceID == "1.1.431" {
                ChataServices.instance.getSuggestionsQueries(query: query) { (options) in
                    DispatchQueue.main.async {
                        self.finalComponent = component
                        self.finalComponent.type = .Suggestion
                        self.finalComponent.options = options
                        self.loadType()
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

