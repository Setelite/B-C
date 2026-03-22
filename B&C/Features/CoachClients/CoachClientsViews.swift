import SwiftUI

struct ClientsListScreenView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Clients List Screen",
            subtitle: "Список всех клиентов • Статус • Прогресс • Последняя активность"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                VStack(spacing: 12) {
                    PrimaryButton(title: "Add Client") { router.push(.addClient) }
                    PrimaryButton(title: "Open Client Detail") { router.push(.clientDetail) }
                }
            }
            .padding(16)
        }
    }
}

struct AddClientScreenView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Add Client Screen",
            subtitle: "Email приглашение или создание • Отправить приглашение"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                PrimaryButton(title: "Send invitation") { router.push(.invitationSent) }
            }
            .padding(16)
        }
    }
}

struct InvitationSentView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Invitation Sent",
            subtitle: "Backend: создание invite token • Email/SMS отправка"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                PrimaryButton(title: "Back to Clients") { router.goToDashboard() }
            }
            .padding(16)
        }
    }
}

struct ClientDetailScreenView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Client Detail Screen",
            subtitle: "Программы • Прогресс • Метрики • История"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                VStack(spacing: 12) {
                    PrimaryButton(title: "Assign Program") { router.push(.assignProgram) }
                    PrimaryButton(title: "View Client Progress") { router.push(.viewClientProgress) }
                    PrimaryButton(title: "Open Client Chat") { router.push(.openClientChat) }
                }
            }
            .padding(16)
        }
    }
}

struct ViewClientProgressView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "View Client Progress",
            subtitle: "Графики • Метрики • Выполненные тренировки"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                VStack(spacing: 12) {
                    PrimaryButton(title: "Coach Progress View") { router.push(.coachProgressView) }
                    PrimaryButton(title: "Progress Analytics") { router.push(.progressAnalytics) }
                    PrimaryButton(title: "Share Progress") { router.push(.progressAnalytics) }
                }
            }
            .padding(16)
        }
    }
}

struct CoachProgressView: View {
    var body: some View {
        AppScreen(
            title: "Coach Progress View",
            subtitle: "Все метрики • Тренировки • Сравнения"
        )
    }
}

