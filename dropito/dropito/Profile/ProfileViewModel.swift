//
//  ProfileViewModel.swift
//  dropito
//
//  Created by Maros Kramar on 21/12/2020.
//

import Foundation

protocol ProfileViewModeling: AnyObject {
    var username: String { get set }
    var posts: [Post] { get set }

    func loadUserPosts(completion: @escaping (Bool) -> Void)
}

class ProfileViewModel: ProfileViewModeling {
    
    var username: String {
        get { UserDefaults.standard.string(forKey: "username") ?? "error" }
        set { UserDefaults.standard.setValue(newValue, forKey: "username") }
    }
    
    var posts: [Post] = []
    
    func loadUserPosts(completion: @escaping (Bool) -> Void) {

        let url = URL(string: "http://localhost:8000/api/post/?author=\(username)")!
        
        print("loading posts from", url)

        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("[ERROR]", error)
                completion(false)
            }

            guard let data = data else { return }
            
            if let decoded = try? JSONDecoder().decode(PostsResponse.self, from: data) {
                self.posts = decoded.objects
                completion(true)
            }
            else {
                self.posts = []
                completion(false)
            }
        }.resume()
    }
}
