//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 26/01/22.
//

import SwiftUI

struct ImagePath: View {
    var name: String
    var body: some View {
        Image(packageResource: name, ofType: "png").resizable()
    }
}


