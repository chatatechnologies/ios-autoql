//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 09/02/22.
//

import SwiftUI

struct ChatWebView: View {
    var position: Int
    @Binding var isReportPopUp: Bool
    @Binding var isSQLPopUp: Bool
    var info: ComponentInfoModel?
    @State var wbString = ""
    var onClick: (_ position : Int) -> Void
    @State private var showingAlert = false
    @State var buttons: [ChatToolbarModel] = [
        ChatToolbarModel(image: "icReport", typeFunction: .report),
        ChatToolbarModel(image: "icDelete", typeFunction: .delete),
        ChatToolbarModel(image: "icPoints", typeFunction: .more)
    ]
    var body: some View {
        ZStack{
            HStack{
                WebView(WbString: wbString).background(
                    QLRoundedView(cornerRadius: 10)
                )
            }.onAppear{
                guard let info = info else{
                    return
                }
                let table = TableViewHTML.instance.getTable(info)
                wbString = WebviewString.instance.generateWB(table)
            }
            .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 400)
            .background(
                QLRoundedView(cornerRadius: 10)
            )
        }
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
        case .delete: onClick(position)
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
