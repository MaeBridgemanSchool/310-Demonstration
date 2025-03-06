//
//  MapPinLocations.swift
//  310MapKitDemo
//
//  Created by Grant Olson on 3/5/25.
//

import Foundation
import CoreLocation

// create a struct for map pins. Has an ID, coordinates, title, and description
struct MapPin: Identifiable, Hashable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    var title: String
    var description: String
    
    // allows to compare the instances of two map pins based on their ID's
    // this was added to address pins not persisting after being saved
    static func == (lhs: MapPin, rhs: MapPin) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Hashing function to enable the pin to be used in a for each loop
    func hash(into hasher: inout Hasher) {
        hasher.combine(coordinate.latitude)
        hasher.combine(coordinate.longitude)
    }
}
