import SwiftUI

struct AthleteSettingsView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Athlete Settings",
            subtitle: "Личные данные • Уведомления"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                VStack(spacing: 12) {
                    PrimaryButton(title: "Goals Settings") { router.push(.goalsSettings) }
                    PrimaryButton(title: "Body Metrics") { router.push(.bodyMetrics) }
                }
            }
            .padding(16)
        }
    }
}

struct GoalsSettingsView: View {
    var body: some View {
        AppScreen(
            title: "Goals Settings",
            subtitle: "Вес • Сила • Выносливость"
        )
    }
}

struct AthleteProfileView2: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Profile",
            subtitle: "Параметры • Настройки • Цели"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                PrimaryButton(title: "Athlete Settings") { router.push(.athleteSettings) }
            }
            .padding(16)
        }
    }
}

struct BodyMetricsView: View {
    var body: some View {
        AppScreen(
            title: "Body Metrics",
            subtitle: "Текущие замеры • История"
        )
    }
}

#Preview {
    FlowCoordinatorView()
}

