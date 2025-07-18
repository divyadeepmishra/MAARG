import SwiftUI
import SwiftData

struct PastHikesView: View {
    
    /* The @Query automatically fetches all HikeRecord objects from the database. We sort them to show the newest hikes first. */
    @Query(sort: \HikeRecord.date, order: .reverse) private var hikes: [HikeRecord]
    @Environment(\.dismiss) private var dismiss   // This gives us a way to close this screen.

    var body: some View {
        NavigationStack {
            List {
                // We loop through each hike that the @Query found.
                ForEach(hikes) { hike in
                    NavigationLink(destination: HikeDetailView(hike: hike)){
                        VStack(alignment: .leading, spacing: 8) {
                            Text(hike.date, format: .dateTime.day().month().year())
                                .font(.headline)
                            
                            HStack {
                                // Show distance in kilometers.
                                Text(String(format: "%.2f km", hike.distance / 1000))
                                    .font(.subheadline)
                                    .foregroundColor(.green)
                                
                                Spacer()
                                
                                // Show the duration in a readable format.
                                Text(formatDuration(hike.duration))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("Hike History")
            .toolbar {
                // Add a "Done" button to close the sheet.
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // This is a helper function to make the duration look nice.
    // e.g., 3700 seconds becomes "1h 1m 40s"
    private func formatDuration(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: duration) ?? "0s"
    }
}

#Preview {
    PastHikesView()
        // This is needed for the preview to work with SwiftData.
        .modelContainer(for: HikeRecord.self, inMemory: true)
}
