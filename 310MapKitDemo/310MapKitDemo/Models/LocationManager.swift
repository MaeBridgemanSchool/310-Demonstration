//
//  LocationManager.swift
//  310MapKitDemo
//
//  Created by Grant Olson on 3/5/25.
//

import SwiftUI
import MapKit
import CoreLocation

// manage the user's location data
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    // make an instance
    private let manager = CLLocationManager()
    // store the user's location
    @Published var userLocation: CLLocation?
    
    //initialize the manager
    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    // Method to get the most recent location of the user
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.userLocation = location
        }
    }
}
