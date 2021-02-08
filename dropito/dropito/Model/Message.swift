//
//  Message.swift
//  dropito
//
//  Created by Maros Kramar on 31/01/2021.
//

import Foundation

struct Message: Hashable {
    let id: Int
    //let timestamp: String
    let sender: String
    let recipient: String
    let text: String
}
