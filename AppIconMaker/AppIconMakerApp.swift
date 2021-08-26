import SwiftUI

@main
struct AppIconMakerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(MainViewModel())
                .navigationTitle("Select or drag and drop image for icon")
        }
    }
}
