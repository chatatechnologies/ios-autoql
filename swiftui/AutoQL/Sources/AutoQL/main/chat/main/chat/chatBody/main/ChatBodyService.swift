//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 31/01/22.
//

import SwiftUI
typealias CompletionComponents = (_ arrComponents: [ComponentModel]) -> Void
typealias CompletionComponentInfo = (_ componentInfo: ComponentInfoModel) -> Void
class ChatBodyService: ObservableObject {
    @Published var bodyMessages = [ComponentModel]()
    init() {
        bodyMessages = [
            ComponentModel(type: .botmessage, label: "Hi! Let’s dive into your data. What can I help you discover today?"),
        ]
        if !TopicService.instance.topics.isEmpty {
            bodyMessages.append(ComponentModel(type: .querybuilder))
        }
    }
    func getDefaultMessage() -> [ComponentModel]{
        return bodyMessages
    }
    func addNewComponent(
        query: String,
        completion: @escaping CompletionComponents){
            getQuery(query) { componentInfo in
                completion(
                    self.getAnswer(query: query, info: componentInfo)
                )
            }
    }
    func getQuery(_ query: String, dataType: String = "data_messenger.user", completion: @escaping CompletionComponentInfo){
        let body: [String: Any] = [
            "text": query,
            "source": dataType,
            "test": true,
            "translation": "include"
        ]
        HttpRequest.instance.post(url: "\(UrlAutoQl.instance.urlDynamic)query?key=\(AutoQLConfig.shared.authenticationObj.apiKey)", body: body) { response in
            print(response)
            do {
                let dataResponse = response.toDict("data")
                
                let data = try? JSONSerialization.data(withJSONObject: dataResponse , options: .prettyPrinted)
                if let finalData = data {
                    let decodedData = try? JSONDecoder().decode(ComponentInfoModel.self, from: finalData)
                    if var finalDecodedData = decodedData{
                        let rows = dataResponse.toArrArrAny("rows").toArrArrAny()
                        finalDecodedData.rows = rows
                        completion(finalDecodedData)
                    }
                }
            }
        }
    }
    func getAnswer(query: String, info: ComponentInfoModel) -> ([ComponentModel]) {
        var components: [ComponentModel] = []
        let question = ComponentModel(type: .usermessage, label: query)
        components.append(question)
        let responseType = getType(info)
        switch responseType {
        case .botmessage,
             .usermessage,
             .querybuilder:
            let answer = ComponentModel(type: responseType, label: "Response")
            components.append(answer)
        case .webview:
            let answer = ComponentModel(type: responseType, label: "Response", componentInfo: info)
            components.append(answer)
        case .botresponseText:
            let (_, value) = validateOneAnswer(info.rows)
            let answer = ComponentModel(type: responseType, label: value, componentInfo: info)
            components.append(answer)
        case .suggestion:
            let answer = ComponentModel(type: .botresponseText, label: "I want to make sure I understood your query. Did you mean:")
            let answerSuggestion = ComponentModel(
                type: responseType,
                label: ""
            )
            components += [answer, answerSuggestion]
        }
        return components
    }
    func getType(_ info: ComponentInfoModel) -> DataChatType{
        if info.displayType == "data"{
            if validateOneAnswer(info.rows).0 {
                return .botresponseText
            } else {
                return .webview
            }
        }
        return .webview
    }
    func validateOneAnswer(_ rows: [[Any]]) -> (Bool, String){
        if rows.count == 1 {
            if rows[0].count == 1{
                let result = rows[0][0] as? Double ?? 0
                return (true, result.currency())
            }
        }
        return (false, "")
    }
}

