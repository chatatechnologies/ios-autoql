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
    var body: some View {
        Image(packageResource: name, ofType: "png")
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
    }
}


