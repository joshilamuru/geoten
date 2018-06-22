
//
//  POI.swift
//  sampleForGeo
//
//  Created by saadhvi on 6/22/18.
//  Copyright © 2018 Joshila. All rights reserved.
//

import Foundation
import RealmSwift

class POI: Object {
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var address: String = ""
    
}
