//
//  DataManager.swift
//  BestGasPrice
//
//  Created by Jason Zheng on 4/24/17.
//  Copyright © 2017 Jason Zheng. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class DataManager: NSObject {
    
    class func getData() -> [MapItem]{
        var returnData : [MapItem] = [];
        
        let prefs = UserDefaults.standard
        let migrationId = prefs.integer(forKey: "dataMigration")
        if(migrationId == 1){
            // migration exists
            readStations(returnData: &returnData)
            print("read from core data")
        }else{
            // migration does not exist
            // 1
            let fileName = Bundle.main.path(forResource: "data", ofType: "json");
            let data: Data? = try? Data(contentsOf: URL(fileURLWithPath: fileName!))
            
            // 2
            let jsonObject: [String:AnyObject]! = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [String:AnyObject]
            
            // 3
            let dataItems = jsonObject["stations"] as! [AnyObject]
            
            for case let dataItem as [String:AnyObject] in dataItems{
                let mapItem = MapItem(
                    title: dataItem["station"] as! String,
                    coordinate: CLLocationCoordinate2D(
                        latitude: dataItem["lat"] as! CLLocationDegrees,
                        longitude: dataItem["lng"] as! CLLocationDegrees));
                
                mapItem.price = dataItem["reg_price"] as? Double
                mapItem.details = dataItem["notes"] as? String
                print(mapItem.title, mapItem.coordinate, mapItem.price, mapItem.details)
                //create the coredata entity
                createStation(name: dataItem["station"] as! String, lat: dataItem["lat"] as! Double, lng: dataItem["lng"] as! Double, reg_price:dataItem["reg_price"] as! Double, details: dataItem["notes"] as! String)
                returnData.append(mapItem);
            }
            print("created coredata items")
        }
        return returnData;
    }
}

var stations : [NSManagedObject] = []

func createStation(name: String, lat:Double, lng:Double, reg_price:Double, details:String ) {
    //1
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    //2
    let entity =  NSEntityDescription.entity(forEntityName: "Station", in:managedContext)
    
    let station = NSManagedObject(entity: entity!, insertInto: managedContext)
    
    //3
    station.setValue(name, forKey: "station")
    station.setValue(lat, forKey: "lat")
    station.setValue(lng, forKey:"lng")
    station.setValue(reg_price, forKey:"reg_price")
    station.setValue(details, forKey:"notes")
    //4
    do {
        try managedContext.save()
        //5
        stations.append(station)
    } catch let error as NSError  {
        print("Could not save \(error), \(error.userInfo)")
    }
}

func readStations(returnData: inout [MapItem]){
    //1
    let appDelegate =
        UIApplication.shared.delegate as! AppDelegate
    
    let managedContext = appDelegate.persistentContainer.viewContext
    //2
    let fetchRequest = 	NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
    
    //fetchRequest.predicate = NSPredicate(format: "station = %@", "Another")
    
    //3
    do {
        let results =
            try managedContext.fetch(fetchRequest)
        stations = results as! [NSManagedObject]
        for station in stations{
            
            let mapItem = MapItem(
                title: station.value(forKey:"station")! as! String,
                coordinate: CLLocationCoordinate2D(
                    latitude: station.value(forKey:"lat") as! CLLocationDegrees,
                    longitude: station.value(forKey:"lng") as! CLLocationDegrees));
            
            mapItem.price = station.value(forKey: "reg_price") as? Double
            mapItem.details = station.value(forKey: "notes") as? String
            returnData.append(mapItem);
        }
        print("Success read from station")
    } catch let error as NSError {
        print("Could not fetch \(error), \(error.userInfo)")
    }
}


