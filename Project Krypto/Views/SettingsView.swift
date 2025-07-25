import SwiftUI

struct SettingsView: View {
    var body: some View {
        Form {
            Section(header: Text("About")) {
                Text("Last Chance Homes helps save at-risk shelter animals by connecting them with adopters.")
            }
            Section(header: Text("Settings")) {
                Text("More settings coming soon!")
            }
        }
        .navigationTitle("Settings")
    }
} 