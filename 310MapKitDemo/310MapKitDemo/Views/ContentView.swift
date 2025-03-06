//
//  _10MapKitDemoApp.swift
//  310MapKitDemo
//
//  Created by Mae Bridgeman on 2/26/25.
//
import SwiftUI
import MapKit

//Main View of the App
struct ContentView: View {
    //Use the location manager
    @StateObject private var locationManager = LocationManager()
    
    //Make sure we can move the map
    @State private var position: MapCameraPosition = .automatic
    
    //MapPin Array
    @State private var pinLocations: [MapPin] = []
    
    //Store the selected pin index
    @State private var selectedPinIndex: Int? = nil
    
    //Control whether or not the pop up is showing
    @State private var showPopup = false

    var body: some View {
        VStack {
            // Display the current user location if available, otherwise show a waiting message
            if let location = locationManager.userLocation {
                Text("Current location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            } else {
                Text("Waiting for location permissions or accurate data...")
            }
            
            // Embed the MapViewRepresentable to show the map
            MapViewRepresentable(
                position: $position,
                pins: $pinLocations,
                selectedPinIndex: $selectedPinIndex,
                showPopup: $showPopup
            )
            // Update the camera position when the user location changes
            .onChange(of: locationManager.userLocation) { newLocation, _ in
                guard let location = newLocation else { return }
                position = .camera(MapCamera(centerCoordinate: location.coordinate, distance: 1000))
            }
            .frame(height: 400)
        }
        //Show the popup when showPopup is true
        .sheet(isPresented: $showPopup) {
            // Ensure the selected index is valid before showing the popup
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
