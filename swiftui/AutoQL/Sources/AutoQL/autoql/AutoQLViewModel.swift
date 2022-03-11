//
//  File.swift
//  
//
//  Created by Vicente Rincon on 09/03/22.
//

import SwiftUI
public typealias CompletionSuccess = (_ success: Bool) -> Void
public class AutoQLViewModel: ObservableObject{
    public init(){
        
    }
    public func login(data: [String: Any], completion: @escaping CompletionSuccess) {
        let user = data.toStr("userName")
        let password = data.toStr("userPassword")
        
        let body: [String: Any] = ["username": user, "password": password]
        HttpRequest.instance.post(url: UrlAutoQl.wsLogin, body: body, typeHeader: .form_data, formatText: true) { response in
            let success = response.toBool("result")
            if success {
                let token = response.toStr("message")
                DataConfig.authenticationObj.apiKey = data.toStr("userAPIKey")
                DataConfig.authenticationObj.token = token
                self.getJWT(parameters: data) { successJWT in
                    completion(successJWT)
                }
            } else{
                completion(false)
            }
        }
    }
    private func getJWT(parameters: [String: Any], completion: @escaping CompletionSuccess) {
        let mail = parameters.toStr("userID")
        let projectID = parameters.toStr("projectID")
        let url = "\(UrlAutoQl.wsgetJWT)\(mail)&project_id=\(projectID)"
        HttpRequest.instance.get(url: url, formatText: true) { response in
            let success = response.toBool("result")
            if success {
                DataConfig.authenticationObj.domain = parameters.toStr("userDomainURL")
                DataConfig.authenticationObj.token = response.toStr("message")
                UrlAutoQl.instance.urlDynamic = DataConfig.authenticationObj.domain
                self.getValidData { success in
                    completion(success)
                }
            }
            else {
                completion(false)
            }
        }
    }
    private func getValidData(completion: @escaping CompletionSuccess) {
        let url = "\(UrlAutoQl.instance.urlDynamic)/autoql/api/v1/query/related-queries?key=\(DataConfig.authenticationObj.apiKey)&search=test"
        HttpRequest.instance.get(url: url) { response in
            let success = response.toBool("success")
            completion(success)
        }
    }
}
