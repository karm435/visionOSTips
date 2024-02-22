
import SwiftUI
import RealityKit
import RealityKitContent

struct GlobeView: View {
    let sceneName: String
    @EnvironmentObject private var appState: AppState
    
    @State var scale: Double = 1
    @State var startScale: Double? = nil
    
    var body: some View {
        RealityView { content in
            do {
                let sceneEntity = try await Entity.init(named: sceneName, in: realityKitContentBundle)
                sceneEntity.position = SIMD3<Float>(x: 0, y: -0.2, z: 0)
                sceneEntity.scale *= SIMD3<Float>(repeating: 3)
                content.add(sceneEntity)
            } catch {
                logger.error("\(error.localizedDescription)")
            }
        }
        .scaleEffect(scale)
        .simultaneousGesture(
            MagnifyGesture()
                .onChanged({ value in
                    if let startScale {
                        scale = max(0.5, min(2, value.magnification * startScale))
                    } else {
                        startScale = scale
                    }
                })
                .onEnded({ _ in
                    startScale = scale
                })
        )
    }
}

#Preview {
    GlobeView(sceneName: "Scene")
}


