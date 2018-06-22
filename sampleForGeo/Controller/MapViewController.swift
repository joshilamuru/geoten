//
//  MapViewController.swift
//  sampleForGeo
//
//  Created by saadhvi on 6/13/18.
//  Copyright © 2018 Joshila. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation




class PointOfInterest: NSObject {
    var address : String
    var latitude : Double
    var longitude : Double
    var done : Bool = false
    
    func distanceFromUser(userLoc: CLLocation) -> Double {
       return CLLocation(latitude: latitude, longitude: longitude).distance(from: userLoc)
    }
    
    
    init(address: String, latitude: Double, longitude: Double) {
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
}
protocol UserLocationDelegate {
    func locationData(location: CLLocation)
}
class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var pointOfInterestTableView: UITableView!
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    // MARK: Declare variables
   // var poi = [PointOfInterest]()
    var delegate : UserLocationDelegate?
    let searchController = UISearchController(searchResultsController: nil)
    let locationManager = CLLocationManager()
    var currentLocation = CLLocation()
  
    var selectedIndexPath : IndexPath?
    var poi = [
      
        PointOfInterest(address: "address 4",latitude: 13.084413, longitude: 80.241083),
        PointOfInterest(address: "address 3", latitude: 13.083807, longitude: 80.239216),
        PointOfInterest(address: "address 2", latitude: 13.086044, longitude: 80.252087),
        PointOfInterest(address: "address 1", latitude: 13.088406, longitude:  80.241830),
        PointOfInterest(address: "address 5",latitude: 13.084413, longitude: 80.241083),
        PointOfInterest(address: "address 6", latitude: 13.083807, longitude: 80.239216),
        PointOfInterest(address: "address 7", latitude: 13.086044, longitude: 80.252087),
        PointOfInterest(address: "address 8", latitude: 13.088406, longitude:  80.241830), PointOfInterest(address: "address 4",latitude: 13.084413, longitude: 80.241083),
        PointOfInterest(address: "address 9", latitude: 13.083807, longitude: 80.239216),
        PointOfInterest(address: "address 10", latitude: 13.086044, longitude: 80.252087),
        PointOfInterest(address: "address 11", latitude: 13.088406, longitude:  80.241830), PointOfInterest(address: "address 4",latitude: 13.084413, longitude: 80.241083),
        PointOfInterest(address: "address 12", latitude: 13.083807, longitude: 80.239216),
        PointOfInterest(address: "address 13", latitude: 13.086044, longitude: 80.252087),
        PointOfInterest(address: "address 14", latitude: 13.088406, longitude:  80.241830)]
   /* var savedLocations = [["latitude": 14.2789631, "longitude": -90.299759],
                          ["latitude": 14.798016, "longitude": -89.544779],
                          ["latitude": 14.4039326, "longitude": -90.699493],
                          ["latitude": 14.4044418, "longitude": -90.698166],
                          ["latitude": 14.5640697, "longitude": -89.350716],
                          ["latitude": 14.2774296, "longitude": -90.298431]]*/
    var placesClient : GMSPlacesClient!
    var selectedPlace : GMSPlace?
    var sortedPoi : [PointOfInterest] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup search controller
        
        
        pointOfInterestTableView.delegate = self
        pointOfInterestTableView.dataSource = self
        //Setup location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //mapView.delegate = self
        
        //load pointsOfInterest from realm database
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Nearby Places"
      
    }
    
 
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    @IBAction func addNewPlacePressed(_ sender: Any) {
        delegate?.locationData(location: currentLocation)
        performSegue(withIdentifier: "addPlaceSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "addPlaceSegue") {
            let destinationVC = segue.destination as! AddPlaceViewController
            destinationVC.currentLocation = currentLocation
            
            navigationItem.title = " "
            destinationVC.navigationItem.title = "Add A New Place"
        }
    }
    
    // MARK : Sort poi based on distance from user location
    func sortPoiByDistance() {
        
          sortedPoi = poi.sorted(by: {$0.distanceFromUser(userLoc: currentLocation) < $1.distanceFromUser(userLoc: currentLocation)})
            for poi in sortedPoi{
            print(poi.address)
        }
        poi = sortedPoi
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    //didUpdateLocations method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[locations.count-1] //getting the last updated location which is most accurate
        if currentLocation.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            
            //sort Point of Interest locations and reload tableview
            sortPoiByDistance()
            self.pointOfInterestTableView.reloadData()
            
            print("longitude = \(currentLocation.coordinate.longitude), latitude = \(currentLocation.coordinate.latitude)")
            
            let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude,longitude: currentLocation.coordinate.longitude, zoom: 16)
            mapView.camera = camera
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
            let gmsCircle = GMSCircle(position: currentLocation.coordinate, radius: 100)
            let update = GMSCameraUpdate.fit(gmsCircle.bounds())
            mapView.animate(with: update)
            
           

            
            //To display all the locations markers and bound to them
        /*   mapView.clear()
            var bounds = GMSCoordinateBounds()
           for point in poi{
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
                print(marker.position.latitude, marker.position.longitude)
                bounds = bounds.includingCoordinate(marker.position)
                marker.map = self.mapView
                var update = GMSCameraUpdate.fit(bounds, withPadding: 20)
                mapView.moveCamera(update)
            }
            */
        
            
        }
    }
    //didFailWithError method
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        //locationDetailLabel.text = "Location Unavailable"
    }

}


// MARK: TableView datasource and delegate methods
extension MapViewController : UITableViewDelegate, UITableViewDataSource {
    
    //TableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pointOfInterestCell", for: indexPath)
        let item = poi[indexPath.row]
        cell.textLabel?.text = item.address
        //value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
      //  self.searchBar.resignFirstResponder()
        searchBar.endEditing(true)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // self.searchBar.resignFirstResponder()
        searchBar.endEditing(true)
        if(selectedIndexPath != nil && indexPath != selectedIndexPath) {
            tableView.cellForRow(at: selectedIndexPath!)?.accessoryType = .none
            poi[(selectedIndexPath?.row)!].done = false
        }
        
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            poi[indexPath.row].done = false
            mapView.clear()
            //tableView.reloadRows(at: [indexPath], with: .top)
        }else {
            
            poi[indexPath.row].done = true
            selectedIndexPath = indexPath
            mapView.clear()
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: poi[indexPath.row].latitude, longitude: poi[indexPath.row].longitude)
            marker.map = mapView
            self.mapView.animate(toLocation: marker.position)
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}





