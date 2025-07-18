
import SwiftUI

struct PostHikeFormView: View {
    // State variables
    @State private var selectedTerrain: Terrain = .paved
    @State private var selectedWildlifeDanger: String = "low"

    // Closures for save and dismiss actions
    var onSave: (String, String) -> Void
    
    // Gives us access to the environment's dismiss action
    @Environment(\.dismiss) private var dismiss

    private let dangerOptions = ["low", "high"]

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()

            VStack(spacing: 20) {
                // The headerView is now responsible for the title and cancel button
                headerView
                
                terrainSelector
                
                dangerSelector
                
                Spacer()
                
                saveButton
            }
            .padding()
        }
    }
    
    // MARK: - Subviews
    private var headerView: some View {
        HStack {
            Text("Hike Details")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
            
            Button {
                dismiss() // Call the dismiss action when tapped
            } label: {
                Text("Cancel")
                    .fontWeight(.medium)
                    .padding(8)
            }
        }
        .padding(.bottom, 10)
    }

    private var terrainSelector: some View {
            VStack(alignment: .leading) {
                Text("Terrain".uppercased())
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.leading)

                HStack(spacing: 12) {
                    ForEach(Terrain.allCases) { terrain in
                        let isSelected = selectedTerrain == terrain
                        let color = terrainColor(for: terrain)
                        
                        Button(action: {
                            withAnimation { selectedTerrain = terrain }
                        }) {
                            VStack {
                                Image(systemName: terrainIcon(for: terrain))
                                    .font(.title2)
                                Text(terrain.rawValue.capitalized)
                                    .font(.footnote)
                                    .fontWeight(.medium)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            // Use the color for the background
                            .background(isSelected ? color.opacity(0.15) : Color(.secondarySystemGroupedBackground))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    // Use the color for the stroke
                                    .stroke(isSelected ? color : Color.gray.opacity(0.3), lineWidth: 1.5)
                            )
                        }
                        // Using color for the tint
                        .tint(isSelected ? color : .primary)
                    }
                }
            }
        }
    
    // Wildlife Danger Section
    private var dangerSelector: some View {
        VStack(alignment: .leading) {
            Text("Wildlife Danger".uppercased())
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.leading)

            HStack(spacing: 12) {
                ForEach(dangerOptions, id: \.self) { option in
                    Button(action: {
                        withAnimation { selectedWildlifeDanger = option }
                    }) {
                        VStack {
                            Image(systemName: dangerIcon(for: option))
                                .font(.title2)
                            Text(option.capitalized)
                                .font(.footnote)
                                .fontWeight(.medium)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selectedWildlifeDanger == option ? (option == "high" ? Color.red.opacity(0.15) : Color.green.opacity(0.15)) : Color(.secondarySystemGroupedBackground))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(selectedWildlifeDanger == option ? (option == "high" ? Color.red : Color.green) : Color.gray.opacity(0.3), lineWidth: 1.5)
                        )
                    }
                    .tint(selectedWildlifeDanger == option ? (option == "high" ? .red : .green) : .primary)
                }
            }
        }
    }

    // Save button
    private var saveButton: some View {
        Button(action: {
            onSave(selectedTerrain.rawValue, selectedWildlifeDanger)
        }) {
            Text("Save Hike")
                .font(.headline)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(16)
                .shadow(color: .blue.opacity(0.3), radius: 8, y: 4)
        }
    }

    // Function for terrain icon
    private func terrainIcon(for terrain: Terrain) -> String {
        switch terrain {
        case .paved: return "road.lanes"
        case .dirt: return "figure.hiking"
        case .rocky: return "mountain.2.fill"
        case .sandy: return "sun.max.fill"
        }
    }
    
    // Function for terrain Colour
    private func terrainColor(for terrain: Terrain) -> Color {
            switch terrain {
            case .paved:
                return .blue 
            case .dirt:
                return .brown
            case .rocky:
                return .gray
            case .sandy:
                return Color(red: 0.90, green: 0.80, blue: 0.4)
            }
        }
    
    private func dangerIcon(for option: String) -> String {
        return option == "low" ? "shield.fill" : "exclamationmark.triangle.fill"
    }
}

#Preview {
    PostHikeFormView(onSave: { terrain, danger in
        print("Terrain: \(terrain), Danger: \(danger)")
    })
}
