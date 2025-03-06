//
//  _10MapKitDemoApp.swift
//  310MapKitDemo
//
//  Created by Mae Bridgeman on 2/26/25.
//
import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    
    @State private var position: MapCameraPosition = .automatic

    @State private var pinLocations: [MapPin] = []
    @State private var selectedPinIndex: Int? = nil
    @State private var showPopup = false

    var body: some View {
        VStack {
            if let location = locationManager.userLocation {
                Text("Current location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            } else {
                Text("Waiting for location permissions or accurate data...")
            }
            
            MapViewRepresentable(
                position: $position,
                pins: $pinLocations,
                selectedPinIndex: $selectedPinIndex,
                showPopup: $showPopup
            )
            .onChange(of: locationManager.userLocation) { newLocation in
                guard let location = newLocation else { return }
                position = .camera(MapCamera(centerCoordinate: location.coordinate, distance: 1000))
            }
            .frame(height: 400)
        }
        .sheet(isPresented: $showPopup) {
            if let index = selectedPinIndex, index < pinLocations.count {
                PinInfoPopup(
                    title: Binding(
                        get: { pinLocations[index].title },
                        set: { pinLocations[index].title = $0 }
                    ),
                    description: Binding(
                        get: { pinLocations[index].description },
                        set: { pinLocations[index].description = $0 }
                    ),
                    onSave: {
                        pinLocations[index] = MapPin(
                            coordinate: pinLocations[index].coordinate,
                            title: pinLocations[index].title,
                            description: pinLocations[index].description
                        )
                        showPopup = false
                    }
                )
            } else {
                Text("Loading pin data...")
            }
        }
    }
}
