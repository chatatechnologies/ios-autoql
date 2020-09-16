//
//  QueryOutput.swift
//  chata
//
//  Created by Vicente Rincon on 16/09/20.
//

import Foundation
public class QueryOutput: UIView{
    public var authenticationInput: authentication = authentication()
    public var autoQLConfig: autoQLConfigInput = autoQLConfigInput()
    public var themeConfig: themeConfigInput = themeConfigInput()
    public var isDisabled: Bool = false
    public var placeholder: String = "Type Your Queries here"
    public var showLoadingDots: Bool = true
    public var showChataIcon: Bool = true
    public var enableVoiceRecord: Bool = true
    public var autoCompletePlacement: String = "above"
    public var inputPlacement: String = "top"
    /*
     queryResponse (Required)    Object    -
     queryInputRef    Instance of <QueryInput/>    undefined
     displayType    String    undefined
     height    Number    undefined
     width    Number    undefined
     onDataClick    Function    (groupByObject, queryID, activeKey) => {}
     activeChartElementKey    String    undefined
     renderTooltips    Boolean    true
     onQueryValidationSelectOption    Function    () => {}
     autoSelectQueryValidationSuggestion    Boolean    true
     queryValidationSelections    Array of Suggestion Objects    undefined
     renderSuggestionsAsDropdown    Boolean    false
     suggestionSelection    String    undefined
     dataFormatting    Object    {}
     themeConfig
     */
    let tfMain = UITextField()
    let btnSend = UIButton()
    let tbAutoComplete = UITableView()
    var isMic = true
    var arrAutocomplete: [String] = []
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    public func start(mainView: UIView) {
        let finalAlign: DViewSafeArea = inputPlacement == "top" ? .topPadding : .bottomPadding
        mainView.addSubview(self)
        self.edgeTo(mainView, safeArea: finalAlign, height: 60 )
        DataConfig.authenticationObj = self.authenticationInput
        wsUrlDynamic = self.authenticationInput.domain
        generateComponents()
    }
    private func generateComponents() {
        
    }
}

