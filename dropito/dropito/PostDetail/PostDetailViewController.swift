//
//  PostDetailViewController.swift
//  dropito
//
//  Created by Maros Kramar on 31/01/2021.
//

import Foundation
import UIKit

final class PostDetailViewController: UIViewController, UIScrollViewDelegate {
    
    private let viewModel: PostDetailViewModeling
    private var imageView = UIImageView()
    private var scrollView = UIScrollView()
    private var textLabel = UILabel()
    private var commentView: CommentViewController
    
    init(viewModel: PostDetailViewModeling) {
        self.viewModel = viewModel
        self.commentView = CommentViewController(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
    
        super.loadView()
        view.backgroundColor = .white

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
        view.addSubview(scrollView)
        
        viewModel.loadPost() { success in
            if success {
                DispatchQueue.main.async { [self] in
                    setUpDismissButton()
                    setUpImageView()
                    setUpTextLabel()
                    setUpComments()
                    
                    while self.viewModel.comments == nil {}
                    
                    if viewModel.post?.author ==  UserDefaults.standard.string(forKey: "username")! {
                        setUpDeleteButton()
                    }
                }
            }
            else {
                DispatchQueue.main.async { [self] in
                    let alert = Alerts.connectionAlert {
                        self.loadView()
                    }
                    present(alert, animated: true) {}
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: commentView.view.bounds.height + imageView.bounds.height + textLabel.bounds.height + 100)
        let layout = view.safeAreaLayoutGuide
        scrollView.centerXAnchor.constraint(equalTo: layout.centerXAnchor).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: layout.centerYAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: layout.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: layout.heightAnchor).isActive = true
    }
    
    private func setUpDeleteButton() {
        let button = UIButton(frame: CGRect(x: view.frame.width - 50, y: 20, width: 25, height: 25))
        button.tintColor = .systemRed
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        
        view.addSubview(button)
        button.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    }
    
    private func setUpComments() {
        self.addChild(commentView)
        
        commentView.didMove(toParent: self)
        scrollView.addSubview(commentView.view!)
        
        NSLayoutConstraint.activate([
            commentView.textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            commentView.textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            commentView.textView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 30),
            commentView.textView.heightAnchor.constraint(lessThanOrEqualToConstant: 300),
            
            commentView.submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            commentView.submitButton.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor),
            commentView.submitButton.topAnchor.constraint(equalTo: commentView.textView.bottomAnchor, constant: 20),
            commentView.submitButton.heightAnchor.constraint(lessThanOrEqualToConstant: 30),
            
            commentView.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            commentView.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            commentView.tableView.topAnchor.constraint(equalTo: commentView.textView.bottomAnchor, constant: 50),
            commentView.tableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 500),
        ])
        commentView.refreshComments()
    }
    
    private func setUpImageView() {
        
        let authorLabel = UILabel()
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.text = viewModel.post?.author
        authorLabel.numberOfLines = 1
        authorLabel.font = UIFont.boldSystemFont(ofSize: 23)
        scrollView.addSubview(authorLabel)
        
        NSLayoutConstraint.activate([
            authorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            authorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            authorLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 60),
        ])
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = viewModel.post?.image
        scrollView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 100),
            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 300),
        ])
        
        if imageView.image == nil {
            NSLayoutConstraint.activate([
                imageView.heightAnchor.constraint(equalToConstant: 0)
            ])
        }
    }
    
    private func setUpTextLabel() {
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.text = viewModel.post?.text
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .justified
        scrollView.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
        ])
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
    
    @objc private func deleteTapped() {
        viewModel.deletePost(postID: viewModel.post!.id) { success in
            if success {
                DispatchQueue.main.async { [self] in
                    dismiss(animated: true)
                }
            }
            else {
                DispatchQueue.main.async { [self] in
                    DispatchQueue.main.async { [self] in
                        let alert = Alerts.connectionAlert {
                            self.deleteTapped()
                        }
                        present(alert, animated: true) {}
                    }
                }
            }
        }
    }
}
