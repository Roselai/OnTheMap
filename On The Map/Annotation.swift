//
//  Annotations.swift
//  On The Map
//
//  Created by Shukti Shaikh on 8/5/16.
//  Copyright © 2016 Shukti Shaikh. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Annotation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}