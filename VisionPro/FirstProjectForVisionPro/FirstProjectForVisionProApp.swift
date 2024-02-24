
import SwiftUI
import os

public let logger = Logger()

@main
struct FirstProjectForVisionProApp: App {
    @StateObject var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            if appState.isVolumtricWindowOpen {
                GlobeInformationView()
            } else {
                ContentView()
            }
        }
        .windowResizability(.contentSize)
        .environmentObject(appState)
        
        WindowGroup(id: "volumetricWindow", for: String.self) { $sceneName in
            if let sceneName {
                GlobeView(sceneName: sceneName)
            }
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 1, height: 1, depth: 1, in: .meters)
        .environmentObject(appState)
        
        WindowGroup(id: "toyPlane") {
            ToyPlaneView()
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 0.5, height: 0.5, depth: 0.5, in: .meters)
        
        
    }
}


