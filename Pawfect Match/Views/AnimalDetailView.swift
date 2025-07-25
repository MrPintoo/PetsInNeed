import SwiftUI
import MapKit

struct AnimalDetailView: View {
    let dog: Dog
    @State private var region: MKCoordinateRegion
    @State private var selectedPhotoIndex: Int = 0
    @State private var showContactForm = false
    @State private var showConfirmation = false
    
    init(dog: Dog) {
        self.dog = dog
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: dog.latitude, longitude: dog.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Swipeable Photo Gallery
                PhotoGalleryView(photoURLs: dog.photoURLs, localImage: dog.photoImageLocal, selectedIndex: $selectedPhotoIndex)
                    .frame(height: 260)
                    .padding(.bottom, 4)
                // Friendly Intro
                FriendlyIntroView(dog: dog)
                // Map View
                Map(coordinateRegion: $region, annotationItems: [dog]) { dog in
                    MapMarker(coordinate: CLLocationCoordinate2D(latitude: dog.latitude, longitude: dog.longitude), tint: .red)
                }
                .frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 6)
                // Details
                VStack(alignment: .leading, spacing: 8) {
                    Text("Breed: \(dog.breed)")
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                    Text("Age: \(dog.age) years")
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                    Text("Needs a loving home by \(dog.euthanasiaDate, formatter: dateFormatter)")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(.orange)
                }
                // I'm Interested Button
                Button(action: { showContactForm = true }) {
                    Text("I'm Interested")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(Color("Peach").opacity(0.9))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .shadow(radius: 3)
                }
                .padding(.vertical, 8)
                // Description
                Text(dog.description)
                    .font(.system(size: 17, weight: .regular, design: .rounded))
                    .padding(.vertical)
                Divider()
                Text("Shelter: \(dog.shelterName)")
                Text("Location: \(dog.location)")
                Text("Contact: \(dog.contactInfo)")
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundColor(.blue)
                Spacer()
            }
            .padding()
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color("Cream"), Color("Peach")]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
        .navigationTitle(dog.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showContactForm) {
            ContactFormView(dog: dog, show: $showContactForm, showConfirmation: $showConfirmation)
        }
        .alert(isPresented: $showConfirmation) {
            Alert(title: Text("Thank you!"), message: Text("The shelter will be in touch soon."), dismissButton: .default(Text("OK")))
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

// MARK: - Subviews

struct PhotoGalleryView: View {
    let photoURLs: [URL]
    let localImage: String
    @Binding var selectedIndex: Int
    var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(Array(photoURLs.enumerated()), id: \ .offset) { idx, url in
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Color.gray
                }
                .tag(idx)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .shadow(radius: 6)
                .padding(.horizontal, 8)
            }
            // Local fallback
            if !localImage.isEmpty {
                Image(localImage)
                    .resizable().scaledToFill()
                    .tag(photoURLs.count)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(radius: 6)
                    .padding(.horizontal, 8)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .animation(.easeInOut, value: selectedIndex)
    }
}

struct FriendlyIntroView: View {
    let dog: Dog
    var body: some View {
        Text("Hi! I’m \(dog.name). \(dog.description.split(separator: ".").first ?? "I can't wait to meet you!")")
            .font(.system(size: 22, weight: .semibold, design: .rounded))
            .padding()
            .background(Color("MutedGreen").opacity(0.18))
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(radius: 4)
            .padding(.horizontal, 2)
    }
}

struct AnimalActionButtonsView: View {
    let dog: Dog
    var body: some View {
        HStack(spacing: 16) {
            Button(action: { /* Express interest */ }) {
                Label("I'm Interested", systemImage: "heart.fill")
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color("Peach").opacity(0.9))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .shadow(radius: 2)
            }
            .scaleEffectOnTap()
            Button(action: { /* Schedule visit */ }) {
                Label("Schedule Visit", systemImage: "calendar")
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color("MutedGreen").opacity(0.9))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .shadow(radius: 2)
            }
            .scaleEffectOnTap()
            Button(action: { /* Share */ }) {
                Image(systemName: "square.and.arrow.up")
                    .padding(12)
                    .background(Color("WarmBrown").opacity(0.9))
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .shadow(radius: 2)
            }
            .scaleEffectOnTap()
        }
        .padding(.horizontal)
    }
}

// MARK: - Button Animation Modifier

extension View {
    func scaleEffectOnTap() -> some View {
        self.modifier(ScaleEffect())
    }
}

struct ScaleEffect: ViewModifier {
    @State private var pressed = false
    func body(content: Content) -> some View {
        content
            .scaleEffect(pressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: pressed)
            .onLongPressGesture(minimumDuration: 0.01, pressing: { isPressing in
                pressed = isPressing
            }, perform: {})
    }
} 

struct ContactFormView: View {
    let dog: Dog
    @Binding var show: Bool
    @Binding var showConfirmation: Bool
    @State private var name = ""
    @State private var email = ""
    @State private var message = ""
    @State private var isSubmitting = false
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Your Info")) {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                }
                Section(header: Text("Message (optional)")) {
                    TextField("Let us know why you're interested!", text: $message)
                }
                Button(action: submit) {
                    if isSubmitting {
                        ProgressView()
                    } else {
                        Text("Send Interest")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                    }
                }
                .disabled(name.isEmpty || email.isEmpty || isSubmitting)
            }
            .navigationTitle("Contact Shelter")
            .navigationBarItems(trailing: Button("Cancel") { show = false })
        }
    }
    func submit() {
        isSubmitting = true
        // Simulate sending to backend or email
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isSubmitting = false
            show = false
            showConfirmation = true
        }
    }
} 
