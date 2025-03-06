//
//  MapViewRepresentable.swift
//  310MapKitDemo
//
//  Created by Grant Olson on 3/5/25.
//

import SwiftUI
import MapKit

struct MapViewRepresentable: UIViewRepresentable {
    @Binding var position: MapCameraPosition
    @Binding var pins: [MapPin]
    @Binding var selectedPinIndex: Int?
    @Binding var showPopup: Bool

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewRepresentable
        var mapView: MKMapView?

        init(parent: MapViewRepresentable) {
            self.parent = parent
        }

        @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
            guard gesture.state == .began, let mapView = mapView else { return }

            let touchPoint = gesture.location(in: mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                // Create a pin with a default name
                let newPin = MapPin(
                    coordinate: coordinate,
                    title: "New Pin \(parent.pins.count + 1)",
                    description: "Created at \(Date())"
                )
                parent.pins.append(newPin)
            }
        }
        
        func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
            if let pinAnnotation = annotation as? MKPointAnnotation {
                let index = self.parent.pins.firstIndex(where: {
                    $0.coordinate.latitude == pinAnnotation.coordinate.latitude &&
                    $0.coordinate.longitude == pinAnnotation.coordinate.longitude
                })

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

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator
        context.coordinator.mapView = mapView

        let longPressRecognizer = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleLongPress(_:)))
        mapView.addGestureRecognizer(longPressRecognizer)

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)
        let annotations = pins.map { pin -> MKPointAnnotation in
            let annotation = MKPointAnnotation()
            annotation.coordinate = pin.coordinate
            annotation.title = pin.title
            return annotation
        }
        uiView.addAnnotations(annotations)
    }
}
