//
//  ContentView.swift
//  Pawfect Match
//
//  Created by bryant pinto on 7/24/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = HomeViewModel()
    var body: some View {
        TabView {
            NavigationStack { HomeView().environmentObject(viewModel) }
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            NavigationStack { FavoritesView().environmentObject(viewModel) }
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }
            NavigationStack { ImpactView().environmentObject(viewModel) }
                .tabItem {
                    Image(systemName: "sparkles")
                    Text("Impact")
                }
        }
    }
}

struct FavoritesView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    var favoriteDogs: [Dog] {
        viewModel.dogs.filter { viewModel.isFavorite($0) }
    }
    var body: some View {
        VStack {
            if favoriteDogs.isEmpty {
                Image(systemName: "heart.fill")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.pink)
                Text("Your Favorites")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .padding(.top, 8)
                Text("Animals you’ve saved will appear here.")
                    .foregroundColor(.secondary)
                    .padding(.top, 2)
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(favoriteDogs) { dog in
                            AnimalCardView(dog: dog, viewModel: viewModel)
                        }
                    }
                    .padding()
                }
            }
        }
        .padding()
    }
}

struct ImpactView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Make a Difference")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .padding(.top, 16)
                // Educational content
                Text("Learn how to foster, sponsor, donate, share animals, or get involved in rescue efforts.")
                    .font(.system(size: 17, weight: .regular, design: .rounded))
                    .multilineTextAlignment(.center)
                    .padding()
                // Success stories
                ForEach(viewModel.successStories) { story in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("You helped save \(story.title)")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 120)
                            .cornerRadius(16)
                            .padding(.bottom, 4)
                        Text(story.text)
                            .font(.system(size: 15, weight: .regular, design: .rounded))
                    }
                    .padding()
                    .background(Color("Cream").opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(radius: 3)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    ContentView()
}
