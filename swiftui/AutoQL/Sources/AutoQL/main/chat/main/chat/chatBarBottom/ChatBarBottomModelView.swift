//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 31/01/22.
//

import SwiftUI

class ChatBarBottomModelView: ObservableObject {
    @Published var queries: [String] = []
    var serviceBodyChat = ChatBodyService()
    func addComponentToChat(query: String, completion: @escaping([ChatComponent]) -> ()){
        serviceBodyChat.addNewComponent(query: query) { newComponents in
            completion(newComponents)
        }
    }
    func getAutoComplete(query: String){
        let url = "\(AutoQLConfig.shared.authenticationObj.domain)/autoql/api/v1/query/autocomplete?text=\(query)&key=\(AutoQLConfig.shared.authenticationObj.apiKey)"
        if !query.isEmpty{
            HttpRequest.instance.get(url: url) { response in
                let data = response.toDict("data")
                let matches = data.toArrStr("matches")
                DispatchQueue.main.async {
                    self.queries = matches
                }
            }
        } else {
            self.queries = []
        }
    }
}
