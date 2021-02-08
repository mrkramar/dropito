//
//  PostCreateViewController.swift
//  dropito
//
//  Created by Maros Kramar on 21/12/2020.
//

import Foundation
import UIKit


class PostCreateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    var viewModel: PostCreateViewModeling
    var submitAction: () -> Void
    var textView: UITextView?
    var imageView: UIImageView?
    
    init(viewModel: PostCreateViewModeling, submitAction: @escaping () -> Void) {
        self.viewModel = viewModel
        self.submitAction = submitAction
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        
        setUpDismissButton()
        textView = setUpMessageBox()
        imageView = setUpImageBox()
        setUpSubmitButton()
    }
    
    private func setUpImageBox() -> UIImageView {
        
        let addPhotoButton = UIButton(type: .system)
        addPhotoButton.setTitle("Add photo", for: .normal)
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(addPhotoButton)
        
        addPhotoButton.addTarget(self, action: #selector(addPhotoTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            addPhotoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addPhotoButton.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            addPhotoButton.topAnchor.constraint(equalTo: textView!.bottomAnchor, constant: 20),
            addPhotoButton.heightAnchor.constraint(lessThanOrEqualToConstant: 30)
        ])
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .gray
        return imageView
    }
    
    private func setUpSubmitButton() {
        let button: UIButton = UIButton()
        button.setImage(UIImage(systemName: "mappin.circle"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        view.addSubview(button)
        button.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            button.widthAnchor.constraint(equalToConstant: 70),
            button.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func setUpMessageBox() -> UITextView {
        let messageBox = UITextView()
        messageBox.translatesAutoresizingMaskIntoConstraints = false
        messageBox.text = "Type your thoughts here..."
        messageBox.textColor = .lightGray
        messageBox.isEditable = true
        messageBox.autocapitalizationType = .words
        messageBox.isScrollEnabled = false
        messageBox.font = UIFont(name: messageBox.font!.fontName, size: 18)
        view.addSubview(messageBox)
        
        NSLayoutConstraint.activate([
            messageBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            messageBox.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            messageBox.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            messageBox.heightAnchor.constraint(lessThanOrEqualToConstant: 300),
        ])
        messageBox.delegate = self
        return messageBox
    }
    
    internal func textViewDidBeginEditing (_ textView: UITextView) {
        if textView.textColor == .lightGray && textView.isFirstResponder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    internal func textViewDidEndEditing (_ textView: UITextView) {
        if textView.text.isEmpty || textView.text == "" {
            textView.textColor = .lightGray
            textView.text = "Type your thoughts here..."
        }
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
    
    @objc private func addPhotoTapped() {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .photoLibrary
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage  {
            
            imageView!.image = image
            
            view.addSubview(imageView!)
            
            imageView!.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                imageView!.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
                imageView!.topAnchor.constraint(equalTo: textView!.bottomAnchor, constant: 20),
                imageView!.heightAnchor.constraint(lessThanOrEqualToConstant: 300)
            ])
        }
    }
    
    @objc private func submitTapped() {

        viewModel.createPost(text: textView!.text!, photo: imageView?.image) { success in
            if success {
                DispatchQueue.main.async { [weak self] in
                    self?.dismiss(animated: true, completion: self?.submitAction)
                }
            } else {
                let alert = Alerts.connectionAlert {
                    self.submitTapped()
                }
                self.present(alert, animated: true) {}
            }
        }
    }
}
