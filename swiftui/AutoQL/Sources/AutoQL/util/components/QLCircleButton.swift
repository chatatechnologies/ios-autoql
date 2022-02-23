//
//  File.swift
//  
//
//  Created by Vicente Rincon on 21/02/22.
//

import SwiftUI
struct QLCircleButton : View{
    var image: String
    var onClick: () -> Void
    var body: some View{
        Button(action: onClick, label: {
            ImagePath(name: image, size: 35)
        })
        .background(qlAccentColor)
        .clipShape(
            Circle()
        )
    }
}
