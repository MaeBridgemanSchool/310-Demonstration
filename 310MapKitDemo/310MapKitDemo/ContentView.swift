import SwiftUI
import MapKit
import CoreLocation

struct ContentView: View {
    
    //Store the user's position as a MapCameraPosition
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    //In getLocation(), this stores the user's position as a CLLocation
    @State private var userLocation: CLLocation?
    
    var body: some View {
        VStack {
            //If userLocation != nil, display the location
            if let location = userLocation {
                Text("Current location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            }
            //If userLocation is nil, either the user hasn't selected permissions, or they chose approximate
            else {
                Text("Doesn't have accurate location permissions.")
            }
            
            //Display a map centered on the position variable defined earlier
            Map(position: $position) {
                UserAnnotation()
            }
            //Create buttons so users can re-center and toggle the 3D map
            .mapControls {
                MapUserLocationButton()
                MapPitchToggle()
            }
            //Request permissions and calls getLocation() for the Text
            .onAppear {
                CLLocationManager().requestWhenInUseAuthorization()
                getLocation()
            }
        }
    }
    
    //Get the user's latest location and store it in the userLocation variable
    func getLocation() {
        Task {
            for try await update in CLLocationUpdate.liveUpdates() {
                DispatchQueue.main.async {
                    self.userLocation = update.location
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
