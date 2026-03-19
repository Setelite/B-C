import SwiftUI

struct CoachChatView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Coach Chat",
            subtitle: "Сообщения • Медиа • Быстрые ответы"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                PrimaryButton(title: "Send Message") { router.push(.sendMessage) }
            }
            .padding(16)
        }
    }
}

#Preview {
    FlowCoordinatorView()
}

