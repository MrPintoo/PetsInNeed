import SwiftUI

struct AnimalDetailView: View {
    let dog: Dog
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: dog.photoURLs.first) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray
                }
                .frame(height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.bottom, 8)
                Text(dog.name)
                    .font(.largeTitle).bold()
                Text("Breed: \(dog.breed)")
                    .font(.title3)
                Text("Age: \(dog.age) years")
                    .font(.title3)
                Text("Urgency: \(dog.urgencyLevel.rawValue.capitalized)")
                    .font(.headline)
                    .foregroundColor(.red)
                Text("Euthanasia Date: \(dog.euthanasiaDate, formatter: dateFormatter)")
                    .font(.subheadline)
                    .foregroundColor(.red)
                Text(dog.description)
                    .font(.body)
                    .padding(.vertical)
                Divider()
                Text("Shelter: \(dog.shelterName)")
                Text("Location: \(dog.location)")
                Text("Contact: \(dog.contactInfo)")
                    .font(.callout)
                    .foregroundColor(.blue)
                Spacer()
            }
            .padding()
        }
        .navigationTitle(dog.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}() 