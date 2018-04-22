//
//  ViewController.swift
//  GetLocation
//
//  Created by Andrew Tittle on 3/7/18.
//  Copyright © 2018 Andrew Tittle. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    var manager = CLLocationManager()
    var placemark = CLPlacemark()

    var longitudeStored : Double?
    var latitudeStored : Double?
    
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var zipcodeLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var longLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    @IBAction func getLocation(_ sender: UIButton) {
        //formats double into string to display in UILabel
        let longDoubleToString : String = String(format: "%f", longitudeStored!)
        let latDoubleToString : String = String(format: "%f", latitudeStored!)
        //sets labels text to our variables
        longLabel.text = longDoubleToString
        latLabel.text = latDoubleToString
        
        
        
    }
    
    @IBAction func reverseGeoCoderButton(_ sender: UIButton) {
        reverseGeoCode(latitude: latitudeStored!, longitude: longitudeStored!) { placemark, error in
            guard let placemark = placemark, error == nil else { return }
            DispatchQueue.main.async {
               print("address 1 :", placemark.thoroughfare ?? "")
                print("address 2 :", placemark.subThoroughfare ?? "")
                print("city :", placemark.locality ?? "")
                print("state :", placemark.administrativeArea ?? "")
                print("zip code :", placemark.postalCode ?? "")
                print("country :", placemark.country ?? "")
                }
            self.addressLabel.text = placemark.thoroughfare
            self.cityLabel.text = placemark.locality
            self.stateLabel.text = placemark.administrativeArea
            self.zipcodeLabel.text = placemark.postalCode
            self.countryLabel.text = placemark.country
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loads all neccsarry CLLocation assets
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //location function to gather location info
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation : CLLocation = locations[0]
        longitudeStored = userLocation.coordinate.longitude
        latitudeStored = userLocation.coordinate.latitude
        print(latitudeStored as Any, longitudeStored as Any)
        manager.stopUpdatingLocation()
        
    }
    
    //reverse GeoCode location info
    func reverseGeoCode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitudeStored!, longitude: longitudeStored!)) {
            placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                completion(nil, error)
                return
            }
            completion(placemark, nil)
        }
    }
    
    
    
}

