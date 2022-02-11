//
//  File.swift
//  
//
//  Created by Vicente Rincon on 01/02/22.
//

import Speech

class SpeechManager {
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    public var isRecording = false
    private var audioEngine: AVAudioEngine!
    private var inputNote: AVAudioNode!
    private var audioSession: AVAudioSession!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    func checkPermissions(){
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    print("Auth")
                case .denied:
                    print("denied")
                case .restricted, .notDetermined:
                    print("restricted")
                @unknown default:
                    print("Default")
                }
            }
        }
    }
    func start(completion: @escaping (String?) -> Void) {
        if isRecording {
            stopRecording()
        } else{
            startRecording(completion: completion)
        }
    }
    func startRecording(completion: @escaping (String?) -> Void){
        guard let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US")), recognizer.isAvailable else{
            print("not available")
            return
        }
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest!.shouldReportPartialResults = true
        recognizer.recognitionTask(with: recognitionRequest!){ (result, error) in
            guard error == nil else {
                print("error")
                return
            }
            guard let result = result else {
                return
            }
            completion(result.bestTranscription.formattedString)
        }
        audioEngine = AVAudioEngine()
        inputNote = audioEngine.inputNode
        let recordingFormat = inputNote.outputFormat(forBus: 0)
        inputNote.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.recognitionRequest?.append(buffer)
            
        }
        audioEngine.prepare()
        do{
            audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .spokenAudio, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            try audioEngine.start()
        } catch{
            print(error)
        }
    }
    func stopRecording(){
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        audioEngine.stop()
        inputNote.removeTap(onBus: 0)
        try? audioSession.setActive(false)
        audioSession = nil
    }
}


