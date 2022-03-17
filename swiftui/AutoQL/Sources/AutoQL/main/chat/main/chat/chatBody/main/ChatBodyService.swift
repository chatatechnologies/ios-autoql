//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 31/01/22.
//

import SwiftUI
typealias CompletionComponents = (_ arrComponents: [ComponentModel]) -> Void
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
            getQuery(query) { arrComponents in
                completion(self.getAnswer(query: query))
            }
    }
    func getQuery(_ query: String, dataType: String = "data_messenger.user", completion: @escaping CompletionComponents){
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
                        print(finalDecodedData)
                    }
                }
            }
            completion([])
        }
    }
    func getAnswer(query: String) -> ([ComponentModel]) {
        var components: [ComponentModel] = []
        let question = ComponentModel(type: .usermessage, label: query)
        components.append(question)
        let responseType: DataChatType = .webview
        switch responseType {
        case .botmessage,
             .usermessage,
             .querybuilder,
             .botresponseText,
             .webview:
            let answer = ComponentModel(type: responseType, label: "Response")
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
}

