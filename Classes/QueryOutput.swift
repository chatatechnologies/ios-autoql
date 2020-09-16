//
//  QueryOutput.swift
//  chata
//
//  Created by Vicente Rincon on 16/09/20.
//

import Foundation
import WebKit
public class QueryOutput: UIView, WKNavigationDelegate{
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
        self.backgroundColor = .black
        DataConfig.authenticationObj = self.authenticationInput
        wsUrlDynamic = self.authenticationInput.domain
        generateComponents()
        wvMain.backgroundColor = .blue
        //self.addSubview(wvMain)
        wvMain.edgeTo(self, safeArea: .nonePadding, padding: 16)
    }
    private func generateComponents() {
        
    }
}

