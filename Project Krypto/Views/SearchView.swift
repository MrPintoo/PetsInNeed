import SwiftUI

struct SearchView: View {
    @State private var selectedBreed: String = ""
    @State private var selectedSize: String = ""
    @State private var selectedLocation: String = ""
    @State private var selectedUrgency: Dog.UrgencyLevel? = nil
    
    var body: some View {
        Form {
            Section(header: Text("Breed")) {
                TextField("Enter breed", text: $selectedBreed)
            }
            Section(header: Text("Size")) {
                TextField("Enter size", text: $selectedSize)
            }
            Section(header: Text("Location")) {
                TextField("Enter location", text: $selectedLocation)
            }
            Section(header: Text("Urgency")) {
                Picker("Urgency", selection: $selectedUrgency) {
                    Text("Any").tag(Dog.UrgencyLevel?.none)
                    ForEach(Dog.UrgencyLevel.allCases, id: \ .self) { level in
                        Text(level.rawValue.capitalized).tag(Optional(level))
                    }
                }
                .pickerStyle(.segmented)
            }
            Button("Apply Filters") {
                // Filtering logic to be implemented
            }
        }
        .navigationTitle("Search")
    }
} 
