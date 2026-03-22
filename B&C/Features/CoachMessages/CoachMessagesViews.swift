import SwiftUI

struct ChatListView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Chat List",
            subtitle: "Список чатов • Последние сообщения • Уведомления"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                VStack(spacing: 12) {
                    PrimaryButton(title: "Open Chat Detail") { router.push(.chatDetail) }
                    PrimaryButton(title: "Empty State: No Messages") { router.push(.emptyStateNoMessages) }
                }
            }
            .padding(16)
        }
    }
}

struct ChatDetailView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Chat Detail",
            subtitle: "История • Медиа • Заметки о клиенте"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                VStack(spacing: 12) {
                    PrimaryButton(title: "Send Message") { router.push(.sendMessage) }
                    PrimaryButton(title: "Push Notification: New Message") { router.push(.pushNotificationNewMessage) }
                }
            }
            .padding(16)
        }
    }
}

struct SendMessageView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Send Message",
            subtitle: "Текст • Фото • Видео"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                VStack(spacing: 12) {
                    PrimaryButton(title: "Send") { router.push(.messageSent) }
                    PrimaryButton(title: "Error: Message Failed") { router.push(.errorMessageFailed) }
                }
            }
            .padding(16)
        }
    }
}

#Preview {
    FlowCoordinatorView()
}

