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
class QueryInputView: UIView {
    let inputQuery = QueryInput()
    let token = "eyJ0eXAiOiAiSldUIiwgImFsZyI6ICJSUzI1NiIsICJraWQiOiAiNzUxZmYzY2YxMjA2ZGUwODJhNzM1MjY5OTI2ZDg0NTgzYjcyOTZmNCJ9.eyJpYXQiOiAxNjAwMTA0MzQyLCAiZXhwIjogMTYwMDEyNTk0MiwgImlzcyI6ICJkZW1vMy1qd3RhY2NvdW50QHN0YWdpbmctMjQ1NTE0LmlhbS5nc2VydmljZWFjY291bnQuY29tIiwgImF1ZCI6ICJkZW1vMy1zdGFnaW5nLmNoYXRhLmlvIiwgInN1YiI6ICJkZW1vMy1qd3RhY2NvdW50QHN0YWdpbmctMjQ1NTE0LmlhbS5nc2VydmljZWFjY291bnQuY29tIiwgImVtYWlsIjogImRlbW8zLWp3dGFjY291bnRAc3RhZ2luZy0yNDU1MTQuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLCAicHJvamVjdF9pZCI6ICJzcGlyYS1kZW1vMyIsICJ1c2VyX2lkIjogImNhcmxvc0ByaW5yby5jb20ubXgiLCAiZGlzcGxheV9uYW1lIjogImNhcmxvc0ByaW5yby5jb20ubXgiLCAicmVzb3VyY2VfYWNjZXNzIjogWyIvYXV0b3FsL2FwaS92MS9xdWVyeSIsICIvYXV0b3FsL2FwaS92MS9ydWxlcyIsICIvYXV0b3FsL2FwaS92MS9ub3RpZmljYXRpb25zLyoqIiwgIi9hdXRvcWwvYXBpL3YxL3J1bGVzLyoqIiwgIi9hdXRvcWwvYXBpL3YxL3F1ZXJ5LyoqIl19.nYcKFFvIR0Cek4xS4gtOo-N6yCQ_nUVswaGUZGK5USQds4VXRAFk6Uv7tc7wUwR4gxC_Bkxs3-g_QWxitA96Dqy907GJkjZd-WPwOV3ZsPjl4j7_FyL-SApwp1s5VHMTQ-aG0XRJtfxtxw3nNUeXzizZmwzbCIuX_-pi1Yc4iR6yOGKTL0dbqwaN9_hqJZuEwn7hijms837HVJvXdl2wH6jtI5JwWGVV_bV4pH4NtpF7658GoVpaD0xZZ-iNY8ledrL5v29lWd6D9uDqTetSi6YEaSPffECZGqmZOEiayuPNY1UUp9K7N-JM4d1rLW8nXmRsnf4Ud5jAtVV-40zGBQ=="
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
        inputQuery.showChataIcon = false
        inputQuery.start(mainView: self)
    }
}
