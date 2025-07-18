import SwiftUI

// This is reusable container view.
struct TrailField<Content: View>: View {
    let iconName: String
    let label: String
    // This allows us to pass any kind of view (like a Picker) into our container.
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.secondary)
                Text(label)
                    .font(.headline)
            }
            .padding(.leading)
            
            content
                .padding(.top, 4)
        }
    }
}

#Preview {
    // Provide sample data to the TrailField so it knows what to display.
    TrailField(iconName: "leaf.fill", label: "Sample Field") {
        Text("This is where the picker or other content would go.")
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
    }
    .padding()
}
