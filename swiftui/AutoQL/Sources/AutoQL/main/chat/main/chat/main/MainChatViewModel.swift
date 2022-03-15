//
//  File.swift
//  
//
//  Created by Vicente Rincon on 14/03/22.
//

import Foundation
class MainChatViewModel: ObservableObject{
    static let instance = MainChatViewModel()
    @Published var allComponents: [ChatComponent] = []
    func cleanChat(){
        var defaultValue: [ChatComponent] = []
        if TopicService.instance.topics.isEmpty{
            defaultValue.append(allComponents[0])
        } else {
            defaultValue = [allComponents[0], allComponents[1]]
        }
        self.allComponents = defaultValue
    }
}
