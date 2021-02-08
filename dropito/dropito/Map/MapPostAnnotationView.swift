import Foundation
import UIKit
import MapKit

final class MapPostAnnotationView: MKAnnotationView {
    var postImage: UIImage? {
        get { postImageView.image }
        set { postImageView.image = newValue }
    }
    
    var postLocation: String? {
        get { postLocationLabel.text }
        set { postLocationLabel.text = newValue }
    }
    
    
    private weak var postImageView: UIImageView!
    private weak var postLocationLabel: UILabel!
    var postId: Int!
    weak var parentView: MapViewController!
    
    private var postDetailButton: UIButton = UIButton(type: .detailDisclosure)
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        translatesAutoresizingMaskIntoConstraints = false

        let icon = UIImageView(image: UIImage(systemName: "envelope"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        addSubview(icon)
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: leadingAnchor),
            icon.trailingAnchor.constraint(equalTo: trailingAnchor),
            icon.bottomAnchor.constraint(equalTo: bottomAnchor),
            icon.topAnchor.constraint(equalTo: topAnchor),
            icon.heightAnchor.constraint(equalToConstant: 40),
            icon.widthAnchor.constraint(equalToConstant: 50),
        ])
        
        let calloutView = UIView()
        let postImageView = UIImageView()
        
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        self.postImageView = postImageView

        calloutView.addSubview(postImageView)
        
        NSLayoutConstraint.activate([
            postImageView.leadingAnchor.constraint(equalTo: calloutView.leadingAnchor),
            postImageView.topAnchor.constraint(equalTo: calloutView.topAnchor, constant: 0),
            postImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 200),
            postImageView.widthAnchor.constraint(lessThanOrEqualToConstant: 200)
        ])

        self.postDetailButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        self.postDetailButton.addTarget(self, action: #selector(self.postDetailButtonTapped), for: .touchUpInside)
        
        let postLocationLabel = UILabel()
        postLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.postLocationLabel = postLocationLabel
        postLocationLabel.numberOfLines = 0
        
        calloutView.addSubview(self.postLocationLabel)
        
        NSLayoutConstraint.activate([
            postLocationLabel.leadingAnchor.constraint(equalTo: calloutView.leadingAnchor),
            postLocationLabel.trailingAnchor.constraint(equalTo: calloutView.trailingAnchor),
            postLocationLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 10),
            postLocationLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 150),
        ])
        
        NSLayoutConstraint.activate([
            calloutView.bottomAnchor.constraint(equalTo: postLocationLabel.bottomAnchor, constant: 5),
            calloutView.widthAnchor.constraint(equalToConstant: 200),
        ])
        
        detailCalloutAccessoryView = calloutView
        rightCalloutAccessoryView = self.postDetailButton
        
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func postDetailButtonTapped() {
    
        let pdvm = PostDetailViewModel(postID: self.postId)
        let pdvc = PostDetailViewController(viewModel: pdvm)
        
        parentView.present(pdvc, animated: true) {}
        
    }
}

