//
//  SwiftUIView 2.swift
//  
//
//  Created by Vicente Rincon on 27/01/22.
//

import SwiftUI
import CoreData
struct ChatBarBottomView: View {
    @Binding var value: String
    @Binding var allComponents : [ComponentModel]
    @State var typing = false
    @StateObject var viewModel = ChatBarBottomModelView()
    var speechManager = SpeechManager()
    var service = ChatBodyService()
    @State var recording = false
    //@ObservedObject private var mic = MicMonitor(numberOfSamples: 30)
    var body: some View {
        VStack(spacing: 4){
            //Spacer()
            if !value.isEmpty {
                AutoCompleteView(value: $value, queries: $viewModel.queries){
                    addNewComponent()
                }
            }
            HStack{
                QLInputText(
                    label: "Type your Queries here",
                    value: $value
                ).onChange(of: value) { newValue in
                    viewModel.getAutoComplete(query: newValue)
                }
                Group{
                    if value.isEmpty || recording {
                        QLCircleButton(image: "icMic") {
                            recordingToggle()
                        }
                    } else {
                        QLCircleButton(image: "icSend") {
                            addNewComponent()
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 8)
        //.background(qlBackgroundColorSecondary)
        .onAppear {
            speechManager.checkPermissions()
        }
        
    }
    private func addNewComponent(){
        service.addNewComponent(query: value) {
            newComponents in
            DispatchQueue.main.async {
                allComponents += newComponents
            }
        }
        value = ""
    }
    private func recordingToggle(){
        if speechManager.isRecording{
            self.recording = false
            speechManager.stopRecording()
        } else {
            self.recording = true
            speechManager.start { (speechText) in
                guard let text = speechText, !text.isEmpty else {
                    self.recording = false
                    return
                }
                value = text
            }
        }
        speechManager.isRecording.toggle()
    }
}

