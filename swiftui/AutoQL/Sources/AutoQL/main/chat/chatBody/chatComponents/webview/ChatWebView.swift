//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 09/02/22.
//

import SwiftUI
import WebKit

struct ChatWebView: View {
    var position: Int
    @Binding var isReportPopUp: Bool
    @Binding var isSQLPopUp: Bool
    var onClick: (_ position : Int) -> Void
    @State private var showingAlert = false
    @State var buttons: [ChatToolbarModel] = [
        ChatToolbarModel(image: "R", typeFunction: .report),
        ChatToolbarModel(image: "D", typeFunction: .delete),
        ChatToolbarModel(image: "P", typeFunction: .more)
    ]
    var body: some View {
        ZStack{
            HStack{
                WebView().background(
                    QLRoundedView(cornerRadius: 10)
                )
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
struct WebView: UIViewRepresentable {
  //@Binding var text: String
   
  func makeUIView(context: Context) -> WKWebView {
    return WKWebView()
  }
   
  func updateUIView(_ uiView: WKWebView, context: Context) {
    uiView.loadHTMLString(generateWB(), baseURL: nil)
  }
}
