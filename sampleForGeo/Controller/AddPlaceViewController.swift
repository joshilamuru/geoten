//
//  AddPlaceViewController.swift
//  sampleForGeo
//
//  Created by saadhvi on 6/21/18.
//  Copyright © 2018 Joshila. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces


class AddPlaceViewController: UIViewController, UserLocationDelegate,
GMSAutocompleteViewControllerDelegate
{

    @IBOutlet weak var newPlacMapView: GMSMapView!

    var currentLocation = CLLocation()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpMap()
        
    }
    
        func setUpMap(){
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude,longitude: currentLocation.coordinate.longitude, zoom: 16)
        newPlacMapView.camera = camera
        newPlacMapView.isMyLocationEnabled = true
        newPlacMapView.settings.myLocationButton = true
        print("current location in appPlacevc: \(currentLocation)")
        let gmsCircle = GMSCircle(position: currentLocation.coordinate, radius: 100)
        let update = GMSCameraUpdate.fit(gmsCircle.bounds())
        newPlacMapView.animate(with: update)
        
    }
   
    func locationData(location: CLLocation) {
        currentLocation = location
        print("success  \(currentLocation)")
    }
    //NOT WORKING >>>NEED TO FIND OUT
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "addPlaceSegue") {
            let destinationVC = segue.destination as! MapViewController
            destinationVC.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchPlace(_ sender: Any) {
        let placePickerController = GMSAutocompleteViewController()
        placePickerController.delegate = self
        present(placePickerController, animated: true, completion: nil)
        
    }
    
    //MARK : Autocomplete search delegate methods
   
        func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
            print("Place name: \(place.name)")
            print("Place address: \(place.formattedAddress)")
            dismiss(animated: true, completion: nil)
            newPlacMapView.clear()
            let marker = GMSMarker()
            marker.position = place.coordinate
            marker.map = newPlacMapView
            self.newPlacMapView.animate(toLocation: place.coordinate)
            
        }
        
        func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
            print("error:", error.localizedDescription)
        }
        
        func wasCancelled(_ viewController: GMSAutocompleteViewController) {
            dismiss(animated: true, completion: nil)
        }
        
        func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }


