import SwiftUI
import MapKit

struct HikeDetailView: View {
    
    // This view receives the specific hike it needs to display.
    let hike: HikeRecord
    
    //state to control the map's camera position.
    @State private var cameraPosition: MapCameraPosition = .automatic
    
    @State private var predictedDifficulty: String = "Calculating..."
    
    var body: some View {
        VStack(spacing: 0) {
            Map(position: $cameraPosition) {
                MapPolyline(coordinates: hike.route.map { $0.coordinate })
                    .stroke(.blue, lineWidth: 5)
            }
            .cornerRadius(15)
            .padding([.horizontal, .top])
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // --- AI Analysis Section ---
                    VStack(alignment: .leading) {
                        Text("AI ANALYSIS")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        HStack {
                            Text(predictedDifficulty)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(difficultyColor(for: predictedDifficulty))
                            Spacer()
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(12)

                    // Stats Section
                    VStack(alignment: .leading) {
                        Text("HIKE STATS")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            
                            StatView(icon: "calendar", label: "Date", value: hike.date.formatted(date: .abbreviated, time: .omitted))
                            
                            StatView(icon: "timer", label: "Duration", value: formatDuration(hike.duration))
                            
                            StatView(icon: "map.fill", label: "Distance", value: String(format: "%.2f km", hike.distance / 1000))
                            
                            StatView(icon: "arrow.up.to.line.compact", label: "Elevation Gain", value: String(format: "%.0f m", hike.elevationGain))
                            
                            StatView(icon: "shoe.fill", label: "Terrain", value: hike.terrain.capitalized)
                            
                            StatView(icon: "exclamationmark.triangle.fill", label: "Wildlife", value: hike.wildlifeDangerLevel.capitalized)
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(12)
                }
                .padding()
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Hike Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            setupMapCamera()
            getPrediction()
        }
    }
    
    // Function to determine the color
    private func difficultyColor(for difficulty: String) -> Color {
        switch difficulty {
        case "Easy":
            return .green
        case "Moderate":
            return .yellow
        case "Difficult":
            return .orange
        case "High Risk":
            return .red
        default:
            return .primary // Default color for "Calculating..." or errors
        }
    }
    
    // Function to use our PredictionService
    private func getPrediction() {
        let predictionService = PredictionService()
        predictedDifficulty = predictionService.predictDifficulty(
            distance: hike.distance,
            elevation: hike.elevationGain,
            terrain: hike.terrain,
            wildlifeDanger: hike.wildlifeDangerLevel
        )
    }
    
     // This function calculates the map region that fits the entire route.
    private func setupMapCamera() {
        let routeCoordinates = hike.route.map { $0.coordinate }
        guard !routeCoordinates.isEmpty else { return }
        
        let mapRect = routeCoordinates.reduce(MKMapRect.null) { (rect, coord) -> MKMapRect in
            let point = MKMapPoint(coord)
            return rect.union(MKMapRect(x: point.x, y: point.y, width: 0, height: 0))
        }
        cameraPosition = .rect(mapRect.insetBy(dx: -2000, dy: -2000))
    }
    
    // Function to format the duration string.
    private func formatDuration(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: duration) ?? "0s"
    }
}

// Reusable view for displaying a single stat with an icon
struct StatView: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.accentColor)
                .frame(width: 30, alignment: .center)

            VStack(alignment: .leading) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


#Preview {
    NavigationStack {
        let sampleRoute = [
            CLLocation(latitude: 37.7749, longitude: -122.4194),
            CLLocation(latitude: 37.3382, longitude: -121.8863)
        ]
        
        let sampleHike = HikeRecord(
            date: Date(),
            distance: 5500,
            duration: 3600,
            elevationGain: 230,
            terrain: "rocky",
            wildlifeDangerLevel: "low",
            route: sampleRoute
        )
        
        HikeDetailView(hike: sampleHike)
            .modelContainer(for: HikeRecord.self, inMemory: true)
    }
}
