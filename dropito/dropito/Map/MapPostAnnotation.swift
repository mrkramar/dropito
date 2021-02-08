//
//  MapPostAnnotation.swift
//  dropito
//
//  Created by Maros Kramar on 21/12/2020.
//

import Foundation
import MapKit

final class MapPostAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    
    
    init(
        coordinate: CLLocationCoordinate2D,
        title: String,
        subtitle: Int
    ) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = String(subtitle)
    }
}
