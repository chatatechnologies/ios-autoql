//
//  constans.swift
//  chata
//
//  Created by Vicente Rincon on 18/02/20.
//

import Foundation
public var DataConfig = DataConfiguration.instance
public class DataConfiguration {
    static let instance = DataConfiguration()
    public var authenticationObj = authentication(apiKey: "", domain: "", token: "")
    public var isVisible = true
    public var placement = "right"
    public var title = "Data Messenger"
    public var userDisplayName = "User"
    public var introMessage = "I'm here to help you access, search and analyze your data."
    public var inputPlaceholder = "Type your queries here"
    public var showMask = true
    public var maskClosable = true
    public var showHandle = true
    public var maxMessages = 10
    public var clearOnClose = false
    public var enableVoiceRecord = true
    public var autoQLConfigObj = autoQLConfig(
        enableAutocomplete: true,
        enableQueryValidation: true,
        enableQuerySuggestions: true,
        enableDrilldowns: true,
        enableColumnVisibilityManager: true
    )
    public var dataFormattingObj = dataFormatting(
        currencyCode: "USD",
        languageCode: "en-US",
        currencyDecimals: 2,
        quantityDecimals: 1,
        comparisonDisplay: "PERCENT",
        monthYearFormat: "MMM YYYY",
        dayMonthYearFormat: "MMM D, YYYY"
    )
    public var themeConfigObj = themeConfig(
        theme: "light",
        accentColor: "#28a8e0",
        chartColors: ["#26A7E9", "#A5CD39", "#DD6A6A", "#FFA700", "#00C1B2"]
    )
    //public var mainChatView = Chat()
    // public var chatView = Chat()
    func show(){
        
    }
    func resetData() {
        authenticationObj = authentication(apiKey: "", domain: "", token: "")
        isVisible = false
        placement = "right"
        title = "Data Messenger"
        userDisplayName = "User"
        introMessage = "Hi User! I'm here to help you access, search and analyze your data."
        inputPlaceholder = "Type your queries here"
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
            enableColumnVisibilityManager: true
        )
        dataFormattingObj = dataFormatting(
            currencyCode: "USD",
            languageCode: "en-US",
            currencyDecimals: 2,
            quantityDecimals: 1,
            comparisonDisplay: "PERCENT",
            monthYearFormat: "MMM YYYY",
            dayMonthYearFormat: "MMM D, YYYY"
        )
        themeConfigObj = themeConfig(
            theme: "light",
            accentColor: "#28a8e0",
            chartColors: ["#26A7E9", "#A5CD39", "#DD6A6A", "#FFA700", "#00C1B2"]
        )
    }
}
public struct authentication {
    public var apiKey: String
    public var domain: String
    public var token: String
    public init(apiKey: String,
         domain: String,
         token: String) {
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
