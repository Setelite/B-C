import SwiftUI

struct SelectProgramView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Select Program",
            subtitle: "Выбор программы из библиотеки"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                VStack(spacing: 12) {
                    PrimaryButton(title: "Configure Assignment") { router.push(.configureAssignment) }
                    PrimaryButton(title: "Back") { router.pop() }
                }
            }
            .padding(16)
        }
    }
}

struct ConfigureAssignmentView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Configure Assignment",
            subtitle: "Дата старта • Персонализация"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                VStack(spacing: 12) {
                    PrimaryButton(title: "Confirm Assignment") { router.push(.confirmAssignment) }
                    PrimaryButton(title: "Back") { router.pop() }
                }
            }
            .padding(16)
        }
    }
}

struct ConfirmAssignmentView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Confirm Assignment",
            subtitle: "Backend: создание копии программы • Привязка к клиенту • Уведомление"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                VStack(spacing: 12) {
                    PrimaryButton(title: "Backend: Create Program Copy") { router.push(.backendCreateProgramCopy) }
                    PrimaryButton(title: "Push Notification (Athlete)") { router.push(.pushNotificationAthleteProgramAssigned) }
                    PrimaryButton(title: "Done → Client Detail") {
                        router.popToRoot()
                        router.push(.coachTabBar)
                        router.push(.clientDetail)
                    }
                }
            }
            .padding(16)
        }
    }
}

#Preview {
    FlowCoordinatorView()
}

