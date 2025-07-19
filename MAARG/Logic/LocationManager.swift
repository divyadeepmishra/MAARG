import Foundation
import CoreLocation     // the framework for user location relateed things
import SwiftData

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    /*
     • We make this an "ObservableObject" so our SwiftUI views can watch it for changes.
     • CLLocationManagerDelegate: LocationManager uses its delegate to notify the app of location updates. Implement the delegate methods to update app behavior based on the user's current location, such as updating a map position or filtering location-based search results.
     • Inherits from NSObject to enable compatibility with Objective-C APIs like CLLocationManagerDelegate.
     */
    
    private let locationManager = CLLocationManager()   // The Apple's framework that does the work of getting GPS data.
    
    @Published var userLocation: CLLocation?    // This property will holds the latest location and publish it to any view that's listening.
    @Published var userHeading: CLHeading?      // This property will holds the Compass data.
    @Published var isTracking: Bool = false     // The Switch to tell us if we'arw on Hike.
    @Published var route: [CLLocation] = []     // Array to store all the points of our hike path.
    
    private var startTime : Date?               // To calculate the duration of the hike.
    private var totalElevationGain: Double = 0.0
    
    override init() {
        super.init()   // This is required for NSObject subclasses.
        
        self.locationManager.delegate = self        // Telling it that we're the one that will listen to its updates.
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest  // Asking for the best possible Accuracy.
        self.locationManager.requestWhenInUseAuthorization()            // Trigger the permission pop-up.
        self.locationManager.startUpdatingLocation()                    //Start thr engine!
        // Checks if the device has a compass.
        if CLLocationManager.headingAvailable() {
            self.locationManager.startUpdatingHeading()                 // Start the Compass
        }
    }
    
    func startHike() {
        self.isTracking = true
        route = []           // Clear any old route data when starting a new hike.
        startTime = Date()   // Record the start time
        totalElevationGain = 0.0
    }
    
    func discardHike() {
        isTracking = false
        route = []
        startTime = nil
    }
    
    func stopHike(context: ModelContext, terrain: String, wildlifeDanger: String) -> HikeRecord? {
        isTracking = false
        
        // Return nil if the guard fails.
        guard let startTime = startTime, !route.isEmpty else { return nil }
        
        let endTime = Date()
        let duration = endTime.timeIntervalSince(startTime)
        let distance = calculateTotalDistance()
        
        print("DEBUG: Hike stopped. Final calculated distance is \(distance) km.")   // Line for debugging
        
        let newHike = HikeRecord(
            date: endTime,
            distance: distance,
            duration: duration,
            elevationGain: totalElevationGain,
            terrain: terrain,
            wildlifeDangerLevel: wildlifeDanger,
            route: route
        )
        
        
        context.insert(newHike)
        print("Hike saved! ...")    // For console only.
        
        // Return the hike that just created.
        return newHike
    }
    // This is a helper function to calculate the total distance of the route.
    private func calculateTotalDistance() -> Double {
        var totalDistance: Double = 0
        guard route.count > 1 else { return 0 }
        
        for i in 0..<route.count - 1 {
            let start = route[i]
            let end = route[i+1]
            totalDistance += start.distance(from: end)
        }
        return totalDistance / 1000.0
    }
    
    // This is a new, required delegate method. It's called whenever the location updates.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("DEBUG: Location update received.") // Line for debugging
        
        guard let newLocation = locations.last else { return }
        self.userLocation = newLocation         // take the latest location from the array and update our property.
        if isTracking {
            // Elevation Logic
            if let lastLocation = route.last {
                if newLocation.verticalAccuracy < 10.0 {
                    let altitudeChange = newLocation.altitude - lastLocation.altitude
                    if altitudeChange > 0 { // Only add positive changes
                        totalElevationGain += altitudeChange
                    }
                }
            }
            route.append(newLocation)         // Only add the location to our route if the "switch" is on
           
            print("DEBUG: Hike is active. Route now has \(route.count) points.") // Line for debugging
        }
    }
    
    
    // This function is called whenever the compass gets a new reading.
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.userHeading = newHeading   // Update our heading property.
    }
    
    // This optional method helps to know if there's an error.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed with error: \(error.localizedDescription)")
    }
}
