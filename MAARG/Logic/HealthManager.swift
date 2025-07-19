import Foundation
import HealthKit

class HealthManager: ObservableObject{
    
    let healthStore = HKHealthStore()       // A direct connection to the user's HealthKit data store.
    
    init () {
        // call the authorization request here when the app starts.
    }
    
    func requestAuthorization() {
        // Checks if HealthKit is available on the device.
        guard HKHealthStore.isHealthDataAvailable() else {
            print("Health Kit is not available on this device.")
            return
        }
        
        // These are the types of data we want to WRITE to the Health app. We are only writing data, not reading it.
        let typesToWrite: Set = [
            HKObjectType.workoutType(),
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        ]
        
        // The function that triggers the permission pop-up for the user.
        healthStore.requestAuthorization(toShare: typesToWrite, read: nil){ (success, error) in
            if !success {
                // Handle the error here.
                print("Error requesting HealthKit authorization: \(error?.localizedDescription ?? "Unknown error")")
            } else {
                print("HealthKit authorization granted.")
            }
        }
    }
    
    // Function to save Workout in HealthKit
    func saveHikeAsWorkout(hike: HikeRecord) {
        // 1. Prepare workout data
        let workoutStartDate = hike.date.addingTimeInterval(-hike.duration)
        let workoutEndDate = hike.date
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .hiking
        configuration.locationType = .outdoor
        
        // 2. Create the builder
        let builder = HKWorkoutBuilder(healthStore: healthStore, configuration: configuration, device: .local())
        
        // 3. Begin collection with a completion handler
        builder.beginCollection(withStart: workoutStartDate) { (success, error) in
            guard success else {
                print("Error beginning workout collection: \(error?.localizedDescription ?? "")")
                return
            }
            
            // 4. Create and add data samples
            let distanceSample = HKQuantitySample(type: .quantityType(forIdentifier: .distanceWalkingRunning)!, quantity: HKQuantity(unit: .meter(), doubleValue: hike.distance), start: workoutStartDate, end: workoutEndDate)
            let calorieSample = HKQuantitySample(type: .quantityType(forIdentifier: .activeEnergyBurned)!, quantity: self.estimateCalories(duration: hike.duration), start: workoutStartDate, end: workoutEndDate)
            
            // 5. Add samples with a completion handler
            builder.add([distanceSample, calorieSample]) { (success, error) in
                guard success else {
                    print("Error adding samples to workout: \(error?.localizedDescription ?? "")")
                    return
                }
                
                // 6. End collection with a completion handler
                builder.endCollection(withEnd: workoutEndDate) { (success, error) in
                    guard success else {
                        print("Error ending workout collection: \(error?.localizedDescription ?? "")")
                        return
                    }
                    
                    // 7. Finish the workout and save it
                    builder.finishWorkout { (workout, error) in
                        if let error = error {
                            print("Error finishing workout: \(error.localizedDescription)")
                        } else {
                            print("Workout saved to HealthKit successfully!")
                        }
                    }
                }
            }
        }
    }
    
    // function to estimate Calories burned
    private func estimateCalories(duration: TimeInterval) -> HKQuantity {
        // A simple estimation: Hiking MET value * average weight * duration
        let metValue = 5.3 // Metabolic Equivalent of Task for moderate hiking
        let averageWeightInKg = 70.0
        let durationInHours = duration / 3600 // convert seconds to hours
        
        let caloriesBurned = metValue * averageWeightInKg * durationInHours
        
        return HKQuantity(unit: .kilocalorie(), doubleValue: caloriesBurned)
    }
}
