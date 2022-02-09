//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 27/01/22.
//

import SwiftUI

struct ChatBotMessageView: View {
    var label: String
    var position: Int
    @Binding var isPopUp: Bool
    var onClick: (_ position : Int) -> Void
    @State private var showingAlert = false
    @State var buttons: [ChatToolbarModel] = [
        ChatToolbarModel(image: "R", typeFunction: .report),
        ChatToolbarModel(image: "D", typeFunction: .delete),
        ChatToolbarModel(image: "P", typeFunction: .more)
    ]
    var body: some View {
        HStack{
            QLText(label: label)
                .background(
                    AnyView(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(qlBackgroundColorPrimary)
                    )
                )
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
            Spacer()
        }
        .padding(
            EdgeInsets(
                top: 40,
                leading: 8,
                bottom: 8,
                trailing: 8
            )
        )
    }
    
    func toolbarAction(_ typeFunction: ChatToolItemType){
        switch(typeFunction){
        case .delete: onClick(position)
        case .more: print("more options")
        case .report: print("Report")
        }
    }
    func toolbarMenuAction(_ type: ChatToolbarSubOptionType){
        switch type {
        case .viewsql: print("sql")
        case .incorrect: showingAlert = true
        case .other: isPopUp = true
        case .incomplete: showingAlert = true
        }
    }
}
