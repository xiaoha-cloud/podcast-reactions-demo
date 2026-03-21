import SwiftUI

/// Full-screen blurred artwork + warm gradient fallback (pseudo–Apple Podcasts ambience).
struct EpisodePlayerBackground: View {
    let coverImageName: String

    var body: some View {
        GeometryReader { geo in
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.44, green: 0.36, blue: 0.30),
                        Color(red: 0.20, green: 0.16, blue: 0.14)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                Image(coverImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .blur(radius: 48)
                    .opacity(0.55)
                    .clipped()

                LinearGradient(
                    colors: [
                        Color.black.opacity(0.15),
                        Color.black.opacity(0.45)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    EpisodePlayerBackground(coverImageName: "CoverDeepListen")
}
