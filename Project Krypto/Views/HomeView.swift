import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.dogs) { dog in
                NavigationLink(destination: AnimalDetailView(dog: dog)) {
                    HStack(alignment: .top, spacing: 16) {
                        if let firstURL = dog.photoURLs.first {
                            AsyncImage(url: firstURL) { image in
                                image.resizable()
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        } else if !dog.photoImageLocal.isEmpty {
                            Image(dog.photoImageLocal)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        } else {
                            Color.gray
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text(dog.name)
                                .font(.title2).bold()
                            Text(dog.breed)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("Urgency: \(dog.urgencyLevel.rawValue.capitalized)")
                                .font(.caption)
                                .foregroundColor(viewModel.urgencyColor(for: dog.urgencyLevel))
                        }
                        Spacer()
                        if viewModel.isEuthanasiaNear(for: dog) {
                            Text(viewModel.countdownString(for: dog))
                                .font(.caption2)
                                .foregroundColor(.white)
                                .padding(6)
                                .background(Color.red)
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Last Chance Homes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SearchView()) {
                        Image(systemName: "magnifyingglass")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                    }
                }
            }
        }
    }
} 
