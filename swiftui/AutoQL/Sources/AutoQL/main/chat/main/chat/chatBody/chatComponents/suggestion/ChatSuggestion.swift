//
//  File.swift
//  
//
//  Created by Vicente Rincon on 10/02/22.
//

import SwiftUI

struct ChatSuggestion: View {
    var position: Int
    @Binding var isReportPopUp: Bool
    @Binding var isSQLPopUp: Bool
    var removeElement: (_ position : Int) -> Void
    @State private var showingAlert = false
    @State var buttons: [ChatToolbarModel] = [
        ChatToolbarModel(image: "icReport", typeFunction: .report),
        ChatToolbarModel(image: "icDelete", typeFunction: .delete)
    ]
    @Binding var value: String
    var onClick: () -> Void
    var suggestions: [String] = ["All Sales", "total Sales", "All Taxes", "Last Sales"]
    var body: some View {
        HStack{
            VStack{
                ForEach(suggestions, id: \.self) {
                    suggestion in
                    QLButton(
                        label: suggestion,
                        styleDefault: true) {
                            value = suggestion
                            onClick()
                        }
                }
            }
            .layoutPriority(1)
            .padding(8)
            
        }
        .background(
            AnyView(
                RoundedRectangle(cornerRadius: 10)
                    .fill(qlBackgroundColorPrimary)
            )
        )
        .padding(8)
        .overlay(
            ChatToolbarOptions(
                onClick: toolbarAction,
                onClickMenuAction: toolbarMenuAction,
                buttons: buttons
            ), alignment: .topTrailing
        )
        .alert(isPresented: $showingAlert) {
                    Alert(title: Text(""), message: Text("Thank you for your feedback."), dismissButton: .default(Text("Ok!")))
        }
    }
    func toolbarAction(_ typeFunction: ChatToolItemType){
        switch(typeFunction){
        case .delete: removeElement(position)
        case .more: print("more options")
        case .report: print("Report")
        }
    }
    func toolbarMenuAction(_ type: ChatToolbarSubOptionType){
        switch type {
        case .viewsql: isSQLPopUp = true
        case .incorrect: showingAlert = true
        case .other: isReportPopUp = true
        case .incomplete: showingAlert = true
        }
    }
}
