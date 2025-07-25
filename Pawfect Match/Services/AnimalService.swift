import Foundation

protocol AnimalServiceProtocol {
    func fetchDogs() -> [Dog]
}

class MockAnimalService: AnimalServiceProtocol {
    func fetchDogs() -> [Dog] {
        return [
            Dog(
                id: UUID(),
                name: "Buddy",
                age: 3,
                breed: "Labrador Retriever",
                shelterName: "Happy Tails Shelter",
                location: "San Francisco, CA",
                photoURLs: [URL(string: "https://images.unsplash.com/photo-1558788353-f76d92427f16")!],
                photoImageLocal: "",
                description: "Friendly, energetic, loves people and other dogs.",
                urgencyLevel: .critical,
                euthanasiaDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                contactInfo: "adopt@happytails.org",
                latitude: 37.7749,
                longitude: -122.4194
            ),
            Dog(
                id: UUID(),
                name: "Peanut",
                age: 9,
                breed: "Yorkishire Terrier",
                shelterName: "Safe Haven",
                location: "Oakland, CA",
                photoURLs: [],
                photoImageLocal: "Peanut",
                description: "Vicious, dumdum, needs a loving home soon.",
                urgencyLevel: .high,
                euthanasiaDate: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                contactInfo: "contact@safehaven.org",
                latitude: 37.8044,
                longitude: -122.2712
            )
        ]
    }
} 
