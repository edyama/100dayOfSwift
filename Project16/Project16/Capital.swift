//
//  Capital.swift
//  Project16
//
//  Created by Ed Yama on 27/07/21.
//

import MapKit
import UIKit

class Capital: NSObject, MKAnnotation {
    
    // MARK: - Properties
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    // MARK: - Init
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
