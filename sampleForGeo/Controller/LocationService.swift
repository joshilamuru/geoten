//
//  LocationService.swift
//  sampleForGeo
//
//  Created by saadhvi on 7/4/18.
//  Copyright © 2018 Joshila. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService : NSObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    var data = [String: CLLocation]()
    override init() {
        super.init()
    //    initLocationManager()
        
    }
    
    func initLocationManager() {
        //Setup location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        //locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    func postNotification() {
        NotificationCenter.default.post(name: .currentLoc, object: nil, userInfo: data)
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
            
             currentLocation = locations[locations.count-1] //getting the last updated location which is most accurate
            data  = ["value" : currentLocation]
            print(data["value"] as! CLLocation)
            if currentLocation.horizontalAccuracy > 0 {
                self.locationManager.stopUpdatingLocation()
               // NotificationCenter.default.post(name: Notification.Name(rawValue: "currentLoc"), object: nil, userInfo: data)
               postNotification()
            
                print("longitude = \(currentLocation.coordinate.longitude), latitude = \(currentLocation.coordinate.latitude)")
                
               
                
                
            
        }
        
        
        //didFailWithError method
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print(error)
            //locationDetailLabel.text = "Location Unavailable"
        }
        
        
    }
}
extension Notification.Name{
    public static let currentLoc = Notification.Name(rawValue: "currentLoc")
}
