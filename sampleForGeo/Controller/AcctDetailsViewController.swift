//
//  AcctDetailsViewController.swift
//  sampleForGeo
//
//  Created by saadhvi on 8/9/18.
//  Copyright © 2018 Joshila. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

class AcctDetailsViewController: UIViewController, LocationUpdateProtocol  {

    
    @IBOutlet weak var mapView: GMSMapView!
    var currentLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         NotificationCenter.default.addObserver(self, selector: #selector(AcctDetailsViewController.locationUpdateNotification(_:)), name: NSNotification.Name(rawValue: kLocationDidChangeNotification), object: nil)
        let LocationMgr = LocationService.SharedManager
        LocationMgr.delegate = self
        print("CurrentLocation obtained \(currentLocation)")
        
        // Do any additional setup after loading the view.
    }

    func initMap() {
        let camera = GMSCameraPosition.camera(withLatitude: (currentLocation.coordinate.latitude),longitude: (currentLocation.coordinate.longitude), zoom: 16)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        let gmsCircle = GMSCircle(position: (currentLocation.coordinate), radius: 100)
        let update = GMSCameraUpdate.fit(gmsCircle.bounds())
        mapView.animate(with: update)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc func locationUpdateNotification(_ notification: Notification) {
        let userinfo = notification.userInfo
        self.currentLocation = userinfo!["location"] as! CLLocation
        print("Latitude : \(self.currentLocation.coordinate.latitude)")
        print("Longitude : \(self.currentLocation.coordinate.longitude)")
        initMap()
    }

    func locationDidUpdateToLocation(location: CLLocation) {
        currentLocation = location
        print(currentLocation)
      //  initMap()
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kLocationDidChangeNotification), object: nil)
    }
}
