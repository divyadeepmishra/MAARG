import SwiftUI
import MapKit
import SwiftData
import UserNotifications

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()    //By using @StateObject, we tell SwiftUI to create and manage our navigator. It will be kept alive for the entire life of our view.
    
    @StateObject private var healthManager = HealthManager()
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var showingHikeHistory = false   // This new @State variable will be our switch for showing the history sheet.
    
    @State private var isShowingPostHikeForm = false
    
    
    var body: some View {
        ZStack (alignment: .top){
            // We are now providing custom content inside the Map view.
            Map(initialPosition: .userLocation(fallback: .automatic)){
                MapPolyline(coordinates: locationManager.route.map {$0.coordinate}) // It creates a line from the coordinates in our route array.
                    .stroke(Color.blue, lineWidth: 5)   // Style the line to be blue and thick.
                
                /* • MapPolyline: This is the official SwiftUI view for drawing a line on a map.
                 • locationManager.route: We access the array of saved location points from our manager.
                 • .map { $0.coordinate }: This is a powerful piece of Swift code. It loops through every single CLLocation object in our route array and pulls out just the coordinate part (the latitude and longitude), which is the exact format MapPolyline needs. */
                
                /* (initialPosition: .userLocation(fallback: .automatic))   The Map view now centers on the user's location automatically. If the location isn't available, it uses a default 'automatic' view. */
            }
            .ignoresSafeArea()      // Will use full area of Screen
            
            // The overlay UI is the top layer
            VStack{
                // Compass View at the top
                if let heading = locationManager.userHeading?.trueHeading {
                    CompassView(heading: heading)
                        .padding()
                        .animation(.easeInOut, value: heading)
                }
                
                Spacer()        // Pushes the buttons to the bottom
                
                HStack(spacing: 20){
                    // History Button
                    Button(action: {
                        showingHikeHistory = true
                    }) {
                        Image(systemName: "list.bullet")
                            .font(.title2)
                            .padding(15)
                            .background(Color.blue.opacity(0.55))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    .shadow(radius: 5)
                    
                    if locationManager.isTracking {
                        // Show these two buttons when a hike is in progress
                        Button(action: {
                            isShowingPostHikeForm = true
                        }){
                            Text("Finish Hike")
                                .font(.headline)
                                .padding()
                                .background(Color.red.opacity(0.9))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .shadow(radius: 5)
                        
                        Button(action: {
                            locationManager.discardHike()
                        }) {
                            Text("Cancel Hike")
                                .font(.headline)
                                .padding()
                                .background(Color.gray.opacity(0.9))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .shadow(radius: 5)
                        
                    } else {
                        // Show this button when no hike is in progress
                        Button(action: {
                            locationManager.startHike()
                        }){
                            Text("Start Hike")
                                .font(.headline)
                                .padding()
                                .background(Color.green.opacity(0.9))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .shadow(radius: 5)
                    }
                }
            }
            .padding()
        }
        .sheet(isPresented: $showingHikeHistory) {
            PastHikesView()
        }
        
        // This sheet presents our new form
        .sheet(isPresented: $isShowingPostHikeForm) {
            PostHikeFormView { terrain, wildlifeDanger in
                if let savedHike = locationManager.stopHike(
                    context: modelContext,
                    terrain: terrain,
                    wildlifeDanger: wildlifeDanger
                ) {
                    
                    healthManager.saveHikeAsWorkout(hike: savedHike)
                    
                    // call the notification function
                    scheduleHikeSavedNotification()
                }
                isShowingPostHikeForm = false
            }
        }
        
        .onAppear {
            // Asking for HealthKit request
            healthManager.requestAuthorization()
            
            // Asking for notification permission.
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if granted {
                    print("Notification permission granted.")
                } else if let error = error {
                    print("Notification permission error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    //  A Helper function that will build and schedule the notification.
    private func scheduleHikeSavedNotification() {
        
        // 1. Create the content for the notification
        let content = UNMutableNotificationContent()
        content.title = "Hike Saved!"
        content.body = "Great job on your recent hike. It has been saved to your history and to the Health app."
        content.sound = UNNotificationSound.default
        
        // 2. Define the trigger (when the notification should fire). We'll set it to 2 seconds from now to feel responsive.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        
        // 3. Create the request
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // 4. Add the request to the notification center so iOS system will deliver it.
        UNUserNotificationCenter.current().add(request)
    }
}

    
#Preview {
    ContentView()
        .modelContainer(for: HikeRecord.self, inMemory: true)
}
    

