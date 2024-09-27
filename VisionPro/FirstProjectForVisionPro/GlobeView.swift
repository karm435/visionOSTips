
import SwiftUI
import RealityKit
import RealityKitContent

struct ManipulationState {
	var active: Bool = false
	var transform: AffineTransform3D = .identity
}

struct GlobeView: View {
    let sceneName: String
    @EnvironmentObject private var appState: AppState
	@GestureState var manipulationState: ManipulationState = .init()
    
    var body: some View {
        RealityView { content in
            do {
                let sceneEntity = try await Entity.init(named: sceneName, in: realityKitContentBundle)
                sceneEntity.position = SIMD3<Float>(x: 0, y: -0.2, z: 0)
                sceneEntity.scale *= SIMD3<Float>(repeating: 3)
				sceneEntity.components.set(InputTargetComponent())
                content.add(sceneEntity)
            } catch {
                logger.error("\(error.localizedDescription)")
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
			print("Gesture updating")
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
    GlobeView(sceneName: "Scene")
}

extension SimultaneousGesture<SimultaneousGesture<DragGesture, MagnifyGesture>,RotateGesture3D>.Value {
	func components() -> (Vector3D, Size3D, Rotation3D) {
		let translation = self.first?.first?.translation3D ?? .zero
		let magnification = self.first?.second?.magnification ?? 1
		let size = Size3D(width: magnification, height: magnification, depth: magnification)
		let rotation = self.second?.rotation ?? .identity
		
		return (translation, size, rotation)
	}
}

