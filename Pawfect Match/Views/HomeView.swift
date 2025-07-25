import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Hero Banner
                HeroBannerView()
                    .padding(.top, 8)
                // Lives Saved Counter
                LivesSavedCounterView(livesSaved: viewModel.livesSaved)
                // Pet of the Day
                if let petOfTheDay = viewModel.petOfTheDay {
                    PetOfTheDayCardView(dog: petOfTheDay, viewModel: viewModel)
                }
                // Animal Grid
                VStack(alignment: .leading, spacing: 12) {
                    Text("Meet Our Friends")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .padding(.leading)
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.dogs) { dog in
                            AnimalCardView(dog: dog, viewModel: viewModel)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, 16)
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color("Peach"), Color("Cream")]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
    }
}

struct HeroBannerView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(LinearGradient(gradient: Gradient(colors: [Color("Peach"), Color("Cream")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .shadow(radius: 8)
            VStack(spacing: 8) {
                Image("Peanut") // Placeholder image asset
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                Text("Be the reason someone gets a second chance")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
        .frame(height: 180)
        .padding(.horizontal)
    }
}

struct LivesSavedCounterView: View {
    let livesSaved: Int
    var body: some View {
        HStack {
            Image(systemName: "heart.fill")
                .foregroundColor(.pink)
            Text("Lives saved: \(livesSaved)")
                .font(.system(size: 17, weight: .medium, design: .rounded))
        }
        .padding(12)
        .background(Color("Cream").opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 4)
        .padding(.horizontal)
    }
}

struct PetOfTheDayCardView: View {
    let dog: Dog
    @ObservedObject var viewModel: HomeViewModel
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(gradient: Gradient(colors: [Color("MutedGreen"), Color("Cream")]), startPoint: .top, endPoint: .bottom))
                .shadow(radius: 6)
            HStack(spacing: 16) {
                if let firstURL = dog.photoURLs.first {
                    AsyncImage(url: firstURL) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                } else if !dog.photoImageLocal.isEmpty {
                    Image(dog.photoImageLocal)
                        .resizable()
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                } else {
                    Color.gray
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text(dog.name)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                    Text(dog.breed)
                        .font(.system(size: 15, weight: .regular, design: .rounded))
                        .foregroundColor(.secondary)
                    Text("Looking for a home this week")
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                        .foregroundColor(.orange)
                }
                Spacer()
                Button(action: { viewModel.toggleFavorite(dog) }) {
                    Image(systemName: viewModel.isFavorite(dog) ? "heart.fill" : "heart")
                        .foregroundColor(.pink)
                        .padding(8)
                        .background(Color("Cream").opacity(0.8))
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }
            }
            .padding()
        }
        .frame(height: 110)
        .padding(.horizontal)
    }
}

struct AnimalCardView: View {
    let dog: Dog
    @ObservedObject var viewModel: HomeViewModel
    var body: some View {
        VStack(spacing: 8) {
            if let firstURL = dog.photoURLs.first {
                AsyncImage(url: firstURL) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            } else if !dog.photoImageLocal.isEmpty {
                Image(dog.photoImageLocal)
                    .resizable()
                    .frame(height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                Color.gray
                    .frame(height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            Text(dog.name)
                .font(.system(size: 17, weight: .bold, design: .rounded))
            Text(dog.description.split(separator: ".").first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
                .font(.system(size: 15, weight: .regular, design: .rounded))
                .foregroundColor(.secondary)
                .lineLimit(2)
            Text("Needs a home soon 🧡")
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundColor(.orange)
            Button(action: { viewModel.toggleFavorite(dog) }) {
                Image(systemName: viewModel.isFavorite(dog) ? "heart.fill" : "heart")
                    .foregroundColor(.pink)
                    .padding(8)
                    .background(Color("Cream").opacity(0.8))
                    .clipShape(Circle())
                    .shadow(radius: 2)
            }
        }
        .padding()
        .background(Color("Cream").opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 4)
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
#endif 
