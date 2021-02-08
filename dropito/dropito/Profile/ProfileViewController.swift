//
//  ProfileViewController.swift
//  dropito
//
//  Created by Maros Kramar on 21/12/2020.
//

import Foundation
import UIKit


class ProfileViewController: UIViewController {
    
    
    private let viewModel: ProfileViewModeling
    private var postListViewController: PostListViewController
    
    init(viewModel: ProfileViewModeling) {
        self.viewModel = viewModel
        self.postListViewController = PostListViewController(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var usernameLabel: UILabel = UILabel()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        
        setUpProfilePic()
        setUpDismissButton()
        usernameLabel = setUpUsernameLabel()
        setUplogOutButton()
        setUpPostList()
        
    }
    
    private func setUpPostList() {

        addChild(postListViewController)
        postListViewController.didMove(toParent: self)
        
        let postListView = postListViewController.view!
        postListView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(postListView)
        
        NSLayoutConstraint.activate([
            postListView.widthAnchor.constraint(equalTo: view.widthAnchor),
            postListView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 30),
            postListView.topAnchor.constraint(equalTo: view.topAnchor, constant: 300)
        ])
    }
    
    private func setUpProfilePic() {
        let image = UIImage(systemName: "person.circle.fill")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50)
        ])
    }
    
    private func setUpUsernameLabel() -> UILabel {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.username
        label.font = UIFont(name: "Helvetica-Bold", size: 30)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 220),
            label.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor),
            label.heightAnchor.constraint(lessThanOrEqualToConstant: 30),
        ])
        return label
    }
    
    private func setUplogOutButton() {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Log out", for: .normal)
        button.setTitleColor(.red, for: .normal)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 260),
            button.widthAnchor.constraint(lessThanOrEqualToConstant: 150),
            button.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        button.addTarget(self, action: #selector(logOutTapped), for: .touchUpInside)
    }
    
    private func setUpDismissButton() {
        let dismissButton = UIButton(frame: CGRect(x: 20, y: 20, width: 25, height: 25))
        dismissButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        view.addSubview(dismissButton)
        dismissButton.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
    }
    
    @objc private func dismissTapped() {
        dismiss(animated: true)
    }
    
    @objc private func logOutTapped() {
    
        func updateUsername() {
            self.viewModel.username = UserDefaults.standard.string(forKey: "username") ?? "error"
            self.usernameLabel.text = viewModel.username
            viewModel.loadUserPosts() { success in
                if success {
                    DispatchQueue.main.async { [self] in
                        postListViewController.tableView.reloadData()
                    }
                }
                else {
                    DispatchQueue.main.async { [self] in
                        let alert = Alerts.connectionAlert {
                            self.logOutTapped()
                        }
                        present(alert, animated: true) {}
                    }
                }
            }
        }
        
        signInAlert(vc: self, action: updateUsername)
    }
}
