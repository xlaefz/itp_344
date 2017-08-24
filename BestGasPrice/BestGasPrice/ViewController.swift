//
//  ViewController.swift
//  BestGasPrice
//
//  Created by Jason Zheng on 4/24/17.
//  Copyright © 2017 Jason Zheng. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    var data : [MapItem]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // set initial location in Honolulu
        let initialLocation = CLLocation(latitude: 34.020404, longitude: -118.286583)
        centerMapOnLocation(initialLocation)
        mapView.delegate = self
        
        
        
        let prefs = UserDefaults.standard
        let migrationId = prefs.integer(forKey:"dataMigration")
        data = DataManager.getData()
        if(migrationId != 1){
            //if migration doesn't exist
            prefs.set(1, forKey: "dataMigration")
            prefs.synchronize()
        }
        
        
        mapView.addAnnotations(data)
    }
    
    let regionRadius: CLLocationDistance = 3000
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
}

extension ViewController: MKMapViewDelegate {
    
    // 1
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? MapItem {
            let identifier = "pin"
            var view: MyPinView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MyPinView { // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // 3
                view = MyPinView(annotation: annotation, price: annotation.price!)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                //view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
            }
            return view
        }
        return nil
    }
}
