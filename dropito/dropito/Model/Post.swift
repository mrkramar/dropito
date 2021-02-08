//
//  Post.swift
//  dropito
//
//  Created by Maros Kramar on 21/12/2020.
//

import Foundation
import UIKit

struct PostsResponse: Codable {
    let objects: [Post]
}

struct Post: Hashable {
    
    let id: Int
    let text: String
    let image: UIImage?
    
    let author: String
    
    let lat: Double
    let lon: Double
    let location: String
}

extension Post: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case image
        case author
        case text
        case lat
        case lon
        case location
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        
        let imageString = try container.decode(String.self, forKey: .image)
        let imageData = Data(base64Encoded: imageString) ?? Data()
        image = UIImage(data: imageData)
        
        author = try container.decode(String.self, forKey: .author)
        text = try container.decode(String.self, forKey: .text)
        lat = try container.decode(Double.self, forKey: .lat)
        lon = try container.decode(Double.self, forKey: .lon)
        location = try container.decode(String.self, forKey: .location)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(image?.jpegData(compressionQuality: 0.5)?.base64EncodedString(), forKey: .image)
        try container.encode(author, forKey: .author)
        try container.encode(text, forKey: .text)
        try container.encode(lat, forKey: .lat)
        try container.encode(lon, forKey: .lon)
        try container.encode(location, forKey: .location)
    }
}
