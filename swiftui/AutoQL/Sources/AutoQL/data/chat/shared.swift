//
//  File.swift
//  
//
//  Created by Vicente Rincon on 21/02/22.
//

import Foundation
public var shared = AutoQLConfig.shared
var LANGUAGEDEVICE = "en"
var ISPROD = false

public class AutoQLConfig {
    public static let shared = AutoQLConfig()
    public var authenticationObj = Authentication(apiKey: "", domain: "", token: "")
    public var isVisible = true
    public var projectID = ""
    public var darkenBackgroundBehind = true
    public var placement = ""
    public var title = ""
    public var userDisplayName = "User"
    public var userDisplayHi = "Hi"
    public var introMessage = "Let’s dive into your data. What can I help you discover today?"
    public var inputPlaceholder = ""
    public var showMask = true
    public var maskClosable = true
    public var showHandle = true
    public var maxMessages = 12
    public var clearOnClose = false
    public var enableVoiceRecord = true
    public var demo = true
    public var defaultTab = "data-messenger"
    public var autoQLConfigObj = ConfigChat(
        enableAutocomplete: true,
        enableQueryValidation: true,
        enableQuerySuggestions: true,
        enableDrilldowns: true,
        enableColumnVisibilityManager: true,
        enableNotifications: true,
        enableNotificationTab: true,
        enableExploreQueriesTab: true
    )
    public var dataFormattingObj = DataFormatting(
        currencyCode: "USD",
        languageCode: "en-US",
        currencyDecimals: 2,
        quantityDecimals: 0,
        comparisonDisplay: "PERCENT",
        monthYearFormat: "MMM YYYY",
        dayMonthYearFormat: "MMM d YYYY"
    )
    public var themeConfigObj = ThemeConfig(
        theme: "dark",
        accentColor: "#28a8e0",
        chartColors: []
    )
    public var dashboardParameters = ConfigDashboard (
        backgroundDashboard: "#fafafa",
        titleColor: "#28A8E0"
    )
    public func resetData(){
        AutoQLConfig.shared.authenticationObj = Authentication(apiKey: "", domain: "", token: "")
        AutoQLConfig.shared.projectID = ""
        TopicService.instance.topics = []
        UrlAutoQl.instance.urlDynamic = ""
    }
    func show(){
        
    }
    /*public func loadLangDefaul(){
        let bundle = Bundle(for: type(of: self))
        let txtV = loadTT(bundle: bundle, key: "dm10")
        let txt = loadTT(bundle: bundle, key: "dm11")
        let txtD = loadTT(bundle: bundle, key: "dm12")
        introMessage = txtV
        userDisplayHi = txt
        inputPlaceholder = txtD
        
    }*/
}
public struct Authentication {
    public var apiKey: String
    public var domain: String
    public var token: String
    public init(apiKey: String = "",
         domain: String = "",
         token: String = "") {
        self.apiKey = apiKey
        self.domain = domain
        self.token = token
    }
}
public struct ConfigChat {
    public var enableAutocomplete : Bool
    public var enableQueryValidation : Bool
    public var enableQuerySuggestions : Bool
    public var enableDrilldowns : Bool
    public var enableColumnVisibilityManager : Bool
    public var enableNotifications : Bool
    public var enableNotificationTab: Bool
    public var enableExploreQueriesTab: Bool
}
public struct DataFormatting {
    public var currencyCode : String
    public var languageCode : String
    public var currencyDecimals : Int
    public var quantityDecimals : Int
    public var comparisonDisplay : String
    public var monthYearFormat : String
    public var dayMonthYearFormat : String
}
public struct ThemeConfig {
    public var theme : String
    public var accentColor : String
    public var chartColors : [String]
}
public struct ConfigDashboard {
    public var backgroundDashboard: String
    public var titleColor: String
}
