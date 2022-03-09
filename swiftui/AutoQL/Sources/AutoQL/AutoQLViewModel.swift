//
//  File.swift
//  
//
//  Created by Vicente Rincon on 09/03/22.
//

import SwiftUI
public typealias CompletionAutoQL = (_ success: Bool) -> Void
public class AutoQLViewModel: ObservableObject{
    public init(){
        
    }
    public func login(user: String, password: String, apiKey: String, completion: @escaping CompletionAutoQL) {
        let body: [String: Any] = ["username": user, "password": password]
        //let urlRequest = ISPROD ? wsLoginProd : wsLogin
        HttpRequest.instance.post(url: UrlAutoQl.wsLogin, body: body, typeHeader: .form_data, formatText: true) { response in
            let success = response["result"] as? Bool ?? false
            if success {
                let token = response["message"] as? String ?? ""
                DataConfig.authenticationObj.apiKey = apiKey
                DataConfig.authenticationObj.token = token
                self.getJWT(parameters: [:]) { successJWT in
                    completion(successJWT)
                }
            } else{
                completion(false)
            }
        }
        print("Login")
    }
    private func getJWT(parameters: [String: Any], completion: @escaping CompletionAutoQL) {
        let mail = parameters["userID"] ?? ""
        let projectID = parameters["projectID"] ?? ""
        let url = "\(UrlAutoQl.wsgetJWT)\(mail)&project_id=\(projectID)"
        HttpRequest.instance.get(url: url, formatText: true) { response in
            //ChataServices.instance.jwt = jwt
            let success = response["result"] as? Bool ?? false
            if success {
                DataConfig.authenticationObj.domain = (parameters["domain"] as? String ?? "")
                let jwt = response["message"] as? String ?? ""
                print(jwt)
                UrlAutoQl.instance.urlDynamic = DataConfig.authenticationObj.domain
                self.getValidData { success in
                    completion(success)
                }
            }
        }
    }
    private func getValidData(completion: @escaping CompletionAutoQL) {
        let url = "\(UrlAutoQl.instance.urlDynamic)/autoql/api/v1/query/related-queries?key=\(DataConfig.authenticationObj.apiKey)&search=test"
        HttpRequest.instance.get(url: url) { response in
            let success = response["success"] as? Bool ?? false
            completion(success)
        }
    }
}
