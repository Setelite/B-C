import SwiftUI

struct ProgressAnalyticsView: View {
    var body: some View {
        AppScreen(
            title: "Progress Analytics",
            subtitle: "Тренды • Рекомендации • Корректировки"
        )
    }
}

struct AIInsightsView: View {
    var body: some View {
        AppScreen(
            title: "AI Insights (Future)",
            subtitle: "Рекомендации по программам • Автоматизация"
        )
    }
}

struct ProfileSettingsView: View {
    var body: some View {
        AppScreen(
            title: "Profile Settings",
            subtitle: "Личные данные • Специализация"
        )
    }
}

struct BusinessSettingsView: View {
    var body: some View {
        AppScreen(
            title: "Business Settings",
            subtitle: "Тарифы • Расписание • Оплата"
        )
    }
}

struct CoachProfileView2: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        AppScreen(
            title: "Profile",
            subtitle: "Настройки • Статистика • Тарифы"
        )
        .safeAreaInset(edge: .bottom) {
            CardView {
                VStack(spacing: 12) {
                    PrimaryButton(title: "Profile Settings") { router.push(.profileSettings) }
                    PrimaryButton(title: "Business Settings") { router.push(.businessSettings) }
                    PrimaryButton(title: "Coach Statistics (Future)") { router.push(.coachStatistics) }
                    PrimaryButton(title: "Community & Social") { router.push(.communityAndSocial) }
                }
            }
            .padding(16)
        }
    }
}

struct CoachStatisticsView: View {
    var body: some View {
        AppScreen(
            title: "Coach Statistics (Future)",
            subtitle: "Клиенты • Доход • Активность"
        )
    }
}

struct CommunityAndSocialView: View {
    var body: some View {
        AppScreen(
            title: "Community & Social",
            subtitle: "Форум тренеров • Обмен программами"
        )
    }
}

#Preview {
    FlowCoordinatorView()
}

