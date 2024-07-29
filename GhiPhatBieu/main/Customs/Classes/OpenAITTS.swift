//
//  OpenAITTS.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 28/07/2024.
//

import Foundation

class OpenAITTS {
    
    static var shared = OpenAITTS(apiKey: "")
    
    private let apiKey: String
    private let apiUrl = URL(string: "https://api.hakai.shop:8080/v1/audio/speech")!
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func textToSpeech(text: String, completion: @escaping (Data?, Error?) -> Void) {
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "model": "tts-1",
            "input": text,
            "voice": "onyx"
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        request.httpBody = jsonData
        
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
//        } catch let error {
//            completion(nil, error)
//            return
//        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "dataNilError", code: -100001, userInfo: nil))
                return
            }
            if let str = String(data: data, encoding: .utf8) {
                print("Successfully decoded: \(str)")
            }
            
            completion(data, nil)
        }
        
        task.resume()
    }
    
    func googleTTS(_ text: String, voiceId: String = "vi-VN-Neural2-D/MALE", speed: Double? = 1, completed: @escaping (String?)-> Void) {
        let apiUrl = "https://content-texttospeech.googleapis.com/v1/text:synthesize?alt=json&key=AIzaSyB_1LnNnqLDIXXt-3q_TEmfmW9Gg3qo9Vw"
        guard let url = URL(string: apiUrl) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let name = voiceId.split(separator: "/")[0]
        let ssmlGender = voiceId.split(separator: "/")[1]
        
        let roundedValue = round(speed! * 100) / 100.0
        
        let jsonBody: [String: Any] = [
            "input": ["text": text],
            "voice": ["languageCode": "vi-VN", "ssmlGender": ssmlGender, "name": name],
            "audioConfig": ["audioEncoding": "MP3", "pitch": 0, "speakingRate": roundedValue]
        ]
        
        // Chuyển đổi JSON thành dữ liệu
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody) else {
            print("Error converting JSON to data")
            return
        }
        
        request.httpBody = jsonData
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completed(nil)
                return
            }
            
            guard let data = data else {
                completed(nil)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let jsonDict = json as? [String: Any], let audioContent = jsonDict["audioContent"] as? String {
                    completed(audioContent)
                } else {
                    completed(nil)
                }
            } catch {
                completed(nil)
            }
        }
        task.resume()
    }
}
