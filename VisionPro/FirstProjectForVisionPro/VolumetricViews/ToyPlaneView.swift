
import SwiftUI
import RealityKit
import RealityKitContent

struct ToyPlaneView: View {
    let sceneName = "AttachmentsExample"
    
    var body: some View {
        RealityView { content, attachments in
            do {
                let sceneEntity = try await Entity.init(named: sceneName, in: realityKitContentBundle)
                
                if let pilotAttachment = attachments.entity(for: "pilot") {
                    pilotAttachment.position = SIMD3<Float>(0.0,0.2,0)
                    sceneEntity.addChild(pilotAttachment)
                }
                
                content.add(sceneEntity)
            } catch {
                logger.error("\(error.localizedDescription)")
            }
        } update: { content, attachments in
            
        } attachments: {
            Attachment(id: "pilot") {
                Text("Pilot")
                    .padding()
                    .glassBackgroundEffect()
            }
        }
    }
}

#Preview {
    ToyPlaneView()
}
