//
//  MapVIewController.swift
//  dropito
//
//  Created by Maros Kramar on 12/12/2020.
//

import Foundation
import MapKit
import CoreLocation

final class MapViewController: UIViewController, CLLocationManagerDelegate {

    private weak var mapView: MKMapView!
    let viewModel: MapViewModeling
    private let locationManager = CLLocationManager()
    private var isCentered = false
    
    init(viewModel: MapViewModeling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        
        super.loadView()
        if UserDefaults.standard.string(forKey: "username") == nil {
            signInAlert(vc: self, action: {})
        }
        
        
        setUpMapView()
        setUpCreatePostButton()
        setUpProfileButton()
        setUpMessagesButton()
        setUpCenterLocationButton()
        
        
        //mapView.subviews[1].removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.startUpdatingLocation()

            mapView.register(MapPostAnnotationView.self, forAnnotationViewWithReuseIdentifier: "MapPostAnnotationView")
            mapView.showsUserLocation = true
            
            refreshAnnotations()
            centerLocationTapped()
            Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(self.refreshAnnotations), userInfo: nil, repeats: true)
            
        } else if locationManager.authorizationStatus == .denied {
            showNoLocationAlert()
        }
    }
    
    private func setUpMessagesButton() {
        
        let button: UIButton = UIButton()
        
        button.setImage(UIImage(systemName: "envelope"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -65),
            button.widthAnchor.constraint(equalToConstant: 40),
            button.heightAnchor.constraint(equalToConstant: 30),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27)
        ])
        
        button.addTarget(self,
                         action: #selector(messagesTapped),
                         for: .touchUpInside)
    }
    
    private func setUpProfileButton() {
        
        let button: UIButton = UIButton()
        
        button.setImage(UIImage(systemName: "person"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -65),
            button.widthAnchor.constraint(equalToConstant: 30),
            button.heightAnchor.constraint(equalToConstant: 30),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
        
        button.addTarget(self,
                         action: #selector(profileTapped),
                         for: .touchUpInside)
    }
    
    private func setUpMapView() {
        
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.pointOfInterestFilter = .excludingAll
        
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
        ])
        mapView.delegate = self
        self.mapView = mapView
    }
    
    private func setUpCreatePostButton() {
        
        let button: UIButton = UIButton()
        button.setImage(UIImage(systemName: "mappin.circle.fill"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            button.widthAnchor.constraint(equalToConstant: 70),
            button.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        button.addTarget(self,
                         action: #selector(createPostTapped),
                         for: .touchUpInside)
    }
    
    @objc func refreshAnnotations() {

        mapView.removeAnnotations(mapView.annotations)
        
        viewModel.loadPosts(coordinate: locationManager.location!.coordinate) { success in
            if success {
                DispatchQueue.main.async { [self] in
                    for post in self.viewModel.posts {
                        let coordinate = CLLocationCoordinate2D(latitude: post.lat, longitude: post.lon)
                        self.mapView.addAnnotation(MapPostAnnotation(coordinate: coordinate, title: post.author, subtitle: post.id))
                    }
                }
            }
            else {
                DispatchQueue.main.async { [self] in
                    let alert = Alerts.connectionAlert {
                        self.refreshAnnotations()
                    }
                    present(alert, animated: true) {}
                }
            }
        }
    }
    
    private func setUpCenterLocationButton() {
        let button = UIButton(frame: CGRect(x: 10, y: 40, width: 40, height: 40))
        button.setImage(UIImage(systemName: "scope"), for: .normal)
        button.tintColor = .black
        view.addSubview(button)
        button.addTarget(self, action: #selector(centerLocationTapped), for: .touchUpInside)
    }
    
    @objc private func centerLocationTapped() {
        guard let location: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
        if !isCentered {
            self.mapView.setRegion(region, animated: true)
        }
        isCentered = !isCentered
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
        if isCentered {
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("yes")
        viewDidAppear(true)
    }
    
    @objc private func createPostTapped() {
        let vm = PostCreateViewModel(coordinates: locationManager.location!.coordinate)
        let vc = PostCreateViewController(viewModel: vm, submitAction: self.refreshAnnotations)
        self.present(vc, animated: true) {}
    }
    
    @objc private func profileTapped() {
        self.present(ProfileViewController(viewModel: ProfileViewModel()), animated: true) {}
    }
    
    @objc private func messagesTapped() {
        self.present(MessageListViewController(viewModel: MessageListViewModel()), animated: true) {}
    }
    

    
    private func showNoLocationAlert() {
        let alert = UIAlertController(
            title: "Location error",
            message: "You can't use this app without sharing your location.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if !(annotation is MapPostAnnotation) {
            return nil
        }

        let mapPostAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "MapPostAnnotationView") as! MapPostAnnotationView
        mapPostAnnotationView.canShowCallout = true
        
        var post: Post!
        
        for p in viewModel.posts {
            if p.id == Int(annotation.subtitle!!) {
                post = p
            }
        }

        mapPostAnnotationView.postImage = post.image
        mapPostAnnotationView.postLocation = post.text
        mapPostAnnotationView.postId = post.id
        mapPostAnnotationView.parentView = self
        return mapPostAnnotationView
    }
}
