//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 09/02/22.
//

import SwiftUI

struct ReportProblemPopUp: View {
    @Binding var isPresented: Bool
    @State var value = ""
    var body: some View {
        ZStack{
            HStack{
                VStack{
                    HStack{
                        QLText(label: "Report problem", padding: 0, fontSize: 20)
                    }
                    Divider()
                    HStack{
                        QLText(label: "Please tell us more about the problem you are experiencing:", padding: 0)
                        Spacer()
                    }
                    TextField("", text: $value)
                        .padding()
                        .background(
                            AnyView(
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(qlBackgroundColorPrimary)
                                    .shadow(color: qlBorderColor, radius: 2)
                            )
                        )
                    HStack{
                        QLButton(label: "Cancel", styleDefault: true, onClick: {
                            isPresented.toggle()
                        })
                        Spacer()
                        QLButton(label: "Report", onClick: {
                            print("Report")
                        })
                    }
                }.padding(32)
            }
            .background(
                AnyView(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(qlBackgroundColorPrimary)
                )
            )
            .padding(16)
        }
    }
}

