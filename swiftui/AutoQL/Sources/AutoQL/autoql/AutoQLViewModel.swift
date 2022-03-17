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
                AutoQLConfig.shared.authenticationObj.apiKey = data.toStr("userAPIKey")
                AutoQLConfig.shared.authenticationObj.token = token
                self.getJWT(parameters: data) { successJWT in
                    completion(successJWT)
                }
            } else{
                completion(false)
            }
        }
    }
    public func logout(){
        AutoQLConfig.shared.resetData()
    }
    private func getJWT(parameters: [String: Any], completion: @escaping CompletionSuccess) {
        let mail = parameters.toStr("userID")
        let projectID = parameters.toStr("projectID")
        let url = "\(UrlAutoQl.wsGetJWT)\(mail)&project_id=\(projectID)"
        HttpRequest.instance.get(url: url, formatText: true) { response in
            let success = response.toBool("result")
            if success {
                AutoQLConfig.shared.authenticationObj.domain = parameters.toStr("userDomainURL")
                AutoQLConfig.shared.authenticationObj.token = response.toStr("message")
                AutoQLConfig.shared.projectID = projectID
                UrlAutoQl.instance.urlDynamic = "\(AutoQLConfig.shared.authenticationObj.domain)/autoql/api/v1/"
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
        let url = "\(UrlAutoQl.instance.urlDynamic)query/related-queries?key=\(AutoQLConfig.shared.authenticationObj.apiKey)&search=test"
        HttpRequest.instance.get(url: url) { response in
            let success = response.toBool("success")
            if success {
                TopicService.instance.getTopics()
            }
            completion(success)
        }
    }
}
