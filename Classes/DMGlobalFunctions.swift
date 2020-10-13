//
//  GlobalFunctions.swift
//  chata
//
//  Created by Vicente Rincon on 04/03/20.
//

import Foundation
import Speech
private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
private let request = SFSpeechAudioBufferRecognitionRequest()
private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
private var recognitionTask: SFSpeechRecognitionTask?
private let audioEngine = AVAudioEngine()
var DRILLDOWNACTIVE = false
var speechResult = SFSpeechRecognitionResult()
var finalText = ""
var data = ChatComponentModel()
func getSize(row: ChatComponentModel, width: CGFloat) -> CGFloat  {
    data = row
    switch row.type {
    case .Introduction:
        return getSizeText(row.text, width)
    case .Bar, .Line, .Column, .Pie, .Bubble, .Heatmap, .StackBar, .StackColumn, .StackArea, .Webview, .Table:
        return getSizeWebView(numRow: row.numRow)
    case .Suggestion:
        return getSizeSuggestion()
    case .Safetynet:
        let finalStr = row.options.count > 0 ? row.options[0] : ""
        return getSizeSafetynet(originalQuery: finalStr)
    case .QueryBuilder:
        let base = 100
        if row.numQBoptions == 0 {
            return 170
        }
        let finalSum = row.numQBoptions > 10 ? 220 : row.numQBoptions * 50
        return CGFloat(base + finalSum)
    }
}
func getSizeDashboard(row: DashboardModel, width: CGFloat) -> CGFloat  {
    let base: CGFloat = 70.0
    switch row.type {
    case .Introduction:
        return CGFloat(row.posH) * base
    case .Webview, .Table, .Bar, .Line, .Column, .Pie, .Bubble, .Heatmap, .StackBar, .StackColumn, .StackArea:
        return CGFloat(row.posH) * base
    case .Suggestion:
        return getSizeSuggestion()
    case .Safetynet:
        return 100
    case .QueryBuilder:
        return 0
    }
}
private func getSizeText(_ text: String, _ width: CGFloat) -> CGFloat {
    let approximateWidthOfBioTextView = width - 12 - 50 - 12 - 2
    let size = CGSize(width: approximateWidthOfBioTextView, height: 1000)
    let attributes = [NSAttributedString.Key.font: generalFont]
    let estimatedFrame = NSString(string: text).boundingRect(with: size,
                                                             options: .usesLineFragmentOrigin,
                                                             attributes: attributes,
                                                             context: nil)
    let sum: CGFloat = data.webView == "" ? 0.0 : 15.0
    let finalHeight = estimatedFrame.height + 50 + sum
    return finalHeight
}
private func getSizeWebView(numRow: Int) -> CGFloat{
    let size: CGFloat = data.numRow > 12 ? 380 : (CGFloat(data.numRow * 30) + 100)
    return size
}
private func getSizeSuggestion() -> CGFloat {
    return CGFloat(data.options.count * 55)
}
func getSizeSafetynet(originalQuery: String) -> CGFloat {
    let size = Float(originalQuery.components(separatedBy: " ").count)
    let numRow: Float = Float(size / 3.0)
    let numInt: Int = Int(numRow.rounded(.up))
    let numRows = numInt == 0 ? 1 : numInt
    let finalSize = CGFloat(140 + (45 * numRows))
    return finalSize
}
func startRecording(textbox: UITextField) throws {
    finalText = ""
    if !audioEngine.isRunning {
        AudioServicesPlayAlertSound(SystemSoundID(1113))
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSession.Category.record)
        try audioSession.setMode(AVAudioSession.Mode.measurement)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create the recognition request") }
        recognitionRequest.shouldReportPartialResults = true
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            if let result = result {
                isFinal = result.isFinal
                speechResult = result
                textbox.text = result.bestTranscription.formattedString
            }
            if error != nil || isFinal {
                audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                recognitionTask = nil
            }
        }
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024,
                             format: recordingFormat) { (buffer: AVAudioPCMBuffer, _: AVAudioTime) in
                                recognitionRequest.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()
    } else {
        stopRecording()
    }
}
func stopRecording() {
    isTypingMic = false
    audioEngine.stop()
    recognitionRequest?.endAudio()
    if let recognitionTask = recognitionTask {
        recognitionTask.cancel()
    }
}
func loadRecord(textbox: UITextField) {
    SFSpeechRecognizer.requestAuthorization { authStatus in
        OperationQueue.main.addOperation {
            switch authStatus {
            case .authorized:
                if isTypingMic {
                    do {
                        try startRecording(textbox: textbox)
                    } catch {
                        print("authorized")
                    }
                }
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
func reloadColors () {
    dark = DataConfig.themeConfigObj.theme == "dark"
    chataDrawerAccentColor = (DataConfig.themeConfigObj.accentColor).hexToColor()
    chataDrawerBackgroundColor = (dark ? "#636363" : "#ffffff").hexToColor()
    chataDrawerBorderColor = (dark ? "#d3d3d3" : "#d3d3d3").hexToColor()
    chataDrawerHoverColor = (dark ? "#5A5A5A" : "#ECECEC").hexToColor()
    chataDrawerTextColorPrimary = (dark ? "#FFFFFF" :  "#5D5D5D").hexToColor()
    chataDrawerTextColorPlaceholder = (dark ? "#333333" : "#000000").hexToColor()
    chataDashboardAccentColor = (dark ? "#ffffff" : "#28A8E0").hexToColor()
    chataDrawerWebViewBackground = dark ? "#636363" : "#ffffff"
    chataDrawerWebViewText = dark ? "#FFFFFF" : "#5D5D5D"
}
func supportPivot(columns: [ChatTableColumnType]) -> Bool {
    var support = false
    if columns.count == 3{
        let valid1 = (columns[0] == .date
            )
            || (columns[1] == .date
        )
        let valid2 = columns[1] == .dollar || columns[2] == .dollar
        support = valid1 && valid2
        if support {
            support = columns[2] == .dollar
        }
    }
    return support
}
func supportContrast(columns: [ChatTableColumnType]) -> Bool {
    var support = false
    if columns[0] == .date && columns[1] == .dollar && columns[2] == .dollar {
        support = true
    }
    return support
}
func validateArray(_ array:[Any], _ pos: Int) -> Any{
    if pos == -1 {
        return 0
    }
    return array.count > pos ? array[pos] : 0
}
func loadingView(mainView: UIView, inView: UIView , _ load: Bool = true){
    if load {
        let bundle = Bundle(for: type(of: mainView))
        let path = bundle.path(forResource: "gifBalls", ofType: "gif")
        let url = URL(fileURLWithPath: path!)
        let imageView2 = UIImageView(image: nil)
        imageView2.loadGif(url: url)
        imageView2.tag = 500
        inView.addSubview(imageView2)
        imageView2.edgeTo(inView, safeArea: .centerSize, height: 50, padding: 100)
    } else{
        inView.removeView(tag: 500)
    }
}
func whiteListTypes(type: String) -> Bool {
    var valid = false
    switch type {
    case "bar",
    "line",
    "column",
    "pie",
    "heatmap",
    "bubble",
    "stacked_column",
    "stacked_line",
    "stacked_bar",
    "table":
        valid = true
    default:
        valid = false
    }
    return valid
}
func triChartList(type: String) -> Bool {
    var valid = false
    switch type {
    case
    "heatmap",
    "bubble",
    "stacked_column",
    "stacked_line",
    "stacked_bar":
        valid = true
    default:
        valid = false
    }
    return valid
}
