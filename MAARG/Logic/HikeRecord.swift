import Foundation
import SwiftData
import CoreLocation

@Model
final class HikeRecord {
    var date: Date
    var distance: Double
    var duration: TimeInterval
    var elevationGain: Double
    var terrain : String
    var wildlifeDangerLevel: String
    
    // Store the route as raw Data. This is a very stable way to save complex info.
    private var routeData: Data
    
    // This is a "computed property". It acts like a variable but runs code. It lets us easily convert our route to and from the saved `routeData`.
    var route: [CLLocation] {
        get {
            // When we need the route, this code decodes it from Data back to [CLLocation].
            guard let decodedRoute = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, CLLocation.self], from: routeData) as? [CLLocation] else { return [] }
            return decodedRoute
        }
        set {
            // When we set a new route, this code encodes it into Data for saving.
            guard let data = try? NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: false) else { return }
            self.routeData = data
        }
    }
    
    init(date: Date, distance: Double, duration: TimeInterval, elevationGain: Double, terrain: String, wildlifeDangerLevel: String ,route: [CLLocation]) {
        self.date = date
        self.distance = distance
        self.duration = duration
        self.elevationGain = elevationGain
        self.terrain = terrain
        self.wildlifeDangerLevel = wildlifeDangerLevel
        // Initialize routeData here, but we can still use the convenient 'route' property.
        self.routeData = Data() // Start with empty data
        self.route = route // The 'set' block above will run, encoding the route into routeData.
    }
}



