//
//  MessageListViewController.swift
//  dropito
//
//  Created by Maros Kramar on 21/12/2020.
//

import Foundation
import UIKit

class MessageListViewController: UIViewController {
    
    private let viewModel: MessageListViewModeling
    
    init(viewModel: MessageListViewModeling) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        
        setUpDismissButton()
        setUpTitleLabel()
        setUpMessagesTable()
        
        viewModel.loadMessages()
    }
    
    private func setUpTitleLabel() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Private messages"
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 30)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
        ])
    }
    
    private func setUpMessagesTable() {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
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
}

extension MessageListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style:UITableViewCell.CellStyle.subtitle, reuseIdentifier: "messageCell")
        var content = cell.defaultContentConfiguration()
        
        content.text = viewModel.messages[indexPath.row].sender
        content.secondaryText = viewModel.messages[indexPath.row].text
        
        
        cell.contentConfiguration = content
        return cell
    }
    
}
