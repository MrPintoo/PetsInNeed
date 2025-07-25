import Foundation

// MARK: - Dog Model
struct Dog: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let age: Int
    let breed: String
    let shelterName: String
    let location: String
    let photoURLs: [URL]
    let photoImageLocal: String
    let description: String
    let urgencyLevel: UrgencyLevel
    let euthanasiaDate: Date
    let contactInfo: String
    let latitude: Double
    let longitude: Double
    
    enum UrgencyLevel: String, Codable, CaseIterable, Equatable {
        case low, medium, high, critical
    }
    // TODO: Add support for user favorites (e.g., isFavorite: Bool)
}

struct SuccessStory: Identifiable {
    let id = UUID()
    let title: String
    let text: String
}

// TODO: Add User model for user accounts and authentication
// TODO: Add APIService for remote JSON API fetching 
