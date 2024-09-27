
import SwiftUI
import RealityKit
import RealityKitContent

struct ToyPlaneView: View {
    let sceneName = "AttachmentsExample"
	@GestureState var manipulationState: ManipulationState = .init()
   
	
    var body: some View {
        RealityView { content, attachments in
            do {
                let sceneEntity = try await Entity.init(named: sceneName, in: realityKitContentBundle)
                
                if let pilotAttachment = attachments.entity(for: "pilot") {
                    pilotAttachment.position = SIMD3<Float>(0.0,0.2,0)
                    sceneEntity.addChild(pilotAttachment)
                }
				sceneEntity.components.set(InputTargetComponent())
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
		.scaleEffect(manipulationState.transform.scale.width)
		.rotation3DEffect(manipulationState.transform.rotation ?? .identity)
		.offset(x: manipulationState.transform.translation.x,
				y: manipulationState.transform.translation.y)
		.offset(z: manipulationState.transform.translation.z)
		.animation(.spring, value: manipulationState.transform)
		.gesture(manipulationGestures.updating($manipulationState) { value, state, _ in
			state.active = true
			state.transform = value
		})
    }
	
	var manipulationGestures: some Gesture<AffineTransform3D> {
		DragGesture()
			.simultaneously(with: MagnifyGesture())
			.simultaneously(with: RotateGesture3D())
			.map { gesture in
				print("Gesture triggerd")
				let (translation, scale, rotation) = gesture.components()
				
				return AffineTransform3D(scale: scale, rotation: rotation, translation: translation)
			}
	}
}

#Preview {
    ToyPlaneView()
}
