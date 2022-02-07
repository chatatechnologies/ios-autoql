//
//  File.swift
//  
//
//  Created by Vicente Rincon on 04/02/22.
//

import Foundation
struct ChatToolbarModel{
    var image: String
    var typeFunction: ChatToolItemType
}
enum ChatToolItemType {
    case delete, report, more
}
