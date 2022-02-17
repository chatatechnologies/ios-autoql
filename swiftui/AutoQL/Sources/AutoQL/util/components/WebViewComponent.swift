//
//  File.swift
//  
//
//  Created by Vicente Rincon on 16/02/22.
//
import WebKit
import SwiftUI
struct WebViewComponent: View{
    var WbString = "\(generateWB())"
    var body: some View{
        HStack{
            WebView(WbString: WbString).background(
                QLRoundedView(cornerRadius: 10)
            )
        }
        .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 400)
        .background(
            QLRoundedView(cornerRadius: 10)
        )
    }
}
struct WebView: UIViewRepresentable {
  //@Binding var text: String
  var WbString = ""
  func makeUIView(context: Context) -> WKWebView {
    return WKWebView()
  }
   
  func updateUIView(_ uiView: WKWebView, context: Context) {
    uiView.loadHTMLString(generateWB(), baseURL: nil)
  }
}
