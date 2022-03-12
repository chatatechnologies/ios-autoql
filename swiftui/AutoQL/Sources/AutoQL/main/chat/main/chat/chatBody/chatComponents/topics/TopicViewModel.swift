//
//  File.swift
//  
//
//  Created by Vicente Rincon on 12/03/22.
//

import SwiftUI
class TopicViewModel: ObservableObject{
    var qbOptionsLvl1: [String] = TopicService.instance.topics.compactMap {$0.topic}
    @Published var indexSelect = 0
    @Published var changeLvl2 = false
    func selectOptionQB1(position: Int){
        self.indexSelect = position
        self.changeLvl2 = true
    }
}
