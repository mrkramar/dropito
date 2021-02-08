//
//  MapViewModel.swift
//  dropito
//
//  Created by Maros Kramar on 21/12/2020.
//

import Foundation
import UIKit.UIImage
import MapKit


protocol MapViewModeling: AnyObject {
    var posts: [Post] { get set }
    var viewModelDidChange: (MapViewModeling) -> Void { get set }
    
    func loadPosts(coordinate: CLLocationCoordinate2D, completion: @escaping (Bool) -> Void)
}

final class MapViewModel: MapViewModeling {
    
    var posts: [Post] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.viewModelDidChange(self)
            }
        }
    }
    
    var viewModelDidChange: (MapViewModeling) -> Void = { _ in }
    
    func loadPosts(coordinate: CLLocationCoordinate2D, completion: @escaping (Bool) -> Void) {
        
        self.posts = []
        
        let latLowerBound = coordinate.latitude - 0.1
        let latUpperBound = coordinate.latitude + 0.1
        let lonLowerBound = coordinate.longitude - 0.1
        let lonUpperBound = coordinate.longitude + 0.1
        
        let url = URL(string: "http://localhost:8000/api/post/?lat_gt=\(latLowerBound)&lat_lt=\(latUpperBound)&lon_gt=\(lonLowerBound)&lon_lt=\(lonUpperBound)")!
        
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
