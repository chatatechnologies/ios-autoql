//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 08/02/22.
//

import SwiftUI

struct CustomPopupView<Content, PopupView>: View where Content: View, PopupView: View {
    
    @Binding var isPresented: Bool
    @ViewBuilder let content: () -> Content
    @ViewBuilder let popupView: () -> PopupView
    let backgroundColor: Color
    let animation: Animation?
    
    var body: some View {
        
        content()
            .animation(nil, value: isPresented)
            .overlay(isPresented ? backgroundColor.ignoresSafeArea() : nil)
            .overlay(isPresented ? popupView() : nil)
            .animation(animation, value: isPresented)
            //.onTapGesture { isPresented.toggle() }
        
    }
}

extension View {
    func customPopupView<PopupView>(isPresented: Binding<Bool>, popupView: @escaping () -> PopupView, backgroundColor: Color = .black.opacity(0.3), animation: Animation? = .default) -> some View where PopupView: View {
        return CustomPopupView(isPresented: isPresented, content: { self }, popupView: popupView, backgroundColor: backgroundColor, animation: animation)
    }
}
struct popupView: View {
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
                        Button {
                            isPresented.toggle()
                        } label: {
                            Text("Cancel")
                        }
                        Spacer()
                        Button {
                            print("Report")
                        } label: {
                            Text("Report")
                        }
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
            /*RoundedRectangle(cornerRadius: 20.0)
                .fill(Color.white)
                .frame(width: 300, height: 200.0)
                .overlay(
                    
                    Image(systemName: "xmark").resizable().frame(width: 10.0, height: 10.0)
                        .foregroundColor(Color.black)
                        .padding(5.0)
                        .background(Color.red)
                        .clipShape(Circle())
                        .padding()
                        .onTapGesture { isPresented.toggle() }
                    
                    , alignment: .topLeading)
                
                .overlay(Text("Custom PopUp View!"))
                .transition(AnyTransition.scale)
                .shadow(radius: 10.0)*/
            
        }

}
