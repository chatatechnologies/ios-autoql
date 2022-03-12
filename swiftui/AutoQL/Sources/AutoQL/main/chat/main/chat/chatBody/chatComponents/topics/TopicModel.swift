//
//  File.swift
//  
//
//  Created by Vicente Rincon on 12/03/22.
//

import Foundation
struct TopicModel{
    var topic: String
    var queries: [String]
    init(topic: String = "", queries: [String] = []){
        self.topic = topic
        self.queries = queries
    }
}
