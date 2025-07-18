import Foundation

// This enum defines specific set of terrain options. CaseIterable lets us loop through all cases, and Identifiable works with ForEach.
enum Terrain: String, CaseIterable, Identifiable {
    case paved
    case dirt
    case rocky
    case sandy
    
    var id: Self { self }
}
