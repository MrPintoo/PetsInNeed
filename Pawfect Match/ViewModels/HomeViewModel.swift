import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var dogs: [Dog] = []
    private(set) var allDogs: [Dog] = []
    private let animalService: AnimalServiceProtocol
    
    @Published var livesSaved: Int = 1287 // Example number
    @Published var petOfTheDay: Dog? = nil
    @Published var successStories: [SuccessStory] = [
        SuccessStory(title: "Daisy's New Family", text: "Daisy found her forever home and now spends her days playing in the park!"),
        SuccessStory(title: "Max's Second Chance", text: "Max was adopted just in time and is now a loyal companion to his new owner.")
    ]
    @Published var favoriteDogIDs: Set<UUID> = []
    
    init(animalService: AnimalServiceProtocol = MockAnimalService()) {
        self.animalService = animalService
        loadDogs()
        self.petOfTheDay = dogs.first
    }
    
    func loadDogs() {
        let fetched = animalService.fetchDogs()
        allDogs = fetched
        dogs = fetched
    }
    
    func urgencyColor(for level: Dog.UrgencyLevel) -> Color {
        switch level {
        case .low: return .green
        case .medium: return .yellow
        case .high: return .orange
        case .critical: return .red
        }
    }
    
    func isEuthanasiaNear(for dog: Dog) -> Bool {
        let daysLeft = Calendar.current.dateComponents([.day], from: Date(), to: dog.euthanasiaDate).day ?? 0
        return daysLeft <= 3
    }
    
    func countdownString(for dog: Dog) -> String {
        let daysLeft = Calendar.current.dateComponents([.day], from: Date(), to: dog.euthanasiaDate).day ?? 0
        return daysLeft > 0 ? "\(daysLeft)d left" : "Last day!"
    }
    
    func isFavorite(_ dog: Dog) -> Bool {
        favoriteDogIDs.contains(dog.id)
    }
    
    func toggleFavorite(_ dog: Dog) {
        if favoriteDogIDs.contains(dog.id) {
            favoriteDogIDs.remove(dog.id)
        } else {
            favoriteDogIDs.insert(dog.id)
        }
    }
} 
