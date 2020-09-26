//
//  WebServices.swift
//  chata
//
//  Created by Vicente Rincon on 11/03/20.
//

import Foundation
private var baseApi = "https://backend.chata.ai/"
private var baseTestApi = "https://backend-staging.chata.ai/"
private var baseTestApi2 = "https://backend-staging.chata.io/"
private var baseQbo = "https://qbo-staging.chata.io/"
private var versionApi1 = "\(baseApi)api/v1/"
private var versionBaseTestApi1 = "\(baseTestApi)api/v1/"
private var versionBaseTestApi2 = "\(baseTestApi2)api/v1/"
var wsUrlDynamic = ""
let wsQueryBuilder = "\(versionBaseTestApi2)topics?key="
let wsAutocomplete = "\(versionApi1)autocomplete?q="
let wsQuery = "\(versionBaseTestApi1)chata/query"
let wsSafetynet = "\(versionApi1)safetynet?q="
let wsLogin = "\(versionBaseTestApi2)login"
let wsJwt = "\(versionBaseTestApi2)jwt?display_name="
let wsDrillDown = "\(versionBaseTestApi2)chata/query/drilldown"
let wsDashboard = "\(versionBaseTestApi2)dashboards?key="
typealias CompletionResponse = (_ response: [String: Any]) -> Void
func httpRequest(_ urlFinal: String,
                 _ method: String = "GET",
                 _ body: [String: Any] = [:] ,
                 content: String = "application/json",
                 resultText: Bool = false,
                 token: String = "",
                 integrator: Bool = false,
                 completion: @escaping CompletionResponse) {
    //create the url with NSURL
    let url = URL(string: urlFinal)! //change the url
    //create the session object
    let session = URLSession.shared
    //now create the URLRequest object using the url object
    var request = URLRequest(url: url) as URLRequest
    //var request = URLRequest(url: URL(string: url)!)
    request.httpMethod = method
    if method == "POST" || method == "PUT" || method == "DELETE" {
        let pjson = jsonToString(json: body)
        let data = (pjson.data(using: .utf8))! as Data
        request.httpBody = data
        //let data2 = (pjson.data(using: .utf8))! as Data
        //let postString = "text=A&source=data_messenger&user_id=demo&customer_id=demo"
        //request.httpBody = postString.data(using: .utf8)
        if content == "application/json"{
            request.setValue(content, forHTTPHeaderField: "Content-Type")
        } else {
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            do{
                //request.httpBody = try {
                request.httpBody = {
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
    }
    let jwt = ChataServices.instance.getJwt()
    if jwt != "" {
        request.setValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")
    } else if DataConfig.authenticationObj.token != "" {
        request.setValue("Bearer \(DataConfig.authenticationObj.token)", forHTTPHeaderField: "Authorization")
    }
    if integrator {
        request.setValue(DataConfig.authenticationObj.domain, forHTTPHeaderField: "Integrator-Domain")
    }
    //
    
    //request.addValue("application/json", forHTTPHeaderField: "Accept")
    //request.setValue("Bearer \(UserDefault.instance.defaultAuthToken)", forHTTPHeaderField: "Authorization")
    //create dataTask using the session object to send data to the server
    let task = session.dataTask(with: request, completionHandler: { data, response, error in
        guard error == nil else {
            completion(["result": "fail"])
            return
        }
        guard let data = data else {
            return
        }
        if let response = response {
            let nsHTTPResponse = response as! HTTPURLResponse
            let statusCode = nsHTTPResponse.statusCode
            print ("status code = \(statusCode)")
        }
        if resultText {
            if let respon = String(data: data,
                                   encoding: String.Encoding.utf8) {
                completion(["result":respon])
            }
        } else {
            do {
                //create json object from data
                //let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                if let json = responseJSON as? [String: Any] {
                    completion(json)
                } else{
                    completion(["response": responseJSON ?? [:]])
                }
            }
        }
    })
    task.resume()
}
func httpFormDat(_ urlFinal: String, _ method: String = "GET",_ body: [String: Any] = [:] , completion: @escaping CompletionResponse) {
    let url = URL(string: urlFinal)! //change the url
    //create the session object
    let session = URLSession.shared
    //now create the URLRequest object using the url object
    var request = URLRequest(url: url) as URLRequest
    //var request = URLRequest(url: URL(string: url)!)
    request.httpMethod = method
    if method == "POST" {
        //let pjson = jsonToString(json: body)
        //let data2 = (pjson.data(using: .utf8))! as Data
        //let postString = "text=A&source=data_messenger&user_id=demo&customer_id=demo"
        //request.httpBody = postString.data(using: .utf8)
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions()) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
    }
    request.setValue("form-data", forHTTPHeaderField: "Content-Type")
    let task = session.dataTask(with: request, completionHandler: { data, response, error in
        guard error == nil else {
            return
        }
        guard let data = data else {
            return
        }
        if let response = response {
            let nsHTTPResponse = response as! HTTPURLResponse
            let statusCode = nsHTTPResponse.statusCode
            print ("status code = \(statusCode)")
        }
        do {
            //create json object from data
            //let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            if let json = responseJSON as? [String: Any] {
                completion(json)
            } else{
                completion([:])
            }
        }
    })
    task.resume()
}
func jsonToString(json: [String: Any]) -> String {
    do {
        let json2 = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
        let jsonString = NSString(data: json2, encoding: String.Encoding.utf8.rawValue)! as String
        return jsonString
    } catch {
        print("problema con diccionario: \(String(describing: error))")
        return ""
    }
}
