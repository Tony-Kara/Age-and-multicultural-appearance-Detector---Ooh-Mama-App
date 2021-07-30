//
//  NetworkServices.swift
//  Age and multicultural appearance Detector - Ooh Mama App
//
//  Created by mac on 6/8/20.
//  Copyright © 2020 EniTony. All rights reserved.
//

import UIKit
typealias Parameters = [String: String]
class NetworkServices {
static let instance = NetworkServices()
    
    func getAge(image: UIImage, completion: @escaping (Int) -> ()) {
        
        
        
        guard let mediaImage = Media(withImage: image , forKey: "inputFile") else { return } //This is where you manually change things, insert your image and the key
        
        guard let url = URL(string: "https://api.cloudmersive.com/image/face/detect-age") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = self.generateBoundary()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("9efdd447-4df6-4e94-815b-e9936065b4f1", forHTTPHeaderField: "Apikey")
        
        let dataBody = self.createDataBody(withParameters: nil, media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil{
                debugPrint("Errors were found")
                return
            }
            
            guard let data = data else{ return }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else { return }
                
                guard let outputs = json["PeopleWithAge"] as? [[String: Any]] else { return }
                
                var requiredAge = [Float]()
                
                for ages in outputs {
                    let age = ages["Age"] as? Float ?? 0.0
                    requiredAge.append(age)
                    
                    
                    DispatchQueue.main.async {
                        completion(Int(age))
                    }
                    
                }
                
                
                
            } catch {
                debugPrint("JSON error: \(error.localizedDescription)")
            }
        }
        task.resume()
        
        
        
    }
    
    func getGender(image: UIImage, completion: @escaping (String) -> ()) {
        guard let mediaImage = Media(withImage: image , forKey: "inputFile") else { return } //This is where you manually change things, insert your image and the key
        
        guard let url = URL(string: "https://api.cloudmersive.com/image/face/detect-gender") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = self.generateBoundary()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("9efdd447-4df6-4e94-815b-e9936065b4f1", forHTTPHeaderField: "Apikey")
        
        let dataBody = self.createDataBody(withParameters: nil, media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil{
                debugPrint("Errors were found")
                return
            }
            
            guard let data = data else{ return }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else { return }
                
                guard let outputs = json["PersonWithGender"] as? [[String: Any]] else { return }
                
                var requiredGender = [String]()
                
                for genders in outputs {
                    let gender = genders["GenderClass"] as? String ?? ""
                    requiredGender.append(gender)
                    
                    
                    DispatchQueue.main.async {
                        completion(gender)
                    }
                    
                }
                
                
                
            } catch {
                debugPrint("JSON error: \(error.localizedDescription)")
            }
        }
        task.resume()
    
    }
    
    
    //MARK: - Post Methods
    
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func createDataBody(withParameters params: Parameters?, media: [Media]?, boundary: String) -> Data {
        
        let lineBreak = "\r\n" //this is required in converting my file into data
        var body = Data()
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        
        if let media = media {// put in your filename here from media class
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)// append actual image from Media class when you initialise Media class
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
    
    
    //MARK: - Function to get Mama Advice
    
    
    func getAdvice(completion:@escaping(String) -> ()) {
        
        
        let randomFactEndpoint = URL(string: "https://api.quotable.io/random")
        guard let url = randomFactEndpoint else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse , response.statusCode == 200 else{
                debugPrint("Server error")
                return
            }
            
            guard let data = data else{return}
            
            do{
              
               guard let json = try JSONSerialization.jsonObject(with: data, options:
                                        // we treat the data as a dictionary which means we will filter through out result using key-value pair
                 [.allowFragments]) as? [String:Any] else{return}
               let advice = json["content"] as? String ?? ""
                DispatchQueue.main.async {
                   completion(advice)
                }
               
             
              }catch{
                  debugPrint("Error returning data for images")
              }
       
        }
        task.resume()
    }
    
    
    
    
    //MARK: - Function to be used in future
    func getRace(imgUrl: UIImage, completion: @escaping ([ClarifaiModel]) -> ()) {
        
        guard let url = URL(string: "https://api.clarifai.com/v2/models/c0c0ac362b03416da06ab3fa36fb58e3/outputs") else { return }
        let apiKey = "Key 30ad6c9249a046439d5dcc8ca17a267c"
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(apiKey, forHTTPHeaderField: "Authorization")
        
        urlRequest.httpMethod = "POST"
        guard let data = imgUrl.jpegData(compressionQuality: 0.7) else { fatalError() }
        let imgData = data.base64EncodedData()
        let imgStr = String(data: imgData, encoding: .utf8)!
        let json: [String: Any] = [
            
            "inputs": [
                [
                    "data": [
                        "image": [
                            "base64" : imgStr
                        ]
                    ]
                ]
            ]
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // guard let data = imgUrl.jpegData(compressionQuality: 0.7) else { fatalError() }
        // let jsonData = try? JSONSerialization.data(withJSONObject: imgUrl)
        //  let jsonData = data.base64EncodedData()
        // let jsonData = String(decoding: data, as: UTF8.self)
        
        urlRequest.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            // First we are going to check to make sure there were no errors
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            // Second, check that the response is of the correct type, and that the request was successful.
            guard let response = response as? HTTPURLResponse , response.statusCode == 200 else {
                debugPrint("Server error")
                return
            }
            
            // Third, we are going to make sure we definitely have data
            guard let data = data else { return }
            
            // And finally, we are going to parse the JSON data and cast it as a dictionary so we can pull out the desired result and display it.
            do {
                guard let clarifaiData = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else { return }
                guard let outputs = clarifaiData["outputs"] as? [[String: Any]] else { return }
                guard let outputsData = outputs[0]["data"] as? [String: Any] else { return }
                guard let concepts = outputsData["concepts"] as? [[String: Any]] else { return }
                
                var clarifaiModel = [ClarifaiModel]()
                
                for concept in concepts {
                    
                    let name = concept["name"] as? String ?? ""
                    let certainty = concept["value"] as? Float ?? 0.0
                    
                    let newModel = ClarifaiModel(name: name, probability: certainty)
                    clarifaiModel.append(newModel)
                }
                
                DispatchQueue.main.async {
                    completion(clarifaiModel)
                }
                
            } catch {
                debugPrint("JSON error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
}

extension Data {
    mutating func append(_ string: String) { // i will use this to append all my files.
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
