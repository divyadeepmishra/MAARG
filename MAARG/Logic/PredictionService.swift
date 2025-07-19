import Foundation
import CoreML

struct PredictionService {
    
    // The function now accepts the new parameters.
    func predictDifficulty(distance: Double, elevation: Double, terrain: String, wildlifeDanger: String) -> String {
        do {
            let model = try TrailAnalyzerModel(configuration: MLModelConfiguration())
            
            // We need to convert the "low" or "high" string into a number for the model.
            let dangerValue = wildlifeDanger == "high" ? 1 : 0
            
            // The input now uses the real data provided by the user.
            let modelInput = TrailAnalyzerModelInput(
                distance: Int64(distance),
                elevation: Int64(elevation),
                terrain: terrain,
                dangerous: Int64(dangerValue)
            )
            
            let prediction = try model.prediction(input: modelInput).risk
            
            switch prediction {
            case -5..<20:
                return "Easy"
            case 20..<50:
                return "Moderate"
            case 50..<100:
                return "Difficult"
            case 100..<600:
                return "High Risk"
            default:
                // This case handles a score any unexpected value.
                return "Analysis Failed"
            }
            
        } catch {
            print("Error making prediction: \(error)")
            return "Could not predict"
        }
    }
}







