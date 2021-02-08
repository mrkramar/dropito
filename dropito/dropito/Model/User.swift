//
//  User.swift
//  dropito
//
//  Created by Maros Kramar on 21/12/2020.
//

import Foundation
import UIKit


struct User: Hashable {
    
    let username: String
    let avatar: UIImage?
    
}

func signInAlert(vc: UIViewController, action: @escaping () -> Void) {
    let alert = UIAlertController(
        title: "Sign In",
        message: "Enter your username",
        preferredStyle: .alert
    )
    alert.addTextField { textField in
        textField.text = ""
        textField.placeholder = "Username"
    }
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
        UserDefaults.standard.set(alert.textFields?.first?.text ?? "", forKey: "username")
        action()
    })
    vc.present(alert, animated: true)
}
