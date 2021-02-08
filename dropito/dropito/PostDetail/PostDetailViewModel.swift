//
//  PostDetailViewModel.swift
//  dropito
//
//  Created by Maros Kramar on 31/01/2021.
//

import Foundation

protocol PostDetailViewModeling {
    var post: Post? { get set }
    var comments: [Comment]? { get set }
    
    func loadPost(completion: @escaping (Bool) -> Void)
    func loadComments(completion: @escaping (Bool) -> Void)
    func createComment(text: String, completion: @escaping (Bool) -> Void)
    func deletePost(postID: Int, completion: @escaping (Bool) -> Void)
}

final class PostDetailViewModel: PostDetailViewModeling {
    
    var post: Post?
    var comments: [Comment]?
    var postID: Int
    
    init(postID: Int) {
        self.postID = postID
    }
    
    func loadPost(completion: @escaping (Bool) -> Void) {
        
        let url = URL(string: "http://localhost:8000/api/post/\(postID)")!
        
        print("loading post from", url)

        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("[ERROR]", error)
                completion(false)
            }

            guard let data = data else { return }
            
            if let decoded = try? JSONDecoder().decode(Post.self, from: data) {
                self.post = decoded
                completion(true)
            }
            else {
                self.post = nil
                completion(false)
            }
        }.resume()
    }
    
    func loadComments(completion: @escaping (Bool) -> Void) {
        
        print("loading comments")
        
        let url = URL(string: "http://localhost:8000/api/comment/?post=\(postID)")!

        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("[ERROR]", error)
                completion(false)
            }

            guard let data = data else {
                completion(false)
                return
            }
            
            if let decoded = try? JSONDecoder().decode(CommentResponse.self, from: data) {
                self.comments = decoded.objects
                completion(true)
            }
            else {
                self.comments = []
                completion(false)
            }
        }.resume()
    }
    
    func createComment(text: String, completion: @escaping (Bool) -> Void) {
        
        var urlRequest = URLRequest(url: URL(string: "http://localhost:8000/api/comment/")!)
        urlRequest.allHTTPHeaderFields = ["Content-Type": "application/json"]
        urlRequest.httpMethod = "POST"
        
         let formatter = DateFormatter()
         formatter.timeZone = TimeZone.current
         formatter.dateFormat = "yyyy-MM-dd HH:mm"
         let timestamp = formatter.string(from: Date())
        
        let body: [String: Any?] = [
            "post": postID,
            "author": UserDefaults.standard.string(forKey: "username") ?? "error",
            "text": text,
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
    
    func deletePost(postID: Int, completion: @escaping (Bool) -> Void) {
        var urlRequest = URLRequest(url: URL(string: "http://localhost:8000/api/post/\(postID)")!)
        urlRequest.allHTTPHeaderFields = ["Content-Type": "application/json"]
        urlRequest.httpMethod = "DELETE"
        
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
