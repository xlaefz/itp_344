//
//  MapItem.swift
//  BestGasPrice
//
//  Created by Jason Zheng on 4/24/17.
//  Copyright © 2017 Jason Zheng. All rights reserved.
//

import UIKit
import MapKit

class MapItem: NSObject, MKAnnotation {
    
    let title: String?
    let coordinate: CLLocationCoordinate2D
    var price: Double?
    var details: String?
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        super.init()
        
    }
    
    var subtitle: String? {
        return details
    }
    
    
}
