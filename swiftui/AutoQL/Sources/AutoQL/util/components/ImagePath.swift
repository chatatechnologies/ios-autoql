//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 26/01/22.
//

import SwiftUI

struct ImagePath: View {
    var name: String
    var size: CGFloat = 50.0
    var tintColor: Bool = false
    var type: String = "png"
    var body: some View {
        Image(packageResource: name, ofType: type)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .colorMultiply(tintColor ? qlTextColorPrimary: qlColorWhite)
    }
}


