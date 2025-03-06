//
//  MapViewRepresentable.swift
//  310MapKitDemo
//
//  Created by Grant Olson on 3/5/25.
//

import SwiftUI
import MapKit

//MapView to SwiftUI Bridge that allows us to know the coordinates of pins
struct MapViewRepresentable: UIViewRepresentable {
    @Binding var position: MapCameraPosition
    @Binding var pins: [MapPin]
    @Binding var selectedPinIndex: Int?
    @Binding var showPopup: Bool
    
    // Handle Map Events
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewRepresentable
        var mapView: MKMapView?

        // Store the parent reference for later
        init(parent: MapViewRepresentable) {
            self.parent = parent
        }

        // Handle long press gestures on the map view to add new pins.
        @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
            guard gesture.state == .began, let mapView = mapView else { return }
            
            //convert where the user touches to geographical coordinates
            let touchPoint = gesture.location(in: mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)

            //updat the pins array
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                // Create a new pin with the touch coordinate, a default title, and a description that includes the current date.
                let newPin = MapPin(
                    coordinate: coordinate,
                    title: "New Pin \(parent.pins.count + 1)",
                    description: "Created at \(Date())"
                )
                parent.pins.append(newPin)
            }
        }
        
        // Called when an annotation (MapPin) is selected on the map.
        func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
            if let pinAnnotation = annotation as? MKPointAnnotation {
                // Find the index of the corresponding MapPin by matching coordinates.
                let index = self.parent.pins.firstIndex(where: {
                    $0.coordinate.latitude == pinAnnotation.coordinate.latitude &&
                    $0.coordinate.longitude == pinAnnotation.coordinate.longitude
                })
                
                // Update the selected pin index and display the popup
                DispatchQueue.main.async {
                    self.parent.selectedPinIndex = index
                    self.parent.showPopup = true
                }
            }
        }
        
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    // Creates and configures the MKMapView instance.
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator
        context.coordinator.mapView = mapView
        
        //recognize long presses
        let longPressRecognizer = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleLongPress(_:)))
        mapView.addGestureRecognizer(longPressRecognizer)

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        //Remove the existing annotations (businesses, important locations, etc.) from the view.
        uiView.removeAnnotations(uiView.annotations)
        //Add MapPins as annotations
        let annotations = pins.map { pin -> MKPointAnnotation in
            let annotation = MKPointAnnotation()
            annotation.coordinate = pin.coordinate
            annotation.title = pin.title
            return annotation
        }
        uiView.addAnnotations(annotations)
    }
}
