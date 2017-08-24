//
//  MyPinView.swift
//  BestGasPrice
//
//  Created by Jason Zheng on 4/24/17.
//  Copyright © 2017 Jason Zheng. All rights reserved.
//

import UIKit
import MapKit

class MyPinView: MKAnnotationView {
    
    var price : Double?
    
    convenience init(annotation: MKAnnotation?,  price: Double){
        self.init(annotation: annotation, reuseIdentifier: nil)
        self.price = price
        self.annotation = annotation
        self.canShowCallout = true
        self.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
        
        self.image = UIImage(named: "customPin")
        
        self.bounds = CGRect(x: 0, y: 0, width: 60, height: 60)
        
        let label : UILabel = UILabel(frame: CGRect(x: 5, y: 8, width: 37, height: 15))
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.darkGray
        label.text = "\(price)"
        label.font = UIFont.systemFont(ofSize: 12, weight: 2)
        self.addSubview(label)
        
        
        
    }
    
}
