//
//  QueryInputView.swift
//  chata_Example
//
//  Created by Vicente Rincon on 11/09/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import chata
class QueryInputView: UIView, QueryInputDelegate {
    let inputQuery = QueryInput()
    let outputQuery = QueryOutput()
    let token = "eyJ0eXAiOiAiSldUIiwgImFsZyI6ICJSUzI1NiIsICJraWQiOiAiNzUxZmYzY2YxMjA2ZGUwODJhNzM1MjY5OTI2ZDg0NTgzYjcyOTZmNCJ9.eyJpYXQiOiAxNjAwMTE2MTE0LCAiZXhwIjogMTYwMDEzNzcxNCwgImlzcyI6ICJkZW1vMy1qd3RhY2NvdW50QHN0YWdpbmctMjQ1NTE0LmlhbS5nc2VydmljZWFjY291bnQuY29tIiwgImF1ZCI6ICJkZW1vMy1zdGFnaW5nLmNoYXRhLmlvIiwgInN1YiI6ICJkZW1vMy1qd3RhY2NvdW50QHN0YWdpbmctMjQ1NTE0LmlhbS5nc2VydmljZWFjY291bnQuY29tIiwgImVtYWlsIjogImRlbW8zLWp3dGFjY291bnRAc3RhZ2luZy0yNDU1MTQuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLCAicHJvamVjdF9pZCI6ICJzcGlyYS1kZW1vMyIsICJ1c2VyX2lkIjogInZpY2VudGVAcmlucm8uY29tLm14IiwgImRpc3BsYXlfbmFtZSI6ICJ2aWNlbnRlQHJpbnJvLmNvbS5teCIsICJyZXNvdXJjZV9hY2Nlc3MiOiBbIi9hdXRvcWwvYXBpL3YxL3J1bGVzIiwgIi9hdXRvcWwvYXBpL3YxL25vdGlmaWNhdGlvbnMvKioiLCAiL2F1dG9xbC9hcGkvdjEvcnVsZXMvKioiLCAiL2F1dG9xbC9hcGkvdjEvcXVlcnkvKioiLCAiL2F1dG9xbC9hcGkvdjEvcXVlcnkiXX0=.XRcFexfkZeXtjCpGopVnmN8zsqJ8aMgJkEomgISmz2mfGyPoW4xrCYctfXa3Gp4vfYaoqiYtYsAG1NrlRfGPpeNK8o9ZHCocj0Nv5iE8e_wE0aOKAL91HMT76brwNYsaDxY8gv3rJS_AR9o3QzSp90VGAlREjDYJpaeJGNF9OBKton581I7COfmBDxzgZWyRDWnPA9qGUk6LoeaVoNxeN4uOM8rrKOtHeTYHLKMK5UYN6JbKvnS4JhEt0AEE80w8pS7J9emUIfy4oVDbaaCAQrjdhPGAyrl0HtR1QxUg-ySjsp0C9NI5LVJID9xhGAUbAwF0DdrsM9teVvqWhGq2mg=="
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        // spira
        //loadTable()
    }
    func loadView() {
        inputQuery.authenticationInput = authentication(apiKey: "AIzaSyD4ewBvQdgdYfXl3yIzXbVaSyWGOcRFVeU", domain: "https://spira-staging.chata.io", token: token)
        inputQuery.start(mainView: self)
        inputQuery.delegate = self
        outputQuery.start(mainView: self, subView: inputQuery)
    }
    func requestQuery(text: String) {
        print(text)
        outputQuery.loadComponent(text: text)
    }
    
}
