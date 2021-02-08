//
//  PostCreateViewModel.swift
//  dropito
//
//  Created by Maros Kramar on 21/12/2020.
//

import Foundation
import UIKit
import MapKit


protocol PostCreateViewModeling: AnyObject {
    
    var coordinates: CLLocationCoordinate2D { get set }
    
    func createPost(text: String, photo: UIImage?, completion: @escaping (Bool) -> Void)
}

final class PostCreateViewModel: PostCreateViewModeling {

    var coordinates: CLLocationCoordinate2D
    
    init(coordinates: CLLocationCoordinate2D) {
        self.coordinates = coordinates
    }
    
    func createPost(text: String, photo: UIImage?, completion: @escaping (Bool) -> Void) {
        
        var urlRequest = URLRequest(url: URL(string: "http://localhost:8000/api/post/")!)
        urlRequest.allHTTPHeaderFields = ["Content-Type": "application/json"]
        urlRequest.httpMethod = "POST"
        
         let formatter = DateFormatter()
         formatter.timeZone = TimeZone.current
         formatter.dateFormat = "yyyy-MM-dd HH:mm"
         let timestamp = formatter.string(from: Date())
        
        let body: [String: Any?] = [
            "image": photo?.jpegData(compressionQuality: 0)?.base64EncodedString(),
            "author": UserDefaults.standard.string(forKey: "username") ?? "error",
            "text": text,
            "lat": coordinates.latitude,
            "lon": coordinates.longitude,
            "timestamp": timestamp
        ]
        
        urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: body)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
         
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("Response data string:\n \(dataString)")
                    completion(true)
                } else {
                    completion(false)
                }
        }
        task.resume()
    }
}
