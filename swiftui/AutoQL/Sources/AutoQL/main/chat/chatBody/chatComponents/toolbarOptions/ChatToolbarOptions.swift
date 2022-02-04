//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 03/02/22.
//

import SwiftUI

struct ChatToolbarOptions: View {
    var body: some View {
        HStack {
            HStack{
                Button {
                    print("Report")
                } label: {
                    Text("R")
                }
                Button {
                    print("delete")
                } label: {
                    Text("D")
                }
                Button {
                    print("points")
                } label: {
                    Text("P")
                }
            }
            .padding(8)
        }
        .background(.red)
        .padding(
            EdgeInsets(
                top: 16,
                leading: 8,
                bottom: 0,
                trailing: 16
            )
        )
    }
}
