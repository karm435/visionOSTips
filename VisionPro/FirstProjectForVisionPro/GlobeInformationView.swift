
import SwiftUI

struct GlobeInformationView: View {
    var body: some View {
        VStack {
            Text("Information about the Globe")
                .font(.title)
                .bold()
            
            Text("This is a globe which is rendered in the volumetric window.")
        }
        .frame(width: 300, height: 300)
    }
}

#Preview {
    GlobeInformationView()
}
