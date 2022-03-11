//
//  File.swift
//  
//
//  Created by Vicente Rincon on 09/03/22.
//

import SwiftUI
typealias CompletionResponse = (_ response: [String: Any]) -> Void
class HttpRequest{
    static let instance = HttpRequest()
    func get(url: String, formatText: Bool = false, completion: @escaping CompletionResponse){
        guard let request = genereteURLRequest(url: url, httpMethod: "GET") else{
            return
        }
        sendRequest(request: request, formatText: formatText) { response in
            completion(response)
        }
    }
    func post(url: String, body: [String: Any], typeHeader: TypeHeader = .json, formatText: Bool = false, completion: @escaping CompletionResponse){
        guard var request = genereteURLRequest(url: url, httpMethod: "POST") else{
            return
        }
        guard let data = (jsonToString(json: body).data(using: .utf8)) else{
            return
        }
        request.httpBody = data
        switch(typeHeader){
        case .json:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        case .form_data:
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = generateBodyForm(body: body, boundary: boundary)
        }
        sendRequest(request: request, formatText: formatText) { response in
            completion(response)
        }
    }
    func put(url: String, body: [String: Any], completion: @escaping CompletionResponse){
        generateRequest(url: url, httpMethod: "PUT", body: body) { response in
            completion(response)
        }
    }
    func delete(url: String, body: [String: Any], completion: @escaping CompletionResponse){
        generateRequest(url: url, httpMethod: "DELETE", body: body) { response in
            completion(response)
        }
    }
    private func genereteURLRequest(url: String, httpMethod: String) -> URLRequest?{
        guard let urlValid = URL(string: url) else {
            return nil
        }
        var request = URLRequest(url: urlValid) as URLRequest
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if !DataConfig.authenticationObj.token.isEmpty{
            request.setValue("Bearer \(DataConfig.authenticationObj.token)", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = httpMethod
        return request
    }
    private func generateRequest(url: String, httpMethod: String, body: [String: Any] = [:], completion: @escaping CompletionResponse){
        guard let urlValid = URL(string: url) else {
            return
        }
        var request = URLRequest(url: urlValid) as URLRequest
        request.httpMethod = httpMethod
        guard let data = (jsonToString(json: body).data(using: .utf8)) else{
            return
        }
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if !DataConfig.authenticationObj.token.isEmpty{
            request.setValue("Bearer \(DataConfig.authenticationObj.token)", forHTTPHeaderField: "Authorization")
        }
        sendRequest(request: request) { response in
            completion(response)
        }
    }
    private func generateBodyForm(body: [String: Any], boundary: String) -> Data {
        do{
            return {
                var bodyFinal = Data()
                for (rawName, rawValue) in body {
                    if !bodyFinal.isEmpty {
                        bodyFinal.append("\r\n".data(using: .utf8)!)
                    }

                    bodyFinal.append("--\(boundary)\r\n".data(using: .utf8)!)

                    guard
                        rawName.canBeConverted(to: String.Encoding.utf8),
                        let disposition = "Content-Disposition: form-data; name=\"\(rawName)\"\r\n".data(using: String.Encoding.utf8) else {
                        return Data()
                            
                    }
                    bodyFinal.append(disposition)

                    bodyFinal.append("\r\n".data(using: .utf8)!)

                    guard let value = (rawValue as AnyObject).data(using: String.Encoding.utf8.rawValue) else {
                        return Data()
                    }

                    bodyFinal.append(value)
                }

                bodyFinal.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

                return bodyFinal
            }()
        }
    }
    private func jsonToString(json: [String: Any]) -> String {
        do {
            let json2 = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
            let jsonString = NSString(data: json2, encoding: String.Encoding.utf8.rawValue)! as String
            return jsonString
        } catch {
            return ""
        }
    }
    private func sendRequest(request: URLRequest, formatText: Bool = false, completion: @escaping CompletionResponse){
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
                guard error == nil else {
                    completion(["result": "fail"])
                    return
                }
                guard let data = data else {
                    completion(["result": "no data"])
                    return
                }
                if formatText{
                    if let responseText = String(data: data,
                                           encoding: String.Encoding.utf8) {
                        if let nsHTTPResponse = response as? HTTPURLResponse {
                            let statusCode = nsHTTPResponse.statusCode
                            let dictionaryResponse:[String: Any] = ["result": statusCode == 200, "message": responseText]
                            completion(dictionaryResponse)
                        }
                        
                    }
                } else{
                    do {
                        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                        if var json = responseJSON as? [String: Any] {
                            if let nsHTTPResponse = response as? HTTPURLResponse {
                                let statusCode = nsHTTPResponse.statusCode
                                json["success"] = statusCode == 200
                                completion(json)
                            }
                        } else{
                            completion(["response": responseJSON ?? [:]])
                        }
                    }
                }
            }
        )
        task.resume()
    }
}
enum TypeHeader{
    case json
    case form_data
}
