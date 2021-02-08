//
//  Comment.swift
//  dropito
//
//  Created by Maros Kramar on 02/02/2021.
//

import Foundation

struct Comment: Hashable, Codable {
    
    let author: String
    let text: String
    let timestamp: String
}


struct CommentResponse: Codable {
    let objects: [Comment]
}
