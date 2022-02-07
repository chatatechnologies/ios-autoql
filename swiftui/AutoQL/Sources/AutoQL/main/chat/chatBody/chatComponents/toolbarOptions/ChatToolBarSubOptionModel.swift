//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 07/02/22.
//

import SwiftUI
struct ChatToolbarSubOptionModel: Hashable  {
    var label: String
    var typeFunction: ChatToolbarSubOptionType
}
enum ChatToolbarSubOptionType {
    case incomplete, incorrect, other, viewsql
}


