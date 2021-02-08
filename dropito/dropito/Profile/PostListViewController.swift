//
//  PostListViewController.swift
//  dropito
//
//  Created by Maros Kramar on 07/02/2021.
//

import Foundation
import UIKit

final class PostListViewController: UIViewController {
    var viewModel: ProfileViewModeling
    var tableView = UITableView()
    var titleLabel = UILabel()
    
    init(viewModel: ProfileViewModeling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        
        super.loadView()
        
        setUpTitleLabel()
        setUpTableView()
    }
    
    override func viewDidLoad() {
        
        viewModel.loadUserPosts() { success in
            if success {
                DispatchQueue.main.async { [self] in
                    tableView.reloadData()
                }
            }
            else {
                DispatchQueue.main.async { [self] in
                    let alert = Alerts.connectionAlert {
                        self.viewDidLoad()
                    }
                    present(alert, animated: true) {}
                }
            }
        }
    }
    
    private func setUpTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Your posts"
        titleLabel.numberOfLines = 1
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
        ])
    }
    
    private func setUpTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20)
        ])
    }
}

extension PostListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style:UITableViewCell.CellStyle.subtitle, reuseIdentifier: "postCell")
        var content = cell.defaultContentConfiguration()
        
        content.text = "\(viewModel.posts[indexPath.row].lat), \(viewModel.posts[indexPath.row].lon)"
        content.secondaryText = viewModel.posts[indexPath.row].text
        
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        self.present(PostDetailViewController(viewModel: PostDetailViewModel(postID: viewModel.posts[indexPath.row].id)), animated: true) {}
    }
}
