import SwiftUI

struct EmptyStateView: View {
    let title: String
    let subtitle: String

    var body: some View {
        ContentUnavailableView(
            title,
            systemImage: "tray",
            description: Text(subtitle)
        )
        .padding(16)
        .foregroundStyle(.white)
        .background(Color.bgPrimary)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ErrorView: View {
    let title: String
    let subtitle: String

    var body: some View {
        ContentUnavailableView(
            title,
            systemImage: "exclamationmark.triangle",
            description: Text(subtitle)
        )
        .padding(16)
        .foregroundStyle(.white)
        .background(Color.bgPrimary)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BackendStepView: View {
    let title: String
    let subtitle: String

    var body: some View {
        AppScreen(title: title, subtitle: subtitle)
    }
}

struct PushNotificationView: View {
    let title: String
    let subtitle: String

    var body: some View {
        AppScreen(title: title, subtitle: subtitle)
    }
}

#Preview {
    NavigationStack { EmptyStateView(title: "Empty", subtitle: "Nothing here") }
}
