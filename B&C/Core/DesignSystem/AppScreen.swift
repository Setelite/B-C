import SwiftUI

struct AppScreen: View {
    let title: String
    var subtitle: String? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)

                if let subtitle {
                    Text(subtitle)
                        .font(.body)
                        .foregroundStyle(.white.opacity(0.72))
                }

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
        }
        .background(Color.bgPrimary)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { AppScreen(title: "Screen", subtitle: "Subtitle") }
}
