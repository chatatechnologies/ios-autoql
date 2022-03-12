//
//  File.swift
//  
//
//  Created by Vicente Rincon on 11/03/22.
//

import Foundation
class TopicService{
    static let instance = TopicService()
    @Published var topics: [TopicModel] = []
    func getTopics(){
        HttpRequest.instance.get(url: UrlAutoQl.wsGetTopics) { response in
            print(response)
            let items = response.toArrDict("items")
            items.forEach { item in
                let topic = item.toStr("topic")
                let queries = item.toArrStr("queries")
                let newTopic = TopicModel(topic: topic, queries: queries)
                DispatchQueue.main.async {
                    self.topics.append(newTopic)
                }
            }
            
        }
    }
}
