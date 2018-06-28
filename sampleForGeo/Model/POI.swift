
//
//  POI.swift
//  sampleForGeo
//
//  Created by saadhvi on 6/22/18.
//  Copyright © 2018 Joshila. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

class POI: Object {
   
    @objc dynamic var address : String = ""
    @objc dynamic var latitude : Double = 0.0
    @objc dynamic var longitude : Double = 0.0
 //   @objc dynamic var done : Bool = false
    
    
    func calcDistanceFromUser(userLoc: CLLocation) -> Double {
        return CLLocation(latitude: latitude, longitude: longitude).distance(from: userLoc)
    }
 
    
    
//    init(address: String, latitude: Double, longitude: Double) {
//        self.address = address
//        self.latitude = latitude
//        self.longitude = longitude
       
    }


