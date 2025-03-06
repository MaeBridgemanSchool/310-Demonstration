//
//  MapPinLocations.swift
//  310MapKitDemo
//
//  Created by Grant Olson on 3/5/25.
//

import Foundation
import CoreLocation

struct MapPin: Identifiable, Hashable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    var title: String
    var description: String

    static func == (lhs: MapPin, rhs: MapPin) -> Bool {
        return lhs.id == rhs.id // ✅ Ensure equality is based on ID
    }
    
    // Hashing function to allow usage in ForEach
    func hash(into hasher: inout Hasher) {
        hasher.combine(coordinate.latitude)
        hasher.combine(coordinate.longitude)
    }
}
