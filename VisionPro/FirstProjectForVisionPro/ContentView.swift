import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Environment(\.openWindow) var openWindow
    
    var body: some View {
        VStack {
            Button("Open Globe") {
                openWindow(id: "volumetricWindow", value: "Scene")
            }
            
            Button("Open Globe Green") {
                openWindow(id: "volumetricWindow", value: "SceneWithGreen")
            }
        }
        .padding()
        .frame(width: 300, height: 300)
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}

