//
//  Alerts.swift
//  dropito
//
//  Created by Maros Kramar on 07/02/2021.
//

import Foundation
import UIKit.UIAlertController

final class Alerts {
    
    static func connectionAlert(action: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(
            title: "Connection error",
            message: "Server is not responding. Try again later",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
            action()
        })
        
        return alert
    }
}

