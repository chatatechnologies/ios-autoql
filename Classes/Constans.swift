//
//  constans.swift
//  chata
//
//  Created by Vicente Rincon on 18/02/20.
//

import Foundation
public var DataConfig = DataConfiguration.instance
var generalFont = UIFont.systemFont(ofSize: 16)
let notifSendText = Notification.Name("sendText")
let notifTypingText = Notification.Name("typingText")
let notifcloseQueryTips = Notification.Name("closeQT")
let notifAlert = Notification.Name("alert")
var LOGIN: Bool = false
var notificationsAttempts: Int = 0
private var defaultTitle = "Data Messenger"
private var defaultPlace = "right"
private var defaultPlaceholder = "Type your queries here"
private var defaultColors = ["#26A7E9", "#A5CD39", "#DD6A6A", "#FFA700", "#00C1B2"]
public class DataConfiguration {
    static let instance = DataConfiguration()
    public var authenticationObj = authentication(apiKey: "", domain: "", token: "")
    public var isVisible = true
    public var darkenBackgroundBehind = true
    public var placement = defaultPlace
    public var title = defaultTitle
    public var userDisplayName = "User"
    public var introMessage = "Let’s dive into your data. What can I help you discover today?"
    public var inputPlaceholder = defaultPlaceholder
    public var showMask = true
    public var maskClosable = true
    public var showHandle = true
    public var maxMessages = 12
    public var clearOnClose = false
    public var enableVoiceRecord = true
    public var demo = true
    public var defaultTab = "data-messenger"
    public var autoQLConfigObj = autoQLConfig(
        enableAutocomplete: true,
        enableQueryValidation: true,
        enableQuerySuggestions: true,
        enableDrilldowns: true,
        enableColumnVisibilityManager: true,
        enableNotifications: true,
        enableNotificationTab: true,
        enableExploreQueriesTab: true
    )
    public var dataFormattingObj = dataFormatting(
        currencyCode: "USD",
        languageCode: "en-US",
        currencyDecimals: 2,
        quantityDecimals: 0,
        comparisonDisplay: "PERCENT",
        monthYearFormat: "MMM YYYY",
        dayMonthYearFormat: "MMM d YYYY"
    )
    public var themeConfigObj = themeConfig(
        theme: "light",
        accentColor: "#28a8e0",
        chartColors: defaultColors
    )
    public var dashboardParameters = dashboardParametersConfig (
        backgroundDashboard: "#fafafa",
        titleColor: "#28A8E0"
    )
    func show(){
        
    }
    func resetData() {
        authenticationObj = authentication(apiKey: "", domain: "", token: "")
        isVisible = false
        placement = defaultPlace
        title = defaultTitle
        userDisplayName = "User"
        introMessage = "Hi User! Let’s dive into your data. What can I help you discover today?"
        inputPlaceholder = defaultPlaceholder
        showMask = true
        maskClosable = true
        showHandle = true
        maxMessages = 10
        clearOnClose = false
        enableVoiceRecord = true
        autoQLConfigObj = autoQLConfig(
            enableAutocomplete: true,
            enableQueryValidation: true,
            enableQuerySuggestions: true,
            enableDrilldowns: true,
            enableColumnVisibilityManager: true,
            enableNotifications: true,
            enableNotificationTab: true,
            enableExploreQueriesTab: true
        )
        dataFormattingObj = dataFormatting(
            currencyCode: "USD",
            languageCode: "en-US",
            currencyDecimals: 0,
            quantityDecimals: 0,
            comparisonDisplay: "PERCENT",
            monthYearFormat: "MMM YYYY",
            dayMonthYearFormat: "MMM d YYYY"
        )
        themeConfigObj = themeConfig(
            theme: "light",
            accentColor: "#28a8e0",
            chartColors: defaultColors
        )
        dashboardParameters = dashboardParametersConfig (
            backgroundDashboard: "#fafafa",
            titleColor: "#28A8E0"
        )
    }
}
public struct authentication {
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
public struct autoQLConfig {
    public var enableAutocomplete : Bool
    public var enableQueryValidation : Bool
    public var enableQuerySuggestions : Bool
    public var enableDrilldowns : Bool
    public var enableColumnVisibilityManager : Bool
    public var enableNotifications : Bool
    public var enableNotificationTab: Bool
    public var enableExploreQueriesTab: Bool
}
public struct dataFormatting {
    public var currencyCode : String
    public var languageCode : String
    public var currencyDecimals : Int
    public var quantityDecimals : Int
    public var comparisonDisplay : String
    public var monthYearFormat : String
    public var dayMonthYearFormat : String
}
public struct themeConfig {
    public var theme : String
    public var accentColor : String
    public var chartColors : [String]
}
public struct dashboardParametersConfig {
    public var backgroundDashboard: String
    public var titleColor: String
}
