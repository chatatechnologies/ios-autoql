//
//  File.swift
//  
//
//  Created by Vicente Rincon on 09/03/22.
//

import Foundation
class UrlAutoQl{
    static let instance = UrlAutoQl()
    static let baseUrlDebug = "https://backend-staging.chata.io/"
    static let baseUrlProd = "https://backend.chata.io/"
    static let baseApiV1 = "\(baseUrlDebug)api/v1/"
    static let wsLogin = "\(baseApiV1)login"
    static let wsGetJWT = "\(baseApiV1)jwt?display_name="
    static let wsGetTopics = "\(baseApiV1)topics?key=\(AutoQLConfig.shared.authenticationObj.apiKey)&project_id=\(AutoQLConfig.shared.projectID)"
    static let wsAutoComplete = "\(baseApiV1)query/autocomplete?text="
    var urlDynamic = ""
}

