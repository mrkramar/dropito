//
//  CommentViewController.swift
//  dropito
//
//  Created by Maros Kramar on 06/02/2021.
//

import Foundation
import UIKit

final class CommentViewController: UIViewController {
    
    var textView = UITextView()
    var tableView = UITableView()
    var submitButton = UIButton(type: .system)
    var viewModel: PostDetailViewModeling
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: PostDetailViewModeling) {
        
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    override func loadView() {
        super.loadView()

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.separatorColor = .clear
        view.addSubview(tableView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Type your comment here..."
        textView.textColor = .lightGray
        textView.isEditable = true
        textView.isScrollEnabled = false
        textView.font = UIFont(name: textView.font!.fontName, size: 18)
        textView.delegate = self
        view.addSubview(textView)
        
        submitButton.setTitle("Send", for: .normal)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.addTarget(self, action: #selector(self.createComment), for: .touchUpInside)
        view.addSubview(submitButton)
        
    }
    
    func refreshComments() {
        self.viewModel.loadComments() { success in
            if success {
                DispatchQueue.main.async { [self] in
                    self.tableView.reloadData()
                }
            }
            else {
                DispatchQueue.main.async { [self] in
                    let alert = Alerts.connectionAlert {
                        self.refreshComments()
                    }
                    present(alert, animated: true) {}
                }
            }
        }
    }
    
    @objc func createComment() {
        viewModel.createComment(text: textView.text) { success in
            if success {
                DispatchQueue.main.async { [self] in
                    refreshComments()
                    textView.isEditable = false
                    textView.isEditable = true
                    textView.textColor = .lightGray
                    textView.text = "Type your thoughts here..."
                }
            }
            else {
                DispatchQueue.main.async { [self] in
                    DispatchQueue.main.async { [self] in
                        let alert = Alerts.connectionAlert {
                            self.createComment()
                        }
                        present(alert, animated: true) {}
                    }
                }
            }
        }
    }
}

extension CommentViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(viewModel.comments?.count ?? 0)
        return viewModel.comments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style:UITableViewCell.CellStyle.subtitle, reuseIdentifier: "messageCell")
        var content = cell.defaultContentConfiguration()
        
        content.text = viewModel.comments?[indexPath.row].author
        content.secondaryText = viewModel.comments?[indexPath.row].text
        
        cell.contentConfiguration = content
        return cell
    }
    
}

extension CommentViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing (_ textView: UITextView) {
        if textView.textColor == .lightGray && textView.isFirstResponder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing (_ textView: UITextView) {
        if textView.text.isEmpty || textView.text == "" {
            textView.textColor = .lightGray
            textView.text = "Type your thoughts here..."
        }
    }
}
