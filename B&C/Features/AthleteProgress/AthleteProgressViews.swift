import SwiftUI

struct ExerciseProgressView: View {
    var body: some View {
        AppScreen(
            title: "Exercise Progress",
            subtitle: "Графики весов • Объема • Интенсивности"
        )
    }
}

struct ProgressView2: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Progress",
            subtitle: "Графики • Метрики • Достижения"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                PrimaryButton(title: "Progress Dashboard") { router.push(.progressDashboard) }
            }
            .padding(16)
        }
    }
}

struct ProgressDashboardView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Progress Dashboard",
            subtitle: "Графики веса • Объемов • Силовых"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                VStack(spacing: 12) {
                    PrimaryButton(title: "Metrics History") { router.push(.metricsHistory) }
                    PrimaryButton(title: "Exercise Progress") { router.push(.exerciseProgress) }
                    PrimaryButton(title: "Log Metrics") { router.push(.logMetrics) }
                    PrimaryButton(title: "Backend: Update Trends") { router.push(.backendUpdateTrends) }
                    PrimaryButton(title: "AI Coach Assistant (Future)") { router.push(.aiCoachAssistant) }
                }
            }
            .padding(16)
        }
    }
}

struct MetricsHistoryView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Metrics History",
            subtitle: "Вес тела • Замеры • Фото"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                PrimaryButton(title: "Добавить замер") { router.push(.logMetrics) }
            }
            .padding(16)
        }
    }
}

struct LogMetricsView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Log Metrics",
            subtitle: "Вес • Объемы • Фото • Заметки"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                PrimaryButton(title: "Save Metrics") { router.push(.saveMetrics) }
            }
            .padding(16)
        }
    }
}

#Preview {
    FlowCoordinatorView()
}
