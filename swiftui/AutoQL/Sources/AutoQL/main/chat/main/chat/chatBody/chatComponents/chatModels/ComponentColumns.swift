//
//  File.swift
//  
//
//  Created by Vicente Rincon on 16/03/22.
//

import Foundation
struct ComponentColumns: Decodable{
    var displayName: String
    var groupable: Bool
    var isVisible: Bool
    var multiSeries: Bool
    var name: String
    var type: String
    enum CodingKeys: String, CodingKey{
        case displayName = "display_name"
        case groupable, name, type
        case isVisible = "is_visible"
        case multiSeries = "multi_series"
    }
    init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName) ?? ""
        self.groupable = try container.decodeIfPresent(Bool.self, forKey: .groupable) ?? false
        self.isVisible = try container.decodeIfPresent(Bool.self, forKey: .isVisible) ?? false
        self.multiSeries = try container.decodeIfPresent(Bool.self, forKey: .multiSeries) ?? false
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
    }
}
