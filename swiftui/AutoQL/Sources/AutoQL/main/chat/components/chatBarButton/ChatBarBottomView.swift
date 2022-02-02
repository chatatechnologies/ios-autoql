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
    @Binding var allComponents : [ChatComponent]
    var speechManager = SpeechManager()
    var service = ChatBarBottomModelView()
    @State var recording = false
    //@ObservedObject private var mic = MicMonitor(numberOfSamples: 30)
    var body: some View {
        HStack{
            TextField("Type your Queries here", text: $value)
                .padding()
                .background(
                    AnyView(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(qlBackgroundColorPrimary)
                    )
                )
            Button("SEND") {
                service.addComponentToChat(query: value) { newComponents in
                    allComponents += newComponents
                }
                value = ""
            }
            Button("REC") {
                recordingToggle()
            }
        }.padding()
            .background(qlBackgroundColorSecondary)
            .onAppear {
                speechManager.checkPermissions()
            }
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

