import SwiftUI

struct CompassView: View {
    
    let heading: Double
    
    var body: some View {
        Image(systemName: "location.north.line.fill")
            .font(.system(size: 60))
            .foregroundColor(.accentColor)
            .rotationEffect(Angle(degrees: heading))
            .shadow(radius: 5)
    }
}

#Preview {
    CompassView(heading: 0)
}
